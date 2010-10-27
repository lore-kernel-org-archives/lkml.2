Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0J0ByY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:54:24 -0400
Received: from nm14.bullet.mail.ac4.yahoo.com ([98.139.52.211]:41636 "HELO
	nm14.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753014Ab0J0ByX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:54:23 -0400
X-Yahoo-Newman-Id: 451121.99062.bm@omp1060.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Hrqis98VM1kWeK.QM2uRPoZMBTdm2qxLz_.0CvMUVw2mATK
 zS9.FBtBTAs3zR.mYcLFVKYBk5ya2YJNLKFvGwJEY7ikZF90efSyvoDnuEGs
 tAuOfTbmGF73kjDm.i5REBKjUaKsAnwqT5XAz_BSeUA4XkKGh05Xp1OELvhA
 l0o6jPZcK584hjQI2eN1vtLwCfLAHb6NmMg5Xvj3JOjO.5BBvwehQj1nY1UQ
 Ycd1cqhxY8duyu1P4MixV0BqN87k7ZQ2kgdni1tK8iknMqdBHZyhzM4bQ_yU
 ftxo0PVUhSLbAyIumpwJzIdtJ1QdJzeF.533Z1UzrmkRdBxFnZUwwlFAsBdc
 rtnM-
X-Yahoo-Newman-Property: ymail-3
Subject: RE: [PATCH] scsi: Add SHT->unlocked_qcmd for host_lock less
	SHT->queuecommand() dispatch
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jack Wang <jack_wang@usish.com>
Cc: "'linux-scsi'" <linux-scsi@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
In-Reply-To: <EA06876956CB4AC4A0678AD1E6E72840@usish.com.cn>
References: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
	 <EA06876956CB4AC4A0678AD1E6E72840@usish.com.cn>
Content-Type: text/plain
Date: Tue, 26 Oct 2010 18:49:26 -0700
Message-Id: <1288144166.5169.182.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 09:52 +0800, Jack Wang wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This patch adds scsi_dispatch_cmd_unlocked() and scsi_dispatch_cmd_locked()
> which are now called directly from scsi_dispatch_cmd() depending upon what
> is reported by SHT->unlocked_qcmd on a per driver basis.  Note that by
> default
> unlocked_qcmd is disabled, and all LLDs not defining a SHT->unlocked_qcmd
> will
> be using the legacy scsi_dispatch_cmd_locked().
> 
> This patch also drops the usage of scsi_cmd_get_serial() in
> scsi_dispatch_cmd()
> and assumes the legacy SCSI LLDs that depend upon struct
> scsi_cmnd->serial_number
> will call the now EXPORT_SYMBOL()'ed scsi_cmd_get_serial() call.
> 
> This patch also adds a cmd->eh_eflags |= SCSI_EH_SOFTIRQ_DONE assignment in
> scsi_softirq_done() in order to signal scsi_try_to_abort_cmd() that the
> command
> has been completed.  This patch uses blk_test_rq_complete() together with a
> new SCSI_EH_SOFTIRQ_DONE in scsi_error.c:scsi_try_to_abort_cmd() in order to
> handle the struct scsi_cmnd timeout case intsead w/o scmd->serial_number
> usage:
> 
> -	if (scmd->serial_number == 0)
> +	if ((blk_test_rq_complete(scmd->request)) &&
> +	    (scmd->eh_eflags & SCSI_EH_SOFTIRQ_DONE))
> 		return SUCCESS;
> 
> Finally, this patch also converts the remaining struct
> Scsi_Host->cmd_serial_number
> to atomic_t following a recommedation by Joe Eykholt to start struct
> Scsi_Host->
> cmd_serial_number at 1, and increment each serial_number by 2 so that the
> serial is odd, and wraps to 1 instead of 0.  struct
> Scsi_Host->cmd_serial_number
> is initialized to '1' in drivers/scsi/hosts.c:scsi_host_alloc().
> 
> Along with the changes to SCSI ML, this series includes the following LLD
> commits to enable lock-less operation for certain LLDs, and adds the explict
> scsi_cmd_get_serial() to the legacy LLDs still requring cmd->serial_number
> for anything beyond informational purposes:
> 
> libiscsi: Remove host_lock unlock() + lock() from iscsi_queuecommand()
> libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
> aic94xx: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
> mvsas: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
> pm8001: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
> libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
> lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
> qla4xxx: Remove host_lock unlock() + lock() from qla4xxx_queuecommand()
> qla2xxx: Remove host_lock unlock() + lock() from qla2xxx_queuecommand()
> fnic: Remove host_lock unlock() + lock() from fnic_queuecommand()
> mpt2sas: Add scsi_cmd_get_serial() call and set SHT->unlocked_qcmd=1
> mpt/fusion: Add scsi_cmd_get_serial() call and set SHT->unlocked_qcmd=1
> dpt_i2o: Add scsi_cmd_get_serial() call
> eata: Add scsi_cmd_get_serial() call
> u14-34f: Add scsi_cmd_get_serial() call
> 
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Acked-by: Ravi Anand <ravi.anand@qlogic.com> (for qla2xx)
> Acked-by: Luben Tuikov <ltuikov@yahoo.com> (for aic94xx)
> 
> Hi, Nab
> 
> Please consider to add my ack. Thanks!
> Acked-by: Jack Wang <jack_wang@usish.com> (for pm8001)
> 

Many thanks Jack!

Best,

--nab

> Jack
> 

