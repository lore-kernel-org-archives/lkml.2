Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0LVL3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:29:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60640 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab0LVL3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XSOFwnXFG9+NsWas/bR6M2M1YWfLUNtBgVVm5yTacbWtkXdTARPvv1gy7YH+rtmThb
         ROrEn59tEt5rzCvnC26k8jQxM7Mhz7KYHchx2OpN0VQxxe8nXVGk5ofuMGx7e39iWGxe
         MaUuBl/RaUamZijqI3iIYob240RB123DPiDmg=
Subject: Re: [PATCH] tcp: use RTAX_CWND for outgoing connections properly
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>
In-Reply-To: <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012172310400.16569@pobox.suse.cz>
	 <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 12:29:43 +0100
Message-ID: <1293017383.3027.75.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 décembre 2010 à 11:00 +0100, Jiri Kosina a écrit :
> On Fri, 17 Dec 2010, Jiri Kosina wrote:
> 
> > For outgoing connections, the initial value of cwnd is always set to 2 (in 
> > tcp_v4_init_sock()) regardless of setting of RTAX_CWND. For incoming 
> > connections, this is handled properly in tcp_init_metrics().
> > 
> > As a result of this, Linux TCP stack always uses cwnd == 2 at the beginning of
> > outgoing TCP session (i.e. waits for ACK after 2 packets once the connection
> > has been established) and grows it in accordance with slow-start algorithm
> > only after it receives ACK for first two packets.
> > 
> > When slow-start triggers later during the connection (e.g. after idle), 
> > cwnd is properly re-initialized to RTAX_CWND value (if specified) through 
> > tcp_cwnd_restart() -> tcp_init_cwnd().
> > 
> > Initialize tp->snd_cwnd properly so that RTAX_CWND value is being used 
> > also in the slow-start phase for the first packets in the connection.
> 
> This should of course read RTAX_INITCWND instead of RTAX_CWND in the whole 
> changelog, sorry.
> 
> Besides that, any comments on this, please?
> 

Its a bit strange, here is what I have with two net-next-2.6 machines
(without your patch)

192.168.20.0/24 dev eth1  scope link  initcwnd 10

12:13:46.855786 IP 192.168.20.110.39146 > 192.168.20.108.59636: S 1615862982:1615862982(0) win 14600 <mss 1460,sackOK,timestamp 277530 0,nop,wscale 8>
12:13:46.855807 IP 192.168.20.108.59636 > 192.168.20.110.39146: S 1603053412:1603053412(0) ack 1615862983 win 14480 <mss 1460,sackOK,timestamp 744840 277530,nop,wscale 7>
12:13:46.855878 IP 192.168.20.110.39146 > 192.168.20.108.59636: . ack 1 win 58 <nop,nop,timestamp 277530 744840>
12:13:46.856779 IP 192.168.20.110.39146 > 192.168.20.108.59636: P 1:14481(14480) ack 1 win 58 <nop,nop,timestamp 277530 744840>
12:13:46.856794 IP 192.168.20.108.59636 > 192.168.20.110.39146: . ack 14481 win 136 <nop,nop,timestamp 744841 277530>
12:13:46.856901 IP 192.168.20.110.39146 > 192.168.20.108.59636: . 14481:15929(1448) ack 1 win 58 <nop,nop,timestamp 277531 744841>
12:13:46.856912 IP 192.168.20.108.59636 > 192.168.20.110.39146: . ack 15929 win 159 <nop,nop,timestamp 744841 277531>
12:13:46.856930 IP 192.168.20.110.39146 > 192.168.20.108.59636: . 15929:18825(2896) ack 1 win 58 <nop,nop,timestamp 277531 744841>


We can see 192.168.20.110 sends 14480 bytes in its first frame.

Are you sure your patch still needed after commit 356f039822b8d802138f
(TCP: increase default initial receive window.)



