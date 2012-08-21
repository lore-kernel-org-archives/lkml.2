Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2HUQyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:54:53 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:46036 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2HUQyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:54:51 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH v3 3/3] efi_pstore: Skiping scheduling a workqueue in
 cases other than oops
Thread-Topic: [RFC][PATCH v3 3/3] efi_pstore: Skiping scheduling a workqueue
 in cases other than oops
Thread-Index: Ac1/vaJAe1mxle8VRsyGW5d5fUpS+Q==
Date: Tue, 21 Aug 2012 16:54:41 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413806C44@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-21_05:2012-08-21,2012-08-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208210165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]
 efi_pstore creates sysfs files when logging kernel messages to NVRAM.
 Currently, the sysfs files are updated in a workqueue which is registered in a write callback.

 On the other hand, situations which users needs the sysfs files are when they erase entries or oops happen 
 because a system will  be down and users can't access to sysfs files in other cases like panic, reboot or emergency_restart.

 Also, if kernel panics due to a bug of workqueue operations and a write callback of efi_pstore is called in
 panic case, efi_pstore may fail due to a failure of schedule_work(). 
 And panic_notifier_chain()/emergency_restart() is not kicked if efi_pstore fails.  
   This may cause user's unwanted result.

[Patch Description]
 This patch registers a workqueue updating sysfs entries in cases where users erase entries or oops happen only,
 and skips it in other cases like panic, reboot or emergency_start.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efivars.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3dde7d6..a4919ad 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -746,7 +746,12 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	spin_unlock_irqrestore(&efivars->lock, flags);
 
-	schedule_work(&efivar_work);
+	/*
+	 * The user may want to update sysfs for this write
+	 * when they erase an entry via /dev/pstore or oops happen.
+	 */
+	if (!size || reason == KMSG_DUMP_OOPS)
+		schedule_work(&efivar_work);
 
 	*id = part;
 	return ret;
-- 1.7.1 

