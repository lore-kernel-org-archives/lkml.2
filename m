Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2JHTTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:19:53 -0400
Received: from rain.florz.de ([62.216.164.86]:55393 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753498Ab2JHTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:19:51 -0400
Date: Mon, 8 Oct 2012 21:19:44 +0200
From: Florian Zumbiehl <florz@florz.de>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com
Subject: Re: [PATCH v2] vlan: don't deliver frames for unknown vlans to
 protocols
Message-ID: <20121008191944.GD25288@florz.florz.dyndns.org>
References: <20121008015158.GE25895@florz.florz.dyndns.org>
 <20121008.144230.1404596032615788891.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008.144230.1404596032615788891.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> But I wonder if it breaks things, since you do the assignment so late
> we no longer handle the case where the VLAN device's MAC address
> matches the packet MAC address and the top-level device's does not.
> 
> That's handled by logic in vlan_do_receive() which checks for
> PACKET_OTHERHOST.
> 
> But you're going to unconditionally set PACKET_OTHERHOST, overriding
> any decision that code makes.

I don't think that that's actually the case. If vlan_do_receive() reaches
the MAC address check (that is, there is a vlan device for the tag), it
will either clear skb->vlan_tci and return true (which also causes goto
another_round), or return false with a NULL skb, which causes goto out.

The only way to reach the new check without another_round and with a
non-zero tag is the first return false, which happens if there is no device
for the tag, in which case setting PACKET_OTHERHOST should be the right
thing to do (in particular, a non-existent vlan device won't have the
frame's MAC address). I am assuming that rx_handlers don't modify the
frame unless they return RX_HANDLER_ANOTHER.

> This turns out to be a really non-trivial area and it's going to take
> some time to get this right and audit the change appropriately.

I wouldn't want to disagree with that ;-)

Florian
