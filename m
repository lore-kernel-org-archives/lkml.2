Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031323Ab2COAHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:07:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45613 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031223Ab2COAHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:07:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Thu, 15 Mar 2012 01:11:05 +0100
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
References: <201203032122.36745.chunkeey@googlemail.com> <201203150034.08863.rjw@sisk.pl> <4F612C05.8010301@codeaurora.org>
In-Reply-To: <4F612C05.8010301@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203150111.05724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012, Stephen Boyd wrote:
> On 03/14/12 16:34, Rafael J. Wysocki wrote:
> > On Thursday, March 15, 2012, Stephen Boyd wrote:
> >> On 03/14/12 16:13, Rafael J. Wysocki wrote:
> >>> On Thursday, March 15, 2012, Rafael J. Wysocki wrote:
> >>>
> >>>> Which is OK, I think.
> >>> Moreover, thaw_kernel_threads() is _only_ called by (a) freeze_kernel_threads()
> >>> on error and (b) user-space hibernate interface in kernel/power/user.c
> >>> (and please read the comment in there describing what it's there for, which
> >>> also explains why the schedule() call in there is necessary).
> >> Exactly. So in case (a) when the error occurs we'll have this call flow:
> >>
> >> usermodehelpers_disable()
> >> suspend_freeze_processes()
> >>     freeze_processes()
> >>     freeze_kernel_threads()
> >>         try_to_freeze_tasks() <-- returns error
> >>         thaw_kernel_threads()
> >>             schedule()
> >>     thaw_processes()
> >> usermodehelpers_enable()
> >>
> >> Shouldn't we schedule only after we thaw all processes (not just tasks)?
> >> Otherwise we may run a kernel thread before userspace is thawed?
> > Yes, we may, but that isn't wrong, is it?
> >
> > Only a few kernel threads are freezable, so definitely kernel threads
> > can run while user space is frozen.
> >
> 
> Yes but if someone calls request_firmware() from a kthread then they
> will hit the same problem where the thread runs and requests the
> firmware and usermodehelpers are still disabled. Currently my code is
> written with kthreads and that thread makes the request firmware call,
> so this doesn't seem far fetched (although in my case I can probably fix
> it).

So again, please consider using suspend/resume notifiers to synchronize
your kthread with system power transitions.

> It looks like before 379e0be (PM / Freezer: Thaw only kernel
> threads if freezing of kernel threads fails, 2012-02-03) schedule wasn't
> called until userspace was thawed. It looks like that patch was about
> hibernation and not suspend?

It was about hibernation and it fixed a real bug.

Thanks,
Rafael


