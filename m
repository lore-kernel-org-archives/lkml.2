Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0JCBUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 21:20:13 -0400
Received: from smtp101.sbc.mail.ac4.yahoo.com ([76.13.13.240]:35613 "HELO
	smtp101.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751069Ab0JCBUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 21:20:11 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: w4fPvL0VM1krEPZKuOmObgzwKkcL5iw_iKGufDzHWEQqv9I
 4K9iWASJneHfedq5.Mr6kulx_Lm6h2sKtVieHyhJZFhptAbNkusukqcjztww
 tgU07K4MgTPg.05eYAblIUdPr31lFYcJd4DS4o_j1PRp.46Ywg99zJlzONDK
 F3G_4sVfDUXYi5iVedfuKkEearYdpPMQhwY569aY_yBNFLueXkzVg2qRdz9l
 h.9c_8dNxPGpO6Ij.0v.xGi.0D5bouIBhkm_ORcD26jLMmn8ISoNfJUU.3bL
 aT7r7YeDBf9MSrblmvguLCSyNjGMjEam2eZmaiFtn9krwfhwTbLslbKn9bN4
 7cIffD2iiORMPi5NnqA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Add support for SA WRITE_SAME_32
Date: Sat,  2 Oct 2010 18:20:06 -0700
Message-Id: <1286068806-21458-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings mkp, boaz and co,

This patch adds support for service action WRITE_SAME_32 into
transport_generic_cmd_sequencer() to allow both emulate_tpws=1 with
TCM IBLOCK+FILEIO WRITE_SAME_32 w/ UNMAP=1 and existing TCM/pSCSI passthrough to
function.  This has been briefly tested 'sg_write_same -T' with TCM_Loop ->
TCM/FILEIO -> scsi_debug:

	sg_write_same --xferlen=4096 -T -U -v -v --lba=1024 --num=8 /dev/bsg/9\:0\:1\:0
	open /dev/bsg/9:0:1:0 with flags=0x802
	Default data-out buffer to 4096 zeroes
	    Write same(32) cmd: 7f 00 00 00 00 00 00 18 00 0d 08 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 08
	    Data-out buffer length=4096

Comments are welcome!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   40 ++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 445fbc3..39bbf57 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5856,6 +5856,46 @@ static int transport_generic_cmd_sequencer(
 			T_TASK(cmd)->t_tasks_fua = (cdb[10] & 0x8);
 			ret = TGCS_DATA_SG_IO_CDB;	
 			break;
+		case WRITE_SAME_32:
+			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
+			if (sector_ret)
+				return TGCS_UNSUPPORTED_CDB;
+			size = transport_get_size(sectors, cdb, cmd);
+			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+			transport_get_maps(cmd);
+			cmd->transport_split_cdb = &split_cdb_XX_32;
+			cmd->transport_get_long_lba = &transport_lba_64_ext;
+			/*
+			 * Skip the remaining assignments for TCM/PSCSI passthrough
+			 */
+			if (passthrough) {
+				ret = TGCS_DATA_SG_IO_CDB;
+				break;
+			}
+			if ((cdb[10] & 0x04) || (cdb[10] & 0x02)) {
+				printk(KERN_ERR "WRITE_SAME PBDATA and LBDATA"
+					" bits not supported for Block Discard"
+					" Emulation\n");
+				return TGCS_INVALID_CDB_FIELD;
+			}
+			/*
+			 * Currently for the emulated case we only accept
+			 * tpws with the UNMAP=1 bit set.
+			 */
+			if (!(cdb[10] & 0x08)) {
+				printk(KERN_ERR "WRITE_SAME w/ UNMAP bit not"
+					" supported for Block Discard Emulation\n");
+				return TGCS_INVALID_CDB_FIELD;
+			}
+			
+			cmd->se_cmd_flags |= SCF_EMULATE_SYNC_WRITE_SAME;
+			/*
+			 * Signal to TCM IBLOCK+FILEIO subsystem plugins that WRITE
+			 * tasks will be translated to SCSI UNMAP -> Block Discard
+			 */
+			T_TASK(cmd)->t_tasks_unmap = 1;
+			ret = TGCS_DATA_SG_IO_CDB;	
+			break;
 		default:
 			printk(KERN_ERR "VARIABLE_LENGTH_CMD service action"
 				" 0x%04x not supported\n", service_action);
-- 
1.5.6.5

