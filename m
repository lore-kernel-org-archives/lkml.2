Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0FSHtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 03:49:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34839 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0FSHtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 03:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f3RSie5SjORC+T17vMz2cbLShH/mH40Xe0duAKPB4ji1vyg7L/bJS1/F9Fj+ONEbIP
         xNOrAjGQJVaWlj9CTEa3JMl+FQK4nmRmJxodXu15CtL2nczy/YnqVF84X+EizJwIM4Ne
         jzjR5BIcH+dq5jFT8yJJHvZnZbHXA+P/58D1Y=
Subject: [PATCH v2] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1276870309.23783.3.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1276806785.20754.8.camel@maxim-laptop>
	 <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	 <1276856142.9114.1.camel@maxim-laptop>
	 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	 <1276859156.19554.2.camel@maxim-laptop>
	 <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
	 <1276870309.23783.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Jun 2010 10:49:34 +0300
Message-ID: <1276933774.16697.11.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 17:11 +0300, Maxim Levitsky wrote: 
> On Fri, 2010-06-18 at 09:59 -0400, Bob Copeland wrote: 
> > On Fri, Jun 18, 2010 at 7:05 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > >> Patch I made uses GPL code from e1000e, but since ath5k is
> > >> dual-licensed so patch can't be accepted. So if I got it right, patch
> > >> has to be remade from scratch by someone who really knows about pci
> > >> registers etc. I don't, and learning this to fix something that is
> > >> already fixed in my point of view is waste of (my) time.
> > > Sure, regardless of licensing, this patch has to be redone (and e1000
> > > with it)
> > 
> > At any rate, Jussi, thanks a bundle for tracking it down.  I owe you a
> > beer, lots of bugs have been reported on these devices.
> > 
> > Maxim, this device was always broken in the same way, right?  Just
> > curious if anything made it worse recently.
> 
> Always was broken, of course even with madwifi.
> 
> Recently I think driver stopped doing reset on RXORN, which sometimes
> helped. This did made things a bit worse.
> 
> Anyway, just disable L0S, and card works perfectly.

How this patch?
Its same patch but without open coded ASPM disabler.
Of course to work therefore you need CONFIG_PCIEASPM.
Without it, this reduces to noop.
However I asked at linux-pci, and they said that its not a bad idea to
just remove CONFIG_PCIEASPM and make it default.

I hope there won't be a silly GPL vs BSD debate over one line of code...


commit ac5de416f822917b927958b21186a82141550da7
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Thu Jun 17 23:21:42 2010 +0300

    ath5k: disable ASPM
    
    Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
    Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
    enabled. With ASPM ath5k will eventually stall on heavy traffic with often
    'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
    these problems.
    
    Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
    both ends (usually stalls within seconds).
    
    Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>


diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3abbe75..e7a189a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -48,6 +48,7 @@
 #include <linux/netdevice.h>
 #include <linux/cache.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/ethtool.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
@@ -469,6 +470,9 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	int ret;
 	u8 csz;
 
+	/* Disable PCIE ASPM L0S. It is never enabled by windows driver */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't enable device\n");
@@ -722,6 +726,8 @@ static int ath5k_pci_resume(struct device *dev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
 
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep






