Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2HGWab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:30:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab2HGWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <jdelvare@suse.de>, Huang Ying <ying.huang@intel.com>,
        Gary Hade <garyhade@us.ibm.com>, Len Brown <len.brown@intel.com>
Subject: [ 066/122] ACPI, APEI: Fixup common access width firmware bug
Date: Tue,  7 Aug 2012 15:25:54 -0700
Message-Id: <20120807221954.356297920@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit f712c71f7b2b43b894d1e92e1b77385fcad8815f upstream.

Many firmwares have a common register definition bug where 8-bit
access width is specified for a 32-bit register. Ideally this should
be fixed in the BIOS, but earlier versions of the kernel did not
complain, so fix that up silently.

This closes kernel bug #43282:
https://bugzilla.kernel.org/show_bug.cgi?id=43282

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Huang Ying <ying.huang@intel.com>
Acked-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/apei/apei-base.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -586,6 +586,11 @@ static int apei_check_gar(struct acpi_ge
 	}
 	*access_bit_width = 1UL << (access_size_code + 2);
 
+	/* Fixup common BIOS bug */
+	if (bit_width == 32 && bit_offset == 0 && (*paddr & 0x03) == 0 &&
+	    *access_bit_width < 32)
+		*access_bit_width = 32;
+
 	if ((bit_width + bit_offset) > *access_bit_width) {
 		pr_warning(FW_BUG APEI_PFX
 			   "Invalid bit width + offset in GAR [0x%llx/%u/%u/%u/%u]\n",


