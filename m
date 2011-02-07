Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1BGSbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:31:49 -0500
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:40172 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1BGSbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:31:47 -0500
Message-ID: <4D5039F6.8000408@genband.com>
Date: Mon, 07 Feb 2011 12:29:10 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pekkas@netcore.fi, davem@davemloft.net, yoshfuji@linux-ipv6.org
Subject: BUG?  behaviour mismatch between ipv4 and ipv6 in UDP rx path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Feb 2011 18:29:11.0634 (UTC) FILETIME=[EA5AF320:01CBC6F4]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17942.000
X-TM-AS-Result: No--20.588500-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

One of our guys is seeing occasional dropped ipv4 packets coming in on
an ipv6 udp socket obtained via socket(AF_INET6,  SOCK_DGRAM, IPPROTO_UDP).

Here's what he says:


"The problem happens when release_sock() goes down an interesting code
path.  If (sk->sk_backlog.tail) is non-NULL then release_sock() invokes
__release_sock() which loops over all queue packets and invokes the
socket's backlog receive function for each previously queued packet.

Now for the interesting part.  The UDPv6 backlog receive function (in
net/ipv6/udp.c, udpv6_queue_rcv_skb()) invokes xfrm6_policy_check() to
confirm that the packet is allowed, but the problem is that it calls
this function regardless of whether the packet is IPv4 or IPv6.  The
xfrm6_policy_check() function then assumes that it is an IPv6 packet and
tries to match a policy based on its packet header... but that clearly
won't work because the addresses that it finds when it decodes the skb
are completely bogus."


Looking at the ipv4 code, git commit 9382177 split __udp_queue_rcv_skb()
out of udp_queue_rcv_skb().  It was done for locking purposes, but it
also means that backlog_rcv is bound to __udp_queue_rcv_skb(), which
doesn't call xfrm4_policy_check().


Should a new function __udpv6_queue_rcv_skb() be split out from
udpv6_queue_rcv_skb() and bound to backlog_rcv to resolve the xfrm
issue?  What about the locking that was the reason for the split in the
ipv4 case--is there a similar problem with ipv6?

Thanks,
Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
