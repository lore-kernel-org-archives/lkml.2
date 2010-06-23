Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0FWTX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:23:27 -0400
Received: from bar.sig21.net ([80.81.252.164]:34204 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0FWTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:23:25 -0400
Date: Wed, 23 Jun 2010 21:23:04 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
Message-ID: <20100623192304.GA23113@sig21.net>
References: <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com>
 <20100622165213.GA21842@srcf.ucam.org>
 <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com>
 <20100622172545.GA22680@srcf.ucam.org>
 <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com>
 <20100622175058.GA23499@srcf.ucam.org>
 <AANLkTinE0BiOa5cpcIerbias7K-aDzj3x4qaeDpzy2CQ@mail.gmail.com>
 <20100622184426.GA24546@srcf.ucam.org>
 <20100622193143.GA17803@sig21.net>
 <AANLkTin1fAAgYTYegqaadkYIYP2NXRNRzCR48e-uIgYV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin1fAAgYTYegqaadkYIYP2NXRNRzCR48e-uIgYV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.756,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 12:37:01PM -0700, Luis R. Rodriguez wrote:
> On Tue, Jun 22, 2010 at 12:31 PM, Johannes Stezenbach <js@sig21.net> wrote:
> > I have a Samsung N130 netbook which has a BIOS setting
> > called "CPU Power Saving Mode".  When enabled it activates
> > ASPM L1 and L0s for the ethernet chip (Realtek RTL8102e, 100Mbit)
> > and the PCIE bridge (with the BIOS setting off it's just L1).
> > The result is that the ethernet througput is reduced to 25Mbit/s.
> > (The BIOS setting does not activa L0s for the Atheros AR9285 WLAN.)
> 
> L0s is not going to buy you much gains, getting at least L1 will
> however. L0s is just a further enhancement. I recommend you test by
> enabling L1 and L0s, check how longer your battery lasts and then test
> again with just L1. Then test without both L1 and L0s.

What I did was to dump lspci output to a file, for both settings
of the BIOS option, and then diff.

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02) (prog-if 00 [Normal decode])
		...
                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
		...
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-

I suspect the performance penalty is because L0s is entered very often
even during ethernet bulk transfer, whereas L1 is only entered
when the link is idle for longer time.

The difference in battery run time due to the BIOS option is
significant (IIRC, it's been a while back), but I don't know
what else the BIOS option changes.


Johannes
