Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab2CPWbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:31:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49655 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905Ab2CPWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:31:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] firmware_class: Move request_firmware_nowait() to workqueues
Date: Fri, 16 Mar 2012 23:35:17 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
References: <1331841015-26684-1-git-send-email-sboyd@codeaurora.org> <201203162245.52281.rjw@sisk.pl> <201203162318.30770.chunkeey@googlemail.com>
In-Reply-To: <201203162318.30770.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203162335.18222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 16, 2012, Christian Lamparter wrote:
> On Friday 16 March 2012 22:45:52 Rafael J. Wysocki wrote:
> > On Friday, March 16, 2012, Stephen Boyd wrote:
> > > On 03/16/12 13:19, Rafael J. Wysocki wrote:
> > > > On Friday, March 16, 2012, Stephen Boyd wrote:
> > > >> On 03/15/12 15:31, Rafael J. Wysocki wrote:
> > > >>> On Thursday, March 15, 2012, Stephen Boyd wrote:
> > > >>>> On 03/15/12 13:07, Christian Lamparter wrote:
> > > >>>>> On Thursday, March 15, 2012 08:50:15 PM Stephen Boyd wrote:
> > > >>>>>> Oddly enough a work_struct was already part of the firmware_work
> > > >>>>>> structure but nobody was using it. Instead of creating a new
> > > >>>>>> kthread for each request_firmware_nowait() just schedule the work
> > > >>>>>> on the system workqueue. This should avoid some overhead in
> > > >>>>>> forking new threads when they're not strictly necessary if
> > > >>>>>> workqueues are available.
> > > >>>>>>
> > > >>>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > > >>>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >>>>>> Cc: Kay Sievers <kay.sievers@vrfy.org>
> > > >>>>>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > >>>>>> ---
> > > >>>>>>
> > > >>>>>> I saw this while looking at this problem we're having.
> > > >>>>> Correct me if I'm wrong, but wouldn't that stall all other
> > > >>>>> global workqueue tasks for up to 60 seconds [in worst case]?
> > > >>>>>
> > > >>>>> But I think we can get rid of the firmware_work work struct...
> > > >>>>>
> > > >>>> My understanding is that with concurrency managed workqueues when the
> > > >>>> work item blocks another will be scheduled to run almost immediately. So
> > > >>>> before that change by Tejun workqueues would have been a bad idea
> > > >>>> because it could have blocked up to 60 second but now it should be fine
> > > >>>> because that work item will just be put to sleep and another request
> > > >>>> will run.
> > > >>> Please read the description of system_wq in workqueue.h.
> > > >>>
> > > >>> You should have used either system_long_wq or system_nrt_wq (depending on
> > > >>> what you really need).
> > > >>>
> > > >>>
> > > >> Thanks. I think we can use system_nrt_wq then? Or maybe even the
> > > >> unbounded workqueue system_unbound_wq?
> > > > Hmm.  Can you please remind me what the exact role of that work item is?
> > > >
> > > > It loads the device's firmware, but I'm not sure in what situations that's
> > > > supposed to happen.
> > > >
> > > 
> > > request_firmware_nowait() is used by code that wants to get the firmware
> > > asynchronously. Callers pass in a callback function which is called once
> > > the firmware is retrieved. The work item will correspond to one call to
> > > request_firmware_nowait(), where the work item will handle the sysfs
> > > entry generation, uevent generation, and wait_for_completion() calls
> > > that _request_firmware() does.
> > > 
> > > The work item also executes the callback function the caller passes in
> > > which could do probably anything and could take an arbitrarily long
> > > time. It looks like some drivers even chain request_firmware_nowait()
> > > together by calling request_firmware_nowait() from the callback functions.
> > 
> > So it looks like an unbound workqueue would be suitable for that, but
> > perhaps it may even be an ordered one?
> Just a note:
> kernel/kmod.c currently defines a workqueue "khelper"... So since we are
> already "using" kmod's usermodehelper_*, then why not the mess with the
> workqueue as well?

Well, under a different name, maybe ...

Rafael
