Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1BHQqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:46:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60421 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754815Ab1BHQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:46:37 -0500
Date: Tue, 8 Feb 2011 11:46:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ian Campbell <ijc@hellion.org.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>,
        "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH 0/2] Fix hangup after creating checkpoint on
 Xen.
In-Reply-To: <1297164178.9388.65.camel@zakaz.uk.xensource.com>
Message-ID: <Pine.LNX.4.44L0.1102081143470.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Ian Campbell wrote:

> The problem is that currently we have:
> 
>         dpm_suspend_start(PMSG_SUSPEND);
>         
>                 dpm_suspend_noirq(PMSG_SUSPEND);
>                         
>                         sysdev_suspend(PMSG_SUSPEND);
>                         /* suspend hypercall */
>                         sysdev_resume();
>                 
>                 dpm_resume_noirq(PMSG_RESUME);
>         
>         dpm_resume_end(PMSG_RESUME);
> 
> However the suspend hypercall can return a value indicating that the
> suspend didn't actually happen (e.g. was cancelled). This is used e.g.
> when checkpointing guests, because in that case you want the original
> guest to continue. When the suspend didn't happen the drivers need to
> recover differently from if it did.

That is odd, and it is quite different from the intended design of the 
PM core.  Drivers are supposed to put their devices into a known 
suspended state; then afterwards they put the devices back into an 
operational state.  What happens while the devices are in the suspended 
state isn't supposed to matter -- the system transition can fail, but 
devices get treated exactly the same way as if it succeeded.

Why do your drivers need to recover differently based on the success of 
the hypercall?

Alan Stern

