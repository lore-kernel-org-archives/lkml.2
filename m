Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab0EJX74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:59:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59282 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547Ab0EJX7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xgzJXZEi0G5wpwTRVCEojCnDOtpuqy0PWLlSeMZl/utmEorBmETBDCO+MSd5b7o1CG
         Pe9SDt1cqGcP3H6iPfMgQzp8jW7BQ/rpuhLg2zRtBEK/4zOtrosEbxoi4u+VjgbMgTl3
         0WuLJGHINoU5Ob1k6T8xvcO4o6j6l3yC5jjz8=
MIME-Version: 1.0
In-Reply-To: <1273484339-28911-20-git-send-email-benh@kernel.crashing.org>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-12-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-13-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-14-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-15-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-16-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-17-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-18-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-19-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-20-git-send-email-benh@kernel.crashing.org>
Date: Mon, 10 May 2010 16:59:53 -0700
Message-ID: <AANLkTinOVSpCXdkkcCHMdN-HWsImE7_Gcbgg5plnNMss@mail.gmail.com>
Subject: Re: [PATCH 19/25] lmb: Add array resizing support
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 2:38 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> When one of the array gets full, we resize it. After much thinking and
> a few iterations of that code, I went back to on-demand resizing using
> the (new) internal lmb_find_base() function, which is pretty much what
> Yinghai initially proposed, though there some differences in the details.
>
> To work this relies on the default alloc limit being set sensibly by
> the architecture.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  lib/lmb.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 92 insertions(+), 1 deletions(-)
>
> diff --git a/lib/lmb.c b/lib/lmb.c
> index 4977888..2602683 100644
> --- a/lib/lmb.c
> +++ b/lib/lmb.c
> @@ -11,6 +11,7 @@
>  */
>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/bitops.h>
>  #include <linux/poison.h>
> @@ -24,6 +25,17 @@ static struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
>
>  #define LMB_ERROR      (~(phys_addr_t)0)
>
> +/* inline so we don't get a warning when pr_debug is compiled out */
> +static inline const char *lmb_type_name(struct lmb_type *type)
> +{
> +       if (type == &lmb.memory)
> +               return "memory";
> +       else if (type == &lmb.reserved)
> +               return "reserved";
> +       else
> +               return "unknown";
> +}
> +
>  /*
>  * Address comparison utilities
>  */
> @@ -156,6 +168,73 @@ static void lmb_coalesce_regions(struct lmb_type *type,
>        lmb_remove_region(type, r2);
>  }
>
> +/* Defined below but needed now */
> +static long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size);
> +
> +static int lmb_double_array(struct lmb_type *type)
> +{
> +       struct lmb_region *new_array, *old_array;
> +       phys_addr_t old_size, new_size, addr;
> +       int use_slab = slab_is_available();
> +
> +       pr_debug("lmb: %s array full, doubling...", lmb_type_name(type));
> +
> +       /* Calculate new doubled size */
> +       old_size = type->max * sizeof(struct lmb_region);
> +       new_size = old_size << 1;
> +
> +       /* Try to find some space for it.
> +        *
> +        * WARNING: We assume that either slab_is_available() and we use it or
> +        * we use LMB for allocations. That means that this is unsafe to use
> +        * when bootmem is currently active (unless bootmem itself is implemented
> +        * on top of LMB which isn't the case yet)
> +        *
> +        * This should however not be an issue for now, as we currently only
> +        * call into LMB while it's still active, or much later when slab is
> +        * active for memory hotplug operations
> +        */
> +       if (use_slab) {
> +               new_array = kmalloc(new_size, GFP_KERNEL);
> +               addr = new_array == NULL ? LMB_ERROR : __pa(new_array);
> +       } else
> +               addr = lmb_find_base(new_size, sizeof(phys_addr_t), LMB_ALLOC_ACCESSIBLE);
> +       if (addr == LMB_ERROR) {
> +               pr_err("lmb: Failed to double %s array from %ld to %ld entries !\n",
> +                      lmb_type_name(type), type->max, type->max * 2);
> +               return -1;
> +       }
> +       new_array = __va(addr);
> +
> +       /* Found space, we now need to move the array over before
> +        * we add the reserved region since it may be our reserved
> +        * array itself that is full.
> +        */
> +       memcpy(new_array, type->regions, old_size);
> +       memset(new_array + type->max, 0, old_size);
> +       old_array = type->regions;
> +       type->regions = new_array;
> +       type->max <<= 1;
> +
> +       /* If we use SLAB that's it, we are done */
> +       if (use_slab)
> +               return 0;
> +
> +       /* Add the new reserved region now. Should not fail ! */
> +       BUG_ON(lmb_add_region(&lmb.reserved, addr, new_size) < 0);
> +
> +       /* If the array wasn't our static init one, then free it. We only do
> +        * that before SLAB is available as later on, we don't know whether
> +        * to use kfree or free_bootmem_pages(). Shouldn't be a big deal
> +        * anyways
> +        */
> +       if (old_array != lmb_memory_init_regions &&
> +           old_array != lmb_reserved_init_regions)
> +               lmb_free(__pa(old_array), old_size);
> +
> +       return 0;
> +}
> +
>  static long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
>  {
>        unsigned long coalesced = 0;
> @@ -196,7 +275,11 @@ static long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t
>
>        if (coalesced)
>                return coalesced;
> -       if (type->cnt >= type->max)
> +
> +       /* If we are out of space, we fail. It's too late to resize the array
> +        * but then this shouldn't have happened in the first place.
> +        */
> +       if (WARN_ON(type->cnt >= type->max))
>                return -1;
>
>        /* Couldn't coalesce the LMB, so add it to the sorted table. */
> @@ -217,6 +300,14 @@ static long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t
>        }
>        type->cnt++;
>
> +       /* The array is full ? Try to resize it. If that fails, we undo
> +        * our allocation and return an error
> +        */
> +       if (type->cnt == type->max && lmb_double_array(type)) {

you need to pass base, base+size with lmb_double_array()

otherwise when you are using lmb_reserve(base, size), double_array()
array could have chance to get
new buffer that is overlapped with [base, base + size).

to keep it simple, should check_double_array() after lmb_reserve,
lmb_add, lmb_free (yes, that need it too).
that was suggested by Michael Ellerman.

YH
