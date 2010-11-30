Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0K3JUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:20:19 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48527 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0K3JUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:20:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aX2EKtg1/3ODe85rYpN5Mc/W/jWHq1uzAyTMt0m7AN8DNDLihMTUYlY2QxxHxYbkr6
         TqYe/EUE32+tKDrF1F+x6ELnZ3tyVrc12UfNKzLxCWAD+L2X+adnQOzzIat6TG5UaX90
         m56IhelaRo2UPJZi3IqinHWVuLd0MSqYgbdzU=
Subject: Re: 2.6.35 -> 2.6.36 panic when vlan and promisc with tg3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Leun <lkml20101129@newton.leun.net>
Cc: Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20101130095944.41b5f7b6@xenia.leun.net>
References: <20101129201716.1d0257c4@xenia.leun.net>
	 <4CF442FA.4070701@candelatech.com> <20101130095944.41b5f7b6@xenia.leun.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 10:20:09 +0100
Message-ID: <1291108809.2904.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 novembre 2010 à 09:59 +0100, Michael Leun a écrit :
> On Mon, 29 Nov 2010 16:19:06 -0800
> Ben Greear <greearb@candelatech.com> wrote:
> 
> > On 11/29/2010 11:17 AM, Michael Leun wrote:
> > > UG: unable to handle kernel paging request at 01cc921c
> > > IP: [<c034bfce>] vlan_hwaccel_do_receive+0x59/0xd0
> > > *pdpt = 0000000036a2a001 *pde = 0000000000000000
> > > Oops: 0002 [#1] SMP
> > > last sysfs
> > >
> > > Then machine dead.
> > >
> > > In 2.6.35.x this did not happen (but vlans broken - cannot see vlan
> > > tags with tcpdump),
> > 
> > Try this patch:
> > 
> > http://permalink.gmane.org/gmane.linux.network/176566
> > 
> > It looks like this hasn't made it into stable yet?
> 
> > > To reproduce:
> > >
> > > ip link set eth0 up
> > > vconfig add eth0 2
> > > ip link set eth0 promisc on
> 
> It makes it better - it does not crash anymore on this commands - but
> if you add an "tcpdump -i eth0 -n" at the end it does. So,
> unfortunately no real solution.
> 
> I guess, "dropping packet no one is interested in" (as noted in the
> patch) does not work very well if tcpdump is actually interested?
> 

Could you try with following patch instead, for net/core/dev.c 

(and keep the net/8021q/vlan_core.c part)

--- net/core/dev.c.orig
+++ net/core/dev.c
@@ -2891,6 +2891,9 @@
 ncls:
 #endif
 
+	if (unlikely(vlan_tx_tag_present(skb)))
+		goto bypass;
+
 	/* Handle special case of bridge or macvlan */
 	rx_handler = rcu_dereference(skb->dev->rx_handler);
 	if (rx_handler) {
@@ -2927,6 +2930,7 @@
 		}
 	}
 
+bypass:
 	if (pt_prev) {
 		ret = pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 	} else {


