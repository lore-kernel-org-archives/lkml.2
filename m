Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2LCOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:39:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43967 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451Ab2LCOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:37:02 -0500
Message-Id: <20121203143151.652321547@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 29/89] PCI : Calculate right add_size
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit a4ac9fea016fc5c09227eb479bd35e34978323a4 upstream.

During debug of one SRIOV enabled hotplug device, we found found that
add_size is not passed properly.

The device has devices under two level bridges:

 +-[0000:80]-+-00.0-[81-8f]--
 |           +-01.0-[90-9f]--
 |           +-02.0-[a0-af]----00.0-[a1-a3]--+-02.0-[a2]--+-00.0  Oracle Corporation Device
 |           |                               \-03.0-[a3]--+-00.0  Oracle Corporation Device

Which means later the parent bridge will not try to add a big enough range:

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

It turns out we did not calculate size1 properly.

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

We should not pass add_size with min_size in calculate_memsize since
that will make add_size not contribute final add_size.

So just pass add_size with size1 to calculate_memsize().

With this change, we should have chance to remove extra addon in
pci_reassign_resource.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
index 6923a9b..241de6c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -255,11 +255,12 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
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


