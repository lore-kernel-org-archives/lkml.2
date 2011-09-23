Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963Ab1IWRWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:22:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34774 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1IWRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:22:44 -0400
Date: Fri, 23 Sep 2011 12:22:35 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <greg@kroah.com>,
        Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        richard@nod.at, Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH resend] user namespace: usb: make usb urbs user namespace
 aware (v2)
Message-ID: <20110923172235.GB4065@sergelap>
References: <20110923160653.GB3502@sergelap>
 <Pine.LNX.4.44L0.1109231217430.2059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1109231217430.2059-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alan Stern (stern@rowland.harvard.edu):
> On Fri, 23 Sep 2011, Serge E. Hallyn wrote:
> 
> > Quoting Alan Stern (stern@rowland.harvard.edu):
> > > On Fri, 23 Sep 2011, Serge E. Hallyn wrote:
> > > 
> > > > (re-sending to Cc: Greg and linux-usb)
> > > > 
> > > > Add to the dev_state and alloc_async structures the user namespace
> > > > corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> > > > which can then implement a proper, user-namespace-aware uid check.
> > > > 
> > > > Changelog:
> > > > Sep 20: Per Oleg's suggestion: Instead of caching and passing user namespace,
> > > > 	uid, and euid each separately, pass a struct cred.
> > > 
> > > This should be broken up into two separate patches: One to add
> > > kill_pid_info_as_cred() and the other to modify the usbfs driver.
> > 
> > It seems like that would make the first patch harder to review (since
> > it won't just show the changes from kill_pid_info_as_uid to
> > kill_pid_info_as_cred), but I'll go ahead and split it up.  I assume
> > kill_pid_info_as_uid should be removed in a third patch?
> 
> No, what I meant was that all the changes to /kernel/signal.c should be 
> in one patch and all the changes to drivers/usb/core/devio.c should be 
> in a second patch.

But doing that in two patches would not be bisect-safe.

> You did check to make sure there are no other references to
> kill_pid_info_as_uid() in the kernel?

Yup.

> > > >  	if (signr)
> > > > -		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, uid,
> > > > -				      euid, secid);
> > > > +		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred, secid);
> > > 
> > > This continues a bug that already exists in the current code.  Once 
> > > ps->lock is released, there is no guarantee that the async structure 
> > > will still exist.  It may already have been freed, and the reference to 
> > 
> > Yikes.  That makes sense.  I'll fix that for the cred and the pid as well
> > then?
> 
> Right.

Ok.

thanks,
-serge
