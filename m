Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1AXQLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:11:07 -0500
Received: from stinky.trash.net ([213.144.137.162]:33042 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1AXQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:11:06 -0500
Message-ID: <4D3DA48A.2020605@trash.net>
Date: Mon, 24 Jan 2011 17:10:50 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        NetDev <netdev@vger.kernel.org>
Subject: Re: netfilter: marking IPv6 packets sends them to the wrong interface
References: <20110123122108.GA30305@darkside.kls.lan> <4D3D82D1.6050305@trash.net> <20110124143518.GA2616@darkside.kls.lan>
In-Reply-To: <20110124143518.GA2616@darkside.kls.lan>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.01.2011 15:35, schrieb Mario 'BitKoenig' Holbe:
> On Mon, Jan 24, 2011 at 02:46:57PM +0100, Patrick McHardy wrote:
>> On 23.01.2011 13:21, Mario 'BitKoenig' Holbe wrote:
>>> Without marking everything runs as it should be.
>>> Marking eth0 packets results in all advertisements transmitted via eth1.
>>> The behaviour goes back to normal as soon as the marking disappears.
>>> I also tried marking with 0xff00 instead of 1 - same results.
>> That probably means that we're not using the correct keys
>> when rerouting in ip6_route_me_harder(). Just for testing,
>> please try to disable the ip6_route_me_harder() call in
>> net/ipv6/netfilter/ip6table_mangle.c::ip6t_mangle_out().
> 
> Yes, disabling the ip6_route_me_harder() call in ip6t_mangle_out()
> results in the advertisements being transmitted on the correct
> interfaces

Thanks. The problem appears to be that ip6_route_me_harder()
only uses the socket's oif for the route lookup when the
socket is bound to an interface, but radvd uses IPV6_PKTINFO
to specify the outgoing interface.

I guess netfilter shouldn't be overriding IPV6_PKTINFO, but
we unfortunately have neither an indication of this nor the
original route lookup keys available at the time the packet
is rerouted.
