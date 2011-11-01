Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1KAIMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:12:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:16196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1KAIM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:12:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="69905984"
Subject: Re: [RFC] ata port runtime pm
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Priyanka Gupta <ankaguptaca@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1110281444170.2175-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1110281444170.2175-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 16:12:25 +0800
Message-ID: <1320135145.3489.19.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-29 at 02:51 +0800, Alan Stern wrote:
> On Fri, 28 Oct 2011, Rafael J. Wysocki wrote:
> 
> > On Friday, October 28, 2011, Lin Ming wrote:
> > > On Fri, 2011-10-28 at 11:37 +0800, Jeff Garzik wrote:
> > > > On 10/27/2011 11:21 PM, Lin Ming wrote:
> > > > > @@ -3208,6 +3209,11 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> > > > >
> > > > >   	ap = ata_shost_to_port(shost);
> > > > >
> > > > > +	if (pm_runtime_suspended(&ap->tdev))
> > > > > +		pm_runtime_resume(&ap->tdev);
> > > > > +	pm_runtime_mark_last_busy(&ap->tdev);
> > > > > +	pm_request_autosuspend(&ap->tdev);
> > > > > +
> > > > >   	spin_lock_irqsave(ap->lock, irq_flags);
> > > > >
> > > > 
> > > > 
> > > > Putting this into the core command dispatch fast-path is rather 
> > > > disappointing.  That's at least one additional lock, plus some atomic 
> > > > instructions and tests.
> 
> And it calls pm_runtime_resume(), which requires process context, from 
> within a SCSI queuecmd routine, which runs in interrupt context.

Hi, 

Thanks to point this out. I change the code to do ata port runtime
suspend/resume through scsi layer.

scsi host runtime suspend/resume framework is already there(scsi_pm.c).
So I only need to insert hooks for ata port in
scsi_runtime_suspend/resume(...).

But I found a live lock when testing my patch.

<scsi host runtime suspend>
  scsi_autopm_put_host
    pm_runtime_put_sync
      <scsi_host runtime pm status updated to RPM_SUSPENDING>
      ......
        <call libata hook to do suspend>
          <wake up scsi EH to handle suspend>
          <wait for scsi EH ...>

<scsi EH wake up>
  scsi_error_handler
    <resume scsi host>
    scsi_autopm_get_host
      pm_runtime_get_sync
      .....
        <sleep to wait for the ongoing scsi host suspend> 

libata schedules scsi EH to handle suspend, then dead lock happens
because scsi EH in turn waits for the ongoing suspend.

Any idea how to resolve this dead lock?

Thanks,
Lin Ming

