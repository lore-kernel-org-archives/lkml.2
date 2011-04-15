Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1DOJyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:54:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36313 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1DOJyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R9vzBtiaI2NJO8Rk/xFABgCkV7d/O5FyCdCi056oOxrrm+1Khra3l8sXKKsSfa8o3Y
         nd0LDm+cVwN4xeiT0tnZMGE7VFyKrY/IpT/51Q2/O7sFqxNppsst7BNtWeFAwYXm79q+
         oTw5cNw/sDSJ4j9SjkKEpKaOOF+DdqcgSCqLA=
Subject: Re: [PATCH 2/2] mtd: msm_nand: Add initial msm nand driver support.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Murali Nalajala <mnalajal@codeaurora.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
	 <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 12:51:37 +0300
Message-ID: <1302861097.3220.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 06:17 +0530, Murali Nalajala wrote:
> +#define pr_fmt(fmt) "%s:" fmt, __func__
> +
> +#include <linux/kernel.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/mtd/nand.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/dma-mapping.h>
> +#include <asm/mach/flash.h>
> +#include <mach/dma.h>
> +
> +#include "msm_nand.h"
> +
> +unsigned long msm_nand_phys;

No global variables like this please. Here is how you use them:

+extern unsigned long msm_nand_phys;
+#define MSM_NAND_REG(off) (msm_nand_phys + (off))
+
+#define MSM_NAND_FLASH_CMD            MSM_NAND_REG(0x0000)
+#define MSM_NAND_ADDR0                MSM_NAND_REG(0x0004)

Could you please make the macros to take the "struct msm_nand_chip
*chip" argument instead, and store the pase address there. Do not hide
the fact that those macros are actually functions, not constant - this
is error prone.

Besides, I'm do not know your HW, but if you have several controllers
with various base addresses - your driver won't work.

> +	pr_info("Save cfg0 = %x cfg1 = %x\n", chip->cfg0, chip->cfg1);
> +	pr_info("cfg0: cw/page=%d ud_sz=%d ecc_sz=%d spare_sz=%d "
> +		"num_addr_cycles=%d\n", (chip->cfg0 >> 6) & 7,
> +		(chip->cfg0 >> 9) & 0x3ff, (chip->cfg0 >> 19) & 15,
> +		(chip->cfg0 >> 23) & 15, (chip->cfg0 >> 27) & 7);

Please, revise all your pr_info() calls and turn most of them into
dev_dbg() or pr_debug. Your driver should be completely silent by
default, except of error messages and some information messages when it
is initialized.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

