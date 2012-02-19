Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2BSVng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:43:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2BSVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:43:35 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=mY7GROr8ulsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=YOlqmmHnu5ZfTsnnHxQA:9 a=fpzHbEHZ0ZuMxhRgE2IA:7 a=QEXdDO2ut3YA:10 a=HEdnscJc8mAA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [PATCH v2][GIT PULL][v3.3] x86: Test saved %cs in NMI to determine
 nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20120219125601.GD25900@elte.hu>
References: <1329617173.1561.5.camel@acer.local.home>
	 <20120219125601.GD25900@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Feb 2012 16:43:37 -0500
Message-ID: <1329687817.1561.27.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased the same branch so you may need to wait a little for the
kernel.org mirrors to update.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 38f53faa02c0976ed0a6f0290771a4cbe6dc655b


Steven Rostedt (1):
      x86: Test saved %cs in NMI to determine nested NMI

----
 arch/x86/kernel/entry_64.S |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
---------------------------
commit 38f53faa02c0976ed0a6f0290771a4cbe6dc655b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sat Feb 18 20:26:52 2012 -0500

    x86: Test saved %cs in NMI to determine nested NMI
    
    Currently, the NMI handler tests if it is nested by checking the
    special variable saved on the stack (set during NMI handling) and
    whether the saved stack is the NMI stack as well (to prevent the race
    when the variable is set to zero). But userspace may set their %rsp
    to any value as long as they do not derefence it, and it may make it
    point to the NMI stack, which will prevent NMIs from triggering while
    the userspace app is running. (I tested this, and it is indeed the case)
    
    Add another check to determine nested NMIs by looking at the saved
    %cs (code segment register) and making sure that it is the kernel code segment.
    
    Cc: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..debd851 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1532,6 +1532,13 @@ ENTRY(nmi)
 	pushq_cfi %rdx
 
 	/*
+	 * If %cs was not the kernel segment, then the NMI triggered in user
+	 * space, which means it is definitely not nested.
+	 */
+	cmp $__KERNEL_CS, 16(%rsp)
+	jne first_nmi
+
+	/*
 	 * Check the special variable on the stack to see if NMIs are
 	 * executing.
 	 */


