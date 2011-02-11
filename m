Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab1BKSnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:43:17 -0500
Received: from kroah.org ([198.145.64.141]:35618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949Ab1BKSms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:42:48 -0500
Date: Fri, 11 Feb 2011 10:42:23 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110211184223.GB10891@kroah.com>
References: <20110209224006.GA11202@kroah.com>
 <20110211154508.GA5435@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211154508.GA5435@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 03:45:08PM +0000, Matthew Garrett wrote:
> On Wed, Feb 09, 2011 at 02:40:06PM -0800, Greg KH wrote:
> 
> > +/* Structure to get data back to the calling function */
> > +struct sabi_retval {
> > +	u8 retval[20];
> > +};
> 
> 20 bytes, but only 4 of them end up being used?

Yes, for the commands we care about, we only pay attention to the first
4 bytes, but it really is 20 bytes long from what I can tell.

> > +	if (readb(sabi_iface + SABI_IFACE_COMPLETE) == 0xaa &&
> > +	    readb(sabi_iface + SABI_IFACE_DATA) != 0xff) {
> > +		/*
> > +		 * It did!
> > +		 * Save off the data into a structure so the caller use it.
> > +		 * Right now we only care about the first 4 bytes,
> > +		 * I suppose there are commands that need more, but I don't
> > +		 * know about them.
> > +		 */
> > +		sretval->retval[0] = readb(sabi_iface + SABI_IFACE_DATA);
> > +		sretval->retval[1] = readb(sabi_iface + SABI_IFACE_DATA + 1);
> > +		sretval->retval[2] = readb(sabi_iface + SABI_IFACE_DATA + 2);
> > +		sretval->retval[3] = readb(sabi_iface + SABI_IFACE_DATA + 3);
> > +		goto exit;
> > +	}
> 
> goto on success, continue failure? That's a pretty atypical pattern, and 
> the goto's not even really needed in this case.

Ah, good point.  The code was originally a port from some example code
provided by Samsung, this must have remained from that example, I'll go
fix it up.

Hm, in looking at the code, I think I did this just to make it "only
lock and unlock at one place in the function".  I'll rework it to be a
bit more "sane".


> > +	/* Something bad happened, so report it and error out */
> > +	printk(KERN_WARNING "SABI command 0x%02x failed with completion flag 0x%02x and output 0x%02x\n",
> > +		command, readb(sabi_iface + SABI_IFACE_COMPLETE),
> > +		readb(sabi_iface + SABI_IFACE_DATA));
> 
> Is it guaranteed that further reads will still return the failure state?

Nothing is guaranteed from this interface from what I can tell. :)

I really don't know, in my tests, I only had one failure, and that ended
up being my fault for sending the wrong command.

> > +	/* see if the command actually succeeded */
> > +	if (readb(sabi_iface + SABI_IFACE_COMPLETE) == 0xaa &&
> > +	    readb(sabi_iface + SABI_IFACE_DATA) != 0xff) {
> > +		/* it did! */
> > +		goto exit;
> > +	}
> 
> Ditto for this block.

Will do.

> > +static struct dmi_system_id __initdata samsung_dmi_table[] = {
> 
> This is kind of ugly. Are there any Samsung laptops where reading the 
> bios area is going to cause problems?

Yeah, I was thinking I should just accept all Samsung laptops now that
we can properly detect the type of SABI interface that the machine has.
That would reduce this table, and make users happy that they don't have
to keep adding new devices to it.  I'll make that change as well.

> > +	/* Get a pointer to the SABI Interface */
> > +	ifaceP = (readw(sabi + sabi_config->header_offsets.data_segment) & 0x0ffff) << 4;
> > +	ifaceP += readw(sabi + sabi_config->header_offsets.data_offset) & 0x0ffff;
> > +	sabi_iface = ioremap(ifaceP, 16);
> > +	if (!sabi_iface) {
> > +		printk(KERN_ERR "Can't remap %x\n", ifaceP);
> 
> dev_err()? It'd be nice to have a prefix on the failure cases.

It would, but at this point, we don't have a valid 'struct device' to
hang it off of.  I could create the platform device earlier in the
function, which would allow us to show errors a bit "prettier" if you
think that would be a good idea.

> > +	retval = init_wireless(sdev);
> 
> No way to identify whether or not the hardware has wifi before 
> registering rfkill?

I know of no way to detect this.  The driver assumes that we always have
wifi.  I actually haven't seen a Samsung laptop without it, have you?

thanks,

greg k-h
