Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253Ab2KBMo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:44:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42731 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758437Ab2KBMoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:44:54 -0400
From: Tommi Rantala <tt.rantala@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Tommi Rantala <tt.rantala@gmail.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH] KEYS: fix KEYCTL_INSTANTIATE_IOV error case memory leak
Date: Fri,  2 Nov 2012 14:34:31 +0200
Message-Id: <1351859681-15458-1-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid leaking memory in the keyctl() KEYCTL_INSTANTIATE_IOV operation, by also
checking in the error case if rw_copy_check_uvector() kmalloc'd memory for us.

Discovered with Trinity.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 security/keys/keyctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 5d34b4e..a2c32a2 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1132,12 +1132,13 @@ long keyctl_instantiate_key_iov(key_serial_t id,
 	ret = rw_copy_check_uvector(WRITE, _payload_iov, ioc,
 				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret < 0)
-		return ret;
+		goto out;
 	if (ret == 0)
 		goto no_payload_free;
 
 	ret = keyctl_instantiate_key_common(id, iov, ioc, ret, ringid);
 
+out:
 	if (iov != iovstack)
 		kfree(iov);
 	return ret;
-- 
1.7.9.5

