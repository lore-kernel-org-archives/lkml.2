Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0F3Pak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:30:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60047 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab0F3Pai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T1RyrkEpsgPU+WlK9wwnspprep0z4pr2NMIBQNbzFkd4ZIMEVQ7ZyGx+MAFJQSGZbw
         hjJLGtIGqRe/WCJelmZqs94PTUsFKLXQqk5wxCrsvlPW9XSk/T/ZANhBCLGwO8A82Hmd
         SwAHfYKMaWpX7lt2rtGfDFF3sfnM+fdPIcogI=
MIME-Version: 1.0
In-Reply-To: <20100629123032.GC7094@redhat.com>
References: <20100621110436.GA4056@lst.de>
	<4C1FB5F7.3070908@kernel.dk>
	<20100621191410.GA24213@lst.de>
	<20100621213618.GC6474@redhat.com>
	<20100623100138.GA9575@lst.de>
	<20100624014420.GB3297@redhat.com>
	<20100625110319.GA12855@lst.de>
	<20100626033509.GA2435@redhat.com>
	<x49wrtk32g1.fsf@segfault.boston.devel.redhat.com>
	<AANLkTiktd7GxqDkezq7LJ3vN8D0wFgzKePdQBAY3bz17@mail.gmail.com>
	<20100629123032.GC7094@redhat.com>
Date: Wed, 30 Jun 2010 17:30:35 +0200
Message-ID: <AANLkTimttvpIuS-NybdlWOR7-7v2gfXWvJQdeOo_02AR@mail.gmail.com>
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 2:30 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jun 29, 2010 at 11:06:19AM +0200, Corrado Zoccolo wrote:
>
> [..]
>> > I'm now testing OCFS2, and I'm seeing performance that is not great
>> > (even with the blk_yield patches applied).  What happens is that we
>> > successfully yield the queue to the journal thread, but then idle on the
>> > journal thread (even though RQ_NOIDLE was set).
>> >
>> > So, can we just get rid of idling when RQ_NOIDLE is set?
>> Hi Jeff,
>> I think I spotted a problem with the initial implementation of the
>> tree-wide idle when RQ_NOIDLE is set: I assumed that a queue would
>> either send possibly-idling requests or no-idle requests, but it seems
>> that RQ_NOIDLE is being used to mark the end of a stream of
>> possibly-idling requests (in my initial implementation, this will then
>> cause an unintended idle). The attached patch should fix it, and I
>> think the logic is simpler than Vivek's. Can you give it a spin?
>> Otherwise, I think that reverting the "noidle_tree_requires_idle"
>> behaviour completely may be better than adding complexity, since it is
>> really trying to solve corner cases (that maybe happen only on
>> synthetic workloads), but affecting negatively more common cases.
>>
>
> Hi Corrado,
>
> I think you forgot to attach the patch? Can't find it.
No, it's there:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-06/msg10854.html
>
>
>> About what it is trying to solve, since I think it was not clear:
>> - we have a workload of 2 queues, both issuing requests that are being
>> put in the no-idle tree (e.g. they are random) + 1 queue issuing
>> idling requests (e.g. sequential).
>> - if one of the 2 "random" queues marks its requests as RQ_NOIDLE,
>> then the timeslice for the no-idle tree is not preserved, causing
>> unfairness, as soon as an RQ_NOIDLE request is serviced and the tree
>> is empty.
>
> I think Jeff's primary regressions were coming from the fact that we
> will continue to idle on SYNC_WORKLOAD even if RQ_NOIDLE() was set.

I see. There are probably two ways of handling this:
- make sure the queues sending RQ_NOIDLE requests are marked as
SYNC_NOIDLE_WORKLOAD. Something like this should work, even if it will
increase switching between trees:
@@ -3046,6 +3046,7 @@ cfq_update_idle_window(struct cfq_data *cfqd,
struct cfq_queue *cfqq,
                cfq_mark_cfqq_deep(cfqq);

        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
+           (cfqq->next_rq && rq_noidle(cfqq->next_rq)) ||
            (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
                enable_idle = 0;
        else if (sample_valid(cic->ttime_samples)) {

- or we could explicitly check the rq_noidle() in
cfq_completed_request for SYNC_WORKLOAD:
@@ -3360,8 +3360,10 @@ static void cfq_completed_request(struct
request_queue *q, struct request *rq)
                         * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
                         * only if we processed at least one !rq_noidle request
                         */
-                       if (cfqd->serving_type == SYNC_WORKLOAD
-                           || cfqd->noidle_tree_requires_idle
+                       if ((cfqd->serving_type == SYNC_WORKLOAD
+                            && !rq_noidle(rq))
+                           || (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
+                               && cfqd->noidle_tree_requires_idle)
                            || cfqq->cfqg->nr_cfqq == 1)
                                cfq_arm_slice_timer(cfqd);
                }

> Regarding giving up idling on sync-noidle workload, I think it still
> makes some sense to keep track if some other random queue is doing IO on
> that tree or not and if yes, then continue to idle. That's a different
> thing that current logic if more coarse and could be fine grained a bit.

The patch in previous message should fix this.

>
> Because I don't have a practical workload example at this point of time, I
> also don't mind reverting your old patch and restoring the policy of not
> idling if RQ_NOIDLE() was set.
>
> But it still does not answer the question that why O_DIRECT and O_SYNC
> paths be different when it comes to RQ_NOIDLE.
This is outside my knowledge.

Thanks
Corrado
>
> Thanks
> Vivek
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
