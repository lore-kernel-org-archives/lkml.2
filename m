Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030615Ab2CFVlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:41:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51056 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab2CFVlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:41:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.60.4.106 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: fork_idle from wq cleanup
Date: Tue,  6 Mar 2012 13:41:09 -0800
Message-Id: <1331070074-31717-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
References: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looked at avoiding the wq stuff. But, there is no easy/clean way to do
if as we have number of routines within copy_process assume current
being the parent.

But, we can move most of the complication out of arch code into generic code
and share it across multiple archs. Here is the patch for that.

We can easily add x86 percpu idle task on top of this cleanup (except for
mini-circus to switch idle_task of CPU 0).

Sorry. The patches for ia64, mips, powerpc and s390 are untested and are in
"should work" category.

Overall diffstat looks like
---
 arch/ia64/kernel/smpboot.c |   49 ++---------------------------
 arch/mips/kernel/smp.c     |   47 +---------------------------
 arch/powerpc/kernel/smp.c  |   63 ++++----------------------------------
 arch/s390/kernel/smp.c     |   38 +++--------------------
 arch/x86/kernel/smpboot.c  |   74 ++++++---------------------------------------
 include/linux/sched.h      |    1 
 kernel/fork.c              |   48 +++++++++++++++++++++++++++++
 7 files changed, 79 insertions(+), 241 deletions(-)

