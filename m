Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab0GGVvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:51:36 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:34453 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab0GGVu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=kZqDPx0Zo7MrR9lO7NpuOUBnIU3v03kz+
	/swc5ijMHpUuYuPGxf628Yej+THe6e3Xidx0aOez2aL4gMnV5/JjOD7e2ar1Orhn
	ImNxBP5xFrkj0Z4RR1znyrav/G5RSpip+VK/OvxtVvMXTnlhPhauIvxW9SZQUsNy
	YO27bSyb9w=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH v3 08/10] ceph-rbd: osdc support for osd call and rollback operations
Date: Wed,  7 Jul 2010 15:11:30 -0700
Message-Id: <b3af48c166286125b5b43faeec3c88def78c5a02.1278539315.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used for rbd snapshots administration.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/decode.h     |    5 +++++
 fs/ceph/osd_client.c |   22 ++++++++++++++++++++++
 fs/ceph/osd_client.h |    6 ++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/ceph/decode.h b/fs/ceph/decode.h
index 65b3e02..5f2d803 100644
--- a/fs/ceph/decode.h
+++ b/fs/ceph/decode.h
@@ -189,6 +189,11 @@ static inline void ceph_encode_string(void **p, void *end,
 		ceph_encode_need(p, end, n, bad);		\
 		ceph_encode_copy(p, pv, n);			\
 	} while (0)
+#define ceph_encode_string_safe(p, end, s, n, bad)		\
+	do {							\
+		ceph_encode_need(p, end, n, bad);		\
+		ceph_encode_string(p, end, s, n);		\
+	} while (0)
 
 
 #endif
diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
index 1cb9533..8b718cb 100644
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -136,6 +136,7 @@ static int op_needs_trail(int op)
 	case CEPH_OSD_OP_GETXATTR:
 	case CEPH_OSD_OP_SETXATTR:
 	case CEPH_OSD_OP_CMPXATTR:
+	case CEPH_OSD_OP_CALL:
 		return 1;
 	default:
 		return 0;
@@ -286,6 +287,27 @@ static void osd_req_encode_op(struct ceph_osd_request *req,
 		dst->payload_len = cpu_to_le32(src->xattr.name_len +
 					       src->xattr.value_len);
 		break;
+	case CEPH_OSD_OP_CALL:
+		BUG_ON(!req->r_trail);
+
+		dst->cls.class_len = src->cls.class_len;
+		dst->cls.method_len = src->cls.method_len;
+		dst->cls.indata_len = cpu_to_le32(src->cls.indata_len);
+
+		ceph_pagelist_append(req->r_trail, src->cls.class_name,
+				     src->cls.class_len);
+		ceph_pagelist_append(req->r_trail, src->cls.method_name,
+				     src->cls.method_len);
+		ceph_pagelist_append(req->r_trail, src->cls.indata,
+				     src->cls.indata_len);
+		dst->payload_len = cpu_to_le32(src->cls.class_len + 
+					       src->cls.method_len +
+					       src->cls.indata_len);
+
+		break;
+	case CEPH_OSD_OP_ROLLBACK:
+		dst->snap.snapid = cpu_to_le64(src->snap.snapid);
+		break;
 	}
 	dst->payload_len = cpu_to_le32(src->payload_len);
 }
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index 38c4615..979efce 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -135,14 +135,20 @@ struct ceph_osd_req_op {
 			__u8 cmp_mode;     /* CEPH_OSD_CMPXATTR_MODE_* */
 		} xattr;
 		struct {
+			const char *class_name;
 			__u8 class_len;
+			const char *method_name;
 			__u8 method_len;
 			__u8 argc;
+			const char *indata;
 			u32 indata_len;
 		} cls;
 		struct {
 			u64 cookie, count;
 		} pgls;
+	        struct {
+		        u64 snapid;
+	        } snap;
 	};
 	u32 payload_len;
 };
-- 
1.5.6.5

