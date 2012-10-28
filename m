Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2J1P5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 11:57:39 -0400
Received: from antcom.de ([188.40.178.216]:52988 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab2J1P5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 11:57:38 -0400
Message-ID: <508D55C9.3030702@antcom.de>
Date: Sun, 28 Oct 2012 16:56:57 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, paul.gortmaker@windriver.com,
        benh@kernel.crashing.org
Subject: irq_set_chained_handler() called too early for hwirq to be initialized
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

consider arch/arm/mach-lpc32xx/irq.c: irq_set_chained_handler() is
called at a point where it accesses
irq_to_desc(IRQ_LPC32XX_SUB2IRQ)->irq_data.hwirq but which is not yet
initialized.

(This bug just surfaced on lpc32xx when the chained interrupt controller
SIC2 wasn't working. SIC1 does, but just by chance: The uninitialized
value 0 is just coincidentally the correct one.)

...->hwirq is actually defined only later on in lpc32xx_init_irq() at
irq_domain_add_legacy(). Ideally, I would just move the
irq_set_chained_handler() calls to after of_irq_init() and
irq_domain_add_legacy(). Is this OK or does this produce any race condition?

Thanks in advance,

Roland
