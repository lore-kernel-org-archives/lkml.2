Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab1J1SvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:51:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58405 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933128Ab1J1SvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:51:18 -0400
Date: Fri, 28 Oct 2011 14:51:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Priyanka Gupta <ankaguptaca@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC] ata port runtime pm
In-Reply-To: <201110281931.54527.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1110281444170.2175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Rafael J. Wysocki wrote:

> On Friday, October 28, 2011, Lin Ming wrote:
> > On Fri, 2011-10-28 at 11:37 +0800, Jeff Garzik wrote:
> > > On 10/27/2011 11:21 PM, Lin Ming wrote:
> > > > @@ -3208,6 +3209,11 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> > > >
> > > >   	ap = ata_shost_to_port(shost);
> > > >
> > > > +	if (pm_runtime_suspended(&ap->tdev))
> > > > +		pm_runtime_resume(&ap->tdev);
> > > > +	pm_runtime_mark_last_busy(&ap->tdev);
> > > > +	pm_request_autosuspend(&ap->tdev);
> > > > +
> > > >   	spin_lock_irqsave(ap->lock, irq_flags);
> > > >
> > > 
> > > 
> > > Putting this into the core command dispatch fast-path is rather 
> > > disappointing.  That's at least one additional lock, plus some atomic 
> > > instructions and tests.

And it calls pm_runtime_resume(), which requires process context, from 
within a SCSI queuecmd routine, which runs in interrupt context.

> > Maybe move suspend request to the resume function, as below.
> > 
> > static int ata_port_runtime_resume(struct device *dev)
> > {
> >         struct ata_port *ap = to_ata_port(dev);
> >         int rc;
> > 
> >         rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
> >                 ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
> > 
> >         pm_runtime_mark_last_busy(dev);
> >         pm_request_autosuspend(dev);
> > 
> >         return rc;
> > }
> > 
> > Then the fast-path looks like,
> > 
> > @@ -3208,6 +3209,9 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost,
> > struct scsi_cmnd *cmd)
> > 
> >         ap = ata_shost_to_port(shost);
> > 
> > +       if (pm_runtime_suspended(&ap->tdev))
> > +               pm_runtime_resume(&ap->tdev);
> > +

Unfortunately that won't work.  It's got a race; the device might be 
active when the pm_runtime_suspended() test runs and then it might 
suspend immediately after.

> >         spin_lock_irqsave(ap->lock, irq_flags);
> > 
> >         ata_scsi_dump_cdb(ap, cmd);
> > 
> > What do you think?

See the example code in section 9 of 
Documentation/power/runtime_pm.txt for the outline of a general 
approach.

Alan Stern

