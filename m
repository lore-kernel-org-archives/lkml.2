Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2BSCGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 21:06:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8860 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2BSCGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 21:06:21 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=00ePz_UkAX8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=tHCE_lIPQn44v4elHTgA:9 a=kZwjN2JmyWDuylg57JEA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to determine
 nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Feb 2012 21:06:13 -0500
Message-ID: <1329617173.1561.5.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I found that it is possible for userspace to prevent an NMI from
triggering while it is running by setting its stack pointer to that of
the NMI stack. This tricks the NMI nested algorithm in thinking that the
NMI is nested. The easy solution to this is to test the %rip to make
sure that the NMI happened in kernel mode before testing for nesting.

I've tested a program that exhibits the missing NMIs and this patch
corrects that behavior.

-- Steve

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: b80ddc7b1636474297815d47fbfed7552f9b8f2c


Steven Rostedt (1):
      x86: Test saved %rip in NMI to determine nested NMI

----
 arch/x86/kernel/entry_64.S |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)
---------------------------
commit b80ddc7b1636474297815d47fbfed7552f9b8f2c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sat Feb 18 20:26:52 2012 -0500

    x86: Test saved %rip in NMI to determine nested NMI
    
    Currently, the NMI handler tests if it is nested by checking the
    special variable saved no the stack (set during NMI handling) and
    whether the saved stack is the NMI stack as well (to prevent the race
    when the variable is set to zero). But userspace may set their %rsp
    to any value as long as the do not derefence it, and it may make it
    point to the NMI stack, which will prevent NMIs from triggering while
    the userspace app is running. (I tested this, and it is indeed the case)
    
    Add another check to determine nested NMIs by looking at the saved
    %rip and making sure that it is a kernel pointer (negative).
    
    Cc: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..7c35a7a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1532,6 +1532,14 @@ ENTRY(nmi)
 	pushq_cfi %rdx
 
 	/*
+	 * If the RIP is not negative then we are in userspace where this is not
+	 * a nested NMI. 
+	 */
+	movq 8(%rsp), %rdx
+	testq %rdx, %rdx
+	jns first_nmi
+
+	/*
 	 * Check the special variable on the stack to see if NMIs are
 	 * executing.
 	 */


