Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab0LUQbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:31:14 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:35055 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0LUQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AtXALmecLXhmTFDaF0JXPSs29ZhoMvqOKS7MQzLhBkUkLkFWyZ5xDkx6vqB6oxq2vP
         UXAGcSikT2KTr3yrsNV4O/mRdSUM1a4wZDazwErRwulqkoyz9pvi/a7RDv24CD8vcnr8
         UK1eEz/CocBK7WxFc6CyfU67wGfaq8UVAbv/E=
Date: Tue, 21 Dec 2010 17:31:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 02/16] signal: fix CLD_CONTINUED notification target
Message-ID: <20101221163105.GB13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-3-git-send-email-tj@kernel.org>
 <20101220145815.GA11583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220145815.GA11583@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Dec 20, 2010 at 03:58:15PM +0100, Oleg Nesterov wrote:
> On 12/06, Tejun Heo wrote:
> >
> > CLD_CONTINUED notification code calls do_notify_parent_cldstop() with
> > its group_leader; however, do_notify_parent_cldstop() already uses the
> > group_leader for non-ptraced notifications.
> 
> Yes,
> 
> > The duplicate
> > ->group_leader dereferencing is unnecessary and leads to incorrectly
> > notifying the group_leader's ptracer of CLD_CONTINUED from a different
> > task in the group.  Fix it.
> 
> I do not really agree this is wrong, group_leader was used intentionally
> for ptrace case.
> 
> There is no "correct" thread who should report CLD_CONTINUED, a random
> thread wins and notifies its ->real_parent or debugger. If we always
> choose ->group_leader, we always knows what happens. With this patch
> we can't predict where does this notification go.
> 
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -1867,7 +1867,7 @@ relock:
> >
> >  		if (why) {
> >  			read_lock(&tasklist_lock);
> > -			do_notify_parent_cldstop(current->group_leader, why);
> > +			do_notify_parent_cldstop(current, why);
> 
> OTOH, I see nothing really wrong with this change, and this all will
> be reworked by the next patches anyway.

Ah, okay, I thought it was an unintentional bug.  The reason why the
change is necessary is because of later changes which re-instates the
notification on ptrace detach.  The code is modified such that
notification pending is cleared iff the notification is delivered to
an actual parent.  The double dereference makes it difficult to tell
whether the notification is beling delivered to an actual parent or
not.

If this wasn't a bug, I think the proper thing to do is to move this
later where the change is necessary, after the code learns how to
buffer the notification until ptrace detach and needs to determine
whether it's being eaten by the debugger or not.

Thanks.

-- 
tejun
