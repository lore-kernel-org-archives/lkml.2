Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030902Ab2CFUDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:03:00 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:13035 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199Ab2CFUC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:02:58 -0500
From: Andrew Vagin <avagin@openvz.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Cc: avagin@openvz.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uevent: send events in correct order according to seqnum
Date: Wed,  7 Mar 2012 00:06:08 +0400
Message-Id: <1331064368-55675-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CAPXgP10GRZ6Y3+dtNSw5zQMaM9FnSBBfLrCJmQ948gA3tALtfw@mail.gmail.com>
References: <CAPXgP10GRZ6Y3+dtNSw5zQMaM9FnSBBfLrCJmQ948gA3tALtfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------1.7.1
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


The queue handling in the udev daemon assumes that the events are
ordered.

Before this patch uevent_seqnum is incremented under sequence_lock,
than an event is send uner uevent_sock_mutex. I want to say that code
contained a window between incrementing seqnum and sending an event.

This patch locks uevent_sock_mutex before incrementing uevent_seqnum.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 lib/kobject_uevent.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


--------------1.7.1
Content-Type: text/x-patch; name="0001-uevent-send-events-in-correct-order-according-to-seq.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="0001-uevent-send-events-in-correct-order-according-to-seq.patch"

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index e66e9b6..596c40d 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -243,6 +243,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	else if (action == KOBJ_REMOVE)
 		kobj->state_remove_uevent_sent = 1;
 
+#if defined(CONFIG_NET)
+	mutex_lock(&uevent_sock_mutex);
+#endif
 	/* we will send an event, so request a new sequence number */
 	spin_lock(&sequence_lock);
 	seq = ++uevent_seqnum;
@@ -253,7 +256,6 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 #if defined(CONFIG_NET)
 	/* send netlink message */
-	mutex_lock(&uevent_sock_mutex);
 	list_for_each_entry(ue_sk, &uevent_sock_list, list) {
 		struct sock *uevent_sock = ue_sk->sk;
 		struct sk_buff *skb;

--------------1.7.1--


