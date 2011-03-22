Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1CVWGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:06:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab1CVWGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:06:54 -0400
Date: Tue, 22 Mar 2011 18:06:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cfq-iosched: Don't set active queue in preempt
Message-ID: <20110322220651.GA8080@redhat.com>
References: <1300825050-11371-1-git-send-email-teravest@google.com>
 <1300825050-11371-2-git-send-email-teravest@google.com>
 <20110322205905.GM3757@redhat.com>
 <AANLkTi=GcnW2JCrc0JE4+y5PwSgNjcaquEn-btydS4NT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=GcnW2JCrc0JE4+y5PwSgNjcaquEn-btydS4NT@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 02:58:48PM -0700, Justin TerAvest wrote:
[..]
> >>       cfqd->active_queue = cfqq;
> >> @@ -3332,7 +3338,8 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >>       BUG_ON(!cfq_cfqq_on_rr(cfqq));
> >>
> >>       cfq_service_tree_add(cfqd, cfqq, 1);
> >> -     __cfq_set_active_queue(cfqd, cfqq);
> >> +
> >> +     cfq_clear_queue_stats(cfqd, cfqq);
> >
> > Hi Justin,
> >
> > Why do we have to clear queue stats here for the preempting queue?
> >
> > Especially look at cfqq->dispatch_start = jiffies. We have not started
> > the dispatch yet. When this queue is selected next, then we will start
> > the dispatch.
> >
> > So this patch has introduced another bug now. Now after preemption if
> > we don't select this group, then we have a queue with wrong dispatch
> > start and that will result in huge slice_used for the queue and
> > it will not get its fair share.
> 
> Hi Vivek,
> 
> Ugh, you're right. Sorry, I had some bad ideas in my head for how
> preemption worked that clearly aren't true.
> I think that if the stats aren't cleared here, everything should then
> be fine because jiffies will then be picked up when the active queue
> is set. Does that sound sane to you?
> 

Yes, that makes sense. Primarily you are looking for unaccounted seek time
(slice_start - dispatch_start) and dispatch_start will be set when the
preempting queue is selected for dispatch. So I don't think you have to
clear up anything in cfq_preempt_queue().

Thanks
Vivek
