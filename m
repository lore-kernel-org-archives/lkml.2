Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1B1PgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:36:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1B1PgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:36:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Guan Xuetao <epip@hera.kernel.org>
Subject: Re: [PATCH 16/17] unicore32: add (void __iomem *) to io_p2v macro
Date: Mon, 28 Feb 2011 16:35:56 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
References: <cover.1298821856.git.epip@hera.kernel.org> <e01e265d8c1ee1acf67177717a3611691cccf1da.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <e01e265d8c1ee1acf67177717a3611691cccf1da.1298821856.git.epip@hera.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281635.56528.arnd@arndb.de>
X-Provags-ID: V02:K0:gVM9DFy4KzsBCoxhqS3EMjS9l0XQnGEjmvXna+B5YP3
 zKcgKmxqDMRSB9MVLlhOMaszE0urksZEBjXTM6qp042bHgcu7k
 1QXHdpLDKltZJgYqQpi8j9NprGps1XeYfqXLCkrNlxqa3HCA/p
 SF0h0yRPi0ijbgSwaMbJDzepmJ+B/yZHr80aux9U2VXL1mZ1tg
 BWc/PfS8FO0SlKxKS/Cjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Guan Xuetao wrote:
> -#define PKUNITY_AC97_CONR              __REG(PKUNITY_AC97_BASE + 0x0000)
> -#define PKUNITY_AC97_OCR               __REG(PKUNITY_AC97_BASE + 0x0004)
> -#define PKUNITY_AC97_ICR               __REG(PKUNITY_AC97_BASE + 0x0008)
> -#define PKUNITY_AC97_CRAC              __REG(PKUNITY_AC97_BASE + 0x000C)
> -#define PKUNITY_AC97_INTR              __REG(PKUNITY_AC97_BASE + 0x0010)
> -#define PKUNITY_AC97_INTRSTAT          __REG(PKUNITY_AC97_BASE + 0x0014)
> -#define PKUNITY_AC97_INTRCLEAR         __REG(PKUNITY_AC97_BASE + 0x0018)
> -#define PKUNITY_AC97_ENABLE            __REG(PKUNITY_AC97_BASE + 0x001C)
> -#define PKUNITY_AC97_OUT_FIFO          __REG(PKUNITY_AC97_BASE + 0x0020)
> -#define PKUNITY_AC97_IN_FIFO           __REG(PKUNITY_AC97_BASE + 0x0030)
> +#define PKUNITY_AC97_CONR              io_p2v(PKUNITY_AC97_BASE + 0x0000)
> +#define PKUNITY_AC97_OCR               io_p2v(PKUNITY_AC97_BASE + 0x0004)
> +#define PKUNITY_AC97_ICR               io_p2v(PKUNITY_AC97_BASE + 0x0008)
> +#define PKUNITY_AC97_CRAC              io_p2v(PKUNITY_AC97_BASE + 0x000C)
> +#define PKUNITY_AC97_INTR              io_p2v(PKUNITY_AC97_BASE + 0x0010)

One more comment on the types here (applies to the entire patch):

It would be more straightforward to the define the underlying base
addresses using io_p2v, and then do a simple addition, instead of
another macro that adds a type cast:

#define PKUNITY_SYSTEM_AHB	io_p2v(0xC0000000)
#define PKUNITY_PERIPHERAL_AHB	io_p2v(0xEE000000)

#define PKUNITY_UART0_BASE	(PKUNITY_PERIPHERAL_AHB + 0x00000000)
#define PKUNITY_AC97_BASE	(PKUNITY_PERIPHERAL_AHB + 0x00400000)

#define PKUNITY_AC97_CONR	(PKUNITY_AC97_BASE + 0x0000)
#define PKUNITY_AC97_OCR	(PKUNITY_AC97_BASE + 0x0004)

It would be nice if you could do that for the entire set of hardware
headers.

In the long run, I would recommend moving away from hardcoded I/O addresses
entirely, but you can do that at the same time as moving to a flattened
device tree. When you do that, every driver will do an individual ioremap
to get the virtual address for a physical location, rather than doing it
once at boot time for all hardware. This makes the code more flexible when
dealing with multiple SoC implemetations, but it's not something that
you need to worry about too much for the initial merge.

	Arnd
