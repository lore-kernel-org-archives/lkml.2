Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab0JJDs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 23:48:26 -0400
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:36259 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754112Ab0JJDsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 23:48:24 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: yQ3PHTgVM1ns3Qa.Pj3glmyUs8TtQHwPPn4RLjC91vYY1Aa
 NfsgKwJnpGQ3cP2GDfCPR_0pRnRmiKIyo1vvScehy2L7kSqAIFgVUf.yz9Dn
 Pf84okmfpj62mNRA9FARA0x0uxDr2gGETf1M738FQTbjTXn8dxECzckR5dEQ
 OhmC.QH2X.Ncak92ylMfWw_tSWvJ2pt5QQOPuVSIrTQ_KjC_XgH0noGkU6Hb
 GGsosKcYZHjTJZKKLtiHAxnEfFCQG6xDSSRxkQiRyiwHYxB0fDskifrMk_zR
 5xZOtXqHGKiLrS0vGFay1jFIwGisFLCH6SvbLJ5PvPwQCxMFYs.4Xn9a6I62
 iiUHrQ9Jg3PzIbvG6wiUDKfozC6CAOj.bjmsAXrmAWFIdgPybNG54sJ0L7aF
 mhOieb.4U1FOZbfZ0CGs3MDGkHVnMVk_JPkpZ6X3cynm6WPIBy3c8RNILAeH
 nyhThTXQVFyCsVjY-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/4] tcm: Unify virtual subsystem plugin emulation code
Date: Sat,  9 Oct 2010 20:48:18 -0700
Message-Id: <1286682498-4821-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series contains patches to unify TCM virtual subsystem plugin emulation
logic into generic TCM code, and to provide a method of emulation for control
CDBs that are emulated generically across subsystem plugin code or that may
require CDB specific context in the new struct se_subsystem_api_cdb set of
subsystem dependent CDB callers.

The first patch adds a generic function transport_emulate_control_cdb()
which is intended used by virtual subsystem plugin code.  This includes
the primary list of CDBs handled in this manner from existing IBLOCK,
FILEIO and RAMDISK *_emulate_scsi_cdb() subsystem dependent code, and the
struct se_subsystem_api_cdb define described above.

Thse second patch converts IBLOCK, FILEIO and RAMDISK subsystem code to use
the new ->emulate_inquiry(), ->emulate_read_cap(), ->emulate_read_cap16() and
->emulate_unmap() callers their respective existing subsystem dependent logic.

The third and forth patches move WRITE_SAME_* and SYNCHRONIZE_CACHE_* CDB
emulation logic into transport_emulate_control_cdb() for these two originally
specially handled cases with IBLOCK and FILEIO subsystem code.

So far this code has been tested on TCM_Loop SCSI LUN with IBLOCK, FILEIO and
IBLOCK backstores with TPU=1, TPWS=1 and WCE=1 on v2.6.36-rc6.

Many thanks go out to Christoph for a bit of friendly prodding to finally make
this conversion happen.  Thanks hch!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  tcm: Unify subsystem plugin control CDB emulation
  tcm: Convert IBLOCK, FILEIO and RAMDISK subsystem code to
    transport_emulate_control_cdb()
  tcm: Move WRITE_SAME_* emulation into transport_emulate_control_cdb()
  tcm: Move SYNCHRONIZE_CACHE_* emulation into
    transport_emulate_control_cdb()

 drivers/target/target_core_file.c      |  163 ++++++++------------------
 drivers/target/target_core_iblock.c    |  102 +++-------------
 drivers/target/target_core_rd.c        |   91 ++-------------
 drivers/target/target_core_transport.c |  200 ++++++++++++++++++++++----------
 include/target/target_core_base.h      |    4 +-
 include/target/target_core_transport.h |   26 +++-
 6 files changed, 237 insertions(+), 349 deletions(-)

