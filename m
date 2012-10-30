Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab2J3UDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:03:49 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:39561 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934389Ab2J3UDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:03:45 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v4 6/7] efi_pstore: Add a format check for an existing
 variable name at reading time
Thread-Topic: [PATCH v4 6/7] efi_pstore: Add a format check for an existing
 variable name at reading time
Thread-Index: Ac222ZkaANzKyB9rT4GRzYIMo2uJgQ==
Date: Tue, 30 Oct 2012 20:03:31 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138B1E74@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-30_06:2012-10-30,2012-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210300228
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Issue]

a format of variable name has been updated to type, id, count and ctime
to support holding multiple logs.

Format of current variable name
  dump-type0-1-2-12345678

  type:0
  id:1
  count:2
  ctime:12345678

On the other hand, if an old variable name before being updated
remains, users can't read it via /dev/pstore.

Format of old variable name
  dump-type0-1-12345678

  type:0
  id:1
  ctime:12345678

[Solution]

This patch add a format check for the old variable name in a read callback
to make it readable.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efivars.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7ad3aae..bf7a6f9 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -681,17 +681,35 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 				*count = cnt;
 				timespec->tv_sec = time;
 				timespec->tv_nsec = 0;
-				get_var_data_locked(efivars, &efivars->walk_entry->var);
-				size = efivars->walk_entry->var.DataSize;
-				*buf = kmalloc(size, GFP_KERNEL);
-				if (*buf == NULL)
-					return -ENOMEM;
-				memcpy(*buf, efivars->walk_entry->var.Data,
-				       size);
-				efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
-					           struct efivar_entry, list);
-				return size;
+			} else if (sscanf(name, "dump-type%u-%u-%lu",
+				   type, &part, &time) == 3) {
+				/*
+				 * Check if an old format,
+				 * which doesn't support holding
+				 * multiple logs, remains.
+				 */
+				*id = part;
+				*count = 0;
+				timespec->tv_sec = time;
+				timespec->tv_nsec = 0;
+			} else {
+				efivars->walk_entry = list_entry(
+						efivars->walk_entry->list.next,
+						struct efivar_entry, list);
+				continue;
 			}
+
+			get_var_data_locked(efivars, &efivars->walk_entry->var);
+			size = efivars->walk_entry->var.DataSize;
+			*buf = kmalloc(size, GFP_KERNEL);
+			if (*buf == NULL)
+				return -ENOMEM;
+			memcpy(*buf, efivars->walk_entry->var.Data,
+			       size);
+			efivars->walk_entry = list_entry(
+					efivars->walk_entry->list.next,
+					struct efivar_entry, list);
+			return size;
 		}
 		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
 						 struct efivar_entry, list);
-- 
1.7.1
