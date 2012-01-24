Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2AXCpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:45:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2AXCo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:27 2012
Message-Id: <20120124023927.300332227@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
        Haogang Chen <haogangchen@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [038/129] xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2260
Lines: 69

From: Ian Campbell <Ian.Campbell@citrix.com>

commit 9e7860cee18241633eddb36a4c34c7b61d8cecbc upstream.

Haogang Chen found out that:

 There is a potential integer overflow in process_msg() that could result
 in cross-domain attack.

 	body = kmalloc(msg->hdr.len + 1, GFP_NOIO | __GFP_HIGH);

 When a malicious guest passes 0xffffffff in msg->hdr.len, the subsequent
 call to xb_read() would write to a zero-length buffer.

 The other end of this connection is always the xenstore backend daemon
 so there is no guest (malicious or otherwise) which can do this. The
 xenstore daemon is a trusted component in the system.

 However this seem like a reasonable robustness improvement so we should
 have it.

And Ian when read the API docs found that:
        The payload length (len field of the header) is limited to 4096
        (XENSTORE_PAYLOAD_MAX) in both directions.  If a client exceeds the
        limit, its xenstored connection will be immediately killed by
        xenstored, which is usually catastrophic from the client's point of
        view.  Clients (particularly domains, which cannot just reconnect)
        should avoid this.

so this patch checks against that instead.

This also avoids a potential integer overflow pointed out by Haogang Chen.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/xenbus/xenbus_xs.c     |    6 ++++++
 include/xen/interface/io/xs_wire.h |    3 +++
 2 files changed, 9 insertions(+)

--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -801,6 +801,12 @@ static int process_msg(void)
 		goto out;
 	}
 
+	if (msg->hdr.len > XENSTORE_PAYLOAD_MAX) {
+		kfree(msg);
+		err = -EINVAL;
+		goto out;
+	}
+
 	body = kmalloc(msg->hdr.len + 1, GFP_NOIO | __GFP_HIGH);
 	if (body == NULL) {
 		kfree(msg);
--- a/include/xen/interface/io/xs_wire.h
+++ b/include/xen/interface/io/xs_wire.h
@@ -87,4 +87,7 @@ struct xenstore_domain_interface {
     XENSTORE_RING_IDX rsp_cons, rsp_prod;
 };
 
+/* Violating this is very bad.  See docs/misc/xenstore.txt. */
+#define XENSTORE_PAYLOAD_MAX 4096
+
 #endif /* _XS_WIRE_H */


