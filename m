Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0EZTTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:19:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44363 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0EZTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QD58xbgCUuJYrZEXlACDiLWFsOHW7tBu3wF8cL3vTXt4DBBxFEWe9aAmb8vMkMLDLg
         /gmyquNW7f8oV5e4Ry9dpVBGn1Yhymsuqgrgi8eaZqILHI0W8vI0Cf/6JTazp2fIaufM
         MD1aQOkTCTNtHfEcMPlLt6vHGV21CPSXBvETo=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: UML broken for CONFIG_SLAB
Date: Wed, 26 May 2010 21:19:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1005231149100.605@parag-laptop>
In-Reply-To: <alpine.DEB.2.00.1005231149100.605@parag-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005262119.10600.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16054
for your bug report, please add your address to the CC list in there, thanks!

On niedziela, 23 maja 2010 o 23:40:04 Parag Warudkar wrote:
> UML seems to be badly broken 2.6.34 onwards - leading to random segfaults.
> 
> Reading symbols from /home/parag/devel/kernel/linux-2.6-um/linux...done.
> (gdb) r
> Starting program: /home/parag/devel/kernel/linux-2.6-um/linux
> Checking that ptrace can change system call numbers...OK
> Checking syscall emulation patch for ptrace...OK
> Checking advanced syscall emulation patch for ptrace...OK
> Checking for tmpfs mount on /dev/shm...OK
> Checking PROT_EXEC mmap in /dev/shm/...OK
> Checking for the skas3 patch in the host:
>   - /proc/mm...not found: No such file or directory
>   - PTRACE_FAULTINFO...not found
>   - PTRACE_LDT...not found
> UML running in SKAS0 mode
> Core dump limits :
>         soft - 0
>         hard - NONE
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000006007823f in alloc_kmemlist (cachep=0x61c00f40, limit=<value
> optimized out>, batchcount=<value optimized out>, shared=<value optimized
> out>, gfp=208) at mm/slab.c:3861
> 3861                    l3->free_limit = (1 + nr_cpus_node(node)) *
> (gdb)
> 
> (gdb) bt
> #0  0x000000006007823f in alloc_kmemlist (cachep=0x61c00f40, limit=<value
> optimized out>, batchcount=<value optimized out>, shared=<value optimized
> out>, gfp=208) at mm/slab.c:3861
> #1  do_tune_cpucache (cachep=0x61c00f40, limit=<value optimized out>,
> batchcount=<value optimized out>, shared=<value optimized out>, gfp=208)
> at mm/slab.c:3943
> #2  0x00000000600783be in enable_cpucache (cachep=0x61c00f40,
> gfp=1639983680) at mm/slab.c:3993
> #3  0x000000006016e43d in setup_cpu_cache (cachep=0x61c00f40, gfp=208) at
> mm/slab.c:2017
> #4  0x0000000060078797 in kmem_cache_create (name=0x601c80b6
> "idr_layer_cache", size=<value optimized out>, align=<value optimized
> out>, flags=262144, ctor=<value optimized out>)
>     at mm/slab.c:2351
> #5  0x000000006000982c in idr_init_cache () at lib/idr.c:676
> #6  0x00000000600015df in start_kernel () at init/main.c:658
> 
> This one I tried to debug and something weird seems to be going on -
> 
> mm/slab.c:3849 does a l3 = kmalloc_node(...), which *seems* to be
> returning NULL but the check on next line - if (!l3) doesn't seem to be
> succeeding.
> 
> Finally it seems to happily dereference l3 (0x40 offsets etc.) up until
> dereferencing free_limit at which point it explodes.
> 
> A very few times it goes a little further and explodes at
> 
> fsck from util-linux-ng 2.16
> ROOT: clean, 18550/65536 files, 106443/262144 blocks
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x00000000600effb7 in cfq_close_cooperator (cfqd=0x7fcbe000,
> cur_cfqq=0x7ff81bb0) at block/cfq-iosched.c:1801
> 1801            if (cfq_class_rt(cfqq) != cfq_class_rt(cur_cfqq))
> (gdb) p cfqq
> $1 = (struct cfq_queue *) 0x0
> (gdb) p cur_cfqq
> $2 = (struct cfq_queue *) 0x7ff81bb0
> (gdb)
> 
> This is with CONFIG_SLAB=y.
> 
> Parag
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
