Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1KLQ7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 11:59:38 -0500
Received: from www17.your-server.de ([213.133.104.17]:34378 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab1KLQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 11:59:35 -0500
Message-ID: <1321100509.1668.28.camel@localhost.localdomain>
Subject: [PATCH] staging: hv: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 13:21:49 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
--- a/drivers/staging/hv/hv_mouse.c 2011-11-07 19:38:10.923634136 +0100
+++ b/drivers/staging/hv/hv_mouse.c 2011-11-08 10:52:29.944091035 +0100
@@ -205,13 +205,11 @@ static void mousevsc_on_receive_device_i
 	desc = &device_info->hid_descriptor;
 	WARN_ON(desc->bLength == 0);
 
-	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
+	input_device->hid_desc = kmemdup(desc, desc->bLength, GFP_ATOMIC);
 
 	if (!input_device->hid_desc)
 		goto cleanup;
 
-	memcpy(input_device->hid_desc, desc, desc->bLength);
-
 	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
 	if (input_device->report_desc_size == 0)
 		goto cleanup;
diff -u -p a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
--- a/drivers/staging/hv/netvsc.c 2011-11-07 19:38:10.923634136 +0100
+++ b/drivers/staging/hv/netvsc.c 2011-11-08 10:52:30.410763958 +0100
@@ -230,19 +230,14 @@ static int netvsc_init_recv_buf(struct h
 	net_device->recv_section_cnt = init_packet->msg.
 		v1_msg.send_recv_buf_complete.num_sections;
 
-	net_device->recv_section = kmalloc(net_device->recv_section_cnt
-		* sizeof(struct nvsp_1_receive_buffer_section), GFP_KERNEL);
+	net_device->recv_section = kmemdup(init_packet->msg.v1_msg.send_recv_buf_complete.sections,
+					   net_device->recv_section_cnt * sizeof(struct nvsp_1_receive_buffer_section),
+					   GFP_KERNEL);
 	if (net_device->recv_section == NULL) {
 		ret = -EINVAL;
 		goto cleanup;
 	}
 
-	memcpy(net_device->recv_section,
-		init_packet->msg.v1_msg.
-	       send_recv_buf_complete.sections,
-		net_device->recv_section_cnt *
-	       sizeof(struct nvsp_1_receive_buffer_section));
-
 	/*
 	 * For 1st release, there should only be 1 section that represents the
 	 * entire receive buffer


