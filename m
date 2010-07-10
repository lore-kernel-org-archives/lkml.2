Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0GJDSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 23:18:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37147 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0GJDS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 23:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bfvjioHqBUwS7B6nXe5by3celdH6gflCR9VF2i3o7szDN3kkJeOJDkxgyZXwy6K2Xi
         BVlndCD9n3xBPnKADFBPbAE3aIfkJXkiExtRizB2znZw8biJJJHxmmU0yssEpeLy+gyZ
         NK9dlbUllT4QFseH+f2RxTuc5zt0gWTrcvjCk=
MIME-Version: 1.0
In-Reply-To: <1278695580.2696.55.camel@edumazet-laptop>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	<AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	<1278626921.2435.73.camel@edumazet-laptop>
	<AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	<1278695580.2696.55.camel@edumazet-laptop>
Date: Sat, 10 Jul 2010 00:18:28 -0300
Message-ID: <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Felipe W Damasio <felipewd@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mr. Dumazet,

2010/7/9 Eric Dumazet <eric.dumazet@gmail.com>:
> Reviewing tproxy stuff I spotted a problem in nf_tproxy_assign_sock()
> but I could not see how it could explain your crash.
>
> We can read uninitialized memory and trigger a fault in
> nf_tproxy_assign_sock(), not later in tcp_recvmsg()...
>
> David, Patrick, what do you think ?

But do you think that the bug that squid triggered was caused by the
TProxy code?

Or is related to the network-stack in some other point.

I don't know if this helps, but I'm using ebtables to remove the
packets from the bridge, and iptables to redirect the traffic to
squid.

ebtables rules are:

-p IPv4 -i eth0 --ip-proto tcp --ip-dport 80 -j redirect  --redirect-target DROP
-p IPv4 -i eth1 --ip-proto tcp --ip-sport 80 -j redirect  --redirect-target DROP


iptables -t mangle -L -n is:

iptables -t mangle -L -n
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DIVERT     tcp  --  0.0.0.0/0            0.0.0.0/0           socket
extrachain  tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
dpt:80 ctstate NEW
TPROXY     tcp  --  0.0.0.0/0           !201.40.162.5        tcp
dpt:80 connmark match 0x0 TPROXY redirect 127.0.0.1:3127 mark 0x1/0x1
TPROXY     tcp  --  0.0.0.0/0           !201.40.162.5        tcp
dpt:80 connmark match 0x1 TPROXY redirect 127.0.0.1:3128 mark 0x1/0x1
TPROXY     tcp  --  0.0.0.0/0           !201.40.162.5        tcp
dpt:80 connmark match 0x2 TPROXY redirect 127.0.0.1:3129 mark 0x1/0x1

Chain DIVERT (1 references)
target     prot opt source               destination
MARK       all  --  0.0.0.0/0            0.0.0.0/0           MARK xset
0x1/0xffffffff
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0

Chain extrachain (1 references)
target     prot opt source               destination
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 35 CONNMARK and 0x0
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 35 packet 1 CONNMARK xset 0x1/0xffffffff
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 35 packet 2 CONNMARK xset 0x2/0xffffffff

Don't know if the code on these can be traced back to tcp_recvmsg()
accessing some wrong memory address...

Cheers,

Felipe Damasio
