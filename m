Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab1JaSPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 14:15:12 -0400
Received: from mail.solarflare.com ([216.237.3.220]:11108 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212Ab1JaSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 14:15:10 -0400
Subject: Re: [PATCH] bonding:update speed/duplex for NETDEV_CHANGE
From: Ben Hutchings <bhutchings@solarflare.com>
To: Weiping Pan <wpan@redhat.com>
CC: <netdev@vger.kernel.org>, <fubar@us.ibm.com>, <andy@greyhouse.net>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <e00468a2cbb8a25d7a89028e876769449454309f.1320070684.git.wpan@redhat.com>
References: <4EAE0D9A.9060408@gmail.com>
	 <e00468a2cbb8a25d7a89028e876769449454309f.1320070684.git.wpan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 31 Oct 2011 18:15:06 +0000
Message-ID: <1320084906.2735.9.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18482.005
X-TM-AS-Result: No--13.412500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 31 Oct 2011 18:15:10.0570 (UTC) FILETIME=[06EC44A0:01CC97F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 22:19 +0800, Weiping Pan wrote:
> Zheng Liang(lzheng@redhat.com) found a bug that if we config bonding with
> arp monitor, sometimes bonding driver cannot get the speed and duplex from
> its slaves, it will assume them to be 100Mb/sec and Full, please see
> /proc/net/bonding/bond0.
> But there is no such problem when uses miimon.
> 
> (Take igb for example)
> I find that the reason is that after dev_open() in bond_enslave(),
> bond_update_speed_duplex() will call igb_get_settings()
> , but in that function,
> it runs ethtool_cmd_speed_set(ecmd, -1); ecmd->duplex = -1;
> because igb get an error value of status.
> So even dev_open() is called, but the device is not really ready to get its
> settings.
> 
> Maybe it is safe for us to call igb_get_settings() only after
> this message shows up, that is "igb: p4p1 NIC Link is Up 1000 Mbps Full Duplex,
> Flow Control: RX".
[...]

For any device with autonegotiation enabled, you generally cannot get
the speed and duplex settings until the link is up.  While the link is
down, you may see a value of 0, ~0, or the best mode currently
advertised.  So I think that the bonding driver should avoid updating
the slave speed and duplex values whenever autoneg is enabled and the
link is down.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

