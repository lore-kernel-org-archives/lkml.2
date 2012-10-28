Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2J1ShR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 14:37:17 -0400
Received: from antcom.de ([188.40.178.216]:36982 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2J1ShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 14:37:15 -0400
Message-ID: <508D7B33.80902@antcom.de>
Date: Sun, 28 Oct 2012 19:36:35 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        paul.gortmaker@windriver.com, benh@kernel.crashing.org
Subject: Re: irq_set_chained_handler() called too early for hwirq to be initialized
References: <508D55C9.3030702@antcom.de> <alpine.LFD.2.02.1210281810390.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1210281810390.2756@ionos>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/12 18:34, Thomas Gleixner wrote:
> On Sun, 28 Oct 2012, Roland Stigge wrote:
>> consider arch/arm/mach-lpc32xx/irq.c: irq_set_chained_handler() is
>> called at a point where it accesses
>> irq_to_desc(IRQ_LPC32XX_SUB2IRQ)->irq_data.hwirq but which is not yet
>> initialized.
> 
> None of the functions which are called inside of
> irq_set_chained_handler() touches desc->irq_data.hwirq.
> 
> So what are you talking about?

Via the call trace:

irq_set_chained_handler()
-> __irq_set_handler()
-> irq_startup()
-> irq_enable()
-> desc->irq_data.chip->irq_unmask()

The code path comes back to irq.c's lpc32xx_unmask_irq() which reads the
above described ->hwirq which is only later initialized on
irq_domain_add_legacy(). Hope this explains my above short description.

> Of course are the interrupts preallocated, simply because
> machine_desc->nr_irqs is 0 and therefor the ARM core code allocates
> NR_IRQS irq descriptors in the early setup way before
> lpc32xx_init_irq() is called.

OK, will remove the call to  irq_alloc_descs() since it is superfluous.

Still, my question remains if I can move the irq_set_chained_handler()
calls to after of_irq_init() and irq_domain_add_legacy() since only the
latter initializes hwirq.

> If those interrupts would not be preallocated, then the code would
> fail to initialize any interrupt at all. And of course nothing would
> notice as all function calls to set_irq_* do not check the return
> value.

Do you mean mach-lpc32xx/irq.c's calls to set_irq_* not checking the
return values? Maybe because those are declared "void"?

static inline void
irq_set_chained_handler(unsigned int irq, irq_flow_handler_t handle);
void set_irq_flags(unsigned int irq, unsigned int iflags);
static inline void irq_set_chip_and_handler(unsigned int irq,
                                            struct irq_chip *chip,
                                            irq_flow_handler_t handle);

Or did I misunderstand sth.?

Thanks in advance,

Roland
