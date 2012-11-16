Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab2KPFqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:46:48 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49205 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2KPFqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:46:46 -0500
MIME-Version: 1.0
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E346BDBEC4@ORSMSX101.amr.corp.intel.com>
References: <CABawtvMsrMhGL7emsvYRXrGEB9f2Pzha2+XTVSHaYw1PVJGa-Q@mail.gmail.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E346BC0674@ORSMSX101.amr.corp.intel.com>
	<CABawtvPNmOzgvsg9+y12a5ToCmV4OgKQeBAVQeRyc0F+XWmb7Q@mail.gmail.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E346BDBE51@ORSMSX101.amr.corp.intel.com>
	<CABawtvNq-DjM-nNP23=qvROjFWg-kfGNROJNTtWmt3CwVvj_4w@mail.gmail.com>
	<CABawtvNUXVPQ5YFAEPzyEgih26Wz4BVSWQf+CpO6O24ZAPS4og@mail.gmail.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E346BDBEC4@ORSMSX101.amr.corp.intel.com>
Date: Fri, 16 Nov 2012 13:46:46 +0800
Message-ID: <CABawtvORUq-OdXH4_j8+H=hiKEyT3F2shfrEhGP_0P6ucgU=aQ@mail.gmail.com>
Subject: Re: [PATCH ] tbfadt.c: output warning only when 64bit 32bit address
 of FACS/DSDT all have value but not equal to each other
From: Ethan Zhao <ethan.kernel@gmail.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob,
     How about moving some checking code as following patch ?

     From f46d539d81c763aa4e3e98f9fc1e94e0af48bd15 Mon Sep 17 00:00:00 2001
From: ethan.zhao <ethan.kernel@gmail.com>
Date: Sat, 17 Nov 2012 00:48:41 -0800
Subject: [PATCH]acpica/tbfadt.c  Move some checking and 32bit to 64bit
assignment code from acpi_tb_validate_fadt() to
 acpi_tb_convert_fadt to make the logic clearer and void multiple same
kind of warning.


Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/acpi/acpica/tbfadt.c |   51 ++++++++++++++---------------------------
 1 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index f23f512..dd18aba 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -388,18 +388,30 @@ static void acpi_tb_convert_fadt(void)
 	 */
 	if (!acpi_gbl_FADT.Xfacs) {
 		acpi_gbl_FADT.Xfacs = (u64) acpi_gbl_FADT.facs;
-	} else if (acpi_gbl_FADT.facs &&
+	} else if ((acpi_gbl_FADT.facs && acpi_gbl_FADT.Xfacs) &&
 		   (acpi_gbl_FADT.Xfacs != (u64) acpi_gbl_FADT.facs)) {
-		ACPI_WARNING((AE_INFO,
-		    "32/64 FACS address mismatch in FADT - two FACS tables!"));
+		ACPI_BIOS_WARNING((AE_INFO,
+                                   "32/64X FACS address mismatch in FADT - "
+                                   "0x%8.8X/0x%8.8X%8.8X, using 32",
+                                   acpi_gbl_FADT.facs,
+                                   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xfacs)));
+
+	        acpi_gbl_FADT.Xfacs = (u64)acpi_gbl_FADT.facs;
+
 	}

 	if (!acpi_gbl_FADT.Xdsdt) {
 		acpi_gbl_FADT.Xdsdt = (u64) acpi_gbl_FADT.dsdt;
-	} else if (acpi_gbl_FADT.dsdt &&
+	} else if ((acpi_gbl_FADT.dsdt && acpi_gbl_FADT.Xdsdt) &&
 		   (acpi_gbl_FADT.Xdsdt != (u64) acpi_gbl_FADT.dsdt)) {
-		ACPI_WARNING((AE_INFO,
-		    "32/64 DSDT address mismatch in FADT - two DSDT tables!"));
+		  ACPI_BIOS_WARNING((AE_INFO,
+                                   "32/64X DSDT address mismatch in FADT - "
+                                   "0x%8.8X/0x%8.8X%8.8X, using 32",
+                                   acpi_gbl_FADT.dsdt,
+                                   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xdsdt)));
+
+                acpi_gbl_FADT.Xdsdt = (u64)acpi_gbl_FADT.dsdt;
+
 	}

 	/*
@@ -507,33 +519,6 @@ static void acpi_tb_validate_fadt(void)
 	u8 length;
 	u32 i;

-	/*
-	 * Check for FACS and DSDT address mismatches. An address mismatch between
-	 * the 32-bit and 64-bit address fields (FIRMWARE_CTRL/X_FIRMWARE_CTRL and
-	 * DSDT/X_DSDT) would indicate the presence of two FACS or two DSDT tables.
-	 */
-	if (acpi_gbl_FADT.facs &&
-	    (acpi_gbl_FADT.Xfacs != (u64)acpi_gbl_FADT.facs)) {
-		ACPI_BIOS_WARNING((AE_INFO,
-				   "32/64X FACS address mismatch in FADT - "
-				   "0x%8.8X/0x%8.8X%8.8X, using 32",
-				   acpi_gbl_FADT.facs,
-				   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xfacs)));
-
-		acpi_gbl_FADT.Xfacs = (u64)acpi_gbl_FADT.facs;
-	}
-
-	if (acpi_gbl_FADT.dsdt &&
-	    (acpi_gbl_FADT.Xdsdt != (u64)acpi_gbl_FADT.dsdt)) {
-		ACPI_BIOS_WARNING((AE_INFO,
-				   "32/64X DSDT address mismatch in FADT - "
-				   "0x%8.8X/0x%8.8X%8.8X, using 32",
-				   acpi_gbl_FADT.dsdt,
-				   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xdsdt)));
-
-		acpi_gbl_FADT.Xdsdt = (u64)acpi_gbl_FADT.dsdt;
-	}
-
 	/* If Hardware Reduced flag is set, we are all done */

 	if (acpi_gbl_reduced_hardware) {
-- 
1.7.1


Thanks,
Ethan


On Fri, Nov 16, 2012 at 11:49 AM, Moore, Robert <robert.moore@intel.com> wrote:
> No decision(s) yet, we are still investigating
>
>
>> -----Original Message-----
>> From: Ethan Zhao [mailto:ethan.kernel@gmail.com]
>> Sent: Thursday, November 15, 2012 7:47 PM
>> To: Moore, Robert
>> Subject: Re: [PATCH ] tbfadt.c: output warning only when 64bit 32bit
>> address of FACS/DSDT all have value but not equal to each other
>>
>> Bob,
>>   I read the discussion you have done
>>
>>   https://www.acpica.org/bugzilla/show_bug.cgi?id=885
>>
>>  Why method do you prefer ?
>>
>> Thanks,
>> Ethan
>>
>> On Fri, Nov 16, 2012 at 11:38 AM, Ethan Zhao <ethan.kernel@gmail.com>
>> wrote:
>> > Bob,
>> >   In fact, you know if 32bit and 64bit address are all valid but not
>> > equal to each other, that does not follow ACPI 4&5 ,not follow 3 too.
>> >   Do you mean we need to guess why they declare two different
>> > FACS/DSDT, and so kernel should collect some clue to figure out why ?
>> > that is amazing thing to keep system to work though its buggy BIOS.
>> >
>> > Ethan
>> >
>> >
>> > On Fri, Nov 16, 2012 at 11:27 AM, Moore, Robert <robert.moore@intel.com>
>> wrote:
>> >> Basically, the flow goes like this:
>> >>
>> >> 1) We convert the original FADT (multiple versions) to a common
>> internal FADT.
>> >> 2) Then we check the common internal FADT for errors/inconsistencies.
>> >>
>> >> In this way, we don't need to have different error checking for
>> different versions of the FADT, and this is probably not going to change.
>> >>
>> >> One thing we are going to add is to make a decision on whether to favor
>> a 32-bit address or a 64-bit address (if they are different) based upon
>> the age of the machine/BIOS. This is for Windows compatibility.
>> >>
>> >> Bob
>> >>
>> >>
>> >>> -----Original Message-----
>> >>> From: Ethan Zhao [mailto:ethan.kernel@gmail.com]
>> >>> Sent: Thursday, November 15, 2012 6:29 PM
>> >>> To: Moore, Robert
>> >>> Cc: Brown, Len; Zheng, Lv; LKML
>> >>> Subject: Re: [PATCH ] tbfadt.c: output warning only when 64bit 32bit
>> >>> address of FACS/DSDT all have value but not equal to each other
>> >>>
>> >>> Bob,
>> >>>        Thanks for your detailed reviewing about the whole possible
>> >>> conditions.
>> >>>        I.C.  So that is impossible zero value for Xfacs /Xdsdt if
>> >>> facs/dsdt >0, for they are assigned in acpi_tb_convert_fadt(),  I
>> >>> need to move my eyes one line code higher to see why it yelled twice
>> >>> but not using the 32bit address at once in acpi_tb_convert_fadt().
>> >>>        Do you agree to move the checking code warning  and into
>> >>> acpi_tb_convert_fadt to make the code more simple and clear ? Or
>> >>> just keep it for more rework, more bug?
>> >>>
>> >>>
>> >>> Thanks,
>> >>> Ethan
