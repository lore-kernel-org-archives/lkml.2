Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0KOKPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:15:40 -0500
Received: from stinky.trash.net ([213.144.137.162]:61499 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0KOKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:15:39 -0500
Message-ID: <4CE1084A.3070100@trash.net>
Date: Mon, 15 Nov 2010 11:15:38 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH/RFC] netfilter: nf_conntrack_sip: Handle quirky Cisco
 phones
References: <28d666269c390965f1a4edca42f93c12@localhost>	<1289725175.2743.65.camel@edumazet-laptop>	<AANLkTik4PLga8mX73c8iONPeOtpDiuDhfu3xiPmF07jC@mail.gmail.com>	<1289764664.2743.110.camel@edumazet-laptop> <AANLkTi==8nwn3g5t1uw=CP1K0vegUE2hAdDxOq-fkVRW@mail.gmail.com>
In-Reply-To: <AANLkTi==8nwn3g5t1uw=CP1K0vegUE2hAdDxOq-fkVRW@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.11.2010 04:01, Kevin Cernekee wrote:
> On Sun, Nov 14, 2010 at 11:57 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Via: SIP/2.0/UDP 192.168.2.28:5060;branch=xxxxxxxx
>>
>>
>> Maybe a fix would be to use this "5060" port, instead of hardcoding it
>> like you did ?
> 
> Just posted v2... appreciate the advice so far.
> 
> My new code in process_sip_request() looks for an address match + port
> mismatch between the IP source and the Via: header.  This is how it
> tries to detect whether we are talking directly to an afflicted Cisco
> phone.  If the address doesn't match, I assume the request is passing
> through a non-SIP-aware NAT router so there is no special handling.
> 
> Assuming we can reliably detect the "quirky phone" condition, is there
> any way to just trick Netfilter into thinking the source port was 5060
> instead of 49xxx?  3/4ths of the patch could probably be eliminated if
> we could overwrite the port number inside tuplehash.

The problem in doing this is that further packets from port 49xxx
wouldn't be recognized as belonging to the same connection. If another
packet was sent to the same destination conntrack would treat it as
a new connection, rewrite the source port number, notice the clash and
drop the packet.

The same problem exists with your current patch, packets from port
5060 to the same destination won't be recognized as belonging to the
connection that sent the REGISTER and thus won't be able to modify the
timeout or unregister.

Basically we would need three-legged connections to handle this
situation correctly. I've actually done some work to move one of
the conntrack tuples to a ct_extend since in most situations
(all except IPv4 NAT and ICMP packets) the tuples are symetrical
and the second one can easily be derived, but I never managed
to finish it - not sure what the problem was anymore, I'll see
if I can still find those patches. With this we could simply
attach a third tuple to a connection.
