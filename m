Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab0J0Ndd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:33:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab0J0Ndb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tqBXUM/VPqyaPTJ1V98+/bhOfd8y/AwfYA1UU7WNSRG82GZ1v+w2qMZgZrIvTIxQYB
         Ek+DyLtV7+Uw72EZv+S0Qvv1kmF/WvTyKYaWzh8fMYazrclsqyZF/5WcPQX9NHRPbzkt
         ADuDQUxrQ3BGLTgx+UF+AxmugkZHkKc3P3F/c=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Gerst <brgerst@gmail.com>, tj@kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@elte.hu
In-Reply-To: <1288173442.15336.1490.camel@twins>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 15:33:25 +0200
Message-ID: <1288186405.2709.117.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 11:57 +0200, Peter Zijlstra a écrit :
> On Wed, 2010-10-27 at 08:07 +0200, Eric Dumazet wrote:
> > > -     irqctx = &per_cpu(hardirq_stack, cpu);
> > > +     irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
> > 
> > Hmm, then we lose NUMA affinity for stacks. 
> 
> I guess we could use:
> 
>   alloc_pages_node(cpu_to_node(cpu), THREAD_FLAGS, THREAD_ORDER);
> 
> 

Anyway, I just discovered per_cpu data on my machine (NUMA capable) all
sit on a single node, if 32bit kernel used.

# cat /proc/buddyinfo 
Node 0, zone      DMA      0      1      0      1      2      1      1      0      1      1      3 
Node 0, zone   Normal     94    251     81     16      3      2      1      2      1      2    187 
Node 0, zone  HighMem    113     88     47     36     18      5      4      3      2      0    268 
Node 1, zone  HighMem    154     97     43     16      9      4      3      2      3      2    482 

# dmesg | grep pcpu
[    0.000000] pcpu-alloc: s41920 r0 d23616 u65536 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 


dual socket machine (E5540  @ 2.53GHz), total of 8 cores, 16 threads.

# dmesg | grep irqstack
[    0.000000] CPU 0 irqstacks, hard=f4a00000 soft=f4a02000
[    0.173397] CPU 1 irqstacks, hard=f4a10000 soft=f4a12000
[    0.284939] CPU 2 irqstacks, hard=f4a20000 soft=f4a22000
[    0.392908] CPU 3 irqstacks, hard=f4a30000 soft=f4a32000
[    0.500757] CPU 4 irqstacks, hard=f4a40000 soft=f4a42000
[    0.608713] CPU 5 irqstacks, hard=f4a50000 soft=f4a52000
[    0.716665] CPU 6 irqstacks, hard=f4a60000 soft=f4a62000
[    0.828668] CPU 7 irqstacks, hard=f4a70000 soft=f4a72000
[    0.936555] CPU 8 irqstacks, hard=f4a80000 soft=f4a82000
[    1.044525] CPU 9 irqstacks, hard=f4a90000 soft=f4a92000
[    1.152470] CPU 10 irqstacks, hard=f4aa0000 soft=f4aa2000
[    1.260367] CPU 11 irqstacks, hard=f4ab0000 soft=f4ab2000
[    1.368313] CPU 12 irqstacks, hard=f4ac0000 soft=f4ac2000
[    1.476313] CPU 13 irqstacks, hard=f4ad0000 soft=f4ad2000
[    1.584167] CPU 14 irqstacks, hard=f4ae0000 soft=f4ae2000
[    1.692222] CPU 15 irqstacks, hard=f4af0000 soft=f4af2000


With a 64bit kernel its fine :

[    0.000000] pcpu-alloc: s76992 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 02 04 06 08 10 12 14 17 19 21 23 25 27 29 31 
[    0.000000] pcpu-alloc: [1] 01 03 05 07 09 11 13 15 16 18 20 22 24 26 28 30 

I presume node 1 having only HighMem could be the reason ?



