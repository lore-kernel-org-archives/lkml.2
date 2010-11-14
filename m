Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0KNUDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:03:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54880 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0KNUDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lbj1/VCOpBVM+dnk3YcPw64kA3Fdq/hNFtpb/AYgUStdUfHgwbPs6gJJiOz30sNUYP
         Hn1UXcQmE/gUr5Bu57QuusU5J1C7ytG/92on46N/jHqO3jeXAaQVOKzcjQfQLG0nF1Hd
         N2I23MnVcZATfQZg+hRByQQ0amwTHDzapafiA=
Subject: Re: [PATCH/RFC] netfilter: nf_conntrack_sip: Handle quirky Cisco
 phones
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <AANLkTik4PLga8mX73c8iONPeOtpDiuDhfu3xiPmF07jC@mail.gmail.com>
References: <28d666269c390965f1a4edca42f93c12@localhost>
	 <1289725175.2743.65.camel@edumazet-laptop>
	 <AANLkTik4PLga8mX73c8iONPeOtpDiuDhfu3xiPmF07jC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 20:57:44 +0100
Message-ID: <1289764664.2743.110.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 novembre 2010 à 10:33 -0800, Kevin Cernekee a écrit :
> On Sun, Nov 14, 2010 at 12:59 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > I would like to get an exact SIP exchange to make sure their is not
> > another way to handle this without adding a "Cisco" string somewhere...
> >
> > Please provide a pcap or tcpdump -A
> 
> Existing nf_nat_sip: phone sends unauthenticated REGISTER requests
> over and over again, because it is not seeing the replies sent back to
> port 50070:
> 
> 10:05:53.496479 IP 192.168.2.28.50070 > 67.215.241.250.5060: SIP, length: 723
> E`...[..@.r.....C...........REGISTER sip:losangeles.voip.ms SIP/2.0
> Via: SIP/2.0/
> 

Hmm, partial tcpdump... you should use" tcpdump -s 1000 -A" 

We miss the

Via: SIP/2.0/UDP 192.168.2.28:5060;branch=xxxxxxxx


Maybe a fix would be to use this "5060" port, instead of hardcoding it
like you did ?


> 
> Patched nf_nat_sip: router sends the replies back to port 5060, so the
> phone is now able to register itself and make calls:
> 
> 10:09:46.221631 IP 192.168.2.28.50618 > 67.215.241.250.5060: SIP, length: 723
> E`...G..@.p.....C...........REGISTER sip:losangeles.voip.ms SIP/2.0
> Via: SIP/2.0/
> 
> 10:09:46.253052 IP 67.215.241.250.5060 > 192.168.2.28.5060: SIP, length: 491
> E....+..4..$C...............SIP/2.0 100 Trying
> Via: SIP/2.0/UDP 192.168.2.28:5060
> 
> 10:09:46.253472 IP 67.215.241.250.5060 > 192.168.2.28.5060: SIP, length: 550
> E..B.,..4...C...............SIP/2.0 401 Unauthorized
> Via: SIP/2.0/UDP 192.168.2.2
> 
> 10:09:46.261602 IP 192.168.2.28.50618 > 67.215.241.250.5060: SIP, length: 900
> E`...H..@.p.....C...........REGISTER sip:losangeles.voip.ms SIP/2.0
> Via: SIP/2.0/
> 
> 10:09:46.290211 IP 67.215.241.250.5060 > 192.168.2.28.5060: SIP, length: 491
> E....-..4.."C...............SIP/2.0 100 Trying
> Via: SIP/2.0/UDP 192.168.2.28:5060
> 
> 10:09:46.295041 IP 67.215.241.250.5060 > 192.168.2.28.5060: SIP, length: 579
> E.._....4...C............K..SIP/2.0 200 OK
> Via: SIP/2.0/UDP 192.168.2.28:5060;bra
> 
> 
> BTW, I thought of two possible issues with the original patch:
> 
> 1) Might need to call skb_make_writable() prior to modifying the
> packet.  Presumably the second invocation inside
> nf_nat_mangle_udp_packet() will have no effect.
> 
> (Is there a cleaner way to mangle just the port number?  Most of the
> utility functions only help with modifying the data area.)
> 
> 2) I should probably be checking to make sure request == 0 before
> mangling the packet.  The current behavior is harmless if the SIP
> proxy is on port 5060, but that might not always be the case.
> 
> I can roll these, along with any other suggestions, into v2.


