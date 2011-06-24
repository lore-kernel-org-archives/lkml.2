Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1FXHyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 03:54:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1FXHyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 03:54:39 -0400
Subject: Re: [PATCH] mm: fix unmap_atomic range checks
From: Peter Zijlstra <peterz@infradead.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110624025335.21811fef@katamari>
References: <20110624025335.21811fef@katamari>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Jun 2011 09:53:49 +0200
Message-ID: <1308902029.27849.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 02:53 -0400, Chuck Ebbert wrote:
> Commit 3e4d3af501cccdc8a8cca41bdbe57d54ad7e7e73 ("mm: stack based
> kmap_atomic()", in 2.6.37-rc1) had three places where range checking
> logic was reversed.

Where's the oopses to go along with this?

I think its actually correct, since on both x86 and tile we have:

#define __fix_to_virt(x)        (FIXADDR_TOP - ((x) << PAGE_SHIFT))

Which flips the address space around, ie, END < BEGIN.        

> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
> 
> --- a/arch/tile/mm/highmem.c
> +++ b/arch/tile/mm/highmem.c
> @@ -235,8 +235,8 @@ void __kunmap_atomic(void *kvaddr)
>  {
>  	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
>  
> -	if (vaddr >= __fix_to_virt(FIX_KMAP_END) &&
> -	    vaddr <= __fix_to_virt(FIX_KMAP_BEGIN)) {
> +	if (vaddr >= __fix_to_virt(FIX_KMAP_BEGIN) &&
> +	    vaddr <= __fix_to_virt(FIX_KMAP_END)) {
>  		pte_t *pte = kmap_get_pte(vaddr);
>  		pte_t pteval = *pte;
>  		int idx, type;
> --- a/arch/x86/mm/highmem_32.c
> +++ b/arch/x86/mm/highmem_32.c
> @@ -70,8 +70,8 @@ void __kunmap_atomic(void *kvaddr)
>  {
>  	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
>  
> -	if (vaddr >= __fix_to_virt(FIX_KMAP_END) &&
> -	    vaddr <= __fix_to_virt(FIX_KMAP_BEGIN)) {
> +	if (vaddr >= __fix_to_virt(FIX_KMAP_BEGIN) &&
> +	    vaddr <= __fix_to_virt(FIX_KMAP_END)) {
>  		int idx, type;
>  
>  		type = kmap_atomic_idx();
> --- a/arch/x86/mm/iomap_32.c
> +++ b/arch/x86/mm/iomap_32.c
> @@ -94,8 +94,8 @@ iounmap_atomic(void __iomem *kvaddr)
>  {
>  	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
>  
> -	if (vaddr >= __fix_to_virt(FIX_KMAP_END) &&
> -	    vaddr <= __fix_to_virt(FIX_KMAP_BEGIN)) {
> +	if (vaddr >= __fix_to_virt(FIX_KMAP_BEGIN) &&
> +	    vaddr <= __fix_to_virt(FIX_KMAP_END)) {
>  		int idx, type;
>  
>  		type = kmap_atomic_idx();

