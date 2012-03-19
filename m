Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2CSW4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:56:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53634 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab2CSW4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:56:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Tue, 20 Mar 2012 00:00:43 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <4F66D2E8.2090906@codeaurora.org> <201203191225.00199.rjw@sisk.pl>
In-Reply-To: <201203191225.00199.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203200000.43316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 19, 2012, Rafael J. Wysocki wrote:
> On Monday, March 19, 2012, Stephen Boyd wrote:
> > On 3/18/2012 5:01 AM, Rafael J. Wysocki wrote:
> > > On Sunday, March 18, 2012, Stephen Boyd wrote:
> > >
> > >> Ok. I like where nowait() is going in the other part of the thread but
> > >> I'm still confused about when request_firmware() is correct to use. It
> > >> seems that the function is inherently racy with freezing. Does every
> > >> user of request_firmware() need to synchronize with freezing?
> > >>
> > >> For example, if one CPU is in the middle of a driver probe that makes a
> > >> request_firmware() call and another CPU is starting to suspend we will
> > >> have a race between usermodehelpers being disabled and the
> > >> request_firmware() call acquiring the usermodehelper rwsem. If the
> > >> suspending CPU wins the race it will disable usermodehelpers and the
> > >> request_firmware() call will return -EBUSY and warn.
> > > Yes, it will.
> > 
> > That sounds wrong then, no? Why don't we have request_firmware() do a
> > read_lock on the usermodehelpers sem and then have suspend do a write
> > lock, disable usermodehelpers, wait for any users  to finish, freeze
> > processes and then unlock the write lock? That way we don't hit a case
> > where request_firmware() races with suspend, and we don't have to change
> > the warning or conditional.
> 
> So, you're postulating that the freezing of tasks be done under
> umhelper_sem write-locked, right?
> 
> That would lead to freezing failures if a user space task waited in
> request_firmware() for umhelper_sem to become available for read-locking
> and unfortunately we don't have an interruptible variant of down_read().
> 
> However, we may catch request_firmware() and try to freeze the task
> calling it instead.  I'll try to prototype something along these lines later
> today (on top of the three "firmware_class" patches I posted yesterday).

Well, that's going to take some more time, as it's more complicated than
I thought initially.  Please, stay tuned.

Thanks,
Rafael

