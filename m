Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1EZBbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:31:23 -0400
Received: from nm7.access.bullet.mail.sp2.yahoo.com ([98.139.44.134]:37940
	"HELO nm7.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755053Ab1EZBbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:31:22 -0400
X-Yahoo-Newman-Id: 718443.10141.bm@omp1030.access.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: p1bZczYVM1nHMCjngezzRA_0h_JoqBTskIY0.HrO_E6JcH1
 mlVbBSvY5IFrMW0dUTgs7dFhbHdnX1vWaBiR_HBBB8LoTgsQNb5W4.riWhgK
 0QCC0tWiIUwUgpKlXYv5RZaIk2YDbdEmKNX2SVd_ZUMPcOWWrCRaSvy1C8YB
 SvgcE0OiYOMiD5Upk6o8LKI.JUTtnTGpYNGVkJpvMQv98ttF0Vs..UBQfqGm
 Bgj8Rh_bndSM8YjKewyWtn3cQ9cWXnogr7G9C4T241kGrAs3XZMMY7Xi.MTT
 eToXUTD2fJv_MlCpLrOuB9muXeyF.QBJoUV.Yi0usYUIJU_cidqU7flXA1eh
 s3aoVp8wnlp0LneqVZsbQ78gzUPb4L_FCWAO4laghm0C_bMF8o2o8qeNoWV0
 Dg.XQmrY3vMdrU82.mMtMdjQYrrgk15tIL82LgOhPEBs16vjZ_wfEP5TKU4M
 l0SGn2wII.jIjWGyRI8plAdX.aC8ZkTg8LgHoZTn7F4xYbnFftP4woJNW8mS
 VG5QME71cgCbfAxkQF4Q3tOT9a.DPi2l1nqd3_od5_cPCDc0-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] iscsi-target: Fix SessionType=Discovery RX context conn->conn_logout_comp hang
Date: Wed, 25 May 2011 18:31:12 -0700
Message-Id: <1306373472-20573-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James & Co.

Below is the one outstanding bugfix patch to apply on top of iscsi-target
PATCH-v5 for an initial .40-rc1 / .2.8.0-rc1 merge into scsi-misc.

Once again, thanks to Martin Svec for efficently tracking down this issue
and getting this patch tested+verified the initial merge code on .39-rc..

Thanks!

--nab

----------------------------------------------------------------------------

This patch fixes a bug in iscsi_target_rx_thread():ISCSI_OP_LOGOUT where
conn->conn_logout_comp was sleeping definately on wait_for_completion with
SessionType=Discovery.  This was occuring because the per connection NopIN
timer is correctly not enabled for discovery sessions, and hence does not
fire to trigger an connection failure event in iscsi_target_tx_thread() ->
iscsit_close_connection() in order to wakeup the sleeping RX thread context.

This patch changes the conn_logout_comp to use wait_for_completion_timeout()
for both cases and defines a SECONDS_FOR_LOGOUT_COMP of 15 seconds.

Reported-by & Tested-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c      |    3 ++-
 drivers/target/iscsi/iscsi_target_core.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6bba5fd..964cadc 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4292,7 +4292,8 @@ restart:
 		case ISCSI_OP_LOGOUT:
 			ret = iscsit_handle_logout_cmd(conn, buffer);
 			if (ret > 0) {
-				wait_for_completion(&conn->conn_logout_comp);
+				wait_for_completion_timeout(&conn->conn_logout_comp,
+						SECONDS_FOR_LOGOUT_COMP * HZ);
 				goto transport_err;
 			} else if (ret < 0)
 				goto transport_err;
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index c7ca0a0..af24171 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -15,6 +15,7 @@
 #define ISCSI_RX_THREAD_TCP_TIMEOUT	2
 #define SECONDS_FOR_ASYNC_LOGOUT	10
 #define SECONDS_FOR_ASYNC_TEXT		10
+#define SECONDS_FOR_LOGOUT_COMP		15
 #define WHITE_SPACE			" \t\v\f\n\r"
 
 /* struct iscsi_node_attrib sanity values */
-- 
1.7.5.2

