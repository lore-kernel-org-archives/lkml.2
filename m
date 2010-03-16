Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab0CPO6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:58:06 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:55719 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab0CPO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:58:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux@dominikbrodowski.net
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: [PATCH 1/1] PCMCIA: resource, fix lock imbalance
Date: Tue, 16 Mar 2010 15:57:44 +0100
Message-Id: <1268751464-15168-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that one error path (when alloc_skb fails) in netdev_tx
omits to unlock hw_priv->hwlock. Fix that by moving away from unlock in
each fail path. Unlock at one place instead.

Introduced in 94a819f80297e1f635a7cde4ed5317612e512ba7
(pcmcia: assert locking to struct pcmcia_device)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/pcmcia/pcmcia_resource.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index b2df041..add962a 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -256,6 +256,7 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
 {
 	struct pcmcia_socket *s;
 	config_t *c;
+	int ret;
 
 	s = p_dev->socket;
 
@@ -264,13 +265,13 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
 
 	if (!(s->state & SOCKET_PRESENT)) {
 		dev_dbg(&s->dev, "No card present\n");
-		mutex_unlock(&s->ops_mutex);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 	if (!(c->state & CONFIG_LOCKED)) {
 		dev_dbg(&s->dev, "Configuration isnt't locked\n");
-		mutex_unlock(&s->ops_mutex);
-		return -EACCES;
+		ret = -EACCES;
+		goto unlock;
 	}
 
 	if (mod->Attributes & CONF_IRQ_CHANGE_VALID) {
@@ -286,7 +287,8 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
 
 	if (mod->Attributes & CONF_VCC_CHANGE_VALID) {
 		dev_dbg(&s->dev, "changing Vcc is not allowed at this time\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	/* We only allow changing Vpp1 and Vpp2 to the same value */
@@ -294,21 +296,21 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
 	    (mod->Attributes & CONF_VPP2_CHANGE_VALID)) {
 		if (mod->Vpp1 != mod->Vpp2) {
 			dev_dbg(&s->dev, "Vpp1 and Vpp2 must be the same\n");
-			mutex_unlock(&s->ops_mutex);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto unlock;
 		}
 		s->socket.Vpp = mod->Vpp1;
 		if (s->ops->set_socket(s, &s->socket)) {
-			mutex_unlock(&s->ops_mutex);
 			dev_printk(KERN_WARNING, &s->dev,
 				   "Unable to set VPP\n");
-			return -EIO;
+			ret = -EIO;
+			goto unlock;
 		}
 	} else if ((mod->Attributes & CONF_VPP1_CHANGE_VALID) ||
 		   (mod->Attributes & CONF_VPP2_CHANGE_VALID)) {
 		dev_dbg(&s->dev, "changing Vcc is not allowed at this time\n");
-		mutex_unlock(&s->ops_mutex);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	if (mod->Attributes & CONF_IO_CHANGE_WIDTH) {
@@ -332,9 +334,11 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
 			s->ops->set_io_map(s, &io_on);
 		}
 	}
+	ret = 0;
+unlock:
 	mutex_unlock(&s->ops_mutex);
 
-	return 0;
+	return ret;
 } /* modify_configuration */
 EXPORT_SYMBOL(pcmcia_modify_configuration);
 
-- 
1.7.0.1


