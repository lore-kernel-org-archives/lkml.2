Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1KYXGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 18:06:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36447 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1KYXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:06:03 -0500
Message-ID: <1322262357.2550.12.camel@edumazet-laptop>
Subject: Re: [bug?] r8169: hangs under heavy load
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        Armin Kazmi <armin.kazmi@tu-dortmund.de>, Gerd <booster@wolke7.net>
Date: Sat, 26 Nov 2011 00:05:57 +0100
In-Reply-To: <20111125222211.GA13719@electric-eye.fr.zoreil.com>
References: <4E7F4D45.7040902@wolke7.net>
	 <1316978632.4122.103.camel@deadeye> <4E82C0B5.1050902@wolke7.net>
	 <1317254171.4068.12.camel@deadeye>
	 <20111124044137.GA18262@elie.hsd1.il.comcast.net>
	 <4ECFE7A7.5070300@wolke7.net>
	 <20111125201936.GA26692@elie.hsd1.il.comcast.net>
	 <1322253122.2550.3.camel@edumazet-laptop>
	 <20111125222211.GA13719@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 novembre 2011 à 23:22 +0100, Francois Romieu a écrit :
> Eric Dumazet <eric.dumazet@gmail.com> :
> [...]
> > rtl8169_rx_interrupt(..., budget) can return budget + 1 sometimes
> > because of :
> > 
> >                 /* Work around for AMD plateform. */
> >                 if ((desc->opts2 & cpu_to_le32(0xfffe000)) &&
> >                     (tp->mac_version == RTL_GIGA_MAC_VER_05)) {
> >                         desc->opts2 = 0;
> >                         cur_rx++;
> >                 }
> 
> It needs fixing but RTL_GIGA_MAC_VER_05 is an old PCI 8169sc while
> debian's bug #642911 is about a 8168c (aka RTL_GIGA_MAC_VER_{19 .. 22}).
> 
> This path is not used.
> 

OK, then we receive a RxFIFOOver indication while napi handler is
running (quite possible if machine under network load)

This (hard) interrupt calls rtl8169_tx_timeout()
	-> rtl8169_hw_reset()
		-> rtl_hw_reset()
			-> rtl8169_init_ring_indexes()

tp->dirty_tx = tp->dirty_rx = tp->cur_tx = tp->cur_rx = 0;

When control returns to softirq handler (rtl8169_rx_interrupt())
it can then catch tp->cur_rx being now 0 instead of value at start of
handler.

count = cur_rx - tp->cur_rx; // too big


Really, calling rtl8169_init_ring_indexes() from hardirq is killing us.



