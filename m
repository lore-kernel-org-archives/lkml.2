Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab0IFGFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:05:06 -0400
Received: from smtp104.sbc.mail.ne1.yahoo.com ([98.138.84.215]:32423 "HELO
	smtp104.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752493Ab0IFGFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:05:03 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: DTWYzvQVM1lQoV2CrZmXm3mrZdHD202yGVdyEOVx_.5uaxZ
 iizXf7eA1jj5MhFOMVWqijR4j89vvPpqSBJRIYUWRUCNdcM.yE0igoH_utxX
 O2wkJ6Tt.s9n3iIjYI83Jct0WmL6EYPBQ6oLHG4kjvJ6pBkTKpb1oP_JdW5A
 FYz5WBcQrArwBtZaKTJw2k7kYf6.QlzFftDPk9WE6XatIyccqW7at4QbN.KM
 _H8RNAUsdT.TptRYlHoWzVu_oyuejaG55kUUVF7rwa2W5fBrzsVI0SKsr
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <20100906053845.GG17212@core.coreip.homeip.net>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
	 <20100905203006.GD18411@core.coreip.homeip.net>
	 <1283723479.556.135.camel@haakon2.linux-iscsi.org>
	 <20100906050816.GD17212@core.coreip.homeip.net>
	 <20100906051703.GA2891@suse.de>
	 <1283750480.556.196.camel@haakon2.linux-iscsi.org>
	 <20100906053845.GG17212@core.coreip.homeip.net>
Content-Type: text/plain
Date: Sun, 05 Sep 2010 23:01:01 -0700
Message-Id: <1283752861.556.200.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 22:38 -0700, Dmitry Torokhov wrote:
> On Sun, Sep 05, 2010 at 10:21:20PM -0700, Nicholas A. Bellinger wrote:
> > On Sun, 2010-09-05 at 22:17 -0700, Greg KH wrote:
> > > On Sun, Sep 05, 2010 at 10:08:16PM -0700, Dmitry Torokhov wrote:
> > > > On Sun, Sep 05, 2010 at 02:51:19PM -0700, Nicholas A. Bellinger wrote:
> > > > > On Sun, 2010-09-05 at 13:30 -0700, Dmitry Torokhov wrote:
> > > > > > On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Bellinger wrote:
> > > > > > > +
> > > > > > > +static void tcm_loop_primary_release(struct device *dev)
> > > > > > > +{
> > > > > > > +	return;
> > > > > > > +}
> > > > > > > +
> > > > > > > +static struct device tcm_loop_primary = {
> > > > > > > +	.init_name		= "tcm_loop_0",
> > > > > > > +	.release		= tcm_loop_primary_release,
> > > > > > > +};
> > > > > > > +
> > > > > > 
> > > > > > No, you can not have statically allocated devices and dummy release
> > > > > > functions.
> > > > > > 
> > > > > 
> > > > > Last time I checked this is still what mainline
> > > > > drivers/scsi/scsi_debug.c is doing for struct device pseudo_primary:
> > > > > 
> > > > > static void pseudo_0_release(struct device *dev)
> > > > > {
> > > > >         if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
> > > > >                 printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
> > > > > }
> > > > > 
> > > > > static struct device pseudo_primary = {
> > > > >         .init_name      = "pseudo_0",
> > > > >         .release        = pseudo_0_release,
> > > > > };
> > > > > 
> > > > > so for these type of things in TCM_Loop I tend to follow what scsi_debug does,
> > > > >  so I don't exactly see a issue here atm.  Anybody else have comments..?
> > > > 
> > > > The kobject embedded in the device structure is refcounted and it's
> > > > lifetime may be different from lifetime of your module. If somebody
> > > > happen to hold reference to the driver while your module is being
> > > > unloaded bad things will happen.
> > > > 
> > > > I am sure Greg has something on this topic ready for cut-and-paste.
> > > 
> > > Documentation/kobject.txt :)
> > 
> > I still don't get it..?  Does this mean that scsi_debug and TCM_Loop are
> > currently broken wrt to this item or not..?
> > 
> 
> Yes they are broken.

Hi Dmitry and Greg,

Would you mind giving a bit more specific idea as to what a patch to fix
this issue would involve for an emulated struct device usage..?  I would
be happy to generate patches for scsi_debug and TCM_loop to resolve this
issue, but I need a bit more information what I should be looking at.

Thanks,

--nab


