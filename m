Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1AXNrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:47:05 -0500
Received: from stinky.trash.net ([213.144.137.162]:63335 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1AXNrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:47:03 -0500
Message-ID: <4D3D82D1.6050305@trash.net>
Date: Mon, 24 Jan 2011 14:46:57 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: netfilter: marking IPv6 packets sends them to the wrong interface
References: <20110123122108.GA30305@darkside.kls.lan>
In-Reply-To: <20110123122108.GA30305@darkside.kls.lan>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2011 13:21, Mario 'BitKoenig' Holbe wrote:
> Hello,
> 
> I have a strange issue with netfilter MARK on IPv6 which I cannot
> explain and which I believe to be a kernel bug:
> If I mark outgoing IPv6 packets they appear to be transmitted via the
> wrong physical interface. At least multicast packets - at least some of
> them.
> 
> I'm running a Linux-based router with two local interfaces and radvd
> advertises stateless autoconfiguration information on them.
> If I mark all outgoing IPv6 packets, after some time all hosts on both
> subnets appear to be autoconfigured for both subnets, i.e. they all have
> two IPv6 addresses - one of each subnet and two default routes - one for
> each router interface. Of course, only one of them really works on each
> host.
> 
> The gateway does pretty normal routing, no routing policies,
> particularly no fwmark rules, does no bridging or something like that.
> The network interfaces are Intel driven by e100.
> 
> The following debug session is done with a 2.6.32 kernel, the condensed
> packet information originates from tcpdump:
> 
> Without marking everything runs as it should be.
> Marking eth0 packets results in all advertisements transmitted via eth1.
> The behaviour goes back to normal as soon as the marking disappears.
> Marking eth1 packets doesn't appear to change the normal behaviour at
> the first glance, but with that I experience hiccups after some time of
> inactivity (i.e. from time to time ping6 from one subnet to the other
> gets no answers for the first 6 to 8 packets). 
> 
> I also tried marking with 0xff00 instead of 1 - same results.
> I tested this on kernels 2.6.26, 2.6.32, and 2.6.37 - all show the same
> behaviour.

That probably means that we're not using the correct keys
when rerouting in ip6_route_me_harder(). Just for testing,
please try to disable the ip6_route_me_harder() call in
net/ipv6/netfilter/ip6table_mangle.c::ip6t_mangle_out().

