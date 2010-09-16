Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0IPOXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:23:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58855 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753556Ab0IPOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:23:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        David Woodhouse <David.Woodhouse@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v2] ihex: Add support for CS:IP/EIP records
Date: Thu, 16 Sep 2010 15:23:28 +0100
Message-Id: <1284647008-17469-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ihex firmwares can include a jump address for starting execution. Add
a -j option which will cause this to be written into the generated
file as a record with address zero and data consisting of the address
to jump to, allowing drivers to make use of this information.

This format is chosen because it most closely follows the original ihex
format, though it may make more sense to write a record with length zero
and the address stored as the address.  The records are not omitted by
default since our ihex format does not include record type information
and so including additional records may lead to confusion.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Updated to avoid alignment issues.

 firmware/ihex2fw.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/firmware/ihex2fw.c b/firmware/ihex2fw.c
index 5a03ba8..ba0cf0b 100644
--- a/firmware/ihex2fw.c
+++ b/firmware/ihex2fw.c
@@ -55,6 +55,7 @@ static int output_records(int outfd);
 
 static int sort_records = 0;
 static int wide_records = 0;
+static int include_jump = 0;
 
 static int usage(void)
 {
@@ -63,6 +64,7 @@ static int usage(void)
 	fprintf(stderr, "usage: ihex2fw [<options>] <src.HEX> <dst.fw>\n");
 	fprintf(stderr, "       -w: wide records (16-bit length)\n");
 	fprintf(stderr, "       -s: sort records by address\n");
+	fprintf(stderr, "       -j: include records for CS:IP/EIP address\n");
 	return 1;
 }
 
@@ -73,7 +75,7 @@ int main(int argc, char **argv)
 	uint8_t *data;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "ws")) != -1) {
+	while ((opt = getopt(argc, argv, "wsj")) != -1) {
 		switch (opt) {
 		case 'w':
 			wide_records = 1;
@@ -81,7 +83,9 @@ int main(int argc, char **argv)
 		case 's':
 			sort_records = 1;
 			break;
-		default:
+		case 'j':
+			include_jump = 1;
+			break;
 			return usage();
 		}
 	}
@@ -128,6 +132,7 @@ static int process_ihex(uint8_t *data, ssize_t size)
 {
 	struct ihex_binrec *record;
 	uint32_t offset = 0;
+	uint32_t data32;
 	uint8_t type, crc = 0, crcbyte = 0;
 	int i, j;
 	int line = 1;
@@ -223,8 +228,14 @@ next_record:
 			return -EINVAL;
 		}
 
+		memcpy(&data32, &record->data[0], sizeof(data32));
+		data32 = htonl(data32);
+		memcpy(&record->data[0], &data32, sizeof(data32));
+
 		/* These records contain the CS/IP or EIP where execution
-		 * starts. Don't really know what to do with them. */
+		 * starts. If requested output this as a record. */
+		if (include_jump)
+			file_record(record);
 		goto next_record;
 
 	default:
-- 
1.7.1

