Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2BTTqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:46:42 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34160 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab2BTTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:46:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.190.4 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Mon, 20 Feb 2012 11:46:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] More i387 state save/restore work
In-Reply-To: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a slightly updated patch-series that does the same thing my
previous one did, just fixing a few special cases.

In particular, I noticed that the 'fpu_counter' situation was still
rather confused in the last patch-series, and instead of having patch#1
fix up a part of it as part of re-organizing the FP state restore code,
this just fixes the fpu_counter confusion separately.  Especially since
I wanted to clear the fpu_counter at fork time for new processes, just
to make sure tht we never try to lazily switch to stale FPU state
(re-used task struct pointer and all that). 

So patch#1 is that fpu_counter work.

The two other patches are basically the same as last time, except with 
slightly updated commit logs and obviously updated for the fpu_counter 
fixes (it is, for example, wrong to update the counter at FPU preload 
time: if we do the lazy restore, there won't be any explicit preload, but 
the fpu_counter should still update - so that affected the preloading 
thing).

I've also done more testing of the series, although some of that shows
funny effects: it's actually faster on my machine (and in my specialized
tests) to switch between two processes where *one* uses the FPU with
these lazy restore patches than it is to switch between two non-FPU
users. 

However, that seems to be due to some funny cache interaction: the
profiles clearly show that '__switch_to()' itself is much faster if it
doesn't have to work with any FPU state at all.  But probably because of
some random cache replacement detail, I then get more switches with the
more expensive __switch_to when I only save the FP state (without ever
restoring it).

Regardless, I'm pretty happy with this series, and I think I'll commit
and push out at least the two first patches just because they fix real
(albeit not very important) bugs.  I feel like I'm going to do the third
one too for 3.3, but I'm not sure yet.  And comments welcome.

                Linus


Linus Torvalds (3):
  i387: fix up some fpu_counter confusion
  i387: use 'restore_fpu_checking()' directly in task switching code
  i387: support lazy restore of FPU state

 arch/x86/include/asm/i387.h      |   53 +++++++++++++++++++++++++++----------
 arch/x86/include/asm/processor.h |    3 +-
 arch/x86/kernel/cpu/common.c     |    2 +
 arch/x86/kernel/process_32.c     |    3 +-
 arch/x86/kernel/process_64.c     |    3 +-
 arch/x86/kernel/traps.c          |   40 +++++-----------------------
 6 files changed, 54 insertions(+), 50 deletions(-)

-- 
1.7.9.188.g12766.dirty

