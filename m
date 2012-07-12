Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162498Ab2GLXDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162489Ab2GLXDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Moore <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/68] cipso: handle CIPSO options correctly when NetLabel is disabled
Date: Thu, 12 Jul 2012 16:01:40 -0700
Message-Id: <20120712175035.971925372@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Paul Moore <pmoore@redhat.com>

[ Upstream commit 20e2a86485967c385d7c7befc1646e4d1d39362e ]

When NetLabel is not enabled, e.g. CONFIG_NETLABEL=n, and the system
receives a CIPSO tagged packet it is dropped (cipso_v4_validate()
returns non-zero).  In most cases this is the correct and desired
behavior, however, in the case where we are simply forwarding the
traffic, e.g. acting as a network bridge, this becomes a problem.

This patch fixes the forwarding problem by providing the basic CIPSO
validation code directly in ip_options_compile() without the need for
the NetLabel or CIPSO code.  The new validation code can not perform
any of the CIPSO option label/value verification that
cipso_v4_validate() does, but it can verify the basic CIPSO option
format.

The behavior when NetLabel is enabled is unchanged.

Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/cipso_ipv4.h |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -42,6 +42,7 @@
 #include <net/netlabel.h>
 #include <net/request_sock.h>
 #include <asm/atomic.h>
+#include <asm/unaligned.h>
 
 /* known doi values */
 #define CIPSO_V4_DOI_UNKNOWN          0x00000000
@@ -285,7 +286,33 @@ static inline int cipso_v4_skbuff_getatt
 static inline int cipso_v4_validate(const struct sk_buff *skb,
 				    unsigned char **option)
 {
-	return -ENOSYS;
+	unsigned char *opt = *option;
+	unsigned char err_offset = 0;
+	u8 opt_len = opt[1];
+	u8 opt_iter;
+
+	if (opt_len < 8) {
+		err_offset = 1;
+		goto out;
+	}
+
+	if (get_unaligned_be32(&opt[2]) == 0) {
+		err_offset = 2;
+		goto out;
+	}
+
+	for (opt_iter = 6; opt_iter < opt_len;) {
+		if (opt[opt_iter + 1] > (opt_len - opt_iter)) {
+			err_offset = opt_iter + 1;
+			goto out;
+		}
+		opt_iter += opt[opt_iter + 1];
+	}
+
+out:
+	*option = opt + err_offset;
+	return err_offset;
+
 }
 #endif /* CONFIG_NETLABEL */
 


