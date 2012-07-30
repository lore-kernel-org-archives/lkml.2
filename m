Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2G3QE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:04:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35893 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3QE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:04:26 -0400
Date: Mon, 30 Jul 2012 09:04:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aggrwal Poonam-B10812 <B10812@freescale.com>
Cc: Singh Sandeep-B37400 <B37400@freescale.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [2/3][PATCH][v2] TDM Framework
Message-ID: <20120730160422.GC28703@kroah.com>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727175939.GA23105@kroah.com>
 <ACB6D0C0104CFF42A45A5D82A0DD4F3D079C0B75@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ACB6D0C0104CFF42A45A5D82A0DD4F3D079C0B75@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 09:10:48AM +0000, Aggrwal Poonam-B10812 wrote:
> 
> 
> > -----Original Message-----
> > From: Linuxppc-dev [mailto:linuxppc-dev-
> > bounces+poonam.aggrwal=freescale.com@lists.ozlabs.org] On Behalf Of Greg
> > KH
> > Sent: Friday, July 27, 2012 11:30 PM
> > To: Singh Sandeep-B37400
> > Cc: devel@driverdev.osuosl.org; linuxppc-dev@lists.ozlabs.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: Re: [2/3][PATCH][v2] TDM Framework
> > 
> > On Fri, Jul 27, 2012 at 07:35:38PM +0530, sandeep@freescale.com wrote:
> > > +/* Data structures required for sysfs */ static struct tdm_sysfs attr
> > > += {
> > > +	.attr.name = "use_latest_data",
> > > +	.attr.mode = 0664,
> > > +	.cmd_type = TDM_LATEST_DATA,
> > > +};
> > 
> > What is this for?
> This knob is to control the behavior of the TDM framework with respect
> to handling the received TDM frames.

How will userspace know how to use this?  Who will use this?

> The framework layer receives the TDM frames from the TDM adapter
> driver, de-interleaves the data and sends to respective client
> modules.

Why would userspace care about this then?

> In the case when the TDM client module has not consumed the data and
> emptied the Buffer, this flag decides whether to discard the
> un-fetched data, or discard the latest received data.

Again, why let userspace make this decision?  How will it know to do
this or not?

Don't add options for things that don't need options.

> > > +int tdm_sysfs_init(void)
> > > +{
> > > +	struct kobject *tdm_kobj;
> > > +	int err = 1;
> > > +	tdm_kobj = kzalloc(sizeof(*tdm_kobj), GFP_KERNEL);
> > > +	if (tdm_kobj) {
> > > +		kobject_init(tdm_kobj, &tdm_type);
> > > +		if (kobject_add(tdm_kobj, NULL, "%s", "tdm")) {
> > > +			pr_err("tdm: Sysfs creation failed\n");
> > > +			kobject_put(tdm_kobj);
> > > +			err = -EINVAL;
> > > +			goto out;
> > > +		}
> > > +	} else {
> > > +		pr_err("tdm: Unable to allocate tdm_kobj\n");
> > > +		err = -ENOMEM;
> > > +		goto out;
> > > +	}
> > > +
> > > +out:
> > > +	return err;
> > > +}
> > 
> > You just leaked memory, what are you trying to do here?
> > 
> > And why are you using "raw" kobjects?  That's a sure sign that something
> > is really wrong.
> Will refer the documentation. Not very experienced on this stuff. Thanks for the comment.
> > 
> > Your code doesn't look like it is tied into the driver model at all, why
> > not?  What are you trying to do here?
> This is a framework layer, not associated to a particular device.

Not true, you have a parent pointer already, so you are hooked up to the
device tree.

> TDM adapter drivers will register to this framework.

Then you had better be part of the kernel driver model.

> We got this comment in internal freescale review list also.

Why did you ignore that feedback and make us ask the same thing?

> > Also, when creating new sysfs entries, like you are attempting to do here
> > (unsuccessfully I might add), you must create Documentation/ABI/ files as
> > well.
> Ok.
> > 
> > And, to top it all off, you do realize you are asking us to do code
> > review in the middle of the merge window, when we are all busy doing
> > other things?
> Apologize for asking a review in the merge window time frame.
> Are there any guidelines when to send something for a review? We will
> be careful next time.

Anytime not in the merge window is usually good, also the week before
the merge window is usually busy as well.

greg k-h
