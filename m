Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab0GJGRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 02:17:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57720 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0GJGRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 02:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lDkK9F+lEr3inpjsp3o6VIaj+bPATtUUlQ/c0ky107DnyTUQk7A6/x3/ZEe24GsrRr
         +xFrb8recq4LnfapAB4QMSoaN3M2T+Vi9z6U9NjywrobNi6PJ46h9BTwQCEdlSZi3wSB
         pPx7xXMibmSZ7J6ytp3ZidqS5vTi+wIapgg88=
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felipe W Damasio <felipewd@gmail.com>
Cc: David Miller <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	 <1278626921.2435.73.camel@edumazet-laptop>
	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	 <1278695580.2696.55.camel@edumazet-laptop>
	 <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jul 2010 08:17:29 +0200
Message-ID: <1278742649.2538.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 10 juillet 2010 à 00:18 -0300, Felipe W Damasio a écrit :
> Hi Mr. Dumazet,
> 
> 2010/7/9 Eric Dumazet <eric.dumazet@gmail.com>:
> > Reviewing tproxy stuff I spotted a problem in nf_tproxy_assign_sock()
> > but I could not see how it could explain your crash.
> >
> > We can read uninitialized memory and trigger a fault in
> > nf_tproxy_assign_sock(), not later in tcp_recvmsg()...
> >
> > David, Patrick, what do you think ?
> 
> But do you think that the bug that squid triggered was caused by the
> TProxy code?
> 

I dont think so, but I was asking David or Patrick another point of
view.

Strange thing with your crash report is CR2 value, with unexpected value
of 000000000b388000 while RAX value is dce8dce85d415d41

Faulting instruction is :

48 83 b8 b0 00 00 00 00   cmpq   $0x0,0xb0(%rax)

So I would have expected CR2 being RAX+0xb0, but its not.



> Or is related to the network-stack in some other point.
> 
> I don't know if this helps, but I'm using ebtables to remove the
> packets from the bridge, and iptables to redirect the traffic to
> squid.
> 
> ebtables rules are:
> 
> -p IPv4 -i eth0 --ip-proto tcp --ip-dport 80 -j redirect  --redirect-target DROP
> -p IPv4 -i eth1 --ip-proto tcp --ip-sport 80 -j redirect  --redirect-target DROP
> 
> 
> iptables -t mangle -L -n is:
> 
> iptables -t mangle -L -n
> Chain PREROUTING (policy ACCEPT)
> target     prot opt source               destination
> DIVERT     tcp  --  0.0.0.0/0            0.0.0.0/0           socket
> extrachain  tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
> dpt:80 ctstate NEW
> TPROXY     tcp  --  0.0.0.0/0           !201.40.162.5        tcp
> dpt:80 connmark match 0x0 TPROXY redirect 127.0.0.1:3127 mark 0x1/0x1
> TPROXY     tcp  --  0.0.0.0/0           !201.40.162.5        tcp
> dpt:80 connmark match 0x1 TPROXY redirect 127.0.0.1:3128 mark 0x1/0x1
> TPROXY     tcp  --  0.0.0.0/0           !201.40.162.5        tcp
> dpt:80 connmark match 0x2 TPROXY redirect 127.0.0.1:3129 mark 0x1/0x1
> 
> Chain DIVERT (1 references)
> target     prot opt source               destination
> MARK       all  --  0.0.0.0/0            0.0.0.0/0           MARK xset
> 0x1/0xffffffff
> ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0
> 
> Chain extrachain (1 references)
> target     prot opt source               destination
> CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
> mode nth every 35 CONNMARK and 0x0
> CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
> mode nth every 35 packet 1 CONNMARK xset 0x1/0xffffffff
> CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
> mode nth every 35 packet 2 CONNMARK xset 0x2/0xffffffff
> 
> Don't know if the code on these can be traced back to tcp_recvmsg()
> accessing some wrong memory address...
> 
> Cheers,
> 
> Felipe Damasio


