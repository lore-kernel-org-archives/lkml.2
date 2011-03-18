Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1CROUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:20:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab1CROUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Fri, 18 Mar 2011 15:20:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>,
        linux-i2c@vger.kernel.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103181319.54191.arnd@arndb.de> <20110318125150.GD27129@sirena.org.uk>
In-Reply-To: <20110318125150.GD27129@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181520.14315.arnd@arndb.de>
X-Provags-ID: V02:K0:CLuzS/+F53ONMChkxPh+8RIK5g8sniRBJ96oExG9N6r
 XxVvp/5OtF2MzpgJE7yqy7WoLQq/1Jrf64HFZLvNQxdTz2YNDS
 5DSC4zXNy1m8Fku+1+S5bg5PE9EcLzvd2tkT7biul4bwDNPlqv
 v7fa6C2YPGV7Q1qWclzbpUriEHS0dGw1H5kWXpou+FShEu6U8Q
 VpdeGkIGyXGtAVO85Hi2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Mark Brown wrote:
> On Fri, Mar 18, 2011 at 01:19:53PM +0100, Arnd Bergmann wrote:
> > On Friday 18 March 2011, Waldemar Rymarkiewicz wrote:
> 
> > > +
> > > +   mutex_lock(&info->rx_mutex);
> > > +   info->irq_state = 1;
> > > +   mutex_unlock(&info->rx_mutex);
> > > +
> > > +   wake_up_interruptible(&info->rx_waitq);
> > > +
> > > +   return IRQ_HANDLED;
> > > +}
> 
> > You cannot take a mutex from interrupt context, that may
> > cause deadlocks.
> 
> This is a threaded IRQ handler so mutexes are fine.

Ah, right. I've never seen one of these used in the field,
so I didn't think of this.

Looking at the mutexes though: The read function does
not hold the rx_mutex when reading the irq_state
variable, so that is potentially racy.

The read function seems to have another problem regarding
the user space buffer: it bails out if the provided buffer
is larger than the available data, which is pointless,
but it does not check if the user buffer is too short.

	Arnd
