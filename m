Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1KATez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:34:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57052 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750829Ab1KATex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:34:53 -0400
Date: Tue, 1 Nov 2011 15:34:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Priyanka Gupta <ankaguptaca@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC] ata port runtime pm
In-Reply-To: <1320135145.3489.19.camel@minggr>
Message-ID: <Pine.LNX.4.44L0.1111011528561.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011, Lin Ming wrote:

> On Sat, 2011-10-29 at 02:51 +0800, Alan Stern wrote:
> > On Fri, 28 Oct 2011, Rafael J. Wysocki wrote:
> > 
> > > On Friday, October 28, 2011, Lin Ming wrote:
> > > > On Fri, 2011-10-28 at 11:37 +0800, Jeff Garzik wrote:
> > > > > On 10/27/2011 11:21 PM, Lin Ming wrote:
> > > > > > @@ -3208,6 +3209,11 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> > > > > >
> > > > > >   	ap = ata_shost_to_port(shost);
> > > > > >
> > > > > > +	if (pm_runtime_suspended(&ap->tdev))
> > > > > > +		pm_runtime_resume(&ap->tdev);
> > > > > > +	pm_runtime_mark_last_busy(&ap->tdev);
> > > > > > +	pm_request_autosuspend(&ap->tdev);
> > > > > > +
> > > > > >   	spin_lock_irqsave(ap->lock, irq_flags);
> > > > > >
> > > > > 
> > > > > 
> > > > > Putting this into the core command dispatch fast-path is rather 
> > > > > disappointing.  That's at least one additional lock, plus some atomic 
> > > > > instructions and tests.
> > 
> > And it calls pm_runtime_resume(), which requires process context, from 
> > within a SCSI queuecmd routine, which runs in interrupt context.
> 
> Hi, 
> 
> Thanks to point this out. I change the code to do ata port runtime
> suspend/resume through scsi layer.
> 
> scsi host runtime suspend/resume framework is already there(scsi_pm.c).
> So I only need to insert hooks for ata port in
> scsi_runtime_suspend/resume(...).
> 
> But I found a live lock when testing my patch.
> 
> <scsi host runtime suspend>
>   scsi_autopm_put_host
>     pm_runtime_put_sync
>       <scsi_host runtime pm status updated to RPM_SUSPENDING>
>       ......
>         <call libata hook to do suspend>
>           <wake up scsi EH to handle suspend>
>           <wait for scsi EH ...>
> 
> <scsi EH wake up>
>   scsi_error_handler
>     <resume scsi host>
>     scsi_autopm_get_host
>       pm_runtime_get_sync
>       .....
>         <sleep to wait for the ongoing scsi host suspend> 
> 
> libata schedules scsi EH to handle suspend, then dead lock happens
> because scsi EH in turn waits for the ongoing suspend.
> 
> Any idea how to resolve this dead lock?

This is a nasty problem.  I've known for a long time that the 
scsi_autopm_get_host() call in the error handler was going to lead to 
problems.

For now, it seems best to assume that when the error handler starts, 
the device will still be active.  Therefore the scsi_autopm_get_host() 
should be replaced by something that calls pm_runtime_get_noresume() 
instead of pm_runtime_get_sync().

You can try replacing one function call with the other, or you can 
define a new scsi_autopm_get_host_noresume() routine.

Alan Stern

