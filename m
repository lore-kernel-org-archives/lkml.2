Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0D1VJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:09:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53474 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab0D1VJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:09:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
Date: Wed, 28 Apr 2010 23:09:42 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <1272429119-12103-7-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com>
In-Reply-To: <20100428194028.GA16389@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004282309.42188.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010, Oleg Nesterov wrote:
> On 04/27, Arve Hjønnevåg wrote:
> >
> > Allow work to be queued that will block suspend while it is pending
> > or executing. To get the same functionality in the calling code often
> > requires a separate suspend_blocker for pending and executing work, or
> > additional state and locking. This implementation does add additional
> > state and locking, but this can be removed later if we add support for
> > suspend blocking work to the core workqueue code.
> 
> I think this patch is fine.
> 
> Just one silly question,
> 
> > +int queue_suspend_blocking_work(struct workqueue_struct *wq,
> > +				struct suspend_blocking_work *work)
> > +{
> > +	int ret;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&work->lock, flags);
> > +	suspend_block(&work->suspend_blocker);
> > +	ret = queue_work(wq, &work->work);
> > +	if (ret)
> > +		work->active++;
> 
> why not
> 
> 	ret = queue_work(wq, &work->work);
> 	if (ret) {
> 		suspend_block(&work->suspend_blocker);
> 		work->active++;
> 	}
> 
> ?
> 
> Afaics, we can't race with work->func() doing unblock, we hold work-lock.
> And this way the code looks more clear.

Agreed.  Arve, any objections to doing that?

> Sorry, I had no chance to read the previous patches. After the quick look
> at 1/8 I think it is OK to call suspend_block() twice, but still...

It is.

> Or I missed something? Just curious.
> 
> 
> Hmm... actually, queue_work() can also fail if we race with cancel_ which
> temporary sets WORK_STRUCT_PENDING. In that case suspend_block() won't
> be paired by unblock ?
> 
> 
> > +int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
> > +{
> > ...
> > +	ret = schedule_work(&work->work);
> 
> Off-topic. We should probably export keventd_wq to avoid the duplications
> like this.

Please see my reply to Tejun. :-)

Rafael
