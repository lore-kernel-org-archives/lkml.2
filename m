Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030239Ab2KVWPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:15:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:49367 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab2KVSie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Worsley <amworsley@gmail.com>
Subject: [ 38/38] PCI : Calculate right add_size
Date: Wed, 21 Nov 2012 16:40:21 -0800
Message-Id: <20121122003908.492925989@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Andrew Worsley <amworsley@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-bus.c |    4 ++--
 drivers/pci/setup-res.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -614,7 +614,7 @@ static void pbus_size_io(struct pci_bus
 	if (children_add_size > add_size)
 		add_size = children_add_size;
 	size1 = (!add_head || (add_head && !add_size)) ? size0 :
-		calculate_iosize(size, min_size+add_size, size1,
+		calculate_iosize(size, min_size, add_size + size1,
 			resource_size(b_res), 4096);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
@@ -718,7 +718,7 @@ static int pbus_size_mem(struct pci_bus
 	if (children_add_size > add_size)
 		add_size = children_add_size;
 	size1 = (!add_head || (add_head && !add_size)) ? size0 :
-		calculate_memsize(size, min_size+add_size, 0,
+		calculate_memsize(size, min_size, add_size,
 				resource_size(b_res), min_align);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -233,11 +233,12 @@ int pci_reassign_resource(struct pci_dev
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


