Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1J1Fgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 01:36:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:30250 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab1J1Fgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 01:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,416,1315206000"; 
   d="scan'208";a="67898833"
Subject: Re: [RFC] ata port runtime pm
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Priyanka Gupta <ankaguptaca@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <4EAA2392.40105@pobox.com>
References: <1319772072.24236.0.camel@minggr>  <4EAA2392.40105@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 13:36:34 +0800
Message-ID: <1319780194.24236.34.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 11:37 +0800, Jeff Garzik wrote:
> On 10/27/2011 11:21 PM, Lin Ming wrote:
> > @@ -3208,6 +3209,11 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> >
> >   	ap = ata_shost_to_port(shost);
> >
> > +	if (pm_runtime_suspended(&ap->tdev))
> > +		pm_runtime_resume(&ap->tdev);
> > +	pm_runtime_mark_last_busy(&ap->tdev);
> > +	pm_request_autosuspend(&ap->tdev);
> > +
> >   	spin_lock_irqsave(ap->lock, irq_flags);
> >
> 
> 
> Putting this into the core command dispatch fast-path is rather 
> disappointing.  That's at least one additional lock, plus some atomic 
> instructions and tests.

Maybe move suspend request to the resume function, as below.

static int ata_port_runtime_resume(struct device *dev)
{
        struct ata_port *ap = to_ata_port(dev);
        int rc;

        rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
                ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);

        pm_runtime_mark_last_busy(dev);
        pm_request_autosuspend(dev);

        return rc;
}

Then the fast-path looks like,

@@ -3208,6 +3209,9 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost,
struct scsi_cmnd *cmd)

        ap = ata_shost_to_port(shost);

+       if (pm_runtime_suspended(&ap->tdev))
+               pm_runtime_resume(&ap->tdev);
+
        spin_lock_irqsave(ap->lock, irq_flags);

        ata_scsi_dump_cdb(ap, cmd);

What do you think?

Thanks,
Lin Ming

