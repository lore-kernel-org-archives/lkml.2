Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab2HNO4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:56:48 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:60776 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756357Ab2HNO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:56:45 -0400
Message-ID: <1344956195.824.206.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3/5] net/mlx4_en: Call netif_carrier_off() after
 register_netdev()
From: Ben Hutchings <bhutchings@solarflare.com>
To: <Sathya.Perla@Emulex.Com>
CC: <shchepetkov@ispras.ru>, <yevgenyp@mellanox.co.il>, <davem@davemloft.net>,
        <amirv@mellanox.com>, <ogerlitz@mellanox.com>, <alexg@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@ispras.ru>
Date: Tue, 14 Aug 2012 15:56:35 +0100
In-Reply-To: <CF9D1877D81D214CB0CA0669EFAE020C066A09@CMEXMB1.ad.emulex.com>
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
	 <1344940135-17079-4-git-send-email-shchepetkov@ispras.ru>
	 <CF9D1877D81D214CB0CA0669EFAE020C066A09@CMEXMB1.ad.emulex.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 12:36 +0000, Sathya.Perla@Emulex.Com wrote:
> >-----Original Message-----
> >From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On
> >Behalf Of Ilya Shchepetkov
> >
> >For carrier detection to work properly when binding the driver with a
> >cable unplugged, netif_carrier_off() should be called after
> >register_netdev(), not before.
> >
> >Calling netif_carrier_off() before register_netdev() was causing the
> >network interface to miss a linkwatch pending event leading to an
> >inconsistent state if the link is not up when interface is initialized.
> 
> ndo_open() may be called as soon register_netdev() completes...
> When netif_carrier_off() is called *after* register_netdev(), isn't there
> a possibility of a ndo_open()->netif_carrier_on() call racing this call, causing
> incorrect results?

Yes, you should use something like:

	rtnl_lock();
	rc = register_netdevice(dev);
	if (rc)
		goto out_unlock;
	netif_carrier_off(dev);
	rtnl_unlock();

(Why do we even have register_netdev() when it's such an invitation to
races?)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

