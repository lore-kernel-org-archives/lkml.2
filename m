Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab1BLPvJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 10:51:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58272 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1BLPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 10:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yw0Jl7WVjzAvJ31GStZ3SYmJGY5Mld+1BYHrXsuQVQx3AKzWG6Ekb6IfthFVX8BJVT
         CnALdpFi9eTjJMChCQijeKDfD3TPnYyUO/7pP+uBU5ymdWsmX9SKHJcaJG7bUSo3XBEe
         iIvd7o2bzA04qaxH8xTI/VunOCsLLskgjXbW0=
Date: Sat, 12 Feb 2011 16:51:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Teigland <teigland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] dlm fix for 2.6.38
Message-ID: <20110212155100.GR3770@htj.dyndns.org>
References: <20110211233844.GC30276@redhat.com>
 <1297525475.2584.1.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297525475.2584.1.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Feb 12, 2011 at 03:44:35PM +0000, Steven Whitehouse wrote:
> > diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
> > index 9c64ae9..2d8c87b 100644
> > --- a/fs/dlm/lowcomms.c
> > +++ b/fs/dlm/lowcomms.c
> > @@ -1468,15 +1468,13 @@ static void work_stop(void)
> >  
> >  static int work_start(void)
> >  {
> > -	recv_workqueue = alloc_workqueue("dlm_recv", WQ_MEM_RECLAIM |
> > -					 WQ_HIGHPRI | WQ_FREEZEABLE, 0);
> > +	recv_workqueue = create_singlethread_workqueue("dlm_recv");

recv_workqueue was multithread one even before the conversion.  It
probably is best to leave this part alone.

> > -	send_workqueue = alloc_workqueue("dlm_send", WQ_MEM_RECLAIM |
> > -					 WQ_HIGHPRI | WQ_FREEZEABLE, 0);
> > +	send_workqueue = create_singlethread_workqueue("dlm_send");

send_workqueue was converted from ST to MT but the correct way at this
point would be,

	alloc_ordered_workqueue("dlm_send",
				WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_FREEZEABLE);

> >  	if (!send_workqueue) {
> >  		log_print("can't start dlm_send");
> >  		destroy_workqueue(recv_workqueue);
> > 
> > 
> 
> What is the issue here? If there is a problem with the workqueues then
> we should ask Tejun about it,

Yeah, what kind of problem was it?  There's only one work per
connection so reordering is not a problem.  All the workqueue
operations use proper locking, so the conversion seemed safe to me.
What am I missing?

Thanks.

-- 
tejun
