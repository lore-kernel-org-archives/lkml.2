Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0JTFSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:18:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33009 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0JTFSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SqrT4ybqK9hM+GRSoHGnZ6wkacOJFX1uyzlavYC7WhtVbficZWjlDiynnSNwZ6Wj4E
         NmxdxHSdaDLskxvFy1V4vLMI81ObGmvF9bNuimjCpMvtSrpt71+SIomr0li0TEtNTLZ1
         Qh8HVtMYBpbVky2UPoEdUslV56n6ceJ74QePg=
Subject: Re: [PATCH 1/2]percpu: introduce read mostly percpu API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 07:18:00 +0200
Message-ID: <1287551880.2700.79.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 octobre 2010 à 11:07 +0800, Shaohua Li a écrit :
> Add a new readmostly percpu section and api, next patch will use it.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---


Could you precisely describe why grouping together read mostly percpu
variables is a win ? Especially when you add in your next patch a single
variable ?

>  include/asm-generic/vmlinux.lds.h |    4 ++++
>  include/linux/percpu-defs.h       |    9 +++++++++
>  2 files changed, 13 insertions(+)
> 
> Index: linux/include/asm-generic/vmlinux.lds.h
> ===================================================================
> --- linux.orig/include/asm-generic/vmlinux.lds.h	2010-10-20 09:32:52.000000000 +0800
> +++ linux/include/asm-generic/vmlinux.lds.h	2010-10-20 10:03:38.000000000 +0800
> @@ -677,6 +677,8 @@
>  				- LOAD_OFFSET) {			\
>  		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
>  		*(.data..percpu..first)					\
> +		. = ALIGN(PAGE_SIZE);					\
> +		*(.data..percpu..readmostly)				\
>  		*(.data..percpu..page_aligned)				\
>  		*(.data..percpu)					\
>  		*(.data..percpu..shared_aligned)			\

So percpu..page_aligned is not any more aligned to a PAGE ? or we have a
big hole before it ? Hmm....

Maybe you should put first data..percpu..page_aligned, then align to one
cache line (L1_CACHE_BYTES), then data..percpu..readmostly, so that hole
is small.

We should take care of not introducing too much holes in percpu zone.
Maybe using a new subzone ".data..percpu..small_objects" to put small
objects in it.

nm -v vmlinux | grep -10 sockets_in_use   # select one random part 

0000000000011e0c d cpu_min_freq
0000000000011e10 d cpu_cur_freq
0000000000011e14 d cpu_set_freq
0000000000011e18 d cpu_is_managed
0000000000011e20 d od_cpu_dbs_info
0000000000011fa0 d cs_cpu_dbs_info
00000000000120f0 d cpufreq_show_table
0000000000012100 D cpuidle_devices
0000000000012120 d ladder_devices
0000000000012200 d menu_devices       
00000000000122c0 d sockets_in_use     # object_size = 4 , hole = 28bytes
00000000000122e0 d prot_inuse         
00000000000123e0 D nf_conntrack_untracked
0000000000012560 d rt_cache_stat
00000000000125a0 d ipv4_cookie_scratch
0000000000012740 D init_tss
0000000000014a00 D irq_stat
0000000000014a40 D cpu_info
0000000000014b00 d hv_clock
0000000000014b40 D cpu_tlbstate
0000000000014b80 d runqueues

We can see many holes because of 2^5 alignments of
individual .o  .data..percpu sections.

find . -name "*.o"|xargs objdump -h|grep percpu

Linker promotes a section alignment from natural alignment to 2^5 as
soon as the size reaches 2^5

For example in net/ipv4/route.o, we have a per_cpu structure
(rt_cache_stat), that is an array of 16 integers. The natural alignement
should be 4 (alignof(int)), but we get :

# objdump -h net/ipv4/route.o|grep percpu
 19 .data..percpu 00000040  0000000000000000  0000000000000000  00007a80  2**5

For a section replicated N times, this really is a concern.

Thanks !


