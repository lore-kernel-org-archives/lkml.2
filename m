Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab1KVDg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:36:58 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41682 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1KVDg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <201111210038.41490.rjw@sisk.pl>
References: <201111200153.40224.rjw@sisk.pl>
	<201111210038.41490.rjw@sisk.pl>
Date: Tue, 22 Nov 2011 11:36:57 +0800
Message-ID: <CACVXFVNiCuQdXmjM9meO+Rcf6g8WnV10-wmxsOCwYuwuMfXUAA@mail.gmail.com>
Subject: Re: [PATCH 5] PM: Update comments describing device power management callbacks
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 21, 2011 at 7:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>

>  * @prepare: Prepare the device for the upcoming transition, but do NOT change
>  *     its hardware state.  Prevent new children of the device from being
> @@ -71,101 +78,118 @@ typedef struct pm_message {
>  *     probe method from being made too once @prepare() has succeeded).  If
>  *     @prepare() detects a situation it cannot handle (e.g. registration of a
>  *     child already in progress), it may return -EAGAIN, so that the PM core
> - *     can execute it once again (e.g. after the new child has been registered)
> + *     can execute it once again (e.g. after a new child has been registered)
>  *     to recover from the race condition.  This method is executed for all
>  *     kinds of suspend transitions and is followed by one of the suspend
>  *     callbacks: @suspend(), @freeze(), or @poweroff().
> - *     The PM core executes @prepare() for all devices before starting to
> - *     execute suspend callbacks for any of them, so drivers may assume all of
> - *     the other devices to be present and functional while @prepare() is being
> - *     executed.  In particular, it is safe to make GFP_KERNEL memory
> - *     allocations from within @prepare().  However, drivers may NOT assume
> - *     anything about the availability of the user space at that time and it
> - *     is not correct to request firmware from within @prepare() (it's too
> - *     late to do that).  [To work around this limitation, drivers may
> - *     register suspend and hibernation notifiers that are executed before the
> + *     The PM core executes subsystem-level @prepare() for all devices before
> + *     starting to execute suspend callbacks for any of them, so all devices
> + *     may be assumed to be present and functional while @prepare() is being

Devices aren't functional in runtime suspend state, so maybe the word of
'functional' should be removed.

> + *     executed.  However, device drivers may NOT assume anything about the
> + *     availability of user space at that time and it is NOT valid to request
> + *     firmware from within @prepare() (it's too late to do that).  It also is
> + *     NOT valid to allocate substantial amounts of memory from @prepare() in
> + *     the GFP_KERNEL mode.  [To work around these limitations, drivers may
> + *     register suspend and hibernation notifiers to be executed before the
>  *     freezing of tasks.]


>  * @resume: Executed after waking the system up from a sleep state in which the
> - *     contents of main memory were preserved.  Put the device into the
> - *     appropriate state, according to the information saved in memory by the
> - *     preceding @suspend().  The driver starts working again, responding to
> - *     hardware events and software requests.  The hardware may have gone
> - *     through a power-off reset, or it may have maintained state from the
> - *     previous suspend() which the driver may rely on while resuming.  On most
> - *     platforms, there are no restrictions on availability of resources like
> - *     clocks during @resume().
> + *     contents of main memory were preserved.  Undo the changes made by
> + *     the preceding @suspend() and cause the device to become operational

The device may still not be operational if it was runtime suspended
before running
@suspend().

> + *     (the exact action to perform depends on the device's subsystem).
> + *     The driver starts working again, responding to hardware events and
> + *     software requests.  The state of the device at the time its driver's
> + *     @resume() callback is run depends on the platform and subsystem the
> + *     device belongs to.  On most platforms, there are no restrictions on
> + *     availability of resources like clocks during @resume().
> + *     Subsystem-level @resume() is executed for all devices after invoking
> + *     subsystem-level @resume_noirq() for all of them.


thanks,
-- 
Ming Lei
