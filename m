Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1KVPth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:49:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab1KVPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:49:36 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 4/5] clk: basic gateable and fixed-rate clks
Date: Tue, 22 Nov 2011 15:49:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Mike Turquette <mturquette@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        eric.miao@linaro.org, richard.zhao@linaro.org,
        Mike Turquette <mturquette@linaro.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <201111221311.00117.arnd.bergmann@linaro.org> <1321974200.2412.25.camel@deneb.redhat.com>
In-Reply-To: <1321974200.2412.25.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221549.08451.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:oqRl6JnmlBIx1vT1lEAfbal2Sxrt6sgVbzkn74YWA+B
 YtvdFxAuJkL3IAjBKRidqNoFmWczxKbzft6LAHQOLsvKL9P1A1
 Y2OBDzXGbCoHYbOxCHN//g3Rgb5ROmGUAuADPqmHlW6gyIGLWF
 O8quXQpKdPg+fxwyqAIZsNc5XAwj+vCIqXfTfYUgeSVeJoRZhY
 45hSSIcD03t3MJcJnMW13rTDsiRQUhaqzGy2tcZdcZfII/dHil
 WhfEAepYpF6VlTENO/zhbIcZmn3XJkefTrkmXMOJQTA1wlK5/M
 fndUySpcNsRo1oR5DrL6cY13jstQQAJHrSU5kHkdinDsfvU45F
 P+VxsgqvQ82N19Ob44sLEnftoA7PHQt3bNCxcry94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 November 2011, Mark Salter wrote:
> 
> On Tue, 2011-11-22 at 13:11 +0000, Arnd Bergmann wrote:
> > On Tuesday 22 November 2011, Mike Turquette wrote:
> > > +static void clk_hw_gate_set_bit(struct clk *clk)
> > > +{
> > > +       struct clk_hw_gate *gate = to_clk_hw_gate(clk);
> > > +       u32 reg;
> > > +
> > > +       reg = __raw_readl(gate->reg);
> > > +       reg |= BIT(gate->bit_idx);
> > > +       __raw_writel(reg, gate->reg);
> > > +}
> > 
> > You cannot rely on __raw_readl() to do the right thing, especially
> > in architecture independent code. The safe (but slightly inefficient)
> > solution would be readl/writel. For ARM-only code, it would be best
> > to use readl_relaxed()/writel_relaxed(), but most architectures do
> > not implement that. We can probably add a set of helpers in asm-generic/
> > to define them to the default functions, like "#define readl_relaxed(x)
> > readl(x)", which I think is a good idea anyway.
> > 
> 
> readl/writel won't work for big endian CPU when the registers are on a
> bus that does the endian swabbing in hardware.

That statement doesn't make any sense.

You obviously have to specify the bit index in a way that works with the
driver implementation and with the hardware.

__raw_readl has an unspecified endianess, which is normally the same
as the register endianess of the CPU (assuming a memory-mapped bus),
which means you have to do extra work if the register layout is
independent of the CPU endianess, which is about as common as
MMIO registers defined as being the same endianes as the CPU in
bi-endian implementations.

Considering that hardware makers cannot agree on how to count bits
(IBM calls the MSB bit 0 on big-endian systems), there is no way
to please everyone, though you could debate about what the clearest
semantics are that we should define.

IMHO it would be nicer to use a bit-mask in bus-endian notation, e.g.

      reg = readl(gate->reg);
      reg |= le32_to_cpu(gate->bit_mask);
      writel(reg, gate->reg);

but there are other ways to do this. The only thing that I would
definitely ask for is having the interface clearly documented as
being one of cpu-endian, bus-endian, fixed-endian or having the
endianess specified in the device definition (device tree or platform
data).

Note that I don't object to adding a new cpu-endian mmio accessor,
which has been discussed repeatedly in the past. It's just that
this accessor does not exist, and using __raw_readl as a substitute
causes additional problems.

	Arnd
