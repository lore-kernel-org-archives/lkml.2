Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab0LOKwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:52:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0LOKwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:52:47 -0500
Message-ID: <4D089DEA.2060803@redhat.com>
Date: Wed, 15 Dec 2010 18:52:26 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Neil Horman <nhorman@redhat.com>
CC: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [v3 PATCH 1/2] bonding: sync netpoll code with bridge
References: <20101208075208.5792.45247.sendpatchset@localhost.localdomain> <20101208135746.GD11454@hmsreliant.think-freely.org> <4D008643.5040500@redhat.com>
In-Reply-To: <4D008643.5040500@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2010年12月09日 15:33, Cong Wang 写道:
> On 12/08/10 21:57, Neil Horman wrote:
>> On Wed, Dec 08, 2010 at 02:52:08AM -0500, Amerigo Wang wrote:
>>> -    bond_for_each_slave(bond, slave, i) {
>>> -        if ((slave->dev->priv_flags&  IFF_DISABLE_NETPOLL) ||
>>> -            !slave->dev->netdev_ops->ndo_poll_controller)
>>> -            ret = false;
>>> +    np = kmalloc(sizeof(*np), GFP_KERNEL);
>>> +    err = -ENOMEM;
>>> +    if (!np)
>>> +        goto out;
>>> +
>>> +    np->dev = slave->dev;
>>> +    err = __netpoll_setup(np);
>> Setting up our own netpoll instance on each slave worries me a bit.  The
>> implication here is that, by doing so, some frames will get entirely processed
>> by the slave.  Most notably arp frames.  That means anything that gets queued up
>> to the arp_tx queue in __netpoll_rx will get processed during that poll event,
>> and responded to with the mac of the slave device, rather than with the mac of
>> the bond device, which isn't always what you want.  I think if you go with this
>> route, you'll need to add code to netpoll_poll_dev, right before the call to
>> service_arp_queue, to check if IFF_SLAVE is set in priv_flags, and move the list
>> to the master device, or some such.
>
>
> Good point! Will fix i

Hi, Neil,

I think we should do that in bond_poll_controller() rather than netpoll_poll_dev(),
right? Since this is bond-specific. Does moving all arp_tx of slaves to their bond
address your concern?

Thanks!
