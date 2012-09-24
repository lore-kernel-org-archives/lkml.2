Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2IXUjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:39:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab2IXUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:39:41 -0400
From: Benjamin Segall <bsegall@google.com>
To: =?utf-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: pjt@google.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [patch 11/16] sched: replace update_shares weight distribution with per-entity computation
References: <20120823141422.444396696@google.com>
	<20120823141507.061208672@google.com> <5060B82B.1050206@cs.tu-berlin.de>
Date: Mon, 24 Sep 2012 13:39:36 -0700
In-Reply-To: <5060B82B.1050206@cs.tu-berlin.de> ("Jan H. =?utf-8?Q?Sch?=
 =?utf-8?Q?=C3=B6nherr=22's?= message
	of "Mon, 24 Sep 2012 21:44:43 +0200")
Message-ID: <xm26vcf3b1fb.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blocked_load_avg ~= \sum_child child.runnable_avg_sum/child.runnable_avg_period * child.weight

The thought was: So if all the children have hit zero runnable_avg_sum
(or in the case of a child task, will when they wake up), then
blocked_avg sum should also hit zero at the same and we're in theory
fine.

However, child load can be significantly larger than even the maximum
value of runnable_avg_sum (and you can get a full contribution off a new
task with only one tick of runnable_avg_sum anyway...), so
runnable_avg_sum can hit zero first due to rounding. We should case on
runnable_avg_sum || blocked_load_avg.


As a side note, currently decay_load uses SRR, which means none of these
will hit zero anyway if updates occur more often than once per 32ms. I'm
not sure how we missed /that/, but fixes incoming.

Thanks,
Ben

