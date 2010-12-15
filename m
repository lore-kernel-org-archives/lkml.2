Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0LOMAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:00:06 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56934 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab0LOMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:00:04 -0500
Date: Wed, 15 Dec 2010 06:59:55 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Cong Wang <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [v3 PATCH 1/2] bonding: sync netpoll code with bridge
Message-ID: <20101215115955.GA12559@hmsreliant.think-freely.org>
References: <20101208075208.5792.45247.sendpatchset@localhost.localdomain>
 <20101208135746.GD11454@hmsreliant.think-freely.org>
 <4D008643.5040500@redhat.com>
 <4D089DEA.2060803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D089DEA.2060803@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 06:52:26PM +0800, Cong Wang wrote:
> 于 2010年12月09日 15:33, Cong Wang 写道:
> >On 12/08/10 21:57, Neil Horman wrote:
> >>On Wed, Dec 08, 2010 at 02:52:08AM -0500, Amerigo Wang wrote:
> >>>-    bond_for_each_slave(bond, slave, i) {
> >>>-        if ((slave->dev->priv_flags&  IFF_DISABLE_NETPOLL) ||
> >>>-            !slave->dev->netdev_ops->ndo_poll_controller)
> >>>-            ret = false;
> >>>+    np = kmalloc(sizeof(*np), GFP_KERNEL);
> >>>+    err = -ENOMEM;
> >>>+    if (!np)
> >>>+        goto out;
> >>>+
> >>>+    np->dev = slave->dev;
> >>>+    err = __netpoll_setup(np);
> >>Setting up our own netpoll instance on each slave worries me a bit.  The
> >>implication here is that, by doing so, some frames will get entirely processed
> >>by the slave.  Most notably arp frames.  That means anything that gets queued up
> >>to the arp_tx queue in __netpoll_rx will get processed during that poll event,
> >>and responded to with the mac of the slave device, rather than with the mac of
> >>the bond device, which isn't always what you want.  I think if you go with this
> >>route, you'll need to add code to netpoll_poll_dev, right before the call to
> >>service_arp_queue, to check if IFF_SLAVE is set in priv_flags, and move the list
> >>to the master device, or some such.
> >
> >
> >Good point! Will fix i
> 
> Hi, Neil,
> 
> I think we should do that in bond_poll_controller() rather than netpoll_poll_dev(),
> right? Since this is bond-specific. Does moving all arp_tx of slaves to their bond
> address your concern?
> 
Don't think that will work, because, since your using multiple netpoll instances
here, the slaves arp_tx queue will get serviced on the return from the slaves
netpoll_poll_dev call, prior to returning to the bond_poll_controller call.  In
other words, bond_poll_controller won't ever see any frames on the slaves arp_tx
queue to migrate, since they will have already been responded to by the slave
directly.
Neil

> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
