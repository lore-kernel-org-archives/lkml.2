Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0CTJlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 05:41:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:53867 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0CTJlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 05:41:36 -0400
Subject: Re: [PATCH] MTD: Fix Orion NAND driver compilation with ARM OABI
From: David Woodhouse <dwmw2@infradead.org>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: nico@fluxnic.net, akpm@linux-foundation.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100320085507.4038.96426.stgit@pauliusz>
References: <20100320085507.4038.96426.stgit@pauliusz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 09:41:23 +0000
Message-ID: <1269078083.4028.5586.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 10:55 +0200, Paulius Zaleckas wrote:
> We must tell GCC to use even register for variable passed
> to ldrd instruction. Without this patch GCC 4.2.1 puts this
> variable to r2/r3 on EABI and r3/r4 on OABI, so force it to
> r2/r3. This does not change anything when EABI and OABI
> compilation works OK.
> 
> Without this patch and with OABI I get:
> /tmp/ccMkwOCs.s:63: Error: first destination register must be even -- `ldrd r3,[ip]'
> make[5]: *** [drivers/mtd/nand/orion_nand.o] Error 1

 ...
> -		uint64_t x;
> +		/*
> +		 * force x variable to r2/r3 registers since ldrd instruction
> +		 * requires first register to be even.
> +		 */
> +		register uint64_t x asm ("r2");
> +
>  		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));

Hm, isn't there an asm constraint which will force it into an
appropriate register pair? Failing that, "=&2,4,6,8" ought to work.
(Um, and why the earlyclobber? Why can't io_base be passed in in one of
the same registers?)

We should try to avoid making our constraints more restrictive than they
need to be.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

