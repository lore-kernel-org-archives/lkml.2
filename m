Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865Ab2KBNk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:40:58 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:39099 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762852Ab2KBNky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:40:54 -0400
Date: Fri, 2 Nov 2012 07:38:50 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 5/8] ARM: zynq: add COMMON_CLK support
Message-ID: <20121102133850.GO5190@beefymiracle.amer.corp.natinst.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
 <94af5ee92c2d68f245eb902de74909aadf159be1.1351721190.git.josh.cartwright@ni.com>
 <50939378.2050500@metafoo.de>
MIME-Version: 1.0
In-Reply-To: <50939378.2050500@metafoo.de>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/02/2012 08:38:42 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/02/2012 08:38:43 AM,
	Serialize complete at 11/02/2012 08:38:43 AM
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-02_02:2012-11-02,2012-11-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.

On Fri, Nov 02, 2012 at 10:33:44AM +0100, Lars-Peter Clausen wrote:
> On 10/31/2012 07:58 PM, Josh Cartwright wrote:
> > [...]
> > +#define PERIPH_CLK_CTRL_SRC(x)	(periph_clk_parent_map[((x)&3)>>4])
> > +#define PERIPH_CLK_CTRL_DIV(x)	(((x)&0x3F00)>>8)
> 
> A few more spaces wouldn't hurt ;)

Okay, sure.

> > [...]
> > +static void __init zynq_periph_clk_setup(struct device_node *np)
> > +{
> > +	struct zynq_periph_clk *periph;
> > +	const char *parent_names[3];
> > +	struct clk_init_data init;
> > +	struct clk *clk;
> > +	int err;
> > +	u32 reg;
> > +	int i;
> > +
> > +	err = of_property_read_u32(np, "reg", &reg);
> > +	WARN_ON(err);
>
> Shouldn't the function abort if a error happens somewhere? Continuing here
> will lead to undefined behavior. Same is probably true for the other WARN_ONs.

The way I see it is: the kernel is will be left in a bad state in the
case of any failure, regardless of if we bail out or continue.  AFAICT,
there is no clean way to recover from a failure this early.

Given that, it seems simpler (albeit marginally so) just to continue; so
that's what I chose to do.  I'm not opposed to bailing out, just not
convinced it does anything for us.

> > +
> > +	periph = kzalloc(sizeof(*periph), GFP_KERNEL);
> > +	WARN_ON(!periph);
> > +
> > +	periph->clk_ctrl = slcr_base + reg;
> > +	spin_lock_init(&periph->clkact_lock);
> > +
> > +	init.name = np->name;
> > +	init.ops = &zynq_periph_clk_ops;
> > +	for (i = 0; i < ARRAY_SIZE(parent_names); i++)
> > +		parent_names[i] = of_clk_get_parent_name(np, i);
> > +	init.parent_names = parent_names;
> > +	init.num_parents = ARRAY_SIZE(parent_names);
> > +
> > +	periph->hw.init = &init;
> > +
> > +	clk = clk_register(NULL, &periph->hw);
> > +	WARN_ON(IS_ERR(clk));
> > +
> > +	err = of_clk_add_provider(np, of_clk_src_simple_get, clk);
> > +	WARN_ON(err);
> > +
> > +	for (i = 0; i < 2; i++) {
> 
> Not all of the peripheral clock generators have two output clocks. I think
> it makes sense to use the number entries in clock-output-names here.

Yes, I agree.  I'll also update the bindings documentation.

Thanks again,
  Josh
