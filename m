Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1BVMKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:10:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40800 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab1BVMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:10:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PMQp7XzlEesqJPX1xtK0xHGD4dsPrzRPZpGRqPcg9Yr1n3uglYoqcA1bUKrihVLTJM
         +mSJi5a0/OSjnkZbjbJsK1+Ix1Ka95UL0UyHLEP0eM54V0Rta2uDm9+C5DOWKUaGNhFW
         sP5dc8ILWLCENhdjBaBK7RQSnDw3bbGBgHYb8=
Date: Tue, 22 Feb 2011 20:10:02 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH V2] sched, autogroup: always show autogroup name in
 sched_debug
Message-ID: <20110222121002.GA2100@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
 <1298207379.7998.11.camel@marge.simson.net>
 <20110220141003.GA6006@zhy>
 <1298222533.7881.15.camel@marge.simson.net>
 <1298306175.24121.14.camel@twins>
 <AANLkTin_aqBTXUyO4H-p1_4i-9FAvxChBi1QpPFXvqD_@mail.gmail.com>
 <1298368566.2217.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298368566.2217.18.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 10:56:06AM +0100, Peter Zijlstra wrote:
> On Tue, 2011-02-22 at 11:13 +0800, Yong Zhang wrote:
> > So show autogroup name always. But for the root group,
> > its name will dance between "cfs_rq[cpu]:" and
> > "cfs_rq[cpu]:/autogroup-0" according to
> > sysctl_sched_autogroup_enabled. 
> 
> Would it make sense to force the root group to always be a !autogroup?

Hmmm, I think it's ok.

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] sched, autogroup: always show autogroup name in sched_debug

When autogroup is disabled, there will be lots of group
named "cfs_rq[cpu]:", thus will lead to confusion for
who read it.
And for now, autogroup runtime disable/enable will
not take effect immediately on current live processes,
so there maybe still have some processes attaching to
its autogroup.
So show autogroup name always. But for the root group,
its name will always be "cfs_rq[cpu]:/".

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_autogroup.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 9fb6562..5b9a317 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -258,9 +258,7 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
-	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
-
-	if (!enabled || !tg->autogroup)
+	if (!tg->autogroup || !tg->autogroup->id)
 		return 0;
 
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
-- 
1.7.1

