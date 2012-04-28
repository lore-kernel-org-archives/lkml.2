Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2D1VGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:06:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab2D1VF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:05:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [PATCH 1/2] PM / QoS: Create device constraints objects on notifier registration
Date: Sat, 28 Apr 2012 23:10:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Pihet <j-pihet@ti.com>
References: <201204272346.44145.rjw@sisk.pl> <201204272348.18533.rjw@sisk.pl> <20120428153335.GA13787@G62>
In-Reply-To: <20120428153335.GA13787@G62>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204282310.37811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 28, 2012, mark gross wrote:
> On Fri, Apr 27, 2012 at 11:48:18PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The current behavior of dev_pm_qos_add_notifier() makes device PM QoS
> > notifiers less than useful.  Namely, it silently returns success when
> > called before any PM QoS constraints are added for the device, so the
> > caller will assume that the notifier has been registered, but when
> > someone actually adds some nontrivial constraints for the device
> > eventually, the previous callers of dev_pm_qos_add_notifier()
> > will not know about that and their notifier routines will not be
> > executed (contrary to their expectations).
> > 
> > To address this problem make dev_pm_qos_add_notifier() create the
> > constraints object for the device if it is not present when the
> > routine is called.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/base/power/qos.c |   19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> > 
> > Index: linux/drivers/base/power/qos.c
> > ===================================================================
> > --- linux.orig/drivers/base/power/qos.c
> > +++ linux/drivers/base/power/qos.c
> > @@ -352,21 +352,26 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_remove_requ
> >   *
> >   * Will register the notifier into a notification chain that gets called
> >   * upon changes to the target value for the device.
> > + *
> > + * If the device's constraints object doesn't exist when this routine is called,
> > + * it will be created (or error code will be returned if that fails).
> >   */
> >  int dev_pm_qos_add_notifier(struct device *dev, struct notifier_block *notifier)
> >  {
> > -	int retval = 0;
> > +	int ret = 0;
> >  
> >  	mutex_lock(&dev_pm_qos_mtx);
> >  
> > -	/* Silently return if the constraints object is not present. */
> > -	if (dev->power.constraints)
> > -		retval = blocking_notifier_chain_register(
> > -				dev->power.constraints->notifiers,
> > -				notifier);
> FWIW (and IIRC) I did this because some audio use of pm_qos had a series
> of re-allocation of constraints and clean up that would fall over so I
> had this silent hack to deal with that "complexity".
> 
> > +	if (!dev->power.constraints)
> > +		ret = dev->power.power_state.event != PM_EVENT_INVALID ?
> > +			dev_pm_qos_constraints_allocate(dev) : -ENODEV;
> > +
> > +	if (!ret)
> > +		ret = blocking_notifier_chain_register(
> > +				dev->power.constraints->notifiers, notifier);
> >  
> >  	mutex_unlock(&dev_pm_qos_mtx);
> > -	return retval;
> > +	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(dev_pm_qos_add_notifier);
> >  
> Definitely a change for the better (but we should check that the audio
> stuff still works before committing this.  I'll see if I can check that
> this weekend.)

Well, I don't see why not.  Obviously, we won't set the dev->power.constraints
pointer more than once. :-)

> Acked-by : markgross <markgross@thegnar.org>

Thanks!

Rafael
