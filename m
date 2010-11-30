Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0K3PgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:36:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0K3PgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:36:12 -0500
Message-ID: <4CF519E4.2050305@redhat.com>
Date: Tue, 30 Nov 2010 16:36:04 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
CC: "'James.Bottomley@HansenPartnership.com'" 
	<James.Bottomley@HansenPartnership.com>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'akpm@osdl.org'" <akpm@osdl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] scsi: megaraid_sas -  Add the online reset to iMR
 chip
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 06:29 PM, Yang, Bo wrote:
> Driver added the OCR (online controller reset) support to megaraid sas iMR chip.
>
> Signed-off-by Bo Yang<bo.yang@lsi.com>
>
> ---
> drivers/scsi/megaraid/megaraid_sas.c |   74 ++++++++++++++++++++---------------
> drivers/scsi/megaraid/megaraid_sas.h |    5 +-
>  2 files changed, 47 insertions(+), 32 deletions(-)
>   
> @@ -497,6 +503,8 @@ static int megasas_clear_intr_skinny(struct
> megasas_register_set __iomem *regs) { u32 status; + u32 mfiStatus = 0;
> + /* * Check if it is our interrupt */ @@ -507,6 +515,15 @@
> megasas_clear_intr_skinny(struct megasas } /* + * Check if it is our
> interrupt + */ + if ((megasas_read_fw_status_reg_gen2( regs) &
> MFI_STATE_MASK ) == + MFI_STATE_FAULT ) { + mfiStatus |=
> MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE; + } else + mfiStatus |=
> MFI_INTR_FLAG_REPLY_MESSAGE; + + /* * Clear the interrupt by writing
> back the same value */ writel(status, &regs->outbound_intr_status); 
In the hunk above you use the '|=' which is not needed, a simple
assignment is more readable, see below.

Tomas

@@ -493,6 +499,8 @@ static int
 megasas_clear_intr_skinny(struct megasas_register_set __iomem *regs)
 {
 	u32 status;
+	u32 mfiStatus;
+
 	/*
 	 * Check if it is our interrupt
 	 */
@@ -503,6 +511,15 @@ megasas_clear_intr_skinny(struct megasas_register_set __iomem *regs)
 	}
 
 	/*
+	 * Check if it is our interrupt
+	 */
+	if ((megasas_read_fw_status_reg_gen2( regs) & MFI_STATE_MASK) ==
+						MFI_STATE_FAULT)
+		mfiStatus = MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
+	else
+		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
+
+	/*
 	 * Clear the interrupt by writing back the same value
 	 */
 	writel(status, &regs->outbound_intr_status);


