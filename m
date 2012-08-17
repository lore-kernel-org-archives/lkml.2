Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030879Ab2HQH4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:56:06 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:55642 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030208Ab2HQH4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:56:04 -0400
From: Ilya Shchepetkov <shchepetkov@ispras.ru>
To: <bjorn@mork.no>
Cc: Ilya Shchepetkov <shchepetkov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH 0/5] Call netif_carrier_off() after	register_netdev()
Date: Fri, 17 Aug 2012 11:55:43 +0400
Message-Id: <1345190143-12050-1-git-send-email-shchepetkov@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <87boicz8l7.fsf@nemi.mork.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Ben Hutchings <bhutchings@solarflare.com> writes:
>>> But if you do it beforehand then it doesn't have the intended effect.
>>> (Supposed to be fixed by 22604c866889c4b2e12b73cbf1683bda1b72a313, which
>>> had to be reverted: c276e098d3ee33059b4a1c747354226cec58487c.)
>>>
>>> So you have to do it after, but without dropping the RTNL lock in
>>> between.
>> So you may want to add something like
>>
>> int register_netdev_carrier_off(struct net_device *dev)
>> {
>>      int err;
>>
>>      rtnl_lock();
>>      err = register_netdevice(dev);
>>         if (!err)
>>                 set_bit(__LINK_STATE_NOCARRIER, &dev->state)
>>      rtnl_unlock();
>>      return err;
>> }
>>
>>
>> for these drivers?

t looks like this variant is equivalent to the existing code:

	netif_carrier_off(dev);
	err = register_netdev(dev);
	if (err)
		goto out;

According to explanation in commit 22604c866889c4b2e12b73cbf1683bda1b72a313,
in this case "this causes these drivers to incorrectly report their
link status as IF_OPER_UNKNOWN which can falsely set the IFF_RUNNING
flag when the interface is first brought up".

As far as I understand, to fix the issue it is required to call
netif_carrier_off() itself:

int register_netdev_carrier_off(struct net_device *dev)
{
	int err;

	rtnl_lock();
	err = register_netdevice(dev);
	if (!err)
		netif_carrier_off(dev);
	rtnl_unlock();
	return err;
}

What do you think?
