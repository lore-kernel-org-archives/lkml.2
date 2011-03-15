Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab1COLQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:16:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42388 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188Ab1COLOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:14:32 -0400
Message-Id: <20110315111426.348074239@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:10 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [patch 3/8] tpm: Fix display of data in pubek sysfs entry
References: <20110315111307.895085413@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_driver_fix_pubek.patch
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the TPM's pubek sysfs entry that is accessible as long
as the TPM doesn't have an owner. I shifted the access to the data
by -10 -- the first byte immediately follows the 10 byte header. The
line

 	data = tpm_cmd.params.readpubek_out_buffer;

sets it at the offset '10' in the packet, so we can read the data array
starting at offset '0'.

Before:

Algorithm: 00 0C 00 00
Encscheme: 08 00
Sigscheme: 00 00
Parameters: 00 00 00 00 01 00 AC E2 5E 3C A0 78
Modulus length: -563306801
Modulus: 
28 21 08 0F 82 CD F2 B1 E7 49 F7 74 70 BE 59 8C 
43 78 B1 24 EA 52 E2 FE 52 5C 3A 12 3B DC 61 71 
[...]

After:

Algorithm: 00 00 00 01
Encscheme: 00 03
Sigscheme: 00 01
Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
Modulus length: 256
Modulus: 
AC E2 5E 3C A0 78 DE 6C 9E CF 28 21 08 0F 82 CD 
F2 B1 E7 49 F7 74 70 BE 59 8C 43 78 B1 24 EA 52 
[...]

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -871,18 +871,24 @@ ssize_t tpm_show_pubek(struct device *de
 	data = tpm_cmd.params.readpubek_out_buffer;
 	str +=
 	    sprintf(str,
-		    "Algorithm: %02X %02X %02X %02X\nEncscheme: %02X %02X\n"
-		    "Sigscheme: %02X %02X\nParameters: %02X %02X %02X %02X"
-		    " %02X %02X %02X %02X %02X %02X %02X %02X\n"
-		    "Modulus length: %d\nModulus: \n",
-		    data[10], data[11], data[12], data[13], data[14],
-		    data[15], data[16], data[17], data[22], data[23],
-		    data[24], data[25], data[26], data[27], data[28],
-		    data[29], data[30], data[31], data[32], data[33],
-		    be32_to_cpu(*((__be32 *) (data + 34))));
+		    "Algorithm: %02X %02X %02X %02X\n"
+		    "Encscheme: %02X %02X\n"
+		    "Sigscheme: %02X %02X\n"
+		    "Parameters: %02X %02X %02X %02X "
+		    "%02X %02X %02X %02X "
+		    "%02X %02X %02X %02X\n"
+		    "Modulus length: %d\n"
+		    "Modulus:\n",
+		    data[0], data[1], data[2], data[3],
+		    data[4], data[5],
+		    data[6], data[7],
+		    data[12], data[13], data[14], data[15],
+		    data[16], data[17], data[18], data[19],
+		    data[20], data[21], data[22], data[23],
+		    be32_to_cpu(*((__be32 *) (data + 24))));
 
 	for (i = 0; i < 256; i++) {
-		str += sprintf(str, "%02X ", data[i + 38]);
+		str += sprintf(str, "%02X ", data[i + 28]);
 		if ((i + 1) % 16 == 0)
 			str += sprintf(str, "\n");
 	}

