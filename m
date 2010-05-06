Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0EFTkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:40:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55807 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756548Ab0EFTkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:40:49 -0400
Date: Thu, 6 May 2010 15:40:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <201005062128.31068.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1005061535540.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Rafael J. Wysocki wrote:

> > Here's a completely new issue.  When using opportunistic suspends on an
> > SMP system, it could happen that the system gets a wakeup event and
> > this routine starts running again before the event's IRQ handler has
> > finished (or has enabled a suspend blocker).  The system would 
> > re-suspend too soon.
> 
> This routine will be run from a freezable workqueue.

But how do you know that processes won't get unfrozen until all the 
pending IRQs have been handled?  Imagine something like this:

	CPU 0			CPU 1
	-----			-----
	Wake up non-boot CPUs
	Resume devices		Invoke the IRQ handler

	[ CPU 0 should wait here for the handler to finish, 
	  but it doesn't ]

	Defrost threads		Handler running...
	Workqueue routine runs
	Start another suspend
				Handler enables a suspend blocker,
				but it's too late

Alan Stern

