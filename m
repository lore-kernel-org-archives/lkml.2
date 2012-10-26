Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965272Ab2JZQPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:15:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36732 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038Ab2JZQPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:15:47 -0400
MIME-Version: 1.0
In-Reply-To: <1351053164.6537.95.camel@edumazet-glaptop>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	<1350925299.8609.978.camel@edumazet-glaptop>
	<CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
	<CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
	<CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com>
	<1351053164.6537.95.camel@edumazet-glaptop>
Date: Fri, 26 Oct 2012 09:15:46 -0700
X-Google-Sender-Auth: sqww5x4z8rC_gIw1EXdmFZmYVRE
Message-ID: <CAN8Q1Ef9sCAG8-KNWXEeuRUcmFNcg93mMG=HRQw6i3UuGtJCVg@mail.gmail.com>
Subject: Re: Process Hang in __read_seqcount_begin
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 9:32 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Could you try following patch ?

So, I applied your patch.  And so far, it seems to have fixed the
issue.  I've had my systems running for 48 hours, and no lockup in
iptables.  Usually, I could get a lockup to occur within 12 to 24
hours, and running this long tells me this patch may have things
fixed.

Now, I have a couple of questions.

First, I'm not sure how this actually fixes things.  It does seem
there was a race before.  But it isn't clear to me how this patch
eliminates the race.  I fear that this patch only reduces the window
in which a race could occur, but doesn't eliminate it completely.

Second, perhaps use seqlock_t instead of a seqcount_t for xt_recseq?
This eliminates the problem.  But given that it has been using
seqcount_t for a long time, and is still using it, and nobody else has
had this issue appear, makes me wonder if this problem isn't something
unique to the RT patches.  Perhaps only use seqlock_t in built for
PREEMPT_RT_FULL?

Third, recent RT patches (such as 3.6.2-rt4) have added
preempt_disable_rt() and preempt_enable_rt() calls inside of
read_seqcount_begin() and write_seqcount_end() respectively.  The call
to local_bh_disable/local_bh_enable doesn't do anything to
disable/enable preemption (in 3.6.2-rt4), but it does in 3.03.36-rt58.
 But in 3.0.36-rt58 it only did so if not in an atomic context.  And
it doesn't appear to be an atomic context since local_bh_disable
increments preempt_count by SOFTIRQ_OFFSET.  And it appeared that
building with SMP enabled, even though it did call
preempt_disable_rt(), indirectly, through local_bh_disable(), but the
lockup still occurred.

Finally, after more testing, if this patch proves a solution to the
problem, we could apply it locally.  But what kind of testing would be
required as part of a submission back to the general kernel/RT folk?
The patch is easy enough to generate, but if it can't be proven that
this patch actually fixes anything, I fail to see how it would be
useful.

Thanks,
Pete LaDow
