Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab0JSRBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:01:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51176 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0JSRBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bazHdYefQBEylMH0hFH+KNrpkA8ceTzXs54IeTrUpMn2r/TI6bywwvzrqU7BM01Imz
         SHP0Aw8Ue3UGbuK868fSWbs4h+BQ9zIVAC9TJvZRYTmYJBOYUTKKAWJrbZPaiGqEEGkg
         K5rILCqKjsTA+nqHrYmOaQ97o7vdCOo3wd0PM=
MIME-Version: 1.0
Date: Tue, 19 Oct 2010 18:01:33 +0100
Message-ID: <AANLkTimdrM0H=b1OzmJ_mxMFqe-Y-Hxs5Lof5PAmVdbj@mail.gmail.com>
Subject: [2.6.36-rc5] r8169 regression...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Matthew Garrett <mjg@redhat.com>, Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Networking <linux-net@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.36-rc5, I've been seeing unexpected link up and (as a
side-effect) pending softirq messages [1] when transferring data over
a r8169 adapter ("RTL8168d/8111d").

The recent change [2] to make the r8169 driver sensitive to receive
overflow events is clearly unnecessary for this MAC revision (since it
was fine without before), so it may be worthwhile to reintroduce the
'tp->mac_version == RTL_GIGA_MAC_VER_11' condition on resetting the
link, tweaked to the problematic MAC version in the Thinkpad X100e.

As a second bonus, we find a latent softirq. When a receive overflow
is now detected, we get the callchain
rtl8169_tx_timeout->rtl8169_schedule_work which causes
rtl8169_reset_task->rtl8169_rx_interrupt->netif_rx from outside the
interrupt handler. I could cook a patch which would ensure
netif_rx_ni() is called outside the interrupt handler, but do we care?

Daniel

--- [1]

[ 1908.724492] r8169 0000:0b:00.0: eth0: link up
[ 1909.593803] r8169 0000:0b:00.0: eth0: link up
[ 1909.593818] NOHZ: local_softirq_pending 08
[ 1910.352950] r8169 0000:0b:00.0: eth0: link up
[ 1913.739897] r8169 0000:0b:00.0: eth0: link up
[ 1914.708997] r8169 0000:0b:00.0: eth0: link up
[ 1914.709011] NOHZ: local_softirq_pending 08
[ 1915.947717] r8169 0000:0b:00.0: eth0: link up
[ 1916.317396] r8169 0000:0b:00.0: eth0: link up
[ 1916.317409] NOHZ: local_softirq_pending 08
[ 1919.824151] r8169 0000:0b:00.0: eth0: link up
[ 1919.824169] NOHZ: local_softirq_pending 08
[ 1920.333731] r8169 0000:0b:00.0: eth0: link up
[ 1921.083030] r8169 0000:0b:00.0: eth0: link up
[ 1921.722490] r8169 0000:0b:00.0: eth0: link up
[ 1921.722506] NOHZ: local_softirq_pending 08
[ 1925.438882] r8169 0000:0b:00.0: eth0: link up
[ 1925.438896] NOHZ: local_softirq_pending 08
[ 1926.248151] r8169 0000:0b:00.0: eth0: link up
[ 1927.536887] r8169 0000:0b:00.0: eth0: link up
[ 1927.536893] NOHZ: local_softirq_pending 08
[ 1928.336193] r8169 0000:0b:00.0: eth0: link up
[ 1928.336211] NOHZ: local_softirq_pending 08
[ 1929.735001] r8169 0000:0b:00.0: eth0: link up
...

--- [2]

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=801e147cde02f04b5c2f42764cd43a89fc7400a2
-- 
Daniel J Blueman
