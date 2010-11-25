Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0KYDlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 22:41:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50714 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0KYDl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 22:41:29 -0500
Message-ID: <4CEDDB2A.2020807@cn.fujitsu.com>
Date: Thu, 25 Nov 2010 11:42:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] rcu: Fix series of spurious RCU softirqs
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
In-Reply-To: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-25 11:41:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-25 11:41:45,
	Serialize complete at 2010-11-25 11:41:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 08:31 AM, Frederic Weisbecker wrote:
> Hi,
> 
> I've observed some not so unfrequent series of spurious rcu
> softirqs, sometimes happening at each ticks for a random
> while.
> 
> These patches aims at fixing them.
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>   rcu: Don't chase unnecessary quiescent states after extended grace periods
>   rcu: Stop checking quiescent states after grace period completion from remote
> 

If we ensure rdp->gpnum >= rdp->completed is always true, the problems as
you described will not be existed. Or maybe I misunderstand you.

rdp->gpnum >= rdp->completed is a very important guarantee I think.
(In my RCURING, it is guaranteed.) I'm afraid there are some other
problems still hidden if it is not guaranteed.

so I recommend: (code is better than words)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d5bc439..af4e87a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -648,6 +648,13 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
+
+		/* Ensure ->gpnum >= ->completed after NO_HZ */
+		if (unlikely(rnp->completed - rdp->gpnum > 0
+				|| rdp->gpnum - rnp->gpnum > 0)) {
+			rdp->gpnum = rnp->completed;
+			rdp->qs_pending = 0;
+		}
 	}
 }
 
