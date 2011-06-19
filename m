Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1FSPBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:01:10 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44321 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753761Ab1FSPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:01:07 -0400
Date: Sun, 19 Jun 2011 11:01:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [linux-pm] calling runtime PM from system PM methods
In-Reply-To: <201106191604.11074.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106191042510.11375-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Rafael J. Wysocki wrote:

> Well, that was kind of difficult to debug, but not impossible. :-)
> 
> The problem here turns out to be related to the SCSI subsystem.
> Namely, when the AHCI controller is suspended, it uses the SCSI error
> handling mechanism for scheduling the suspend operation (I'm still at a little
> loss why that is necessary, but Tejun says it is :-)).  This (after several
> convoluted operations) causes scsi_error_handler() to be woken up and
> it calls scsi_autopm_get_host(shost), which returns error code (-EAGAIN),
> because the runtime PM has been disabled at the host level.

Oh no.  I was afraid something like this was going to happen 
eventually.

It's clear that we don't want runtime PM kicking in while the SCSI 
error handler is running.  That's why I added the 
scsi_autopm_get_host().  But this also means we will run into trouble 
if the error handler needs to be used during a power transition.

> This happens because scsi_autopm_get_host() uses
> pm_runtime_get_sync(&shost->shost_gendev) and returns error code when
> shost_gendev.power.disable_depth is nonzero.

Maybe get_sync doesn't need to return an error if the runtime status is 
already ACTIVE.  I'm not sure about this; it's just an idea...

> So, the problem is either in scsi_autopm_get_host() that should check the
> error code returned by pm_runtime_get_sync(), or in rpm_suspend() that should
> return 0 if RPM_GET_PUT is set in flags.  I'm inclined to say that the
> problem should be fixed in rpm_suspend() and hence the appended patch that
> works (well, it probably should be split into three separate patches).

Maybe it would be good enough if the error handler ended up doing a 
get_noresume instead of get_sync?  Although I could be wrong, I don't 
think scsi_error_handler() will ever run in a situation where the host 
adapter is not runtime-active.

Tejun, does that sound right to you?

Alan Stern

