Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab1CFFb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 00:31:56 -0500
Received: from polaris.galacticasoftware.com ([216.55.199.131]:39102 "EHLO
	polaris.galacticasoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726Ab1CFFbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 00:31:55 -0500
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Mar 2011 00:31:54 EST
Date: Sat, 5 Mar 2011 23:31:34 -0600
From: Adam Majer <adamm@zombino.com>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Issue NETDEV_CHANGE notification when bridge
 changes state
Message-ID: <20110306053134.GB3146@mira.lan.galacticasoftware.com>
References: <20110306051833.GA3098@mira.lan.galacticasoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110306051833.GA3098@mira.lan.galacticasoftware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As background for these 2 patches, the current bridge code does not
play very nicely with IPv6 autoconfiguration. What happens is,

[   35.117030] device eth0 entered promiscuous mode
[   35.120898] br0: port 1(eth0) entering learning state
[   35.120901] br0: port 1(eth0) entering learning state

Here bridge is setup and both interface eth0 and br0 are indicated as
up via NETDEV_UP notification. The IPv6 autoconfiguration code
configures linklocal address and start to issue RS packets. These
timeout because bridge is in learning state, not forwarding state.

[   45.168007] br0: no IPv6 routers present
[   45.312020] eth0: no IPv6 routers present

RS timeouts and IPv6 is abandoned at this point.

[   50.144011] br0: port 1(eth0) entering forwarding state

Now bridge entered forwarding state. Userland sets up IPv4 via DHCP or
otherwise.

[   50.144487] ADDRCONF(NETDEV_CHANGE): br0: link becomes ready

With the patches, NETDEV_CHANGE is issued by the bridge once it
changes state. The autoconfiguration code then checks that no RA
packets are received and only linklocal interface is setup. It then
retries soliciting router information.


This is my first attempt at a kernel patch so please be gentle :) Part
of the autoconf patch splits out the addrconf_rs_start() code from the
addrconf_dad_completed() function.

Cheers,
Adam


-- 
Adam Majer
adamm@zombino.com
