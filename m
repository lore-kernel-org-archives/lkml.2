Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0EWVkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 17:40:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55249 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab0EWVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 17:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=MBj8u6drQLKyYSl6ghWVyMl0j+nbceWRY1m/0UttLNyS3z26We3G0vzbDd00U2AU55
         4Yd+uW7xlS0mL/SIBfW4nIiO+dUm7Wc9JEm2Tv8bWKJZTdnSiCsu5ziifkqn1awA7X+a
         YhCRd6F2wkc4q8JuVoVEkQWDSGlO/ecLf6q4Y=
Date: Sun, 23 May 2010 17:40:04 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: linux-kernel@vger.kernel.org
Subject: UML broken for CONFIG_SLAB
Message-ID: <alpine.DEB.2.00.1005231149100.605@parag-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML seems to be badly broken 2.6.34 onwards - leading to random segfaults.

Reading symbols from /home/parag/devel/kernel/linux-2.6-um/linux...done.
(gdb) r
Starting program: /home/parag/devel/kernel/linux-2.6-um/linux 
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...OK
Checking advanced syscall emulation patch for ptrace...OK
Checking for tmpfs mount on /dev/shm...OK
Checking PROT_EXEC mmap in /dev/shm/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
Core dump limits :
        soft - 0
        hard - NONE

Program received signal SIGSEGV, Segmentation fault.
0x000000006007823f in alloc_kmemlist (cachep=0x61c00f40, limit=<value 
optimized out>, batchcount=<value optimized out>, shared=<value optimized 
out>, gfp=208) at mm/slab.c:3861
3861                    l3->free_limit = (1 + nr_cpus_node(node)) *
(gdb) 

(gdb) bt
#0  0x000000006007823f in alloc_kmemlist (cachep=0x61c00f40, limit=<value 
optimized out>, batchcount=<value optimized out>, shared=<value optimized 
out>, gfp=208) at mm/slab.c:3861
#1  do_tune_cpucache (cachep=0x61c00f40, limit=<value optimized out>, 
batchcount=<value optimized out>, shared=<value optimized out>, gfp=208) 
at mm/slab.c:3943
#2  0x00000000600783be in enable_cpucache (cachep=0x61c00f40, 
gfp=1639983680) at mm/slab.c:3993
#3  0x000000006016e43d in setup_cpu_cache (cachep=0x61c00f40, gfp=208) at 
mm/slab.c:2017
#4  0x0000000060078797 in kmem_cache_create (name=0x601c80b6 
"idr_layer_cache", size=<value optimized out>, align=<value optimized 
out>, flags=262144, ctor=<value optimized out>)
    at mm/slab.c:2351
#5  0x000000006000982c in idr_init_cache () at lib/idr.c:676
#6  0x00000000600015df in start_kernel () at init/main.c:658

This one I tried to debug and something weird seems to be going on -

mm/slab.c:3849 does a l3 = kmalloc_node(...), which *seems* to be 
returning NULL but the check on next line - if (!l3) doesn't seem to be 
succeeding.

Finally it seems to happily dereference l3 (0x40 offsets etc.) up until 
dereferencing free_limit at which point it explodes.

A very few times it goes a little further and explodes at 

fsck from util-linux-ng 2.16
ROOT: clean, 18550/65536 files, 106443/262144 blocks

Program received signal SIGSEGV, Segmentation fault.
0x00000000600effb7 in cfq_close_cooperator (cfqd=0x7fcbe000, 
cur_cfqq=0x7ff81bb0) at block/cfq-iosched.c:1801
1801            if (cfq_class_rt(cfqq) != cfq_class_rt(cur_cfqq))
(gdb) p cfqq
$1 = (struct cfq_queue *) 0x0
(gdb) p cur_cfqq 
$2 = (struct cfq_queue *) 0x7ff81bb0
(gdb) 

This is with CONFIG_SLAB=y.

Parag
