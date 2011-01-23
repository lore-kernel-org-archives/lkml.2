Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab1AWOyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 09:54:39 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64529 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1AWOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 09:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SA9uylTd9vxarr5MVgDN72vdJxu74Q0mXclI3xqb8VRpmQkpew++HjjnijcjC45qLY
         BlDaMynichomZ4/6apyeVwgbIGCirMhOtRFJ4RJPDWiZ0oheUn+JvkDzAvKdgNPt5U0U
         dHx9Lr/qAbOjPJyL1ADv6bDPOkKfVk0VnJfV8=
Date: Sun, 23 Jan 2011 22:54:29 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Christian Kujau <christian@nerdbynature.de>
Cc: Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 'autogroup' sched code KILLING responsiveness
Message-ID: <20110123145429.GA2523@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
 <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 02:50:08AM -0800, Christian Kujau wrote:
> On Fri, 21 Jan 2011 at 10:20, Michael Witten wrote:
> > With that code in place, a resource-intensive activity (such as
> > compiling the Linux kernel) causes my computer to become
> > unresponsive for many seconds at a time; the entire screen
> > does not refresh, typed keys are dropped or are handled very
> > late, etc (even in Linux's plain virtual consoles).
> 
> Unfortunately, I'd like to add a "me too". 2.6.38-rc1 behaves fine, but 
> with CONFIG_SCHED_AUTOGROUP=y and doing I/O and CPU intensive work (git 
> prune/git repack on a Linux git tree), system load goes up to ~13 and 
> becomes unresponse for some time too. This even happens when I start the 
> jobs with nice -n10.
> 
> Without CONFIG_SCHED_AUTOGROUP enabled and doing the same work,
> systemload goes up to 1 or maybe 2.
> 
> I'm on UP as well (PowerPC G4), disabling CONFIG_SCHED_AUTOGROUP helps 
> here too.

I think below patch will fix it.

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] sched: tg->se->load should be initialised to tg->shares

Michael reported that when enable autogroup on UP, system
responsiveness becomes very bad.
Because in init_tg_cfs_entry() we initialise se->load
to 0 instead of tg->shares, in the end we have 0-weight
sched entity on rq, then lead to misbehavior.

Reported-by: Michael Witten <mfwitten@gmail.com>
Reported-by: Christian Kujau <christian@nerdbynature.de>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..3ec2c6c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7857,7 +7857,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
+	update_load_set(&se->load, tg->shares);
 	se->parent = parent;
 }
 #endif
-- 
1.7.1


