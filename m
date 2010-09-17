Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0IQSVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:21:47 -0400
Received: from smtp103.sbc.mail.ac4.yahoo.com ([76.13.13.242]:22719 "HELO
	smtp103.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755241Ab0IQSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:21:45 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: fh8d0hcVM1kpVn2O5jvg2XuS0lJNC2_AXmc0jl5yqkg09BN
 QIfvWCbrCJUmmjCd_h9yY2DeqjQlAHyJtIHJIjv1wClr5vfkQIy400XrC_Ba
 Hsa9zAC1Wt.9MaMBajN.0d6M5ggBoO6WWj.1wEXUaJywRTL2t_65R81Jb4Rz
 UqvxJ3z6ScxmunXF2Ft_BUo0BpFPIOEM1BwhC3W7LtoiqlvqiMvq0PmAsCTj
 XJlO2WLlSO.VkvUu17yc4M_6Wpyu9DIe6oed2IWegz4N5Pr2z8UAOIYu3jOm
 Kr91LFp1gcI3LNCa1wTVY6Q4gwJoGJgSfGOcKJpoD7TAkWuRnRA--
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
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH v2 00/11] Drop host_lock usage from scsi_dispatch_cmd()
Date: Fri, 17 Sep 2010 11:21:37 -0700
Message-Id: <1284747697-20840-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series contains the second round of a whole-sale conversion for completely
dropping struct Scsi_Host->host_lock usage within scsi_dispatch_cmd() for
the ML internal scsi_cmd_get_serial() and external SHT->queuecommand() LLD callers.

The main changes from comments from v1 -> v2 are:

	*) Make scsi_cmd_get_serial() use atomic_t and disable it's usage by default.
	*) Drop struct Scsi_Host->host_lock usage in scsi_dispatch_cmd()

For the v2 series, patch #1 converts struct Scsi_Host->cmd_serial_number to
atomic_t and adds struct Scsi_Host->use_serial_number to enabled usage.  This
patch also follows Joe Eykholt suggestion of using a +2 for each scsi_cmd_get_serial()
to ensure that the counter always wraps to a non-zero value.

Patch #2 completely removes host_lock usage from scsi_dispatch_cmd().

Patch #3 -> #6 remove the legacy host_lock lock() -> do_work() -> unlock()
optimization from generic libiscsi, libsas, libfc and libata ->queuecommand()
callers respectively.

And patches #7 -> #11 do the same conversion legacy host_lock lock() -> do_work() ->
unlock() for lpfc, qla4xxx, qla2xxx, fnic, and buslogic LLDs specific ->queuecommand()
callers.

There may still be more LLDs which use this optimization, so please let me know if
there is another piece of SHT->queuecommand() caller code that does this legacy
optimization not in this list that need to be updated.  I will be sure to CC
the right driver maintainers and CC linux-scsi as I come across any more
conversions.

Many thanks to James Bottomley, Andi Keen, Joe Eykholt, Vasu Dev and
Tim Chen for their code and comments!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (11):
  scsi: Convert struct Scsi_Host->cmd_serial_number to atomic_t
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

 drivers/ata/libata-scsi.c           |    2 --
 drivers/scsi/BusLogic.c             |    4 ----
 drivers/scsi/fnic/fnic_scsi.c       |    9 ---------
 drivers/scsi/hosts.c                |    4 ++++
 drivers/scsi/libfc/fc_fcp.c         |    5 +----
 drivers/scsi/libiscsi.c             |    4 ----
 drivers/scsi/libsas/sas_scsi_host.c |    5 -----
 drivers/scsi/lpfc/lpfc_scsi.c       |    2 --
 drivers/scsi/qla2xxx/qla_os.c       |    7 ++-----
 drivers/scsi/qla4xxx/ql4_os.c       |    8 +-------
 drivers/scsi/scsi.c                 |   17 +++++++++++------
 include/scsi/scsi_host.h            |    8 +++++---
 12 files changed, 24 insertions(+), 51 deletions(-)

-- 
1.7.2.3

