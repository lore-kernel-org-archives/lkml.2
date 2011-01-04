Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1ADNUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:20:54 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40837 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026Ab1ADNUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:20:52 -0500
Subject: Re: [PATCH 11/32] v4l/cx18: update workqueue usage
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <20110104083637.GB8066@mtj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-12-git-send-email-tj@kernel.org>
	 <1294102496.10094.152.camel@morgan.silverblock.net>
	 <20110104083637.GB8066@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 08:21:35 -0500
Message-ID: <1294147295.2107.14.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-04_05:2011-01-04,2011-01-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1101040031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 09:36 +0100, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jan 03, 2011 at 07:54:56PM -0500, Andy Walls wrote:
> > 2. To prevent work items being handled by keventd/n from being delayed
> > too long, as the deferred work in question can involve a bit of sleeping
> > due to contention, the workload of the CX23418's MPEG encoding engine,
> > and the number of CX23418 devices in the system.
> > 
> > Will all the sleeping that can happen, is the move to a system wq, under
> > cmwq, going to have adverse affects on processing other work items in
> > the system?
> > 
> > I get the feeling it won't be a problem with cmwq, but I haven't paid
> > enough attention to be sure. 
> 
> It won't be a problem.  Now the system_wq supports parallel execution
> of multiple works and manages concurrency automatically.  Work items
> can sleep as necessary without worrying about other work items.

OK, that's what I thought.  I just wanted to ensure that busy CX23418
chips are not going to delay the processing of other work-events in the
rest the system down. 

> ...
> > It is not unusual for scheduled TV recording software to start nearly
> > simultaneous DTV TS, MPEG, and VBI or MPEG Index streams on multiple
> > cards.  So 3 CX23418 cards with 3 streams each.   Let's nominally
> > estimate the timing of the CX18_CPU_DE_SET_MDL commands per stream at
> > the PAL frame rate of 25 Hz; or 1 CX18_CPU_DE_SET_MDL mailbox command
> > per stream per 40 milliseconds.
> 
> IIUC, if they spend any significant amount of time executing, they'll
> be doing so by waiting for events (mutex, IRQ...), right?

Right.  As a CX23418 is expected to do more streaming by the host, the
mailbox mutex contention goes up and the latency of the CX23418
responding to mailbox commands also goes up so there is more wait()ing.


>   If so,
> there's nothing to worry about.  If it's gonna burn a lot of CPU
> cycles, we'll need to use a workqueue marked CPU_INTENSIVE but I don't
> think that's the case here.

Correct, CPU is not the concern here.


> Thank you.

Thanks.  I'll do a proper inspection of the patch tonight.  It looked OK
on cursory review.

Regards,
Andy

