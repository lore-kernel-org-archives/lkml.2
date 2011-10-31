Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1JaUmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:42:46 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37155 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab1JaUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:42:45 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
cc: Weiping Pan <wpan@redhat.com>, netdev@vger.kernel.org, andy@greyhouse.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding:update speed/duplex for NETDEV_CHANGE
In-reply-to: <1320084906.2735.9.camel@bwh-desktop>
References: <4EAE0D9A.9060408@gmail.com> <e00468a2cbb8a25d7a89028e876769449454309f.1320070684.git.wpan@redhat.com> <1320084906.2735.9.camel@bwh-desktop>
Comments: In-reply-to Ben Hutchings <bhutchings@solarflare.com>
   message dated "Mon, 31 Oct 2011 18:15:06 -0000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Mon, 31 Oct 2011 13:32:09 -0700
Message-ID: <14973.1320093129@death>
x-cbid: 11103120-5930-0000-0000-000000BCAB86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <bhutchings@solarflare.com> wrote:

>On Mon, 2011-10-31 at 22:19 +0800, Weiping Pan wrote:
>> Zheng Liang(lzheng@redhat.com) found a bug that if we config bonding with
>> arp monitor, sometimes bonding driver cannot get the speed and duplex from
>> its slaves, it will assume them to be 100Mb/sec and Full, please see
>> /proc/net/bonding/bond0.
>> But there is no such problem when uses miimon.
>> 
>> (Take igb for example)
>> I find that the reason is that after dev_open() in bond_enslave(),
>> bond_update_speed_duplex() will call igb_get_settings()
>> , but in that function,
>> it runs ethtool_cmd_speed_set(ecmd, -1); ecmd->duplex = -1;
>> because igb get an error value of status.
>> So even dev_open() is called, but the device is not really ready to get its
>> settings.
>> 
>> Maybe it is safe for us to call igb_get_settings() only after
>> this message shows up, that is "igb: p4p1 NIC Link is Up 1000 Mbps Full Duplex,
>> Flow Control: RX".
>[...]

	I'll first point out that this patch is somewhat cosmetic, and
really only affects what shows up in /proc/net/bonding/bond0 for speed
and duplex.  The reason being that the modes that actually need to use
the speed and duplex information require the miimon for link state
checking, and that code path does the right thing already.

	This has probably been wrong all along, but relatively recently
code was added to show the speed and duplex in /proc/net/bonding/bond0,
so it now has a visible effect.

	So, the patch is ok as far as it goes, in that it will keep the
values displayed in the /proc file up to date.

	However, I'm not sure that faking the speed/duplex to 100/Full
is still the correct thing to do.  For the modes that use the
information, the ethtool state won't be queried if carrier is down (and
in those cases, if the speed / duplex returns an error while carrier up,
we should probably pay attention).  For the modes that the information
is merely cosmetic, displaying "unknown" as ethtool does is probably a
more accurate representation.

	Can you additionally remove the "fake to 100/Full" logic?  This
involves changing bond_update_speed_duplex to not fake the speed and
duplex, changing bond_enslave to not issue that warning, and changing
bond_info_show_slave to handle "bad" speed and duplex values.

	Anybody see a problem with doing that?

>For any device with autonegotiation enabled, you generally cannot get
>the speed and duplex settings until the link is up.  While the link is
>down, you may see a value of 0, ~0, or the best mode currently
>advertised.  So I think that the bonding driver should avoid updating
>the slave speed and duplex values whenever autoneg is enabled and the
>link is down.

	Well, it's a little more complicated than that.  Bonding already
generally avoids checking the speed and duplex if the slave isn't up (or
at least normally won't complain if it fails).

	This particular case arises only during enslavement.  The call
to bond_update_speed_duplex call has failed, but the device is marked by
bonding to be up.  Bonding complains that the device isn't down, but it
cannot get speed and duplex, and therefore is assuming them to be
100/Full.

	The catch is that this happens only for the ARP monitor, because
it initially presumes a slave to be up regardless of actual carrier
state (for historical reasons related to very old 10 or 10/100 drivers,
prior to the introduction of netif_carrier_*).

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

