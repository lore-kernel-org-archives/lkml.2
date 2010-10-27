Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203Ab0J0QH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:07:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32860 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0J0QHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L/P9iagwgKjD9GrM5vq/FS6ogAafs7prOzoULsPDInY0ETlVXmJOPkB6xltjpiZFPA
         utFM8CKiy6Ssqm1sA6HZSGPELcdOUq/XvgRS94DAFjj0JvIoLP8l7C/S1O0udz/OHDxp
         eeWuplpNXo6aLJXR5BgkbMQ1RMDvrPrWRK6Tw=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <4CC846D5.50106@kernel.org>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>
	 <1288189461.2709.144.camel@edumazet-laptop>
	 <1288190387.2709.147.camel@edumazet-laptop>  <4CC83A85.3070608@kernel.org>
	 <1288192868.2709.152.camel@edumazet-laptop>  <4CC846D5.50106@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 18:07:48 +0200
Message-ID: <1288195668.2709.167.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 17:35 +0200, Tejun Heo a écrit :

> Hmmm, okay.  Can you please print out early_cpu_to_node() output for
> each cpu from arch/x86/kernel/setup_percpu.c::setup_per_cpu_areas()?
> BTW, some clarifications.
> 
> * In the pcpu-alloc debug message, the n of [n] might not necessarily
>   match the NUMA node.
> 
> * I was confused before.  If CPU distance reported by
>   early_cpu_to_node() is greater than LOCAL_DISTANCE (ie. NUMA
>   configuration), cpus will always belong to different [n].  What gets
>   adjusted is the size of each unit.
> 
> * No matter what, here, the end result is correct.  As there's no low
>   memory on node 1, it doesn't matter how the groups are organized in
>   the first chunk as long as embedding is used.  And for other chunks,
>   pages for each cpu are allocated separatedly w/ cpu_to_node() anyway
>   so NUMA affinity will be correct, again, regardless of the group
>   organization.
> 
> Thanks.
> 

Will do in a few moment, once I recover from frozen machine  :(
(See end of this mail)

Thanks !

By the way, booting with hashdist=1 to make alloc_large_system_hash()
use vmalloc() show that only pages from node 0 were used at boot.

# grep alloc_large /proc/vmallocinfo 
0xf7a01000-0xf7a82000  528384 alloc_large_system_hash+0x144/0x1d9 pages=128 vmalloc N0=128
0xf7a83000-0xf7ac4000  266240 alloc_large_system_hash+0x144/0x1d9 pages=64 vmalloc N0=64
0xf7b11000-0xf7b32000  135168 alloc_large_system_hash+0x144/0x1d9 pages=32 vmalloc N0=32
0xf7b33000-0xf7c34000 1052672 alloc_large_system_hash+0x144/0x1d9 pages=256 vmalloc N0=256
0xf7c39000-0xf7cba000  528384 alloc_large_system_hash+0x144/0x1d9 pages=128 vmalloc N0=128
0xf7cbb000-0xf7cc0000   20480 alloc_large_system_hash+0x144/0x1d9 pages=4 vmalloc N0=4
0xf7cc1000-0xf7cc6000   20480 alloc_large_system_hash+0x144/0x1d9 pages=4 vmalloc N0=4


So I tried following experiment :

# swapoff
# numactl --membind=0 swapon -a
# grep swap /proc/vmallocinfo 
0xf9bf3000-0xf9cf4000 1052672 sys_swapon+0x4aa/0xb24 pages=256 vmalloc N0=256
# swapoff -a
# numactl --membind=1 swapon -a

<<FREEZE>>


