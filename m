Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1J1R3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:29:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38382 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1J1R3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:29:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC] ata port runtime pm
Date: Fri, 28 Oct 2011 19:31:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Priyanka Gupta <ankaguptaca@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1319772072.24236.0.camel@minggr> <4EAA2392.40105@pobox.com> <1319780194.24236.34.camel@minggr>
In-Reply-To: <1319780194.24236.34.camel@minggr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110281931.54527.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC PM-related patches to linux-pm@vger.kernel.org (now added).

Thanks,
Rafael


On Friday, October 28, 2011, Lin Ming wrote:
> On Fri, 2011-10-28 at 11:37 +0800, Jeff Garzik wrote:
> > On 10/27/2011 11:21 PM, Lin Ming wrote:
> > > @@ -3208,6 +3209,11 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> > >
> > >   	ap = ata_shost_to_port(shost);
> > >
> > > +	if (pm_runtime_suspended(&ap->tdev))
> > > +		pm_runtime_resume(&ap->tdev);
> > > +	pm_runtime_mark_last_busy(&ap->tdev);
> > > +	pm_request_autosuspend(&ap->tdev);
> > > +
> > >   	spin_lock_irqsave(ap->lock, irq_flags);
> > >
> > 
> > 
> > Putting this into the core command dispatch fast-path is rather 
> > disappointing.  That's at least one additional lock, plus some atomic 
> > instructions and tests.
> 
> Maybe move suspend request to the resume function, as below.
> 
> static int ata_port_runtime_resume(struct device *dev)
> {
>         struct ata_port *ap = to_ata_port(dev);
>         int rc;
> 
>         rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
>                 ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
> 
>         pm_runtime_mark_last_busy(dev);
>         pm_request_autosuspend(dev);
> 
>         return rc;
> }
> 
> Then the fast-path looks like,
> 
> @@ -3208,6 +3209,9 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost,
> struct scsi_cmnd *cmd)
> 
>         ap = ata_shost_to_port(shost);
> 
> +       if (pm_runtime_suspended(&ap->tdev))
> +               pm_runtime_resume(&ap->tdev);
> +
>         spin_lock_irqsave(ap->lock, irq_flags);
> 
>         ata_scsi_dump_cdb(ap, cmd);
> 
> What do you think?
> 
> Thanks,
> Lin Ming
> 
> 
> 

