Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2A0BHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:07:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2A0BHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:07:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG 
 =?iso-8859-1?q?at=09kernel/workqueue=2Ec=3A3659?=
Date: Fri, 27 Jan 2012 02:10:37 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Baohua.Song@csr.com, Tejun Heo <tj@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>
References: <4F1EC8D5.5040102@suse.cz> <4F20204F.6040606@linux.vnet.ibm.com> <4F21ABE2.1060302@linux.vnet.ibm.com>
In-Reply-To: <4F21ABE2.1060302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201270210.37585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 26, 2012, Srivatsa S. Bhat wrote:
> 
> Hi Rafael,
> 
> On 01/25/2012 09:01 PM, Srivatsa S. Bhat wrote:
> 
> > 
> > Ok, I will need to quote a part of the userspace utility to explain the
> > problem.
> > 
> > In suspend.c inside the suspend-utils userspace package, I see a loop such
> > as:
> > 
> >         error = freeze(snapshot_fd);
> > 	...
> >         attempts = 2;
> >         do {
> >                 if (set_image_size(snapshot_fd, image_size)) {
> >                         error = errno;
> >                         break;
> >                 }
> >                 if (atomic_snapshot(snapshot_fd, &in_suspend)) {
> >                         error = errno;
> >                         break;
> >                 }
> >                 if (!in_suspend) {
> >                         /* first unblank the console, see console_codes(4) */
> >                         printf("\e[13]");
> >                         printf("%s: returned to userspace\n", my_name);
> >                         free_snapshot(snapshot_fd);
> >                         break;
> >                 }
> > 
> >                 error = write_image(snapshot_fd, resume_fd, -1);
> >                 if (error) {
> >                         free_swap_pages(snapshot_fd);
> >                         free_snapshot(snapshot_fd);
> >                         image_size = 0;
> >                         error = -error;
> >                         if (error != ENOSPC)
> >                                 break;
> >                 } else {
> >                         splash.progress(100);
> > #ifdef CONFIG_BOTH
> >                         if (s2ram_kms || s2ram) {
> >                                 /* If we die (and allow system to continue)
> >                                  * between now and reset_signature(), very bad
> >                                  * things will happen. */
> >                                 error = suspend_to_ram(snapshot_fd);
> >                                 if (error)
> >                                         goto Shutdown;
> >                                 reset_signature(resume_fd);
> >                                 free_swap_pages(snapshot_fd);
> >                                 free_snapshot(snapshot_fd);
> >                                 if (!s2ram_kms)
> >                                         s2ram_resume();
> 
> 
> Your patch alters how SNAPSHOT_FREE (IOW, free_snapshot() in this utility) is
> handled. So, I was trying to see if there are any points of concern...
> 
> In the above code, s2ram_resume() gets invoked after free_snapshot(). Will that
> pose any problems because kernel threads would have been thawed at that point,
> after applying your patch?

No, it shouldn't.  s2ram_resume() only executes quirks needed to restore the
state of graphics if KMS is not being used.  That shouldn't interfere with
any kernel threads.

> And other than that, do you foresee any problems arising from the change caused
> to SNAPSHOT_FREE by your patch? I mean, s2ram/s2disk/suspend-utils package are
> not the only userspace utilities after all... so I just wanted to ensure that
> we don't over-fit our solution to this particular utility and end up breaking
> others...

I'm quite sure they are the only package using the interface in
kernel/power/user.c.  At least, I'm not aware of any other users. :-)

Thanks,
Rafael
