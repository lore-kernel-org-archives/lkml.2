Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2FTI6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:58:08 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:1070 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2FTI6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:58:06 -0400
Date: Wed, 20 Jun 2012 10:58:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 2/3 v2] i2c: i801: enable irq for i801 smbus 
 transactions
Message-ID: <20120620105847.65cf37f2@endymion.delvare>
In-Reply-To: <20120619204704.69454016@endymion.delvare>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
	<1325847502-17841-3-git-send-email-djkurtz@chromium.org>
	<20120619204704.69454016@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012 20:47:04 +0200, Jean Delvare wrote:
> On Fri,  6 Jan 2012 18:58:21 +0800, Daniel Kurtz wrote:
> > @@ -879,8 +953,24 @@ static int __devinit i801_probe(struct pci_dev *dev,
> >  	i801_probe_optional_slaves(priv);
> >  
> >  	pci_set_drvdata(dev, priv);
> > +
> > +	if (priv->features & FEATURE_IRQ) {
> > +		init_waitqueue_head(&priv->waitq);
> > +		spin_lock_init(&priv->lock);
> > +
> > +		err = request_irq(dev->irq, i801_isr, IRQF_SHARED,
> > +				  i801_driver.name, priv);
> > +		if (err) {
> > +			dev_err(&dev->dev, "Failed to allocate irq %d: %d",
> 
> Missing "\n".
> 
> > +				dev->irq, err);
> > +			goto exit_del_adapter;
> > +		}
> 
> I believe order is wrong, and interrupt handler should be installed
> _before_ registering the adapter. Otherwise you have a race condition
> where the handler could be called before the waitqueue and spinlock are
> initialized.

Oh, and it's not a theoretical thing. I can reproducibly crash the
kernel by removing and loading the i2c-i801 driver again. Swapping
request_irq() and i2c_add_adapter() solves it.

-- 
Jean Delvare
