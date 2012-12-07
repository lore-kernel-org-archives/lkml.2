Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2LGJ6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:58:05 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39634 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2LGJ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:58:02 -0500
Date: Fri, 7 Dec 2012 10:59:07 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [ 15/20] s390/mm: have 16 byte aligned struct pages
Message-ID: <20121207095907.GA5129@osiris.de.ibm.com>
References: <20121207005232.756641002@linuxfoundation.org>
 <20121207005237.110422582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207005237.110422582@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12120709-5024-0000-0000-0000049D5040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 04:54:30PM -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> commit 4bffbb3455372a26816e364fb4448810f7014452 upstream.
> 
> Select HAVE_ALIGNED_STRUCT_PAGE on s390, so that the slub allocator can make
> use of compare and swap double for lockless updates. This increases the size

The s390 implementation of compare and swap and double was merged for 3.7:
b1d6b40c "s390/cmpxchg,percpu: implement cmpxchg_double()".
It is not part of 3.4. So putting this into stable makes not much sense.

> of struct page to 64 bytes (instead of 56 bytes), however the performance gain
> justifies the increased size:
> 
> - now excactly four struct pages fit into a single cache line; the
>   case that accessing a struct page causes two cache line loads
>   does not exist anymore.
> - calculating the offset of a struct page within the memmap array
>   is only a simple shift instead of a more expensive multiplication.

This is obviously still true, but I've made no measurements if we still
see any (significant) performance gain if the slub allocator doesn't make
use of compare and swap double or if it's just a waste of memory.

So I'd prefer to not have this patch in stable.

> A "hackbench 200 process 200" run on a 32 cpu system did show an 8% runtime
> improvement.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/s390/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -93,6 +93,7 @@ config S390
>  	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
>  	select HAVE_MEMBLOCK
>  	select HAVE_MEMBLOCK_NODE_MAP
> +	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
>  	select ARCH_DISCARD_MEMBLOCK
>  	select ARCH_INLINE_SPIN_TRYLOCK
>  	select ARCH_INLINE_SPIN_TRYLOCK_BH

