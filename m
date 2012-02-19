Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2BSWXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 17:23:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55734 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2BSWXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 17:23:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.239.229 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Sun, 19 Feb 2012 14:23:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] More i387 state save/restore work
Message-ID: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, this is a series of two patches that continue my i387 state 
save/restore series, but aren't necessarily worth it for Linux-3.3.

That said, the first one is a bug-fix - but it's an old bug, and I'm not 
sure it can actually be triggered. The failure path for the FP state 
preload is bogus - and always was. But I'm not sure it really *can* fail.

The first one has another small bugfix in it too, and I think that one may 
be new to the rewritten FP state preloading - it doesn't update the 
fpu_counter, so once it starts preloading, it never stops.

I wrote a silly FPU task switch testing program, which basically starts 
two processes pinned to the same CPU, and then uses sched_yield() in both 
to switch back-and-forth between them. *One* of the processes uses the FPU 
between every yield, the other does not. It runs for two seconds, and 
counts how many loops it gets through.

With that test, I get:

 - Plain 3.3-rc4:

   [torvalds@i5 ~]$ uname -r
   3.3.0-rc4
   [torvalds@i5 ~]$ ./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;
   2216090 loops in 2 seconds
   2216922 loops in 2 seconds
   2217148 loops in 2 seconds
   2232191 loops in 2 seconds
   2186203 loops in 2 seconds
   2231614 loops in 2 seconds

 - With the first patch that fixes the FPU preloading to eventually stop:

   [torvalds@i5 ~]$ uname -r
   3.3.0-rc4-00001-g704ed737bd3c
   [torvalds@i5 ~]$ ./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;
   2306667 loops in 2 seconds
   2295760 loops in 2 seconds
   2295494 loops in 2 seconds
   2296282 loops in 2 seconds
   2282229 loops in 2 seconds
   2301842 loops in 2 seconds

 - With the second patch that does the lazy preloading

   [torvalds@i5 ~]$ uname -r
   3.3.0-rc4-00002-g022899d937f9
   [torvalds@i5 ~]$ ./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;
   2466973 loops in 2 seconds
   2456168 loops in 2 seconds
   2449863 loops in 2 seconds
   2461588 loops in 2 seconds
   2478256 loops in 2 seconds
   2476844 loops in 2 seconds

so these things do make some difference. But it is also interesting to see 
from profiles just how expensive setting CR0.TS is (the write to CR0 is 
very expensive indeed), so even when you avoid the FP state restore 
lazily, just setting TS in between task switches is still a big cost of 
FPU save/restore.

Linus Torvalds (2):
  i387: use 'restore_fpu_checking()' directly in task switching code
  i387: support lazy restore of FPU state

 arch/x86/include/asm/i387.h      |   48 +++++++++++++++++++++++++++----------
 arch/x86/include/asm/processor.h |    3 +-
 arch/x86/kernel/cpu/common.c     |    2 +
 arch/x86/kernel/process_32.c     |    2 +-
 arch/x86/kernel/process_64.c     |    2 +-
 arch/x86/kernel/traps.c          |   40 ++++++-------------------------
 6 files changed, 49 insertions(+), 48 deletions(-)

Comments? I feel confident enough about these that I thin kthey might even 
work in 3.3, especially the first one. But I want people to look at 
them.

                     Linus

-- 
1.7.9.188.g12766.dirty

