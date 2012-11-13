Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2KMQ0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:26:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:59203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab2KMQ0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:26:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,767,1344236400"; 
   d="scan'208";a="241501113"
From: "Moore, Robert" <robert.moore@intel.com>
To: Ethan Zhao <ethan.kernel@gmail.com>, "Brown, Len" <len.brown@intel.com>
CC: "Zheng, Lv" <lv.zheng@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH ] tbfadt.c: output warning only when 64bit 32bit address
 of FACS/DSDT all have value but not equal to each other
Thread-Topic: [PATCH ] tbfadt.c: output warning only when 64bit 32bit
 address of FACS/DSDT all have value but not equal to each other
Thread-Index: AQHNwU9vBp/XM+1UtU6pHwxKNmNA4pfn8ltg
Date: Tue, 13 Nov 2012 16:26:46 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346BC0674@ORSMSX101.amr.corp.intel.com>
References: <CABawtvMsrMhGL7emsvYRXrGEB9f2Pzha2+XTVSHaYw1PVJGa-Q@mail.gmail.com>
In-Reply-To: <CABawtvMsrMhGL7emsvYRXrGEB9f2Pzha2+XTVSHaYw1PVJGa-Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ethan,

Does this actually solve a problem that you have seen?

I ask because of the code that converts the FADT to the common internal format:

acpi_tb_convert_fadt (
...
	/*
	 * Expand the 32-bit FACS and DSDT addresses to 64-bit as necessary.
	 * Later code will always use the X 64-bit field.
	 */
	if (!acpi_gbl_FADT.Xfacs) {
		acpi_gbl_FADT.Xfacs = (u64) acpi_gbl_FADT.facs;
	}
	if (!acpi_gbl_FADT.Xdsdt) {
		acpi_gbl_FADT.Xdsdt = (u64) acpi_gbl_FADT.dsdt;
	}

This function is called before the call to validate_fadt, so if the 64-bit address was originally zero, it is set to be equal to the 32-bit address. Later, only the 64-bit address field is used.

So, after convert_fadt, we have the following possible conditions:

1) Both facs and Xfacs are zero
2) facs is zero, but Xfacs in non-zero
3) Both facs and Xfacs are non-zero but equal
4) Both facs and Xfacs are non-zero and not equal

Issues for each condition above:

1) There is no FACS
2) No error, we are going to use Xfacs anyway
3) No error, we will use Xfacs
4) This is the error condition, Xfacs != facs


The check for case (4) is what appears in validate_facs:

If ((facs > 0) && (facs != Xfacs))

I don't think we need to check the value of Xfacs against zero because we know we are in case (3) or (4) after the check for facs nonzero:

if
   (facs > 0) - if true, we are in case (3) or (4)
    if
       (facs != Xfacs) - if true, we now know we are in case (4) --> error.


Unless I'm missing something early this morning.
Bob


> -----Original Message-----
> From: Ethan Zhao [mailto:ethan.kernel@gmail.com]
> Sent: Monday, November 12, 2012 7:32 PM
> To: Brown, Len
> Cc: Moore, Robert; Zheng, Lv; LKML
> Subject: [PATCH ] tbfadt.c: output warning only when 64bit 32bit address
> of FACS/DSDT all have value but not equal to each other
> 
> Hi, Len, Robert,
> 
>        Please help to check the following patch, add more conditions when
> validate the 64bit 32bit FACS/DSDT address in FADT to follow ACPI spec, In
> the meantime, keep the compatibility and latitude.
> 
> 
> Thanks,
> Ethan
> 
> 
> 
> From c1116211a7b329c26b0370565c36b084ceb08f71 Mon Sep 17 00:00:00 2001
> From: ethan.zhao <ethan.kernel@gmail.com>
> Date: Tue, 13 Nov 2012 22:21:12 -0800
> Subject: [PATCH 642/642] To follow the ACPI spec 3,4&5 and keep the
> compatibility and latitude,only  output mismatch warning when 64bit
> address and 32bit address of FACS/DSDT are all  valid but not equal to
> each other.
> 
> 
> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
> ---
>  drivers/acpi/acpica/tbfadt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
> index 3906518..f23f512 100644
> --- a/drivers/acpi/acpica/tbfadt.c
> +++ b/drivers/acpi/acpica/tbfadt.c
> @@ -512,7 +512,7 @@ static void acpi_tb_validate_fadt(void)
>          * the 32-bit and 64-bit address fields
> (FIRMWARE_CTRL/X_FIRMWARE_CTRL and
>          * DSDT/X_DSDT) would indicate the presence of two FACS or two
> DSDT tables.
>          */
> -       if (acpi_gbl_FADT.facs &&
> +       if ((acpi_gbl_FADT.facs && acpi_gbl_FADT.Xfacs) &&
>             (acpi_gbl_FADT.Xfacs != (u64)acpi_gbl_FADT.facs)) {
>                 ACPI_BIOS_WARNING((AE_INFO,
>                                    "32/64X FACS address mismatch in FADT -
> "
> @@ -523,7 +523,7 @@ static void acpi_tb_validate_fadt(void)
>                 acpi_gbl_FADT.Xfacs = (u64)acpi_gbl_FADT.facs;
>         }
> 
> -       if (acpi_gbl_FADT.dsdt &&
> +       if ((acpi_gbl_FADT.dsdt && acpi_gbl_FADT.Xdsdt) &&
>             (acpi_gbl_FADT.Xdsdt != (u64)acpi_gbl_FADT.dsdt)) {
>                 ACPI_BIOS_WARNING((AE_INFO,
>                                    "32/64X DSDT address mismatch in FADT -
> "
> --
> 1.7.1
