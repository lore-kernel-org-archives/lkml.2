Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1B1Q1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:27:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42791 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1B1Q1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:27:49 -0500
MIME-Version: 1.0
X-Originating-IP: [130.235.233.36]
Date: Mon, 28 Feb 2011 17:27:47 +0100
Message-ID: <AANLkTi=2hEK9rR2h1hzWtud0DdJU5A4d9rBYD6aTLFx-@mail.gmail.com>
Subject: ICMP reply uses wrong source address as destination
From: Anders Nilsson Plymoth <lml@telhoc.se>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear linux kernel enthusiasts,

I came upon an issue where ICMP reply packets were issued towards the
IP address of the receiving interface, rather than the source IP
address.
Looking at the kernel code, I saw that this is caused by the following
line in net/ipv4/icmp.c function icmp_reply:

daddr = ipc.addr = rt->rt_src;

For most cases the original line of code is ok, but in some situations
doesn't arrive to the kernel from the network device, but through some
other mechanism such as a userspace application. In these cases the
receiving device in the skb appears to be the loopback interface, not
a physical device. icmp_reply will thus issue the reply to the
loopback IP address, rather than the source IP address as it should.

While googling to see if this issue have been submitted, I found this
two threads that address the same problem:

([PATCH] 2.6.22.6 NETWORKING [IPV4]: Always use source addr in skb to
reply packet) on 17 sep 2007
AND
([PATCH RESEND] 2.6.22.6 networking [ipv4]: fix wrong destination when
reply packetes) on 20 sep 2007).

Nothing came out of these threads, and some of the questions there are
easy to answer; such as this doesn't affect DNAT, and if source IP
address is not set then you should not issue a reply for echo and
timestamp anyway.

As to the statement:
"... which IP address should be used as the source
1. the destination address of the packet that generated the message

or.

2. the IP address that the machine would use by default if the machine
were to generate a new connection to the destination."
These may be relevant questions, but the ICMP RFC clearly states the
answer is 1. 2. may seem relevant to multi-homing, but its not the
role of the ICMP reply to resolve multi-homing issues.
The following code will correct the issue.
{
   struct iphdr *ip = ip_hdr(skb);
   daddr = ipc.addr = ip->saddr;
}
The only functions that use icmp_reply are icmp_echo and
icmp_timestamp, and this change do not modify their behavior. After
extensive testing, in regular setups and DNATed situations, I can
verify this change works as intended.
Thanks,
Anders
