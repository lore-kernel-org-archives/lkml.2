Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966058Ab2C3VV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:21:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966015Ab2C3VVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:25 -0400
Message-Id: <20120330194843.377087021@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 092/175] target: Fix 16-bit target ports for SET TARGET PORT GROUPS emulation
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 33395fb8a13731c7ef7b175dbf5a4d8a6738fe6c upstream.

The old code did (MSB << 8) & 0xff, which always evaluates to 0.  Just use
get_unaligned_be16() so we don't have to worry about whether our open-coded
version is correct or not.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_alua.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -30,6 +30,7 @@
 #include <linux/export.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
@@ -267,8 +268,7 @@ int target_emulate_set_target_port_group
 		 * changed.
 		 */
 		if (primary) {
-			tg_pt_id = ((ptr[2] << 8) & 0xff);
-			tg_pt_id |= (ptr[3] & 0xff);
+			tg_pt_id = get_unaligned_be16(ptr + 2);
 			/*
 			 * Locate the matching target port group ID from
 			 * the global tg_pt_gp list
@@ -312,8 +312,7 @@ int target_emulate_set_target_port_group
 			 * the Target Port in question for the the incoming
 			 * SET_TARGET_PORT_GROUPS op.
 			 */
-			rtpi = ((ptr[2] << 8) & 0xff);
-			rtpi |= (ptr[3] & 0xff);
+			rtpi = get_unaligned_be16(ptr + 2);
 			/*
 			 * Locate the matching relative target port identifer
 			 * for the struct se_device storage object.


