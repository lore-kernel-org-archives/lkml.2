Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0IFFIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:08:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46106 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0IFFIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U3gamPywlydPOsgjKaDYgrPqtgGTrPATRd0q0+wB3Yi7vBOje2YnRZHnWkSBm0PeQa
         0HnGmT0gScig0JrfjVJ3mbihC1sKk8orsc6B56rvy3mOxBmOzCJipL4eWAjJ7ozoVMIc
         ++90eaf2CuUKfMJUKxbe4MqLnIxNu5O5NuDEU=
Date: Sun, 5 Sep 2010 22:08:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>,
        Greg KH <gregkh@suse.de>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
 module
Message-ID: <20100906050816.GD17212@core.coreip.homeip.net>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
 <20100905203006.GD18411@core.coreip.homeip.net>
 <1283723479.556.135.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283723479.556.135.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 02:51:19PM -0700, Nicholas A. Bellinger wrote:
> On Sun, 2010-09-05 at 13:30 -0700, Dmitry Torokhov wrote:
> > On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Bellinger wrote:
> > > +
> > > +static void tcm_loop_primary_release(struct device *dev)
> > > +{
> > > +	return;
> > > +}
> > > +
> > > +static struct device tcm_loop_primary = {
> > > +	.init_name		= "tcm_loop_0",
> > > +	.release		= tcm_loop_primary_release,
> > > +};
> > > +
> > 
> > No, you can not have statically allocated devices and dummy release
> > functions.
> > 
> 
> Last time I checked this is still what mainline
> drivers/scsi/scsi_debug.c is doing for struct device pseudo_primary:
> 
> static void pseudo_0_release(struct device *dev)
> {
>         if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
>                 printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
> }
> 
> static struct device pseudo_primary = {
>         .init_name      = "pseudo_0",
>         .release        = pseudo_0_release,
> };
> 
> so for these type of things in TCM_Loop I tend to follow what scsi_debug does,
>  so I don't exactly see a issue here atm.  Anybody else have comments..?

The kobject embedded in the device structure is refcounted and it's
lifetime may be different from lifetime of your module. If somebody
happen to hold reference to the driver while your module is being
unloaded bad things will happen.

I am sure Greg has something on this topic ready for cut-and-paste.

-- 
Dmitry
