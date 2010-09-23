Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0IWXh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:37:29 -0400
Received: from nm27.bullet.mail.sp2.yahoo.com ([98.139.91.97]:45879 "HELO
	nm27.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753357Ab0IWXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:37:27 -0400
X-Yahoo-Newman-Id: 682397.53160.bm@omp1039.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: lbdZwSEVM1lUE52ntJvGNcfY6neBtzlvA3nFO9BK.4xF7GM
 .eHr5_kK_IyntbLWwNycEijVoTNeR9OSGECo2TFFvcANiPARloLe5FNlG6e2
 2hc3jNjWeFmXYLRUZ1ZaGISlJDLFF5uS74bzf_JUZlYZ3rXyFTBHzAWFLcNx
 lbaGhgkDjx0RpaGEtgEfHMutVVhpsE7LZhirDUg5MK3DeYJqHxvJ.k245_Vd
 ptODHz.Bv3ssDDLdWe1X2jAvevPyCF4CaDx4V_2WW6pHQuZUupNL_uFwy1co
 lE2hSTJCv_OhJlgVt9u2qnCMonhDk3QOhmvEhjINZ7dOHSRn4jkFF8_tTNw1
 Lbm_fE7BVGzkF.drhfQ--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v3 00/15] Drop host_lock from scsi_dispatch_cmd() -> SHT->queuecommand()
Date: Thu, 23 Sep 2010 16:37:23 -0700
Message-Id: <1285285043-16331-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This is the third RFC for removing all usage of struct Scsi_Host->host_lock
from drivers/scsi/scsi.c:scsi_dispatch_cmd() -> SHT->queuecomand() per I/O descriptor
context dispatch while doing a wholesale conversion of existing library and
all other SCSI LLD ->queuecommand() callers that use the now extinct host_lock
optimization of:
	
	unlock() ; do_some_lld_work() ; lock() -> return from ->mylld_queuecommand()

This series includes patches to drop this historical optimization (and prevent a
sure-fire deadlock w/ host_lock here) in libiscsi, libsas, libfc, libata and in
lpfc, qla4xxx, qla2xxx, fnic, and buslogic SCSI LLDs.

This patch also converts the scsi_cmd_get_serial() call to a counting by 2 odd
counter that is no longer used directly and by default for LLDs in scsi_dispatch_cmd(),
but is still required for mpt-fusion, mpt2sas, and a handful of old LLDs.

For this case we add explict scsi_cmd_get_serial() calls into SHT->queuecommand()
callers for mpt2sas, mpt/fusion, dpt_i2o, eata and u14-34f.  There are other
SCSI LLDs that use struct scsi_cmnd->serial_number informationally, but no other
ones (AFAICT) actually depend on having ->serial_number set to function properly.

So if anyone else knows if any SCSI LLDs that either:

	*) drop and request struct Scsi_Host->host_lock in their SHT->queuecommand()
	   to prevent dead-lock
	
	*) or depend upon struct scsi_cmnd->serial_number for some reason to prevent
	   any other old/obsecure LLDs from having problems with a zero ->serial_number.

please let me know and I will queue a follow up patches to address any other issues.

Many thanks go out to Vasu Dev, Tim Chen, Matthew Wilcox, Joe Eykholt, Mike Christie,
James Bottomley, and others for their invaluable input to help make the conversion happen.

Thank you!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (15):
  scsi: Drop struct Scsi_Host->host_lock usage in scsi_dispatch_cmd()
  libiscsi: Remove host_lock unlock() + lock() from
    iscsi_queuecommand()
  libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
  libfc: Remove host_lock unlock() + lock() from fc_queuecommand()
  libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
  lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
  qla4xxx: Remove host_lock unlock() + lock() from
    qla4xxx_queuecommand()
  qla2xxx: Remove host_lock unlock() + lock() from
    qla2xxx_queuecommand()
  fnic: Remove host_lock unlock() + lock() from fnic_queuecommand()
  buslogic: Remove host_lock unlock() + lock() from
    BusLogic_QueueCommand()
  mpt2sas: Add scsi_cmd_get_serial() call
  mpt/fusion: Add scsi_cmd_get_serial() call
  dpt_i2o: Add scsi_cmd_get_serial() call
  eata: Add scsi_cmd_get_serial() call
  u14-34f: Add scsi_cmd_get_serial() call

 drivers/ata/libata-scsi.c            |    2 --
 drivers/message/fusion/mptscsih.c    |    5 +++++
 drivers/scsi/BusLogic.c              |    4 ----
 drivers/scsi/dpt_i2o.c               |    5 +++++
 drivers/scsi/eata.c                  |    5 +++++
 drivers/scsi/fnic/fnic_scsi.c        |    9 ---------
 drivers/scsi/libfc/fc_fcp.c          |    5 +----
 drivers/scsi/libiscsi.c              |    4 ----
 drivers/scsi/libsas/sas_scsi_host.c  |    5 -----
 drivers/scsi/lpfc/lpfc_scsi.c        |    2 --
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    5 +++++
 drivers/scsi/qla2xxx/qla_os.c        |    7 ++-----
 drivers/scsi/qla4xxx/ql4_os.c        |    8 +-------
 drivers/scsi/scsi.c                  |   29 ++++++++++++++---------------
 drivers/scsi/scsi_error.c            |   10 +++++++---
 drivers/scsi/u14-34f.c               |    6 ++++++
 include/scsi/scsi_cmnd.h             |    1 +
 include/scsi/scsi_host.h             |    5 ++---
 18 files changed, 54 insertions(+), 63 deletions(-)

-- 
1.7.3

