Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1IVOml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:42:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36580 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1IVOmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:42:39 -0400
Subject: Re: [PATCH V4] mtd: Add DiskOnChip G3 support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Sep 2011 17:45:21 +0300
In-Reply-To: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr>
References: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1316702729.4849.114.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please re-base your driver on top of my l2 tree and fix
warnings 0 I get the following:

  CC [M]  drivers/mtd/devices/docg3.o
drivers/mtd/devices/docg3.c: In function ‘doc_read’:
drivers/mtd/devices/docg3.c:556:2: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 5 has type ‘size_t’ [-Wformat]
drivers/mtd/devices/docg3.c: In function ‘doc_read_oob’:
drivers/mtd/devices/docg3.c:652:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 6 has type ‘size_t’ [-Wformat]
drivers/mtd/devices/docg3.c:657:7: error: ‘MTD_OOB_PLACE’ undeclared (first use in this function)
drivers/mtd/devices/docg3.c:657:7: note: each undeclared identifier is reported only once for each function it appears in
drivers/mtd/devices/docg3.c: In function ‘flashcontrol_open’:
drivers/mtd/devices/docg3.c:793:1: warning: passing argument 2 of ‘single_open’ from incompatible pointer type [enabled by default]
include/linux/seq_file.h:120:5: note: expected ‘int (*)(struct seq_file *, void *)’ but argument is of type ‘ssize_t (*)(struct seq_file *, void *)’
drivers/mtd/devices/docg3.c: In function ‘asic_mode_open’:
drivers/mtd/devices/docg3.c:827:1: warning: passing argument 2 of ‘single_open’ from incompatible pointer type [enabled by default]
include/linux/seq_file.h:120:5: note: expected ‘int (*)(struct seq_file *, void *)’ but argument is of type ‘ssize_t (*)(struct seq_file *, void *)’
drivers/mtd/devices/docg3.c: In function ‘device_id_open’:
drivers/mtd/devices/docg3.c:838:1: warning: passing argument 2 of ‘single_open’ from incompatible pointer type [enabled by default]
include/linux/seq_file.h:120:5: note: expected ‘int (*)(struct seq_file *, void *)’ but argument is of type ‘ssize_t (*)(struct seq_file *, void *)’
drivers/mtd/devices/docg3.c: In function ‘protection_open’:
drivers/mtd/devices/docg3.c:892:1: warning: passing argument 2 of ‘single_open’ from incompatible pointer type [enabled by default]
include/linux/seq_file.h:120:5: note: expected ‘int (*)(struct seq_file *, void *)’ but argument is of type ‘ssize_t (*)(struct seq_file *, void *)’
drivers/mtd/devices/docg3.c: In function ‘docg3_probe’:
drivers/mtd/devices/docg3.c:1015:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 3 has type ‘resource_size_t’ [-Wformat]
drivers/mtd/devices/docg3.c:1021:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 3 has type ‘resource_size_t’ [-Wformat]
drivers/mtd/devices/docg3.c:1039:3: error: implicit declaration of function ‘parse_mtd_partitions’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

BTW, the next step I'd do is to try to compile it with sparse, so you
could test this driver with sparse: Documentation/sparse.txt

Thanks!

On Wed, 2011-09-21 at 21:27 +0200, Robert Jarzmik wrote:
> +#define doc_readb(reg)	\
> +	__raw_readb(docg3->base + (reg));
> +#define doc_writeb(value, reg)						\
> +do {									\
> +	doc_vdbg("Write %02x to register %04x\n", (value), (reg));	\
> +	__raw_writeb((value), docg3->base + (reg));			\
> +} while (0)
> +#define doc_readw(reg)	\
> +	__raw_readw(docg3->base + (reg));
> +#define doc_writew(value, reg)						\
> +do {									\
> +	doc_vdbg("Write %04x to register %04x\n", (value), (reg));	\
> +	__raw_writew((value), docg3->base + (reg));			\
> +} while (0)
> +
> +#define doc_flashCommand(cmd)						\
> +do {									\
> +	doc_dbg("doc_flashCommand:  %02x " #cmd "\n", DoC_Cmd_##cmd);	\
> +	doc_writeb(DoC_Cmd_##cmd, DoC_FlashCommand);			\
> +} while (0)
> +
> +#define doc_flashSequence(seq)						\
> +do {									\
> +	doc_dbg("doc_flashSequence: %02x " #seq "\n", DoC_Seq_##seq);	\
> +	doc_writeb(DoC_Seq_##seq, DoC_FlashSequence);			\
> +} while (0)
> +
> +#define doc_flashAddress(addr)						\
> +do {									\
> +	doc_dbg("doc_flashAddress:  %02x\n", (addr));			\
> +	doc_writeb((addr), DoC_FlashAddress);				\
> +} while (0)

Could you please turn these macros into 'static inline' function - this
is one of the modern patterns of kernel programming - we try to use
functions for better type checking.

-- 
Best Regards,
Artem Bityutskiy

