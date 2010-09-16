Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0IPWf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:35:26 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:47711 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754973Ab0IPWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:35:24 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: _EvxvdMVM1mg1iuqTfMghNYH2JV.TM3RGycOWpTbqnB3S8A
 QhSFk_yNy5elCUEhzrsoSaZJPTGwLvQAtM0PfZjJ9_DyWsUGoaAbAZpqNsnG
 w6U6e1Vbav5srnZNJ3ipD8km6cUrn4xsMN9PZdfDMeoj6PJTFY01V2UYmrcM
 WrDC8Ldsd3OhIX_.rAFyEETQz2ONJBc9nUrhEC3MuEkBqGBoH1Q0fDOowBw_
 e3XDNtHl1JtZFkNqUv8FSwGm8KPv7hKuq1bORGeDpCHBjmUm4khkYrHFx58J
 EZSntxbipdlFI4.aLrp_AvGyMBwjOUuZxyb6C3TGqRoilXP4ghgYZR7zjUtV
 udx2VPD6ArswgP9rJBA--
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
Subject: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand() caller
Date: Thu, 16 Sep 2010 15:35:21 -0700
Message-Id: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series contains the first round of a whole-sale conversion for droping
struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
that is protected by host_lock is scsi_cmd_get_serial)_.

The patches #2 -> #8 converts libiscsi, libsas, lpfc, qla4xxx, qla2xxx,
TCM_Loop, and libfc code to drop their own SHT->queuecommand() internal
host_lock unlock() + lock() optimization that certain high performance libs
and LLDs have adopted over the years.  The changes involved here are really
quite straight forward, but please note that none of this code has been tested
with actual hardware yet, and is intended for generating comments for the relivent
SCSI LLD driver maintainers and other interested folks.

There are probably still be more LLDs which use this optimization, so please
let me know if there is another piece of SHT->queuecommand() caller code that
does this legacy optimization and needs to be updated.  I will be sure to
CC the right driver maintainers and CC linux-scsi as I come across any more
conversions.

Many thanks to Vasu Dev and Tim Chen for their work in this area!!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (8):
  scsi: Drop struct Scsi_Host->host_lock around SHT->queuecommand()
  libiscsi: Remove host_lock unlock() + lock() from
    iscsi_queuecommand()
  libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
  lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
  qla4xxx: Remove host_lock unlock() + lock() from
    qla4xxx_queuecommand()
  qla2xxx: Remove host_lock unlock() + lock() from
    qla2xxx_queuecommand()
  tcm_loop: Remove host_lock unlock() + lock() from
    tcm_loop_queuecommand()
  libfc: Remove host_lock unlock() + lock() from fc_queuecommand()

 drivers/scsi/libfc/fc_fcp.c                    |    5 +----
 drivers/scsi/libiscsi.c                        |    4 ----
 drivers/scsi/libsas/sas_scsi_host.c            |    5 -----
 drivers/scsi/lpfc/lpfc_scsi.c                  |    2 --
 drivers/scsi/qla2xxx/qla_os.c                  |    7 ++-----
 drivers/scsi/qla4xxx/ql4_os.c                  |    8 +-------
 drivers/scsi/scsi.c                            |    3 ++-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    7 -------
 8 files changed, 6 insertions(+), 35 deletions(-)

-- 
1.7.2.3

