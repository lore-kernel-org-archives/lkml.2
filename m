Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2HaNK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:10:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2HaNK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:10:28 -0400
Date: Fri, 31 Aug 2012 14:10:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can not get output of command line on SH
Message-ID: <20120831131020.GB23464@ZenIV.linux.org.uk>
References: <CABMQnVL4Dnee48aQs6Bhmqt5uu_T=Ro72E47sOWcS2CyZTtu4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABMQnVL4Dnee48aQs6Bhmqt5uu_T=Ro72E47sOWcS2CyZTtu4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 04:32:45PM +0900, Nobuhiro Iwamatsu wrote:
> Hi, Al.
> 
> I can not get output of command line on SH in latest linux kernel.
> I bisected, I confirmed that this problem occurred by  following commit.
> 
> -----
> commit 4a9d4b024a3102fc083c925c242d98ac27b1c5f6
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sun Jun 24 09:56:45 2012 +0400
> 
>     switch fput to task_work_add

> For example ,when I input 'ls', nothing is displayed.
> However, it is outputted when 'Ctrl+C' is inputted.
> I checked other CPUs, it is only SH that this problem occurs.
> 
> Paul, do you think about this?

Smells like broken TIF_NOTIFY_RESUME hookup on sh...  Arrrgh.  Looks like
while it is in the relevant masks *and* checked in do_notify_resume() both
on 32bit and 64bit variants since commit ab99c733ae73cce31f2a2434f7099564e5a73d95
Author: Paul Mundt <lethal@linux-sh.org>
Date:   Wed Jul 30 19:55:30 2008 +0900

    sh: Make syscall tracer use tracehook notifiers, add TIF_NOTIFY_RESUME.

they are actually *not* reached without simulataneous SIGPENDING, since the
actual glue in the callers had not been updated back then and still checks
for _TIF_SIGPENDING alone when deciding whether to hit do_notify_resume()
or not.  Looks like the following ought to fix that:

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/sh/kernel/cpu/sh5/entry.S b/arch/sh/kernel/cpu/sh5/entry.S
index b7cf6a5..7e605b9 100644
--- a/arch/sh/kernel/cpu/sh5/entry.S
+++ b/arch/sh/kernel/cpu/sh5/entry.S
@@ -933,7 +933,7 @@ ret_with_reschedule:
 
 	pta	restore_all, tr1
 
-	movi	_TIF_SIGPENDING, r8
+	movi	(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME), r8
 	and	r8, r7, r8
 	pta	work_notifysig, tr0
 	bne	r8, ZERO, tr0
diff --git a/arch/sh/kernel/entry-common.S b/arch/sh/kernel/entry-common.S
index f67601c..b96489d 100644
--- a/arch/sh/kernel/entry-common.S
+++ b/arch/sh/kernel/entry-common.S
@@ -139,7 +139,7 @@ work_pending:
 	! r8: current_thread_info
 	! t:  result of "tst	#_TIF_NEED_RESCHED, r0"
 	bf/s	work_resched
-	 tst	#_TIF_SIGPENDING, r0
+	 tst	#(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME), r0
 work_notifysig:
 	bt/s	__restore_all
 	 mov	r15, r4
