Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0GIBFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:05:54 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59344 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab0GIBFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:05:53 -0400
Subject: Re: [PATCH 10/13] Do not try to disable hpet if it hasn't been
 initialized before
From: john stultz <johnstul@us.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stefano@stabellini.net, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, Stefano.Stabellini@eu.citrix.com,
       sheng@linux.intel.com, ddutile@redhat.com, jeremy@goop.org
In-Reply-To: <20100630175343.GA16488@phenom.dumpdata.com>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
	 <1277136847-13266-10-git-send-email-stefano@stabellini.net>
	 <20100630175343.GA16488@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 18:05:37 -0700
Message-ID: <1278637537.3008.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 13:53 -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 21, 2010 at 05:14:04PM +0100, stefano@stabellini.net wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > hpet_disable is called unconditionally on machine reboot if hpet support
> > is compiled in the kernel.
> > hpet_disable only checks if the machine is hpet capable but doesn't make
> > sure that hpet has been initialized.
> 
> CC-ing John Stultz who has had his head wrapped around this time-thingy.
> 
> Hi John!
> 
> What are your thoughts about this patch?

Sorry for the slow reply.

The patch looks good to me. It makes the code easier to read as well!

However, I've not had my head in the hpet details for awhile, so
Venkatesh's ack (already provided) is the better endorsement.

thanks
-john


> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/kernel/hpet.c |   18 ++++++++++--------
> >  1 files changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> > index 23b4ecd..2b299da 100644
> > --- a/arch/x86/kernel/hpet.c
> > +++ b/arch/x86/kernel/hpet.c
> > @@ -959,16 +959,18 @@ fs_initcall(hpet_late_init);
> >  
> >  void hpet_disable(void)
> >  {
> > -	if (is_hpet_capable()) {
> > -		unsigned int cfg = hpet_readl(HPET_CFG);
> > +	unsigned int cfg;
> >  
> > -		if (hpet_legacy_int_enabled) {
> > -			cfg &= ~HPET_CFG_LEGACY;
> > -			hpet_legacy_int_enabled = 0;
> > -		}
> > -		cfg &= ~HPET_CFG_ENABLE;
> > -		hpet_writel(cfg, HPET_CFG);
> > +	if (!is_hpet_capable() || !hpet_address || !hpet_virt_address)
> > +		return;
> > +
> > +	cfg = hpet_readl(HPET_CFG);
> > +	if (hpet_legacy_int_enabled) {
> > +		cfg &= ~HPET_CFG_LEGACY;
> > +		hpet_legacy_int_enabled = 0;
> >  	}
> > +	cfg &= ~HPET_CFG_ENABLE;
> > +	hpet_writel(cfg, HPET_CFG);
> >  }
> >  
> >  #ifdef CONFIG_HPET_EMULATE_RTC
> > -- 
> > 1.7.0.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


