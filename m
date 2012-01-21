Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2AUKKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:04 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22178 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2AUKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:08:55 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/21] PCI : Calculate right add_size
Date: Sat, 21 Jan 2012 02:08:17 -0800
Message-Id: <1327140517-14811-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F1A8EB2.002E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During debug one SRIOV enabled hotplug, found add_size is not passed properly.

the device have devices under two level bridges..

 +-[0000:80]-+-00.0-[81-8f]--
 |           +-01.0-[90-9f]--
 |           +-02.0-[a0-af]----00.0-[a1-a3]--+-02.0-[a2]--+-00.0  Oracle Corporation Device
 |           |                               \-03.0-[a3]--+-00.0  Oracle Corporation Device

so later parent bridge will not try to add big range.
[  557.455077] pci 0000:a0:00.0: BAR 14: assigned [mem 0xf9000000-0xf93fffff]
[  557.461974] pci 0000:a0:00.0: BAR 15: assigned [mem 0xf6000000-0xf61fffff pref]
[  557.469340] pci 0000:a1:02.0: BAR 14: assigned [mem 0xf9000000-0xf91fffff]
[  557.476231] pci 0000:a1:02.0: BAR 15: assigned [mem 0xf6000000-0xf60fffff pref]
[  557.483582] pci 0000:a1:03.0: BAR 14: assigned [mem 0xf9200000-0xf93fffff]
[  557.490468] pci 0000:a1:03.0: BAR 15: assigned [mem 0xf6100000-0xf61fffff pref]
[  557.497833] pci 0000:a1:03.0: BAR 14: can't assign mem (size 0x200000)
[  557.504378] pci 0000:a1:03.0: failed to add optional resources res=[mem 0xf9200000-0xf93fffff]
[  557.513026] pci 0000:a1:02.0: BAR 14: can't assign mem (size 0x200000)
[  557.519578] pci 0000:a1:02.0: failed to add optional resources res=[mem 0xf9000000-0xf91fffff]

it turns out We did not calculate size1 properly.

static resource_size_t calculate_memsize(resource_size_t size,
                resource_size_t min_size,
                resource_size_t size1,
                resource_size_t old_size,
                resource_size_t align)
{
        if (size < min_size)
                size = min_size;
        if (old_size == 1 )
                old_size = 0;
        if (size < old_size)
                size = old_size;
        size = ALIGN(size + size1, align);
        return size;
}

We should not pass add_size with min_size in calculate_memsize.
that will make add_size not contribute final add_size.

Just pass add_size with size1 to calculate_memsize()

With this change, We should have chance to remove extra addon in pci_reassign_resource...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    4 ++--
 drivers/pci/setup-res.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 86b69f85..9d932f4 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -612,7 +612,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	if (children_add_size > add_size)
 		add_size = children_add_size;
 	size1 = (!realloc_head || (realloc_head && !add_size)) ? size0 :
-		calculate_iosize(size, min_size+add_size, size1,
+		calculate_iosize(size, min_size, add_size + size1,
 			resource_size(b_res), 4096);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
@@ -726,7 +726,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	if (children_add_size > add_size)
 		add_size = children_add_size;
 	size1 = (!realloc_head || (realloc_head && !add_size)) ? size0 :
-		calculate_memsize(size, min_size+add_size, 0,
+		calculate_memsize(size, min_size, add_size,
 				resource_size(b_res), min_align);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 5717509b..8b25f9c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -233,11 +233,12 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 		return -EINVAL;
 	}
 
-	new_size = resource_size(res) + addsize + min_align;
+	/* already aligned with min_align */
+	new_size = resource_size(res) + addsize;
 	ret = _pci_assign_resource(dev, resno, new_size, min_align);
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
-		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
+		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
 		if (resno < PCI_BRIDGE_RESOURCES)
 			pci_update_resource(dev, resno);
 	}
-- 
1.7.7

