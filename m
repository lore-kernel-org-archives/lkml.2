Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab2CFBrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:47:05 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43026 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab2CFBrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:47:03 -0500
Message-ID: <1330998399.24353.65.camel@ThinkPad-T61>
Subject: Re: [PATCH v2 x86 1/2]  fix page faults by nmiaction in nmi if
 kmemcheck is enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net,
        Vegard Nossum <vegardno@ifi.uio.no>, Don Zickus <dzickus@redhat.com>,
        tony.luck@intel.com, bp@amd64.org, robert.richter@amd.com,
        lenb@kernel.org, minyard@acm.org, linux-edac@vger.kernel.org,
        oprofile-list@lists.sf.net, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org, Thomas.Mingarelli@hp.com
Date: Tue, 06 Mar 2012 09:46:39 +0800
In-Reply-To: <20120305102914.GA12774@spo001.leaseweb.com>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61>
	 <1330340324.11248.60.camel@twins> <1330941917.24353.63.camel@ThinkPad-T61>
	 <20120305102914.GA12774@spo001.leaseweb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12030515-0260-0000-0000-000000A69D51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 11:29 +0100, Wim Van Sebroeck wrote:
> Hi Li,
> 
> > diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
> > index 8464ea1..e575e63 100644
> > --- a/drivers/watchdog/hpwdt.c
> > +++ b/drivers/watchdog/hpwdt.c
> > @@ -689,9 +689,22 @@ static void __devinit dmi_find_icru(const struct dmi_header *dm, void *dummy)
> >  	}
> >  }
> >  
> > +static struct nmiaction hpwdt_nmiaction[] = {
> > +	{
> > +		.handler	= hpwdt_pretimeout,
> > +		.name		= "hpwdt",
> > +	},
> > +	{
> > +		.handler	= hpwdt_pretimeout,
> > +		.flags		= NMI_FLAG_FIRST,
> > +		.name		= "hpwdt",
> > +	},
> > +};
> > +
> >  static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
> >  {
> >  	int retval;
> > +	struct nmiaction *na = hpwdt_nmiaction;
> >  
> >  	/*
> >  	 * On typical CRU-based systems we need to map that service in
> > @@ -733,9 +746,11 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
> >  	 * die notify list to handle a critical NMI. The default is to
> >  	 * be last so other users of the NMI signal can function.
> >  	 */
> > -	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
> > -					(priority) ? NMI_FLAG_FIRST : 0,
> > -					"hpwdt");
> > +
> > +	if (priority)
> > +		na = &hpwdt_nmiaction[1];
> > +
> > +	retval = register_nmi_handler(NMI_UNKNOWN, na);
> >  	if (retval != 0) {
> >  		dev_warn(&dev->dev,
> >  			"Unable to register a die notifier (err=%d).\n",
> 
> Why not do something like;
> 
> static struct nmiaction hpwdt_nmiaction = {
> 	.handler	= hpwdt_pretimeout,
> 	.name		= "hpwdt",
> };
> 
> ...
> 	if (priority)
> 		hpwdt_nmiaction.flags = NMI_FLAG_FIRST;
> ...
> 

Thank you, Wim. I'll update it. 

Thanks,
Zhong

> Kind regards,
> Wim.
> 


