Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746Ab2CNXaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:30:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45497 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2CNX36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:29:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Thu, 15 Mar 2012 00:34:08 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203150013.45749.rjw@sisk.pl> <4F612706.4060407@codeaurora.org>
In-Reply-To: <4F612706.4060407@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203150034.08863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012, Stephen Boyd wrote:
> On 03/14/12 16:13, Rafael J. Wysocki wrote:
> > On Thursday, March 15, 2012, Rafael J. Wysocki wrote:
> >> On Wednesday, March 14, 2012, Stephen Boyd wrote:
> >>> On 03/13/12 13:14, Rafael J. Wysocki wrote:
> >>>> All of those use cases are in fact of the "wait for user space to be thawed
> >>>> and then load the firmware" type, which I believe may be handled without
> >>>> changing that code.
> >>>>
> >>>> Why don't you make your kthread freezable, for one example?
> >>>>
> >>>> Why don't you use a freezable workqueue instead?
> >>>>
> >>> If we put it on the freezable workqueue or make it a freezable thread
> >>> will it work?
> >> That depends on what exactly you want to achieve, which isn't entirely clear
> >> to me at this point.
> >>
> >>> In my scenario a wakeup interrupt comes in that wakes us up from
> >>> suspend. Within that wakeup handler a work item is scheduled to the
> >>> freezable workqueue. That work item then calls request_firmware().
> >> That should work.
> >>
> >>> It looks like we call schedule() after thawing the workqueues and tasks
> >>> so the work item could run before usermodehelpers are enabled and then
> >>> request_firmware() would fail. Do we need something like this (ignore
> >>> the fact that we call usermodhelper_enable() twice)?
> >>>
> >>> diff --git a/kernel/power/process.c b/kernel/power/process.c
> >>> index 7e42645..61bfa95 100644
> >>> --- a/kernel/power/process.c
> >>> +++ b/kernel/power/process.c
> >>> @@ -187,6 +187,7 @@ void thaw_processes(void)
> >>>         } while_each_thread(g, p);
> >>>         read_unlock(&tasklist_lock);
> >>>  
> >>> +       usermodehelper_enable();
> >> That would be a reasonable change.
> >>
> >>>         schedule();
> >>>         printk("done.\n");
> >>>  }
> >>>
> >>>
> >>> Is there a reason we disable usermodehelpers if
> >>> CONFIG_SUSPEND_FREEZER=n?
> >> Not really, but CONFIG_SUSPEND_FREEZER=n can only work reliably in a
> >> very limited set of cases, so I don't think it's even worth making the
> >> general code depend on it.
> >>
> >> I'd actually prefer to remove CONFIG_SUSPEND_FREEZER altogether,
> >> because it's not very useful nowadays (probably isn't useful at all).
> >>
> >>> Should we do this instead so that
> >>> usermodehelpers are only disabled if we freeze userspace? Also what is
> >>> that schedule() call in thaw_kernel_threads() for? It looks like we'll
> >>> call schedule between kernel thread thawing and userspace thawing.
> >> Which is OK, I think.
> > Moreover, thaw_kernel_threads() is _only_ called by (a) freeze_kernel_threads()
> > on error and (b) user-space hibernate interface in kernel/power/user.c
> > (and please read the comment in there describing what it's there for, which
> > also explains why the schedule() call in there is necessary).
> 
> Exactly. So in case (a) when the error occurs we'll have this call flow:
> 
> usermodehelpers_disable()
> suspend_freeze_processes()
>     freeze_processes()
>     freeze_kernel_threads()
>         try_to_freeze_tasks() <-- returns error
>         thaw_kernel_threads()
>             schedule()
>     thaw_processes()
> usermodehelpers_enable()
> 
> Shouldn't we schedule only after we thaw all processes (not just tasks)?
> Otherwise we may run a kernel thread before userspace is thawed?

Yes, we may, but that isn't wrong, is it?

Only a few kernel threads are freezable, so definitely kernel threads
can run while user space is frozen.

Thanks,
Rafael
