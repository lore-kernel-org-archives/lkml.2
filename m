Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2APSai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:30:38 -0500
Received: from mail.vyatta.com ([76.74.103.46]:41164 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab2APSag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:30:36 -0500
Date: Mon, 16 Jan 2012 10:30:32 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: =?ISO-8859-2?B?qXRlZmFu?= Gula <steweg@gmail.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
Message-ID: <20120116103032.03768d0d@nehalam.linuxnetplumber.net>
In-Reply-To: <CAGsizzK-La0iqt8sOXBVcn4W+8KgxMnvQgFFozEqZzQY+hGpzA@mail.gmail.com>
References: <CAGsizzJTbGGpwrn-P=SUtqBW=1AN6hCTVXKp_oKHPBAoGZ4ubA@mail.gmail.com>
	<20120116083634.7b327c34@nehalam.linuxnetplumber.net>
	<CAGsizzK-La0iqt8sOXBVcn4W+8KgxMnvQgFFozEqZzQY+hGpzA@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012 18:26:57 +0100
©tefan Gula <steweg@gmail.com> wrote:

> Dòa 16. januára 2012 17:36, Stephen Hemminger <shemminger@vyatta.com> napísal/a:
> > On Mon, 16 Jan 2012 13:13:19 +0100
> > ©tefan Gula <steweg@gmail.com> wrote:
> >
> >> From: Stefan Gula <steweg@gmail.com
> >>
> >> This patch is an extension for current Ethernet over GRE
> >> implementation, which allows user to create virtual bridge (multipoint
> >> VPN) and forward traffic based on Ethernet MAC address informations in
> >> it. It simulates the Bridge bahaviour learing mechanism, but instead
> >> of learning port ID from which given MAC address comes, it learns IP
> >> address of peer which encapsulated given packet. Multicast, Broadcast
> >> and unknown-multicast traffic is send over network as multicast
> >> enacapsulated GRE packet, so one Ethernet multipoint GRE tunnel can be
> >> represented as one single virtual switch on logical level and be also
> >> represented as one multicast IPv4 address on network level.
> >>
> >> Signed-off-by: Stefan Gula <steweg@gmail.com>
> >
> > Thanks for the effort, but it is duplicating existing functionality.
> > It possible to do this already with existing gretap device and the
> > current bridge.
> >
> > The same thing is also supported by OpenVswitch.
> >
> 
> gretap with bridge will not do the same as gretap allows you to only
> encapsulate L2 frames inside the GRE - this one part is actually
> utilized in my code. GRE multipoint implementation is also utilized in
> my code as well. But what is missing is forwarding logic here, which
> prevents the traffic going not optimal way. Scenario one - e.g. if you
> connect through 3 sites with using 1 gretap multipoint VPN, it always
> forwards frames between site 1 and site 2 even if they are unicast.
> That represents waste of bandwidth for site 3. Now assume that there
> will be more than 40 sites and I hope you see that single current
> multipoint gretap is not also good solution here
> 
> The second scenario - e.g. using 3 sites using point-to-point gretap
> interfaces between each 2 sites (2 gretap VPN interfaces per site) and
> bridging those interfaces with real ones results in looped topology
> which needs to utilized STP inside to prevent loops. Once STP
> converges the topology will looks like this, traffic from site 1 to
> site 2 will go always directly by the way of unicast (on GRE level),
> from site 2 to site 3 always directly by the way of unicast (on GRE
> level) and from site 1 to site 3 will go indirectly through site 2 due
> STP limitations, which results in another not optimalized traffic
> flows. Now assume that the number of sites rises, so gretap+standard
> bridge code is also not a good solution here.
> 
> My code utilizes it that way that I have extended the gretap
> multipoint interface with the forwarding logic e.g. using 3 sites,
> each site uses only one gretap VPN interface and if destination MAC
> address is known to bridge code inside the gretap interface forwarding
> logic, it forwards it towards only VPN endpoint that actually need
> that by the way of unicasting on GRE level. On the other hand if the
> destination MAC address is unknown or destination MAC address is L2
> multicast or L2 broadcast than the frame is spread out through
> multicasting on GRE level, providing delivery mechanism analogous to
> standard switches on top of the multipoint GRE tunnels.

Couldn't this be controlled from user space either by programming
the FDB with netlink or doing alternative version of STP?


> I also get through briefly over OpenVswitch documentation and found
> that it is more related to virtualization inside the box like VMware
> switches or so and not to such technologies interconnecting two or
> more separate segments over routed L3 infrastructure - there is a
> mention about the CAPWAP UDP transport but this is more related to
> WiFi implementations than generic ones. My patch also doesn't need any
> special userspace api to be configured. It utilizes the existing one.

