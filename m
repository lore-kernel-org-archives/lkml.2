Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1BVDNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:13:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48871 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1BVDNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:13:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RijWIJuf07/GHn1BO8bZoqafJL25GDP2urS42rq59Q6do68Xry0u09IkvOelCkh5df
         oaDaSaAqUk0w7zOTrKBF/PMPXkzlYKA/DxOGcRoBgNAeGRMdNyYKrEyUYmnngjumJ8i+
         HPhr6Mn5fvCIkmJD3Lr9R39xzJC0Omg5y07Ao=
MIME-Version: 1.0
In-Reply-To: <1298306175.24121.14.camel@twins>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	<1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
	<1298207379.7998.11.camel@marge.simson.net>
	<20110220141003.GA6006@zhy>
	<1298222533.7881.15.camel@marge.simson.net>
	<1298306175.24121.14.camel@twins>
Date: Tue, 22 Feb 2011 11:13:40 +0800
Message-ID: <AANLkTin_aqBTXUyO4H-p1_4i-9FAvxChBi1QpPFXvqD_@mail.gmail.com>
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2011-02-20 at 18:22 +0100, Mike Galbraith wrote:
>>
>> Your whole series looked fine to me at a glance (sunday;), with the
>> exception of #2, that one is maybe iffy, depending on point of view.
>
> Right, so I've queued 1 and 3, 2 is like you said iffy, if there's an
> autogroup it should display it.

So how about replacing patch-2 by below one for now?

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
its name will dance between "cfs_rq[cpu]:" and
"cfs_rq[cpu]:/autogroup-0" according to
sysctl_sched_autogroup_enabled.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_autogroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 64919dc..6114e3e 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -301,7 +301,7 @@ static inline int autogroup_path(struct task_group
*tg, char *buf, int buflen)
 {
 	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);

-	if (!enabled || !tg->autogroup)
+	if (!tg->autogroup || (!tg->autogroup->id && !enabled))
 		return 0;

 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
-- 
1.7.1
-- 
Only stand for myself
