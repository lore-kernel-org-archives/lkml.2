Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0JVVRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:17:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53019 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab0JVVRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:17:15 -0400
Date: Fri, 22 Oct 2010 14:17:13 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: [Patch 2/2] ibm_rtl: check for efi_enabled
Message-ID: <20101022211713.GI8754@lucy>
References: <20101005224718.GC4046@lucy>
 <20101021135429.GC22133@srcf.ucam.org>
 <20101021142319.GA8754@lucy>
 <20101021142523.GA23171@srcf.ucam.org>
 <20101021143821.GB8754@lucy>
 <20101021144234.GA23552@srcf.ucam.org>
 <20101021150928.GC8754@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101021150928.GC8754@lucy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested ibm_rtl on an IBM machine that is supported by this driver in 
Legacy BIOS mode, but which was running in UEFI mode and the system 
complained about remapping the EBDA because the EBDA should not have 
been there to start with.  This patch fixes that:

--Vernon

ibm_rtl: _RTL_ is not available in UEFI mode

Some of the IBM servers that are supported by ibm_rtl
can run in both Legacy mode (BIOS) and in UEFI mode.
When running in UEFI mode, it is possible that the
EBDA table exists but cannot be mapped and reports
errors.  We need to make sure that by default we don't
try to probe the machines if they are running in UEFI
mode.

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>

diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index c5a0061..3cff0e5 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -28,6 +28,7 @@
  #include <linux/io.h>
  #include <linux/sysdev.h>
  #include <linux/dmi.h>
+#include <linux/efi.h>
  #include <linux/mutex.h>
  #include <asm/bios_ebda.h>
  
@@ -238,7 +239,7 @@ static int __init ibm_rtl_init(void) {
  	if (force)
  		pr_warning("ibm-rtl: module loaded by force\n");
  	/* first ensure that we are running on IBM HW */
-	else if (!dmi_check_system(ibm_rtl_dmi_table))
+	else if (efi_enabled || !dmi_check_system(ibm_rtl_dmi_table))
  		return -ENODEV;
  
  	/* Get the address for the Extended BIOS Data Area */
