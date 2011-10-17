Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab1JQRrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:47:09 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:60851 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab1JQRrI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20111017064217.GA20184@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-5-git-send-email-mturquette@ti.com> <20111012064646.GA31037@b20223-02.ap.freescale.net>
 <CAJOA=zPw7BF1iNFaG9js2k6++qPnXz5S3dq4rsPmUWOcUztL0g@mail.gmail.com>
 <20111016182649.GB13565@pengutronix.de> <20111017064217.GA20184@b20223-02.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 17 Oct 2011 10:46:45 -0700
Message-ID: <CAJOA=zPqBCZekAyPBAberrOdGcfhrgdtLWnBD=iirDZpacNCtw@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
To: Richard Zhao <richard.zhao@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linaro-dev@lists.linaro.org,
        eric.miao@linaro.org, grant.likely@secretlab.ca,
        Jamie Iles <jamie@jamieiles.com>, jeremy.kerr@canonical.com,
        sboyd@quiinc.com, linux@arm.linux.org.uk, magnus.damm@gmail.com,
        dsaxena@linaro.org, shawn.guo@freescale.com, arnd.bergmann@linaro.org,
        patches@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, paul@pwsan.com,
        linus.walleij@stericsson.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        Richard Zhao <richard.zhao@freescale.com>, skannan@quicinc.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 11:42 PM, Richard Zhao <richard.zhao@linaro.org> wrote:
> On Sun, Oct 16, 2011 at 08:26:49PM +0200, Sascha Hauer wrote:
>> On Wed, Oct 12, 2011 at 07:59:19AM -0700, Turquette, Mike wrote:
>> > On Tue, Oct 11, 2011 at 11:46 PM, Richard Zhao
>> > <richard.zhao@freescale.com> wrote:
>> > > On Thu, Sep 22, 2011 at 03:26:59PM -0700, Mike Turquette wrote:
>> > >> From: Jeremy Kerr <jeremy.kerr@canonical.com>
>> > >>
>> > >> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
>> > >> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> > >> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
>> > >> Signed-off-by: Mike Turquette <mturquette@ti.com>
>> > >> ---
>> > >> Changes since v1:
>> > >> Add copyright header
>> > >> Fold in Jamie's patch for set-to-disable clks
>> > >> Use BIT macro instead of shift
>> > >>
>> > >>  drivers/clk/Kconfig    |    4 ++
>> > >>  drivers/clk/Makefile   |    1 +
>> > >>  drivers/clk/clk-gate.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
>> > >>  include/linux/clk.h    |   13 ++++++++
>> > >>  4 files changed, 96 insertions(+), 0 deletions(-)
>> > >>  create mode 100644 drivers/clk/clk-gate.c
>> > >
>> > > I feel hard to tell the tree the clk parent, at register/init time. For the
>> > > simple gate clk, the only way is to set .get_parent. But normally, for clk
>> > > without any divider we set .get_parent to NULL. Maybe we can put .parent to
>> > > struct clk_hw?
>> >
>> > For non-mux clocks, whose parent is *always* going to be the same, you
>> > should create a duplicate .parent in the clk_hw_* structure and then
>> > have .get_parent return clk_hw_*->parent.
>>
>> Maybe I do not understand what you mean here, but I think there is
>> something missing in the gate.
> yes, clk_gate can not set fixed parent in v2 patch. Mike means add .parent int clk_gate
> and set .get_parent in the ops.

Yes, it seems I was unclear.  I mean to say that a .parent can be
added to any clk hw implementation (clk_hw_imx or whatever) and the
paired .ops (in this case, .get_parent) will know about it's
existence.

Regards,
Mike

>>
>> >
>> > This is analogous to the way clk_hw_fixed returns clk_hw_fixed->rate
>> > when .recalc is called on it.
>> >
>> > >> +
>> > >> +static unsigned long clk_gate_get_rate(struct clk_hw *clk)
>> > >> +{
>> > >> +     return clk_get_rate(clk_get_parent(clk->clk));
>> > >> +}
>>
>> clk_get_parent goes down to clk_gate_set_enable_ops.get_parent below...
>>
>> > >> +
>> > >> +
>> > >> +struct clk_hw_ops clk_gate_set_enable_ops = {
>> > >> +     .recalc_rate = clk_gate_get_rate,
>> > >> +     .enable = clk_gate_enable_set,
>> > >> +     .disable = clk_gate_disable_clear,
>> > >> +};
>>
>> ...but this does not have a get_parent pointer, so clk_get_parent()
>> for a gate always returns NULL which means that a gate never has
>> a valid rate.
>>
>> Sascha
>>
>> --
>> Pengutronix e.K.                           |                             |
>> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
>> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>
>
