Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2FOWFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:05:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33393 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2FOWFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <1339794567-17784-1-git-send-email-greg.pearson@hp.com>
References: <1339794567-17784-1-git-send-email-greg.pearson@hp.com>
Date: Fri, 15 Jun 2012 15:05:12 -0700
X-Google-Sender-Auth: FwtBjzM3NqSsRMlAXRq7c5zSu00
Message-ID: <CAE9FiQWh9bjBQZEbEp=Wti=qNJVR2G-CuEa8bC3TtfN5hSWKxg@mail.gmail.com>
Subject: Re: [PATCH] mm/memblock: fix overlapping allocation when doubling
 reserved array
From: Yinghai Lu <yinghai@kernel.org>
To: Greg Pearson <greg.pearson@hp.com>
Cc: tj@kernel.org, hpa@linux.intel.com, akpm@linux-foundation.org,
        shangw@linux.vnet.ibm.com, mingo@elte.hu, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 2:09 PM, Greg Pearson <greg.pearson@hp.com> wrote:
> The __alloc_memory_core_early() routine will ask memblock for a range
> of memory then try to reserve it. If the reserved region array lacks
> space for the new range, memblock_double_array() is called to allocate
> more space for the array. If memblock is used to allocate memory for
> the new array it can end up using a range that overlaps with the range
> originally allocated in __alloc_memory_core_early(), leading to possible
> data corruption.
>
> With this patch memblock_double_array() now calls memblock_find_in_range()
> with a narrowed candidate range so any memory allocated will not overlap
> with the original range that was being reserved. The range is narrowed by
> passing in the starting address of the previously allocated range as the
> end of the candidate range. Since memblock_find_in_range_node() looks for
> a free range by walking the free memory list in reverse order (highest
> memory address to lowest address) this change should not unnecessarily
> exclude chunks of memory that could otherwise be used to satisfy the
> request.

old early_res version have exclude_start/exclude_end.

>
> Signed-off-by: Greg Pearson <greg.pearson@hp.com>
> ---
>  mm/memblock.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 952123e..599519c 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -184,7 +184,8 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
>        }
>  }
>
> -static int __init_memblock memblock_double_array(struct memblock_type *type)
> +static int __init_memblock memblock_double_array(struct memblock_type *type,
> +                                               phys_addr_t skip_base)

could pass phys_addr_t exclude_base, phys_addr_t execlude_end

>  {
>        struct memblock_region *new_array, *old_array;
>        phys_addr_t old_size, new_size, addr;
> @@ -222,7 +223,8 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
>                new_array = kmalloc(new_size, GFP_KERNEL);
>                addr = new_array ? __pa(new_array) : 0;
>        } else {
> -               addr = memblock_find_in_range(0, MEMBLOCK_ALLOC_ACCESSIBLE, new_size, sizeof(phys_addr_t));
> +               addr = memblock_find_in_range(0, skip_base,
> +                               new_size, sizeof(phys_addr_t));

could try to search [exclude_end, MEMBLOCK_ALLOC_ACCESSIBLE) at first.
then try [0, execlude_start).

Yinghai
