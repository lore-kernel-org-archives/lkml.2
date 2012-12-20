Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab2LTPNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:13:17 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:54945 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2LTPNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:13:07 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: [PATCH v3 2/2] efi_pstore: Avoid deadlock in non-blocking paths
Thread-Topic: [PATCH v3 2/2] efi_pstore: Avoid deadlock in non-blocking paths
Thread-Index: Ac3exG0xTpGfiYNPTTa+NIsMizFaxg==
Date: Thu, 20 Dec 2012 15:12:48 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A070@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-20_05:2012-12-20,2012-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212200121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

There is a scenario which efi_pstore may hang up:

 - cpuA grabs efivars->lock
 - cpuB panics and calls smp_send_stop
 - smp_send_stop sends IRQ to cpuA
 - after 1 second, cpuB gives up on cpuA and sends an NMI instead
 - cpuA is now in an NMI handler while still holding efivars->lock
 - cpuB is deadlocked

This case may happen if a firmware has a bug and
cpuA is stuck talking with it.

[Solution]

This patch changes a spin_lock to a spin_trylock in non-blocking paths.
and if the spin_lock has already taken by another cpu,
it returns without accessing to a firmware to avoid the deadlock.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efivars.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7b1c374..ef5070d 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1209,7 +1209,16 @@ static int efi_pstore_write(enum pstore_type_id type,
 	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status = EFI_NOT_FOUND;
 
-	spin_lock(&efivars->lock);
+	if (pstore_cannot_block_path(reason)) {
+		/*
+		 * If the lock is taken by another cpu in non-blocking path,
+		 * this driver returns without entering firmware to avoid
+		 * hanging up.
+		 */
+		if (!spin_trylock(&efivars->lock))
+			return -EBUSY;
+	} else
+		spin_lock(&efivars->lock);
 
 	/*
 	 * Check if there is a space enough to log.
-- 1.7.1
