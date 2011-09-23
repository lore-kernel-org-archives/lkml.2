Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1IWPtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:49:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36074 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754907Ab1IWPsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:48:52 -0400
Date: Fri, 23 Sep 2011 11:48:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Greg KH <greg@kroah.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        <richard@nod.at>, Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH resend] user namespace: usb: make usb urbs user namespace
 aware (v2)
In-Reply-To: <20110923012751.GA27386@hallyn.com>
Message-ID: <Pine.LNX.4.44L0.1109231137380.2059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Serge E. Hallyn wrote:

> (re-sending to Cc: Greg and linux-usb)
> 
> Add to the dev_state and alloc_async structures the user namespace
> corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> which can then implement a proper, user-namespace-aware uid check.
> 
> Changelog:
> Sep 20: Per Oleg's suggestion: Instead of caching and passing user namespace,
> 	uid, and euid each separately, pass a struct cred.

This should be broken up into two separate patches: One to add
kill_pid_info_as_cred() and the other to modify the usbfs driver.

> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c

> @@ -393,9 +395,8 @@ static void async_completed(struct urb *urb)
>  	struct dev_state *ps = as->ps;
>  	struct siginfo sinfo;
>  	struct pid *pid = NULL;
> -	uid_t uid = 0;
> -	uid_t euid = 0;
>  	u32 secid = 0;
> +	const struct cred *cred = NULL;
>  	int signr;
>  
>  	spin_lock(&ps->lock);
> @@ -408,8 +409,7 @@ static void async_completed(struct urb *urb)
>  		sinfo.si_code = SI_ASYNCIO;
>  		sinfo.si_addr = as->userurb;
>  		pid = as->pid;
> -		uid = as->uid;
> -		euid = as->euid;
> +		cred = as->cred;
>  		secid = as->secid;
>  	}
>  	snoop(&urb->dev->dev, "urb complete\n");
> @@ -423,8 +423,7 @@ static void async_completed(struct urb *urb)
>  	spin_unlock(&ps->lock);
>  
>  	if (signr)
> -		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, uid,
> -				      euid, secid);
> +		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred, secid);

This continues a bug that already exists in the current code.  Once 
ps->lock is released, there is no guarantee that the async structure 
will still exist.  It may already have been freed, and the reference to 
as->cred may already have been dropped.  That's why the local copies 
have to be made above.  cred shouldn't be a simple copy of as->cred; it 
should also increment the reference count.

> @@ -706,8 +705,7 @@ static int usbdev_open(struct inode *inode, struct file *file)
>  	init_waitqueue_head(&ps->wait);
>  	ps->discsignr = 0;
>  	ps->disc_pid = get_pid(task_pid(current));
> -	ps->disc_uid = cred->uid;
> -	ps->disc_euid = cred->euid;
> +	ps->cred = get_cred(cred);

You might as well get rid of the "cred" local variable.  It isn't used 
for anything except this assignment.

Alan Stern

