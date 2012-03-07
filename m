Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2CGL5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:57:46 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47518 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2CGL5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:57:44 -0500
Date: Wed, 7 Mar 2012 14:57:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] acpi throttling: fix endian bug in
 acpi_read_throttling_status()
Message-ID: <20120307115736.GB13204@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F574D36.0141,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a u64 here creates an endian bug.  We store a u32 number in the
top byte which is a larger number than intended on big endian systems.
There is no reason to use a 64 bit data type here, I guess it was just
an oversight.

I removed the initialization to zero as well.  It's needed with a u64
but with a u32, the variable gets initialized properly inside the call
to acpi_os_read_port().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 605a295..1d02b7b 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -769,7 +769,7 @@ static int acpi_read_throttling_status(struct acpi_processor *pr,
 					u64 *value)
 {
 	u32 bit_width, bit_offset;
-	u64 ptc_value;
+	u32 ptc_value;
 	u64 ptc_mask;
 	struct acpi_processor_throttling *throttling;
 	int ret = -1;
@@ -777,12 +777,11 @@ static int acpi_read_throttling_status(struct acpi_processor *pr,
 	throttling = &pr->throttling;
 	switch (throttling->status_register.space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_IO:
-		ptc_value = 0;
 		bit_width = throttling->status_register.bit_width;
 		bit_offset = throttling->status_register.bit_offset;
 
 		acpi_os_read_port((acpi_io_address) throttling->status_register.
-				  address, (u32 *) &ptc_value,
+				  address, &ptc_value,
 				  (u32) (bit_width + bit_offset));
 		ptc_mask = (1 << bit_width) - 1;
 		*value = (u64) ((ptc_value >> bit_offset) & ptc_mask);
