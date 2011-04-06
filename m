Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1DFJiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:38:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36230 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab1DFJiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mMQ3mIQ4PqejckBioQ1ZRRY1HE2CvT5DxFe/9+PlXnakcmWdkgInRB2OAdU+5uzQw0
         KkLCoJJDVqp9yyLJhJdxnw/NCuJ4C2559UyGzWXT6sH4tYsHr5Wgp9r7tmVBzxGN/tCZ
         Hs2QFljRHQuZtBg7OwIUZAf+/I9kTvhqCn0qw=
Date: Wed, 6 Apr 2011 11:38:46 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>, Thomas Renninger <trenn@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hwmon: Add driver for AMD family 15h processor power
 information
Message-ID: <20110406093846.GB2177@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
 <20110405144536.GA5054@alberich.amd.com>
 <20110405201238.GA20551@ericsson.com>
 <4D9C12BF.9090402@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9C12BF.9090402@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 09:14:07AM +0200, Clemens Ladisch wrote:
> Guenter Roeck wrote:
> > On Tue, Apr 05, 2011 at 10:45:36AM -0400, Andreas Herrmann wrote:
> > > +static int __devinit f15h_power_is_internal_node0(struct pci_dev *f4)
> > > +{
> > > +	u32 val;
> > > +	struct pci_dev *f3;
> > > +
> > > +	f3 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3));
> > > +	if (!f3) {
> > > +		dev_err(&f4->dev, "no function 3 available on this slot\n");
> > > +		return 0;
> > 
> > It is a common practice to return a negative value on errors. Why not here ?
> 
> Apparently, this function returns a boolean value.  Using "bool"/"true"/
> "false" would have made this more obvious.

Agreed, using bool as return type would have been the better choice.
I'll adapt it.

> > Also, is this really an error which asks for an error message, or just a CPU
> > or system which does not support the attribute ?
> 
> AFAICT all F15h CPUs are _known_ to have all these PCI functions; the
> error should never occur in practice.

Except under virtualization. But common practice is to not pass any
such devices into a guest. So either all CPU northbridge functions are
there or no function at all. I'll adapt the code to your suggestion.

> What I do in the k10temp driver in this situation is to trust the CPU to
> be there, omitting the pci_get_slot/pci_dev_put and just replacing this:
> 
> > > +	pci_read_config_dword(f3, REG_NORTHBRIDGE_CAP, &val);
> > > +	pci_dev_put(f3);
> 
> with the equivalent of:
> 
>   pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3),
>                             REG_NORTHBRIDGE_CAP, &val);
> 
> 
> BTW: The family 15h CPUs have the same temperature sensor registers
> (D18F3xA4 and D18F3x64) as the earlier families, haven't they?

Yes and I think Andre has just sent a patch to add support for 15h to
k10temp.


Thanks,

Andreas


