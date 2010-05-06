Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0EFXsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:48:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41368 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0EFXsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005061535540.1708-100000@iolanthe.rowland.org>
References: <201005062128.31068.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.1005061535540.1708-100000@iolanthe.rowland.org>
Date: Thu, 6 May 2010 16:48:41 -0700
Message-ID: <y2id6200be21005061648m47d03875h6e9de89d0e965344@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
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
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 12:40 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 6 May 2010, Rafael J. Wysocki wrote:
>
>> > Here's a completely new issue.  When using opportunistic suspends on an
>> > SMP system, it could happen that the system gets a wakeup event and
>> > this routine starts running again before the event's IRQ handler has
>> > finished (or has enabled a suspend blocker).  The system would
>> > re-suspend too soon.
>>
>> This routine will be run from a freezable workqueue.
>
> But how do you know that processes won't get unfrozen until all the
> pending IRQs have been handled?  Imagine something like this:
>
>        CPU 0                   CPU 1
>        -----                   -----
>        Wake up non-boot CPUs
>        Resume devices          Invoke the IRQ handler
>
>        [ CPU 0 should wait here for the handler to finish,
>          but it doesn't ]
>
>        Defrost threads         Handler running...
>        Workqueue routine runs
>        Start another suspend
>                                Handler enables a suspend blocker,
>                                but it's too late

It is not optimal, but it is not too late. We check if any suspend
blockers block suspend after disabling non-boot cpus so as long as
this is done in a way that does not lose interrupts the resuspend
attempt will not succeed.

-- 
Arve Hjønnevåg
