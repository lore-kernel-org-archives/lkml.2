Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab0KOQ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:58:07 -0500
Received: from stinky.trash.net ([213.144.137.162]:35682 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab0KOQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:58:04 -0500
Message-ID: <4CE16699.1050604@trash.net>
Date: Mon, 15 Nov 2010 17:58:01 +0100
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
References: <28d666269c390965f1a4edca42f93c12@localhost>	<1289725175.2743.65.camel@edumazet-laptop>	<AANLkTik4PLga8mX73c8iONPeOtpDiuDhfu3xiPmF07jC@mail.gmail.com>	<1289764664.2743.110.camel@edumazet-laptop>	<AANLkTi==8nwn3g5t1uw=CP1K0vegUE2hAdDxOq-fkVRW@mail.gmail.com>	<4CE1084A.3070100@trash.net> <AANLkTinELGUzDJ8TTTfA8sfiYiLJV-2ZPujwbuQWTPWd@mail.gmail.com>
In-Reply-To: <AANLkTinELGUzDJ8TTTfA8sfiYiLJV-2ZPujwbuQWTPWd@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.11.2010 17:46, Kevin Cernekee wrote:
> On Mon, Nov 15, 2010 at 2:15 AM, Patrick McHardy <kaber@trash.net> wrote:
>> The problem in doing this is that further packets from port 49xxx
>> wouldn't be recognized as belonging to the same connection.
> 
> OK, makes sense.
> 
>> The same problem exists with your current patch, packets from port
>> 5060 to the same destination won't be recognized as belonging to the
>> connection that sent the REGISTER and thus won't be able to modify the
>> timeout or unregister.
>>
>> Basically we would need three-legged connections to handle this
>> situation correctly.
> 
> Just to clarify: the actual source port on a given device will be
> EITHER a high-numbered port (Cisco) or 5060 (others).  I have not come
> across any devices that send from a "mix" of source ports, e.g. 49xxx
> for REGISTER and then 5060 for INVITE.
> 
>>From what I have seen, subsequent SIP requests from the Cisco phone
> are indeed getting associated with the original connection.  My phone
> is logging into two different SIP accounts, and each account seems to
> use its own unique UDP source port for all control traffic (both
> expecting replies on 5060).

Could you provide a binary tcpdump (-w file -s0) of registration
and a subsequent call please?

> If Netfilter adds support for three-legged connections, will the third
> leg show up in the tuplehash so I don't have to track it in the "help"
> structure?

Yes, basically by default all connections would only have a single
tuplehash. The lookup would look up the tuple based on the packet
and, if not found, reverse it and retry the lookup. When the tuples are
asymetric (NAT and ICMP/ICMPv6) a second one would be added in the
ct_extend area and would be added to the hash table as usual. For the
SIP case, we could simply add a third one in a ct_extend area.

Unfortunately I wasn't able to find my old patch so far.
