Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2DPKsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:48:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab2DPKsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:48:09 -0400
From: Hannes Reinecke <hare@suse.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        Kay Sievers <ksievers@vrfy.org>, Stable Kernel <stable@kernel.org>
Subject: [PATCH] driver core: check 'start' argument in bus iterators
Date: Mon, 16 Apr 2012 12:48:05 +0200
Message-Id: <1334573285-24016-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bus_for_each_dev() and bus_find_device() both take a 'start'
argument to start the iteration at a specific list entry.
However, this list entry might already been detached by
the time these functions are called.
So we need to check if the arguments are still valid.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Cc: Kay Sievers <ksievers@vrfy.org>
Cc: Stable Kernel <stable@kernel.org>

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 26a06b8..264e498 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -297,6 +297,9 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
 	if (!bus)
 		return -EINVAL;
 
+	if (start && !klist_node_attached(&start->p->knode_bus))
+		return -ENODEV;
+
 	klist_iter_init_node(&bus->p->klist_devices, &i,
 			     (start ? &start->p->knode_bus : NULL));
 	while ((dev = next_device(&i)) && !error)
@@ -331,6 +334,9 @@ struct device *bus_find_device(struct bus_type *bus,
 	if (!bus)
 		return NULL;
 
+	if (start && !klist_node_attached(&start->p->knode_bus))
+		return NULL;
+
 	klist_iter_init_node(&bus->p->klist_devices, &i,
 			     (start ? &start->p->knode_bus : NULL));
 	while ((dev = next_device(&i)))
