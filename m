Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1GNQFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:05:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab1GNQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:05:00 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=XYJHFtupD_QA:10 a=BVjevQYQsxsA:10 a=3jLnhWJ0iCQA:10 a=kj9zAlcOel0A:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:17 a=AFZ6h_GxPryvdltb5tQA:9 a=_hmBbfBJSjtElBwQYAkA:7 a=CjuIK1q_8ugA:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.113.120.88
Date: Thu, 14 Jul 2011 11:04:56 -0500
From: Ayman El-Khashab <ayman@elkhashab.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the
 460sx
Message-ID: <20110714160456.GA6859@crust.elkhashab.com>
References: <y>
 <1310603611-8960-1-git-send-email-ayman@elkhashab.com>
 <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
 <20110714011627.GJ20597@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714011627.GJ20597@ozlabs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (crust.elkhashab.com [127.0.0.1]); Thu, 14 Jul 2011 11:04:58 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Tony, some comments below.

On Thu, Jul 14, 2011 at 11:16:27AM +1000, Tony Breeds wrote:
> 
> > +static void __init ppc460sx_pciex_check_link(struct ppc4xx_pciex_port *port)
> > +{
> > +	void __iomem *mbase;
> > +	int attempt = 50;
> > +
> > +	port->link = 0;
> > +
> > +	mbase = ioremap(port->cfg_space.start + 0x00000000, 0x1000);
> 
> Why + 0x00000000 ? ppc4xx_pciex_port_setup_hose() does:
> mbase = ioremap(port->cfg_space.start + 0x10000000, 0x1000);
> so isn't one of these statements is wrong?

yes, that doesn't look right.   I'll verify that and make
sure that it works correctly and resubmit the patch.

> 
> > +	if (mbase == NULL) {
> > +		printk(KERN_ERR "%s: Can't map internal config space !",
> > +			port->node->full_name);
> > +		goto done;
> > +	}
> > +
> > +	while (attempt && (0 == (in_le32(mbase + PECFG_460SX_DLLSTA)
> > +			& 0x00000010))) {
> 
> Nitpicking, I think it'd be nice if there was #define for 0x00000010
> perhaps: #define PECFG_460SX_DLLSTA_LINKUP 0x00000010

ok.

> >  
> > -	if (ppc4xx_pciex_hwops->check_link)
> > -		ppc4xx_pciex_hwops->check_link(port);
> > -
> >  	/*
> >  	 * Initialize mapping: disable all regions and configure
> >  	 * CFG and REG regions based on resources in the device tree
> >  	 */
> >  	ppc4xx_pciex_port_init_mapping(port);
> >  
> > +	if (ppc4xx_pciex_hwops->check_link)
> > +		ppc4xx_pciex_hwops->check_link(port);
> > +
> 
> Why move this?  You already iorempat the cfg space.

This was what I was asking about before.  The reason that I
swapped the order of the init_mapping and check_link is
because the init_mapping currently sets up the cfgbax
registers.  Those setup the base address of the
configuration space on the PLB side of the bus.  As far as I
could determine, I cannot access the config space until
those registers are configured.  I need to touch the config
space in order to do the check_link b/c the 460sx uses the
extended config space to keep track of the link status.  I
looked at init mapping and based on what it did I did not
see any potential adverse effects.


> >  		out_le32(mbase + PECFG_POM2LAH, pciah);
> > @@ -1591,8 +1632,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
> >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAH, lah);
> >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAL, lal);
> >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKH, 0x7fffffff);
> > -		/* Note that 3 here means enabled | IO space !!! */
> > -		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa | 3);
> > +		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa);
> >  		break;
> >  	}
> 
> I think you really want to check the definitions for OMRs 2 and 3 to verify that this is right.

Thanks, good catch.  I'll change the first case block to
include a switch on the 460sx.  The first case statement
needs to be | 0x5, while the others need to stay 0x3.

Ayman
