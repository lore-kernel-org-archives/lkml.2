Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030615Ab2B2RD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:03:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45729 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964977Ab2B2RD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:03:27 -0500
Message-ID: <1330534998.11248.158.camel@twins>
Subject: Re: Inconsistent load average on tickless kernels
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Les=C5=82aw_Kope=C4=87?= <leslaw.kopec@nasza-klasa.pl>
Cc: Aman Gupta <aman@tmm1.net>, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Date: Wed, 29 Feb 2012 18:03:18 +0100
In-Reply-To: <1330532667.11248.153.camel@twins>
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>
	 <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins>
	 <1330532667.11248.153.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 17:24 +0100, Peter Zijlstra wrote:
> 
> The only thing I could find is that on nohz we can confuse the per-rq
> sample period, does the below make a difference? 

Uhm, something like so that is.. 

---
 kernel/sched/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d7c4322..44f61df 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2380,7 +2380,8 @@ static void calc_load_account_active(struct rq *this_rq)
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
-	this_rq->calc_load_update += LOAD_FREQ;
+	while (!time_before(jiffies, this_rq->calc_load_update))
+		this_rq->calc_load_update += LOAD_FREQ;
 }
 
 /*

