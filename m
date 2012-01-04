Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2ADJe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:34:56 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:14983 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab2ADJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:34:53 -0500
X-IronPort-AV: E=Sophos;i="4.71,455,1320624000"; 
   d="scan'208";a="9805438"
Subject: Re: [PATCH] XEN: xenbus: integer overflow in process_msg()
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Haogang Chen <haogangchen@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 4 Jan 2012 09:34:49 +0000
In-Reply-To: <1325669095.25206.176.camel@zakaz.uk.xensource.com>
References: <1325619731-13936-1-git-send-email-haogangchen@gmail.com>
	 <1325669095.25206.176.camel@zakaz.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1325669689.25206.181.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 09:24 +0000, Ian Campbell wrote:
> On Tue, 2012-01-03 at 19:42 +0000, Haogang Chen wrote:
> > There is a potential integer overflow in process_msg() that could result
> > in cross-domain attack.
> > 
> > 	body = kmalloc(msg->hdr.len + 1, GFP_NOIO | __GFP_HIGH);
> > 
> > When a malicious guest passes 0xffffffff in msg->hdr.len, the subsequent
> > call to xb_read() would write to a zero-length buffer.
> 
> The other end of this connection is always the xenstore backend daemon
> so there is no guest (malicious or otherwise) which can do this. The
> xenstore daemon is a trusted component in the system.
> 
> However this seem like a reasonable robustness improvement so we should
> have it.

Actually, rereading docs/misc/xenstore.txt I see:
        The payload length (len field of the header) is limited to 4096
        (XENSTORE_PAYLOAD_MAX) in both directions.  If a client exceeds the
        limit, its xenstored connection will be immediately killed by
        xenstored, which is usually catastrophic from the client's point of
        view.  Clients (particularly domains, which cannot just reconnect)
        should avoid this.

So probably we actually want (untested, but seems obvious enough):

8<---------------------------------------------------------

>From a010c48fe67ef15495884c265ec6af8a688795f8 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Wed, 4 Jan 2012 09:29:41 +0000
Subject: [PATCH] xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX.

This also avoids a potential integer overflow pointed out by Haogang Chen.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Haogang Chen <haogangchen@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/xen/xenbus/xenbus_xs.c     |    6 ++++++
 include/xen/interface/io/xs_wire.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index b3b8f2f..6f0121e 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -810,6 +810,12 @@ static int process_msg(void)
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
diff --git a/include/xen/interface/io/xs_wire.h b/include/xen/interface/io/xs_wire.h
index f0b6890..3c1877c 100644
--- a/include/xen/interface/io/xs_wire.h
+++ b/include/xen/interface/io/xs_wire.h
@@ -88,4 +88,7 @@ struct xenstore_domain_interface {
     XENSTORE_RING_IDX rsp_cons, rsp_prod;
 };
 
+/* Violating this is very bad.  See docs/misc/xenstore.txt. */
+#define XENSTORE_PAYLOAD_MAX 4096
+
 #endif /* _XS_WIRE_H */
-- 
1.7.2.5



