Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab0EJXhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:37:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49341 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab0EJXhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U+PpeJ8Qhdszkzc42LcvVDZrCEUl8bDBiBiFdXuFfo5pdJnmbhiTt8GOuwA79ebDo+
         PuoPhy9lgvAGemgYPfvlxQ+t/uHlutg8gOxyC8sxQffErnDz5as0aqyOXnyzj6P3BsbD
         dDkVMGTr+tDbDkRgnGRi9oUZ6qmODwSDUdbdU=
MIME-Version: 1.0
In-Reply-To: <1273484339-28911-22-git-send-email-benh@kernel.crashing.org>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-14-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-15-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-16-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-17-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-18-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-19-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-20-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-21-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-22-git-send-email-benh@kernel.crashing.org>
Date: Mon, 10 May 2010 16:37:05 -0700
Message-ID: <AANLkTimhvJUX2S2eIY8rpw4TnUrDUFicMxEZkLK3hu1N@mail.gmail.com>
Subject: Re: [PATCH 21/25] lmb: Add "start" argument to lmb_find_base()
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
> To constraint the search of a region between two boundaries,
> which will be used by the new NUMA aware allocator among others.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  lib/lmb.c |   27 ++++++++++++++++-----------
>  1 files changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/lib/lmb.c b/lib/lmb.c
> index 84ac3a9..848f908 100644
> --- a/lib/lmb.c
> +++ b/lib/lmb.c
> @@ -117,19 +117,18 @@ static phys_addr_t __init lmb_find_region(phys_addr_t start, phys_addr_t end,
>        return LMB_ERROR;
>  }
>
> -static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
> +static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align,
> +                                       phys_addr_t start, phys_addr_t end)
>  {
>        long i;
> -       phys_addr_t base = 0;
> -       phys_addr_t res_base;
>
>        BUG_ON(0 == size);
>
>        size = lmb_align_up(size, align);
>
>        /* Pump up max_addr */
> -       if (max_addr == LMB_ALLOC_ACCESSIBLE)
> -               max_addr = lmb.current_limit;
> +       if (end == LMB_ALLOC_ACCESSIBLE)
> +               end = lmb.current_limit;
>
>        /* We do a top-down search, this tends to limit memory
>         * fragmentation by keeping early boot allocs near the
> @@ -138,13 +137,19 @@ static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align, phy
>        for (i = lmb.memory.cnt - 1; i >= 0; i--) {
>                phys_addr_t lmbbase = lmb.memory.regions[i].base;
>                phys_addr_t lmbsize = lmb.memory.regions[i].size;
> +               phys_addr_t bottom, top, found;
>
>                if (lmbsize < size)
>                        continue;
> -               base = min(lmbbase + lmbsize, max_addr);
> -               res_base = lmb_find_region(lmbbase, base, size, align);
> -               if (res_base != LMB_ERROR)
> -                       return res_base;
> +               if ((lmbbase + lmbsize) <= start)
> +                       break;
> +               bottom = max(lmbbase, start);
> +               top = min(lmbbase + lmbsize, end);
> +               if (bottom >= top)
> +                       continue;
> +               found = lmb_find_region(lmbbase, top, size, align);
                                                               ^^^^^^^^^
should use bottom  here

YH
