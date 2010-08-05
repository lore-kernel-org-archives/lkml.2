Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab0HEVHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:07:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44298 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0HEVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EMe5ZfzWlCD76CEeyaJ9LvE+8ENa7oDHeJESB2W51QmX6K/2p/wsKhfp1qoFjifoeG
         SxpwRPgEsWi4CWw61hrqZuc1Mp3qswRs6cvxuI/N67KmgjJq+LW1rDOKH0paSVcxgPKl
         +75mvopTbKyLcWifTY2DKELHstko2Ym6lb0XA=
Date: Thu, 5 Aug 2010 14:07:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: Kevin McNeely <kev@cypress.com>, David Brown <davidb@codeaurora.org>,
        Fred <fwk@ubuntu.linuxcertified.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Todd Fischer <todd.fischer@ridgerun.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
Message-ID: <20100805210705.GA20063@core.coreip.homeip.net>
References: <kev@cypress.com>
 <1281031924-3032-1-git-send-email-kev@cypress.com>
 <4C5B22F8.1030204@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5B22F8.1030204@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 02:15:44AM +0530, Trilok Soni wrote:
> > +
> > +/* ************************************************************************
> > + * The cyttsp_xy_worker function reads the XY coordinates and sends them to
> > + * the input layer.  It is scheduled from the interrupt (or timer).
> > + * *************************************************************************/
> > +void handle_single_touch(struct cyttsp_xydata *xy, struct cyttsp_track_data *t,
> > +			 struct cyttsp *ts)
> > +{
> 
> functions should be "static". I would leave a decision to Dmitry if he wants the driver
> to support old single touch protocol hacked up with HAT_xx bits so that driver can support
> two touches with the old single touch protocol itself. 

The ABS_HAT* bits should go away. They were gross abuse even when we did
not have MT protocol and shoudl not be used at all now that we do have
it. I will be cleaning up older drivers (like Elantech) to get rid of
them.

Multitouch devices shouls support either A or B MT protocol. SInce this
device seems to be supporting tracking in hardware it shoudl simply
adhere to protocol B to limit kernel->userspace traffict and be done
with it.

...

> > +
> > +/* schedulable worker entry for timer polling method */
> > +void cyttsp_xy_worker_(struct work_struct *work)
> > +{
> > +	struct cyttsp *ts = container_of(work, struct cyttsp, work);
> > +	cyttsp_xy_worker(ts);
> > +}
> 
> I would really prefer that you remove the polling method from this code as it will simplify
> a code lot. We can delete the whole workqueue because as you will be using request_threaded_irq(...),
> you will not need any workqueue.
> 
 
Seconded. Polling is hardly useful on real production setup as it will
drain battery in no time.

> > +
> > +static int cyttsp_i2c_init(void)
> > +{
> 
> Please add __init like
> 
> static int __init cyttsp_i2c_init(void)
> 
> > +	int retval;
> > +	retval = i2c_add_driver(&cyttsp_i2c_driver);
> > +	printk(KERN_INFO "%s: Cypress TrueTouch(R) Standard Product I2C "
> > +		"Touchscreen Driver (Built %s @ %s) returned %d\n",
> > +		 __func__, __DATE__, __TIME__, retval);
> > +

And lose printk as well. The boot is exremely noisy as it is...

	return i2c_add_driver(&cyttsp_i2c_driver);

is all that is needed.

-- 
Dmitry
