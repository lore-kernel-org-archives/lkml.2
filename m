Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1GNWhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:37:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:48667 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371Ab1GNWhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:37:19 -0400
Subject: Re: [PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the
 460sx
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ayman El-Khashab <ayman@elkhashab.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110714160456.GA6859@crust.elkhashab.com>
References: <y> <1310603611-8960-1-git-send-email-ayman@elkhashab.com>
	 <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
	 <20110714011627.GJ20597@ozlabs.org>
	 <20110714160456.GA6859@crust.elkhashab.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 08:36:59 +1000
Message-ID: <1310683019.4968.289.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 11:04 -0500, Ayman El-Khashab wrote:
> Thanks Tony, some comments below.
> 
> On Thu, Jul 14, 2011 at 11:16:27AM +1000, Tony Breeds wrote:
> > 
> > > +static void __init ppc460sx_pciex_check_link(struct ppc4xx_pciex_port *port)
> > > +{
> > > +	void __iomem *mbase;
> > > +	int attempt = 50;
> > > +
> > > +	port->link = 0;
> > > +
> > > +	mbase = ioremap(port->cfg_space.start + 0x00000000, 0x1000);
> > 
> > Why + 0x00000000 ? ppc4xx_pciex_port_setup_hose() does:
> > mbase = ioremap(port->cfg_space.start + 0x10000000, 0x1000);
> > so isn't one of these statements is wrong?
> 
> yes, that doesn't look right.   I'll verify that and make
> sure that it works correctly and resubmit the patch.

The state of that top bit is obscure. I couldn't figure out from docs
whether it's actually useful or not (it doesn't seem to make a
difference on the HW we've played with here).

It's possible that some parts need it to access the RC config space vs
emitting type 1 cycles, and some don't, in which case the address
decoding just wraps and the bit is ignored ?

> > > +	if (mbase == NULL) {
> > > +		printk(KERN_ERR "%s: Can't map internal config space !",
> > > +			port->node->full_name);
> > > +		goto done;
> > > +	}
> > > +
> > > +	while (attempt && (0 == (in_le32(mbase + PECFG_460SX_DLLSTA)
> > > +			& 0x00000010))) {
> > 
> > Nitpicking, I think it'd be nice if there was #define for 0x00000010
> > perhaps: #define PECFG_460SX_DLLSTA_LINKUP 0x00000010
> 
> ok.
> 
> > >  
> > > -	if (ppc4xx_pciex_hwops->check_link)
> > > -		ppc4xx_pciex_hwops->check_link(port);
> > > -
> > >  	/*
> > >  	 * Initialize mapping: disable all regions and configure
> > >  	 * CFG and REG regions based on resources in the device tree
> > >  	 */
> > >  	ppc4xx_pciex_port_init_mapping(port);
> > >  
> > > +	if (ppc4xx_pciex_hwops->check_link)
> > > +		ppc4xx_pciex_hwops->check_link(port);
> > > +
> > 
> > Why move this?  You already iorempat the cfg space.
> 
> This was what I was asking about before.  The reason that I
> swapped the order of the init_mapping and check_link is
> because the init_mapping currently sets up the cfgbax
> registers.  Those setup the base address of the
> configuration space on the PLB side of the bus.  As far as I
> could determine, I cannot access the config space until
> those registers are configured.  I need to touch the config
> space in order to do the check_link b/c the 460sx uses the
> extended config space to keep track of the link status.  I
> looked at init mapping and based on what it did I did not
> see any potential adverse effects.

I think it makes sense to setup mappings before checking the link. There
may be a couple of mechanical issues in the code with this, I haven't
looked, but I agree in principle.

> > >  		out_le32(mbase + PECFG_POM2LAH, pciah);
> > > @@ -1591,8 +1632,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
> > >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAH, lah);
> > >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAL, lal);
> > >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKH, 0x7fffffff);
> > > -		/* Note that 3 here means enabled | IO space !!! */
> > > -		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa | 3);
> > > +		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa);
> > >  		break;
> > >  	}
> > 
> > I think you really want to check the definitions for OMRs 2 and 3 to verify that this is right.
> 
> Thanks, good catch.  I'll change the first case block to
> include a switch on the 460sx.  The first case statement
> needs to be | 0x5, while the others need to stay 0x3.

Please make it constants using #define or something... those bits tend
to subtly change between ASICs too I noticed.

Cheers,
Ben.

> Ayman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


