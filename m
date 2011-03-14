Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1CNPZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:25:41 -0400
Received: from asset.uwaterloo.ca ([129.97.92.29]:58938 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab1CNPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:25:39 -0400
Date: Mon, 14 Mar 2011 11:25:32 -0400
From: chenliu@asset.uwaterloo.ca
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        cotte@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH]early: Fix possible overlapping data buffer
Message-ID: <20110314152532.GA27277@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Heiko. This patch hasn't been tested yet. I've modifed
the Signed=off-by to make it identical to From. Here is the
patch:
-------------------------------------------------------
This patch fixed bugzilla #12965:
https://bugzilla.kernel.org/show_bug.cgi?id=12965

The original code contains some inproper use of sprintf
function where a buffer is used both as input string
as well as output string. It should remember the written
bytes in the previous and use that as the offset for
later writing. Also replace sprintf with snprintf.

Signed-off-by: Chen Liu <chenliu@asset.uwaterloo.ca>
---
 arch/s390/kernel/early.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -94,6 +94,7 @@ static noinline __init void create_kerne
 	unsigned int sinitrd_pfn, einitrd_pfn;
 #endif
 	int response;
+	int hlen;
 	size_t len;
 	char *savesys_ptr;
 	char defsys_cmd[DEFSYS_CMD_SIZE];
@@ -124,22 +125,27 @@ static noinline __init void create_kerne
 	end_pfn = PFN_UP(__pa(&_end));
 	min_size = end_pfn << 2;
 
-	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
+	snprintf(defsys_cmd, sizeof(defsys_cmd),
+		"DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
 		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
 		eshared_pfn, end_pfn);
+	defsys_cmd[DEFSYS_CMD_SIZE - 1] = '\0';
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (INITRD_START && INITRD_SIZE) {
 		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
 		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
 		min_size = einitrd_pfn << 2;
-		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
-		sinitrd_pfn, einitrd_pfn);
+		hlen += snprintf(defsys_cmd, DEFSYS_CMD_SIZE - hlen,
+			" EW %.5X-%.5X", defsys_cmd,
+			sinitrd_pfn, einitrd_pfn);
+		defsys_cmd[DEFSYS_CMD_SIZE - 1] = '\0';
 	}
 #endif
 
-	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13",
-		defsys_cmd, min_size);
+	snprintf(defsys_cmd + hlen, DEFSYS_CMD_SIZE - hlen,
+		" EW MINSIZE=%.7iK PARMREGS=0-13", min_size);
+	defsys_cmd[DEFSYS_CMD_SIZE - 1] = '\0';
 	sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
 		kernel_nss_name, kernel_nss_name);
 

