Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2DYWYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:24:35 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55279 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345Ab2DYWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:24:34 -0400
Date: Wed, 25 Apr 2012 15:24:29 -0700
From: Tejun Heo <tj@kernel.org>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] mm: percpu: Add PCPU_FC_FIXED to pcpu_fc for setting
 fixed pcpu_atom_size.
Message-ID: <20120425222429.GE8989@google.com>
References: <4F97BA98.6010001@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F97BA98.6010001@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, ShouX.

On Wed, Apr 25, 2012 at 04:49:28PM +0800, ShuoX Liu wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
> 
> We are enabling Android on Medfield. On i386, if the board has more
> physical memory, it means the vmalloc space is small. If the vmalloc
> space is big, it means physical memory is small. Dynamic percpu
> allocation is based on VM space. On i386, by default, the chunk size
> is 4MB. As vmalloc space is <= 128M, percpu allocation often fails.

Can you please provide more details - which kernel/user split was
used, how much memory was there and so on?  Also, can you please
attach boot log and the output of "cat /proc/vmallocinfo"?

> If using PERCPU_FC_PAGE, system can't go to deep sleep states.

Why?

> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> index 71f4727..824bc41 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -185,9 +185,13 @@ void __init setup_per_cpu_areas(void)
>  #endif
>  	rc = -EINVAL;
>  	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
> -		const size_t atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
> +		size_t atom_size;
>  		const size_t dyn_size = PERCPU_MODULE_RESERVE +
>  			PERCPU_DYNAMIC_RESERVE - PERCPU_FIRST_CHUNK_RESERVE;
> +		if (pcpu_chosen_fc == PCPU_FC_FIXED && pcpu_atom_size)
> +			atom_size = pcpu_atom_size;
> +		else
> +			atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
>  
>  		rc = pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
>  					    dyn_size, atom_size,

Umm... this is way too hacky.  atom_size can't be an arbitrary value
and the param is meaningful only to x86 yet defined globally.  Also,
while atom_size has effect on vmalloc area usage, way more important
factor is distance between units.  What we probably need to do is
tighten the rejection criteria of pcpu_embed_first_chunk() and fix
whatever problem FC_PAGE is causing.

Thanks.

-- 
tejun
