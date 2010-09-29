Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0I2Hzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:55:52 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:35384 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752540Ab0I2Hzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:55:50 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: YzcVeIgVM1lQvZykUg438EDgsH3pf46.FkS_KdBqhpTYxJ7
 .fYxGUzzFsyM6xxghSgbgQ10Q_6vTRkjmMHcsTJ6MdAWMByhvSmqjIzmKv7w
 K5cwYnhlt7JAoZXiVRK7KHENR4B_Md2V0MURTuZrOM.bY6Xi8li2dm25A0De
 OmRyKih_lctqQfA3PaIRWmhvPfwhueqQ9H0bxAcXGMxHtHFoA28jzB_tFA1H
 DrQU2TTXon7Ru9ukcX5t3MIWbF4OUb_dVBYV5DRdCoX3cdC2andY.Nl81pVh
 3wWSXqhNYXq8gtBzCsrhyaVf5jKQ4p..FHuE73PwBogNuxrRw_LET8MM5vWZ
 WpPvmPcW0APnE9o01O_jbFCg3EhmokenlCg6pAUsot41bs2vuCXzSSQ7S5pp
 tg93UfsPv80IOt.WhhN6V6QaDMkqLlClo1gfbNBfHbo2DWGXxoRPtHA8w7BU
 ucPXsFs7pzR9.5dsutQ--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC v4 10/19] lpfc: Remove host_lock unlock() + lock() from
	lpfc_queuecommand()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>
In-Reply-To: <4CA1777A.2050606@cs.wisc.edu>
References: <1285639612-7405-1-git-send-email-nab@linux-iscsi.org>
	 <4CA1777A.2050606@cs.wisc.edu>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 00:51:30 -0700
Message-Id: <1285746690.18417.31.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 00:04 -0500, Mike Christie wrote:
> On 09/27/2010 09:06 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger<nab@linux-iscsi.org>
> >
> > This patch removes the now legacy host_lock unlock() + lock() optimization
> > from lpfc_scsi.c:lpfc_queuecommand().  This also includes setting the
> > SHT->unlocked_qcmd=1 for host_lock less lpfc lpfc_queuecommand() operation.
> >
> > Signed-off-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
> > ---
> >   drivers/scsi/lpfc/lpfc_scsi.c |    4 ++--
> >   1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> > index 2e51aa6..69fe31e 100644
> > --- a/drivers/scsi/lpfc/lpfc_scsi.c
> > +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> > @@ -3023,11 +3023,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
> >   		goto out_host_busy_free_buf;
> >   	}
> >   	if (phba->cfg_poll&  ENABLE_FCP_RING_POLLING) {
> > -		spin_unlock(shost->host_lock);
> >   		lpfc_sli_handle_fast_ring_event(phba,
> >   			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
> >
> > -		spin_lock(shost->host_lock);
> >   		if (phba->cfg_poll&  DISABLE_FCP_RING_INT)
> >   			lpfc_poll_rearm_timer(phba);
> >   	}
> > @@ -3723,6 +3721,7 @@ struct scsi_host_template lpfc_template = {
> >   	.slave_destroy		= lpfc_slave_destroy,
> >   	.scan_finished		= lpfc_scan_finished,
> >   	.this_id		= -1,
> > +	.unlocked_qcmd		= 1,
> >   	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
> >   	.cmd_per_lun		= LPFC_CMD_PER_LUN,
> >   	.use_clustering		= ENABLE_CLUSTERING,
> > @@ -3746,6 +3745,7 @@ struct scsi_host_template lpfc_vport_template = {
> >   	.slave_destroy		= lpfc_slave_destroy,
> >   	.scan_finished		= lpfc_scan_finished,
> >   	.this_id		= -1,
> > +	.unlocked_qcmd		= 1,
> >   	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
> >   	.cmd_per_lun		= LPFC_CMD_PER_LUN,
> >   	.use_clustering		= ENABLE_CLUSTERING,
> 
> The FC class sets the rport state and bits with the host lock held. 
> Drivers were then calling fc_remote_port_chkready from the queuecommand 
> with the host lock held. If we remove the host lock from queuecommand is 
> it possible that the on one proc the fc class calls fc_remote_port_add 
> to re-add a rport, this sets the rport state to online, it unblocks the 
> devices, but then on some other processor we start calling queuecommand 
> and see that the rport is not online (maybe blocked with 
> FC_RPORT_FAST_FAIL_TIMEDOUT set) and so we end up failing the IO?

Hey Mike,

So it sounds like we have two options here:

*) Add a per struct fc_rport lock to protect rport->port_state in
fc_remote_port_chkready() (and other places..?) that assume they will
be held under host_lock.  Unfortuately fc_remote_port_chkready() does
not mention the hard requirement for host_lock held usage, so I assume
other callers will not either.. :-(

*) Drop the lockless ->queuecommand() patches for LLD users of
fc_remote_port_chkready() for now and use the legacy ->queuecommand() ->
unlock -> do_lld_work() -> lock optimization.  Here is what that list
currently looks like in drivers/scsi:

drivers/scsi/bfa/bfad_im.c:	if (!rport || fc_remote_port_chkready(rport))
drivers/scsi/bfa/bfad_im.c:	rc = fc_remote_port_chkready(rport);
drivers/scsi/fnic/fnic_main.c:	if (!rport || fc_remote_port_chkready(rport))
drivers/scsi/fnic/fnic_scsi.c:	ret = fc_remote_port_chkready(rport);
drivers/scsi/fnic/fnic_scsi.c:	if (fc_remote_port_chkready(rport) == 0)
drivers/scsi/fnic/fnic_scsi.c:	if (fc_remote_port_chkready(rport))
drivers/scsi/ibmvscsi/ibmvfc.c:	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
drivers/scsi/ibmvscsi/ibmvfc.c:	if (unlikely(rc || (rport && (rc = fc_remote_port_chkready(rport)))) ||
drivers/scsi/ibmvscsi/ibmvfc.c:	if (!rport || fc_remote_port_chkready(rport))
drivers/scsi/libfc/fc_fcp.c:	rval = fc_remote_port_chkready(rport);
drivers/scsi/libfc/fc_fcp.c:	rval = fc_remote_port_chkready(rport);
drivers/scsi/libfc/fc_fcp.c:	if (!rport || fc_remote_port_chkready(rport))
drivers/scsi/lpfc/lpfc_scsi.c:	err = fc_remote_port_chkready(rport);
drivers/scsi/lpfc/lpfc_scsi.c:	if (!rport || fc_remote_port_chkready(rport))
drivers/scsi/qla2xxx/qla_os.c:	rval = fc_remote_port_chkready(rport);
drivers/scsi/qla2xxx/qla_os.c:	if (!rport || fc_remote_port_chkready(rport))
drivers/scsi/scsi_transport_fc.c:	 * the port_state or flags, so that fc_remote_port_chkready will

So what you think we should do here..?

Also, does anyone know if any of the same type of host_lock held
assumptions are also made by libsas and/or libata code..?

Best,

--nab



