Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab1KHTeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:34:17 -0500
Received: from www17.your-server.de ([213.133.104.17]:56223 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1KHTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:34:16 -0500
Subject: [PATCH] KVM: Use kmemdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:32:19 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320780750.8062.152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kmemdup rather than duplicating its implementation

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/memdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c 2011-11-07 19:38:38.350717404 +0100
+++ b/virt/kvm/kvm_main.c 2011-11-08 10:33:24.522069993 +0100
@@ -775,10 +775,10 @@ skip_lpage:
 
 	if (!npages) {
 		r = -ENOMEM;
-		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
+				GFP_KERNEL);
 		if (!slots)
 			goto out_free;
-		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
 		if (mem->slot >= slots->nmemslots)
 			slots->nmemslots = mem->slot + 1;
 		slots->generation++;
@@ -810,10 +810,10 @@ skip_lpage:
 	}
 
 	r = -ENOMEM;
-	slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
+			GFP_KERNEL);
 	if (!slots)
 		goto out_free;
-	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
 	if (mem->slot >= slots->nmemslots)
 		slots->nmemslots = mem->slot + 1;
 	slots->generation++;
@@ -2520,10 +2520,9 @@ int kvm_io_bus_register_dev(struct kvm *
 	if (bus->dev_count > NR_IOBUS_DEVS-1)
 		return -ENOSPC;
 
-	new_bus = kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL);
+	new_bus = kmemdup(bus, sizeof(struct kvm_io_bus), GFP_KERNEL);
 	if (!new_bus)
 		return -ENOMEM;
-	memcpy(new_bus, bus, sizeof(struct kvm_io_bus));
 	kvm_io_bus_insert_dev(new_bus, dev, addr, len);
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
 	synchronize_srcu_expedited(&kvm->srcu);


