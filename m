Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab0HECDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:03:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49020 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab0HECC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:02:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=KbTThquXDhUbUDrJO3Er8Uuv4G0QewyQe5KkxcQkCR3EtXseSrQrVPaoIaKb8urtJ
	rzjDDCH1l9JS8MshziqVw==
MIME-Version: 1.0
In-Reply-To: <20100805015815.GN2927@count0.beaverton.ibm.com>
References: <20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801154708.19817b75@infradead.org>
	<20100802011006.GS2470@linux.vnet.ibm.com>
	<AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
	<20100803183447.0275c134@infradead.org>
	<20100804163216.GB24163@linux.vnet.ibm.com>
	<20100804163509.GA31523@srcf.ucam.org>
	<20100805015815.GN2927@count0.beaverton.ibm.com>
Date: Wed, 4 Aug 2010 19:02:55 -0700
Message-ID: <AANLkTi=yQitRpx9AXMw6+Jx=hAVfZn2imR=DNiSi_SAf@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 6:58 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> On Wed, Aug 04, 2010 at 05:35:09PM +0100, Matthew Garrett wrote:
>>
>> The main problem I see with the cgroups solution is that it doesn't seem
>> to do anything to handle avoiding loss of wakeup events.
>
> cgroups alone don't but there is a solution which doesn't require routing
> all event data through a single server -- use SIGIO.
>
> Suppose we've got two cgroups of tasks -- those in the initial freezer
> cgroup and those in a freezer cgroup meant for power-naive apps. Let's
> call the second cgroup the naive cgroup.
>
> One task -- let's call it the "waker" -- is in the initial cgroup is normaly
> asleep waiting for SIGIO. Note it's not an "app" -- it's been trusted/blessed
> to be a non-power-naive task. It will be signaled via SIGIO by the
> applications which want to be unfrozen when an event comes in.
>
> When the power-naive app in the naive cgroup opens a file descriptor it's
> going through the Android interpretter to make the syscall. The interpretter
> can do fcntl() on the fd to cause SIGIO to be delivered to the waker task.
> When the waker gets SIGIO it unfreezes the naive cgroup and thus wakes the
> power-naive app. When the power-naive app wakes it will
> poll/return-from-poll/read/return-from-read and thus retrieve the event.

The Android execution model includes native code in addition to the
dalvik VM, and in the future could include other runtimes -- there are
many standard libraries that directly make posix file IO calls, and
apps can bundle native libraries which can also directly make
syscalls.  It's not practical to instrument every piece of userspace
code that opens a fd somehow to make additional fcntl calls in various
places.

Brian
