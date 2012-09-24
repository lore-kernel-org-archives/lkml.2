Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2IXRQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:16:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45012 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2IXRQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:16:36 -0400
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
Subject: Re: [patch 00/16] sched: per-entity load-tracking
References: <20120823141422.444396696@google.com>
	<50602849.70506@cs.tu-berlin.de>
Date: Mon, 24 Sep 2012 10:16:31 -0700
In-Reply-To: <50602849.70506@cs.tu-berlin.de> ("Jan H. =?utf-8?Q?Sch=C3=B6?=
 =?utf-8?Q?nherr=22's?= message of
	"Mon, 24 Sep 2012 11:30:49 +0200")
Message-ID: <xm26zk4fbats.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan H. Schönherr" <schnhrr@cs.tu-berlin.de> writes:

> Hi Paul.
>
> Am 23.08.2012 16:14, schrieb pjt@google.com:
>> Please find attached the latest version for CFS load-tracking.
>
> Originally, I thought, this series also takes care of
> the leaf-cfs-runqueue ordering issue described here:
>
> http://lkml.org/lkml/2011/7/18/86
>
> Now, that I had a closer look, I see that it does not take
> care of it.
>
> Is there still any reason why the leaf_cfs_rq-list must be sorted?
> Or could we just get rid of the ordering requirement, now?

Ideally yes, since a parent's __update_cfs_rq_tg_load_contrib and
update_cfs_shares still depend on accurate values in
runnable_load_avg/blocked_load_avg from its children. That said, nothing
should completely fall over, it would make load decay take longer to
propogate to the root.
>
> (That seems easier than to fix the issue, as I suspect that
> __update_blocked_averages_cpu() might still punch some holes
> in the hierarchy in some edge cases.)

Yeah, I suspect it's possible that the parent ends up with a slightly
lower runnable_avg_sum if they're both hovering around the max value
since it isn't quite continuous, and it might be the case that this
difference is large enough to require one more tick to decay to zero.
