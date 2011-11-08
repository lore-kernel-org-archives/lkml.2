Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab1KHT31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:29:27 -0500
Received: from smtp-out.google.com ([74.125.121.67]:47698 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab1KHT3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:29:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=NigdJglvk9Je5a3IHzh8l8wCSN8rjME1ARCGRLXXZVNqFBFe9xFf7SEY3VXTXdW2I
	gF5I0ERyKLaJ4t06YpyHg==
Subject: [PATCH v2 1/3] virtio_console:  Fix locking of vtermno.
To: linux-kernel@vger.kernel.org
From: Miche Baker-Harvey <miche@google.com>
Date: Tue, 08 Nov 2011 11:29:22 -0800
Message-ID: <20111108192921.30437.96169.stgit@miche.sea.corp.google.com>
In-Reply-To: <20111108192916.30437.47434.stgit@miche.sea.corp.google.com>
References: <20111108192916.30437.47434.stgit@miche.sea.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some modifications of vtermno were not done under the spinlock.

Moved assignment from vtermno and increment of vtermno together,
putting both under the spinlock.  Revert vtermno on failure.

Signed-off-by: Miche Baker-Harvey <miche@google.com>
---
 drivers/char/virtio_console.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 8e3c46d..9722e76 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -987,18 +987,21 @@ int init_port_console(struct port *port)
 	 * pointers.  The final argument is the output buffer size: we
 	 * can do any size, so we put PAGE_SIZE here.
 	 */
-	port->cons.vtermno = pdrvdata.next_vtermno;
+	spin_lock_irq(&pdrvdata_lock);
+	port->cons.vtermno = pdrvdata.next_vtermno++;
+	spin_unlock_irq(&pdrvdata_lock);
 
 	port->cons.hvc = hvc_alloc(port->cons.vtermno, 0, &hv_ops, PAGE_SIZE);
+	spin_lock_irq(&pdrvdata_lock);
 	if (IS_ERR(port->cons.hvc)) {
 		ret = PTR_ERR(port->cons.hvc);
 		dev_err(port->dev,
 			"error %d allocating hvc for port\n", ret);
 		port->cons.hvc = NULL;
+		port->cons.vtermno = pdrvdata.next_vtermno--;
+		spin_unlock_irq(&pdrvdata_lock);
 		return ret;
 	}
-	spin_lock_irq(&pdrvdata_lock);
-	pdrvdata.next_vtermno++;
 	list_add_tail(&port->cons.list, &pdrvdata.consoles);
 	spin_unlock_irq(&pdrvdata_lock);
 	port->guest_connected = true;

