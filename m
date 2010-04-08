Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab0DHHSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:18:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:35555 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449Ab0DHHSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:18:10 -0400
Date: Thu, 8 Apr 2010 15:16:17 +0800
From: Liang Li <liang.li@windriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Amit Shah <shahamit@gmail.com>
Subject: Re: [Bug #15615] NULL pointer deref in task_is_waking
Message-ID: <20100408071617.GC26543@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
 <JVS2s9dmTsP.A.ivH.2tPvLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JVS2s9dmTsP.A.ivH.2tPvLB@chimera>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 08 Apr 2010 07:17:35.0429 (UTC) FILETIME=[8FF44750:01CAD6EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 11:13:48PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).

The bug still there. I just met it. And seems its quite simple to get it
fixed.

diff --git a/kernel/sched.c b/kernel/sched.c
index a3dff1f..2df1a76 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -913,7 +913,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
  */
 static inline int task_is_waking(struct task_struct *p)
 {
-	return unlikely((p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
+	return unlikely(p && (p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
 }
 
 /*

But seems commitid 0017d735092844118bef006696a750a0e4ef6ebd in tip tree
also touched task_is_waking. So the patch for tip tree should be:

diff --git a/kernel/sched.c b/kernel/sched.c
index 3acf694..d259641 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -920,7 +920,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
  */
 static inline int task_is_waking(struct task_struct *p)
 {
-	return unlikely(p->state == TASK_WAKING);
+	return unlikely(p && p->state == TASK_WAKING);
 }
 
 /*

Regards,
	-Liang Li

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15615
> Subject		: NULL pointer deref in task_is_waking
> Submitter	: Amit Shah <shahamit@gmail.com>
> Date		: 2010-03-23 04:04 (16 days old)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
