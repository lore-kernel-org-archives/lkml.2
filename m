Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab2LEOmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:42:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2LEOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:42:15 -0500
Date: Wed, 5 Dec 2012 12:41:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/3] aerdrv: Cleanup log output for CPER based AER
Message-ID: <20121205124135.45018984@redhat.com>
In-Reply-To: <20121204210318.4515.10180.stgit@grignak.americas.hpqcorp.net>
References: <20121204210305.4515.91100.stgit@grignak.americas.hpqcorp.net>
	<20121204210318.4515.10180.stgit@grignak.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 04 Dec 2012 14:03:18 -0700
Lance Ortiz <lance.ortiz@hp.com> escreveu:

Hmm... I did a reply to v6 of this patch, but i pressed the wrong button
and it went only to Joe. Excuse-me for that. Let me resend the
comments to everybody:

On Tue, 2012-12-04 at 16:33 -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 04 Dec 2012 09:39:23 -0800
> Joe Perches <joe@perches.com> escreveu:
>   
> > On Tue, 2012-12-04 at 10:04 -0700, Lance Ortiz wrote:  
> > > These changes make cper_print_aer more consistent with aer_print_error
> > > which is called in the AER interrupt case. The string in the variable
> > > 'prefix' is printed at the beginning of each print statement in
> > > cper_print_aer(). The prefix is a string containing the driver name
> > > and the device's slot location.  From the callers the value of prefix
> > > is never assigned and is NULL, so when cper_print_aer prints data the
> > > initial string does not get printed.  This string is important because
> > > it identifies the device that the error is on.  
> > 
> > Hi again Lance.
> >   
> > > diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c  
> > []  
> > > @@ -228,9 +228,14 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
> > >  	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
> > >  	u32 status, mask;
> > >  	const char **status_strs;
> > > -	char *prefix = NULL;
> > > +	char prefix[44];
> > >  
> > >  	aer_severity = cper_severity_to_aer(cper_severity);
> > > +	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
> > > +		(aer_severity == AER_CORRECTABLE) ?
> > > +		KERN_WARNING : KERN_ERR,
> > > +		dev_driver_string(&dev->dev), dev_name(&dev->dev));
> > > +
> > >  	if (aer_severity == AER_CORRECTABLE) {
> > >  		status = aer->cor_status;
> > >  		mask = aer->cor_mask;  
> > 
> > Perhaps this would be better just using dev_printk
> > instead of snprintf into a prefix with printk to
> > emulate dev_printk.
> > 
> > Also, perhaps KERN_NOTICE is preferable to KERN_WARNING
> > in the CORRECTABLE case.  
> 
> Hmm... IMHO, it should be KERN_ERR, even for a correctable one ;) 
> 
> This is an error and probably means some hardware problem or a bad 
> contact. In any case, a preventive action is likely required.
>   
> > 
> > Maybe something like:
> > 
> > 	const char *level = KERN_ERR;
> > 	if (aer_severity == AER_CORRECTABLE)
> > 		level = KERN_NOTICE;
> > 
> > 	...
> > 
> > 	dev_printk(level, &dev->dev, etc...);
> > 
> > Maybe do this after this series of patches is accepted.
> > Enough with the revisions for awhile...
> >   
> 
>   

Regards,
Mauro
