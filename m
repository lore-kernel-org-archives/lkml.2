Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1GFCHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 22:07:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1GFCHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 22:07:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=TTjcjvNlzjwHWk18VmqpShBlIf5x/BysdHOrRnWpY3Tqv9qu1D8jqJh39Dxg5rL5+
	NSd/vfv66wdeyZfNamf/g==
MIME-Version: 1.0
In-Reply-To: <20110702102721.GE17482@elte.hu>
References: <20110702005222.262883892@google.com> <20110702005228.481583467@google.com>
 <20110702090817.GB17482@elte.hu> <1309600625.10073.8.camel@twins> <20110702102721.GE17482@elte.hu>
From: Paul Turner <pjt@google.com>
Date: Tue, 5 Jul 2011 19:07:21 -0700
Message-ID: <CAPM31R+2Ke2urUZKao5W92_LupdR4AYEv-EZWiJ3tG=tEes2cw@mail.gmail.com>
Subject: Re: [patch 1/1] sched: update_curr versus correct cfs_rq in check_preempt_wakeup
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 3:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> On Sat, 2011-07-02 at 11:08 +0200, Ingo Molnar wrote:
>> > * Paul Turner <pjt@google.com> wrote:
>> >
>> > > We update_curr() versus the current entity as the preemption
>> > > decision is based on the relative vruntime.  However, update_curr()
>> > > is not hierarchical and in the group scheduling case
>> > > find_matching_se() will have us making the comparison on a cfs_rq
>> > > different to the one just updated.
>> >
>> > Would be nice to include more contextual information in the
>> > changelog: how did you find it, what effect (if any) did you see
>> > from this patch, what effect do you expect others to see (if
>> > any).
>>
>> Agreed that the Changelog can be improved. From talking to pjt on
>> IRC though, I think he spotted this by reading through the code.
>
> 'code review' is a perfect answer to the 'how did you find it'

Sure, sorry for omitting this -- updated below.

> question: when people read the changelog they will know that no
> practical effect has been observed (yet).

So there should definitely be a measurable practical effect; for the
running task we are potentially leaving up to a tick of execution
unaccounted in deciding whether or not we cross the wakeup_gran to
preempt.

The fact that this drift is bounded above by our vruntime updates
within entity_tick largely masks the negative effects of this.

>
> Thanks,
>
>        Ingo
>


sched: update correct entity's runtime in check_preempt_wakeup()

While looking at check_preempt_wakeup() I realized that we are potentially
updating the wrong entity in the fair-group scheduling case.  In this case
the current task's cfs_rq may not be the same as the one used for the
comparison between the waking task and the existing task's vruntime.

This potentially results in us using a stale vruntime in the pre-emption
decision, providing a small false preference for the previous task.  The
effects of this are bounded since we always perform a hierarchal update on the
tick.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip2/kernel/sched_fair.c
===================================================================
--- tip2.orig/kernel/sched_fair.c
+++ tip2/kernel/sched_fair.c
@@ -1919,8 +1919,8 @@ static void check_preempt_wakeup(struct
        if (!sched_feat(WAKEUP_PREEMPT))
                return;

-       update_curr(cfs_rq);
        find_matching_se(&se, &pse);
+       update_curr(cfs_rq_of(se));
        BUG_ON(!pse);
        if (wakeup_preempt_entity(se, pse) == 1) {
