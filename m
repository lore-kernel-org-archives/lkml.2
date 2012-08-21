Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab2HUP7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:59:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55283 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab2HUP71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:59:27 -0400
Message-ID: <5033B052.7010506@gmail.com>
Date: Tue, 21 Aug 2012 23:59:14 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Hayes Wang <hayeswang@realtek.com>
CC: Yu Zhao <yu.zhao@intel.com>, Dexuan Cui <dexuan.cui@intel.com>,
        Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 00/32] provide interfaces to access PCIe capabilities
 registers
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com> <50325732.3000700@gmail.com> <CAErSpo4-SGH__kE5tPNzz+VO=V-GKOMdcKCqqy6s3=5sNKgG0w@mail.gmail.com> <50325C18.9030207@gmail.com> <CAErSpo6t9m0xmWkXfmONtbicjqLR_z5dLsjKCLWQfcktzRKkUA@mail.gmail.com> <CAErSpo5=OUM9veX8890USWegTG_Fhh10soxPJbjemd80bAO0qg@mail.gmail.com>
In-Reply-To: <CAErSpo5=OUM9veX8890USWegTG_Fhh10soxPJbjemd80bAO0qg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
	Thanks for your help to finalize the patchset.
	There's another suspicious issue in r8169.c, which directly writes PCI_EXP_DEVCTL_NOSNOOP_EN
to PCI_EXP_DEVCTL. I feel it should preserve other bits when setting the NOSNOOP flag.
	Regards!
	Gerry

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index b47d5b3..4104968 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5405,14 +5384,9 @@ static void rtl_hw_start_8101(struct net_device *dev)
                tp->event_slow &= ~RxFIFOOver;

        if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
-           tp->mac_version == RTL_GIGA_MAC_VER_16) {
-               int cap = pci_pcie_cap(pdev);
-
-               if (cap) {
-                       pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL,
-                                             PCI_EXP_DEVCTL_NOSNOOP_EN);
-               }
-       }
+           tp->mac_version == RTL_GIGA_MAC_VER_16)
+               pcie_capability_write_word(pdev, PCI_EXP_DEVCTL,
+                                          PCI_EXP_DEVCTL_NOSNOOP_EN);

        RTL_W8(Cfg9346, Cfg9346_Unlock);
