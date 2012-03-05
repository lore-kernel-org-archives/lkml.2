Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2CEK3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:29:22 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:53200 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756578Ab2CEK3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:29:21 -0500
Date: Mon, 5 Mar 2012 11:29:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Li Zhong <zhong@linux.vnet.ibm.com>
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
Subject: Re: [PATCH v2 x86 1/2]  fix page faults by nmiaction in nmi if kmemcheck is enabled
Message-ID: <20120305102914.GA12774@spo001.leaseweb.com>
References: <1329717665.3448.28.camel@ThinkPad-T61> <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61> <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61> <1330340324.11248.60.camel@twins> <1330941917.24353.63.camel@ThinkPad-T61>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330941917.24353.63.camel@ThinkPad-T61>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

> diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
> index 8464ea1..e575e63 100644
> --- a/drivers/watchdog/hpwdt.c
> +++ b/drivers/watchdog/hpwdt.c
> @@ -689,9 +689,22 @@ static void __devinit dmi_find_icru(const struct dmi_header *dm, void *dummy)
>  	}
>  }
>  
> +static struct nmiaction hpwdt_nmiaction[] = {
> +	{
> +		.handler	= hpwdt_pretimeout,
> +		.name		= "hpwdt",
> +	},
> +	{
> +		.handler	= hpwdt_pretimeout,
> +		.flags		= NMI_FLAG_FIRST,
> +		.name		= "hpwdt",
> +	},
> +};
> +
>  static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
>  {
>  	int retval;
> +	struct nmiaction *na = hpwdt_nmiaction;
>  
>  	/*
>  	 * On typical CRU-based systems we need to map that service in
> @@ -733,9 +746,11 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
>  	 * die notify list to handle a critical NMI. The default is to
>  	 * be last so other users of the NMI signal can function.
>  	 */
> -	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
> -					(priority) ? NMI_FLAG_FIRST : 0,
> -					"hpwdt");
> +
> +	if (priority)
> +		na = &hpwdt_nmiaction[1];
> +
> +	retval = register_nmi_handler(NMI_UNKNOWN, na);
>  	if (retval != 0) {
>  		dev_warn(&dev->dev,
>  			"Unable to register a die notifier (err=%d).\n",

Why not do something like;

static struct nmiaction hpwdt_nmiaction = {
	.handler	= hpwdt_pretimeout,
	.name		= "hpwdt",
};

...
	if (priority)
		hpwdt_nmiaction.flags = NMI_FLAG_FIRST;
...

Kind regards,
Wim.

