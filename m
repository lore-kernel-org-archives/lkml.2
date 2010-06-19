Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0FSPcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:32:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56850 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0FSPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iVugfJBVQY9NIG7fgZZkBxmYbudJyBBUBhPVRvVqw2sZrzaQf1jmF3J+4hee3VYpvK
         bhC/BtEf9JXv0fIU+xiRPWqnP0QwtjXEgCfOrMmrEB1hDkWmxSiwy1/2nnJfmkVvsxnm
         mwTKYPS9TBuHdB+8kz777WTN8HV4Wv9RDOhSI=
Subject: [PATCH v3] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1276952554.3332.3.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1276806785.20754.8.camel@maxim-laptop>
	 <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	 <1276856142.9114.1.camel@maxim-laptop>
	 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	 <1276859156.19554.2.camel@maxim-laptop>
	 <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
	 <1276870309.23783.3.camel@maxim-laptop>
	 <1276933774.16697.11.camel@maxim-laptop>
	 <20100619123841.GA31838@hash.localnet>
	 <1276952554.3332.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Jun 2010 18:32:44 +0300
Message-ID: <1276961564.5173.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-19 at 16:02 +0300, Maxim Levitsky wrote: 
> On Sat, 2010-06-19 at 08:38 -0400, Bob Copeland wrote: 
> > On Sat, Jun 19, 2010 at 10:49:34AM +0300, Maxim Levitsky wrote:
> > > How this patch?
> > 
> > Looks fine to me.  Some nitpicking below but feel free to add my
> > 
> > Acked-by: Bob Copeland <me@bobcopeland.com>
> > 
Done.

Best regards,
Maxim Levitsky

--- 

commit 616afa397b3e843f2aba06be12a30e72dfff7740
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Thu Jun 17 23:21:42 2010 +0300

    ath5k: disable ASPM
    
    Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
    Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
    enabled. With ASPM ath5k will eventually stall on heavy traffic with often
    'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
    these problems.
    Also card sends a storm of RXORN interrupts even though medium is idle.
    
    Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
    both ends (usually stalls within seconds).
    
    Unfortunately BIOS enables ASPM on this card by default on these machines
    This means that, problem shows up (less often) without pcie_aspm=force too. 
    Therefore to benefit from this fix you need to _enable_ CONFIG_PCIEASPM
    

    All credit for this patch goes to Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    for finding and fixing this bug.
    
    Based on patch that is
    From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Acked-by: Bob Copeland <me@bobcopeland.com>

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3abbe75..4f6bd7c 100644
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
@@ -469,6 +470,19 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	int ret;
 	u8 csz;
 
+	/*
+	 * Disable PCIE ASPM L0S on the card.
+	 * ASPM triggers hardware bug, that makes card stall transmission
+	 * untill reset, and even that doesn't always help.
+	 * This happens on meduim to heavy transmit utilization.
+	 * In addition to stall, hardware usually gives a storm of
+	 * RXORN interrupts, despite idle channel, and otherwise doesn't work.
+	 * Windows driver also disables the L0s ASPM,
+	 * probably due to same reason
+	 * Note: to benefit from this fix, please _enable_ CONFIG_PCIEASPM
+	 */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't enable device\n");


