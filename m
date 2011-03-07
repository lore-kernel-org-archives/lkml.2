Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1CGPXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:23:51 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:39480 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1CGPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:23:49 -0500
Date: Mon, 7 Mar 2011 10:23:45 -0500
From: chenliu@asset.uwaterloo.ca
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]early: fix possible overlapping data buffer
Message-ID: <20110307152345.GA1709@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bugzilla #12965:
https://bugzilla.kernel.org/show_bug.cgi?id=12965

The original code contains dangerous uses of sprintf functions like sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13", defsys_cmd, min_size), where defsys_cmd is used both as input string as well as output string. It should remember the written bytes of the previous sprintf and use that as the offset when adding something. Also use snprintf makes the code safer.

Signed-off-by: Chen Liu<chenliunju@gmail.com>
---
 arch/s390/kernel/early.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

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
@@ -124,7 +125,7 @@ static noinline __init void create_kerne
 	end_pfn = PFN_UP(__pa(&_end));
 	min_size = end_pfn << 2;
 
-	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
+	hlen = sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
 		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
 		eshared_pfn, end_pfn);
 
@@ -133,13 +134,13 @@ static noinline __init void create_kerne
 		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
 		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
 		min_size = einitrd_pfn << 2;
-		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
+		hlen += snprintf(defsys_cmd + hlen, DEFSYS_CMD_SIZE - hlen, " EW %.5X-%.5X",
 		sinitrd_pfn, einitrd_pfn);
 	}
 #endif
 
-	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13",
-		defsys_cmd, min_size);
+	hlen += snprintf(defsys_cmd + hlen, DEFSYS_CMD_SIZE - hlen, " EW MINSIZE=%.7iK PARMREGS=0-13",
+		min_size);
 	sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
 		kernel_nss_name, kernel_nss_name);
 
