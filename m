Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1FTOjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:39:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37961 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754839Ab1FTOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:39:33 -0400
Date: Mon, 20 Jun 2011 10:39:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [linux-pm] calling runtime PM from system PM methods
In-Reply-To: <201106192136.51572.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106201028470.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Rafael J. Wysocki wrote:

> In the meantime I rethought the __pm_runtime_disable() part of my previous
> patch and I now think it's not necessary to complicate it any more.  Of course,
> we need not check if runtime resume is pending in __device_suspend(), because
> we've done it already in dpm_prepare(), but the barrier part should better be
> done in there too.

Does this really make sense?  What use is a barrier in dpm_prepare() if 
runtime PM is allowed to continue functioning up to the 
suspend callback?

As I see it, we never want a suspend or suspend_noirq callback to call 
pm_runtime_suspend().  However it's okay for the suspend callback to 
invoke pm_runtime_resume(), as long as this is all done in subsystem 
code.

And in between the prepare and suspend callbacks, runtime PM should be
more or less fully functional, right?  For most devices it will never
be triggered, because it has to run in process context and both
userspace and pm_wq are frozen.  It may trigger for devices marked as
IRQ-safe, though.

Maybe the barrier should be moved into __device_suspend().

Alan Stern

