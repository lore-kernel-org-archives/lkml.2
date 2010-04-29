Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804Ab0D3SZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:25:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab0D3RWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:22:19 -0400
Date: Thu, 29 Apr 2010 20:58:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
Message-ID: <20100429185851.GA13862@redhat.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org> <201004282308.10751.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004282308.10751.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Rafael J. Wysocki wrote:
>
> On Wednesday 28 April 2010, Tejun Heo wrote:
> > On 04/28/2010 09:40 PM, Oleg Nesterov wrote:
> > >> +int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
> > >> +{
> > >> ...
> > >> +	ret = schedule_work(&work->work);
> > >
> > > Off-topic. We should probably export keventd_wq to avoid the duplications
> > > like this.
> >
> > Yeah, had about the same thought.  cmwq exports it so I didn't suggest
> > it at this point but then again we don't really know whether or when
> > that series is going in
>
> As soon as there are no major objections.  At least to my tree.
>
> > so it might be a good idea to make that change now.  Hmm...
>
> I'd rather like a follow-up patch changing that, if poss.

Confused. Rafael, do you mean you dislike this change now?

I don't really care, this change is trivial. But to me it makes more
sense to push the trivial/simple changes ahead. Unless they really
complicate the maintainging of the pending cmwq changes.

Hmm... Speaking about keventd_wq, I just noticed flush_delayed_work()
needs the fix:

	--- a/kernel/workqueue.c
	+++ b/kernel/workqueue.c
	@@ -774,7 +774,7 @@ void flush_delayed_work(struct delayed_w
	 {
		if (del_timer_sync(&dwork->timer)) {
			struct cpu_workqueue_struct *cwq;
	-		cwq = wq_per_cpu(keventd_wq, get_cpu());
	+		cwq = wq_per_cpu(get_wq_data(&dwork->work)->wq, get_cpu());
			__queue_work(cwq, &dwork->work);
			put_cpu();
		}

Oleg.

