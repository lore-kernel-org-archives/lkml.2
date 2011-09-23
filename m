Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1IWQHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:07:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1IWQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:07:09 -0400
Date: Fri, 23 Sep 2011 11:06:53 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <greg@kroah.com>,
        Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        richard@nod.at, Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH resend] user namespace: usb: make usb urbs user namespace
 aware (v2)
Message-ID: <20110923160653.GB3502@sergelap>
References: <20110923012751.GA27386@hallyn.com>
 <Pine.LNX.4.44L0.1109231137380.2059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1109231137380.2059-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alan Stern (stern@rowland.harvard.edu):
> On Fri, 23 Sep 2011, Serge E. Hallyn wrote:
> 
> > (re-sending to Cc: Greg and linux-usb)
> > 
> > Add to the dev_state and alloc_async structures the user namespace
> > corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> > which can then implement a proper, user-namespace-aware uid check.
> > 
> > Changelog:
> > Sep 20: Per Oleg's suggestion: Instead of caching and passing user namespace,
> > 	uid, and euid each separately, pass a struct cred.
> 
> This should be broken up into two separate patches: One to add
> kill_pid_info_as_cred() and the other to modify the usbfs driver.

It seems like that would make the first patch harder to review (since
it won't just show the changes from kill_pid_info_as_uid to
kill_pid_info_as_cred), but I'll go ahead and split it up.  I assume
kill_pid_info_as_uid should be removed in a third patch?

> > --- a/drivers/usb/core/devio.c
> > +++ b/drivers/usb/core/devio.c
> 
> > @@ -393,9 +395,8 @@ static void async_compled ted(struct urb *urb)
> >  	struct dev_state *ps = as->ps;
> >  	struct siginfo sinfo;
> >  	struct pid *pid = NULL;
> > -	uid_t uid = 0;
> > -	uid_t euid = 0;
> >  	u32 secid = 0;
> > +	const struct cred *cred = NULL;
> >  	int signr;
> >  
> >  	spin_lock(&ps->lock);
> > @@ -408,8 +409,7 @@ static void async_completed(struct urb *urb)
> >  		sinfo.si_code = SI_ASYNCIO;
> >  		sinfo.si_addr = as->userurb;
> >  		pid = as->pid;
> > -		uid = as->uid;
> > -		euid = as->euid;
> > +		cred = as->cred;
> >  		secid = as->secid;
> >  	}
> >  	snoop(&urb->dev->dev, "urb complete\n");
> > @@ -423,8 +423,7 @@ static void async_completed(struct urb *urb)
> >  	spin_unlock(&ps->lock);
> >  
> >  	if (signr)
> > -		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, uid,
> > -				      euid, secid);
> > +		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred, secid);
> 
> This continues a bug that already exists in the current code.  Once 
> ps->lock is released, there is no guarantee that the async structure 
> will still exist.  It may already have been freed, and the reference to 

Yikes.  That makes sense.  I'll fix that for the cred and the pid as well
then?

> as->cred may already have been dropped.  That's why the local copies 
> have to be made above.  cred shouldn't be a simple copy of as->cred; it 
> should also increment the reference count.
> 
> > @@ -706,8 +705,7 @@ static int usbdev_open(struct inode *inode, struct file *file)
> >  	init_waitqueue_head(&ps->wait);
> >  	ps->discsignr = 0;
> >  	ps->disc_pid = get_pid(task_pid(current));
> > -	ps->disc_uid = cred->uid;
> > -	ps->disc_euid = cred->euid;
> > +	ps->cred = get_cred(cred);
> 
> You might as well get rid of the "cred" local variable.  It isn't used 
> for anything except this assignment.
> 
> Alan Stern

Thanks for looking, Alan.

-serge
