Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1EOEfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 00:35:10 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46353 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1EOEfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 00:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=reiRrJ6BZ0DkbfR5Auwg0x+9vH7HmFB3BK1acX6RLaq8wPNnEm61oZH6aVgC2cTVDH
         Enx2xwzsnIeUNhJEzgDXeBEDt2eZMiXbXW6GRDoP8upQWzskCeedc5BhieFnzA8AGhJf
         8q1+4WjgiPSXcN5Y0b8jOnto2rYwV8I/5xjts=
MIME-Version: 1.0
Date: Sun, 15 May 2011 12:35:02 +0800
Message-ID: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
Subject: [PATCH] sched: avoid overpull when pulling RT task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pulling RT task for a given runqueue, pulling is continued even
after certain RT tasks get pulled, in case there are still higher
priority tasks on other runqueues, though it is low likelihood as the
comment says. The load of of this runqueue, on other hand, should also
be concerned. If it is overloaded, the low likelihood should be
abandoned to avoid overpull.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 14c764b..b425ca1 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1508,6 +1508,11 @@ static int pull_rt_task(struct rq *this_rq)
 		}
 skip:
 		double_unlock_balance(this_rq, src_rq);
+
+		/* if pulled we have to also avoid overpull */
+		if (ret == 1)
+			if (likely(rt_overloaded(this_rq)))
+				break;
 	}

 	return ret;
