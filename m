Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0JPWaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:30:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48999 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab0JPWaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:30:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        steven miao <realmz6@gmail.com>
Subject: [PATCH] bluetooth: fix unaligned access to l2cap conf data
Date: Sat, 16 Oct 2010 18:29:47 -0400
Message-Id: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: steven miao <realmz6@gmail.com>

In function l2cap_get_conf_opt() and l2cap_add_conf_opt() the address of
opt->val sometimes is not at the edge of 2-bytes/4-bytes, so 2-bytes/4 bytes
access will cause data misalignment exeception.  Use get_unaligned_le16/32
and put_unaligned_le16/32 function to avoid data misalignment execption.

Signed-off-by: steven miao <realmz6@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
was posted a month ago with no feedback ...

 net/bluetooth/l2cap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 0b54b7d..65bcdc1 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -2401,11 +2401,11 @@ static inline int l2cap_get_conf_opt(void **ptr, int *type, int *olen, unsigned
 		break;
 
 	case 2:
-		*val = __le16_to_cpu(*((__le16 *) opt->val));
+		*val = get_unaligned_le16(opt->val);
 		break;
 
 	case 4:
-		*val = __le32_to_cpu(*((__le32 *) opt->val));
+		*val = get_unaligned_le32(opt->val);
 		break;
 
 	default:
@@ -2432,11 +2432,11 @@ static void l2cap_add_conf_opt(void **ptr, u8 type, u8 len, unsigned long val)
 		break;
 
 	case 2:
-		*((__le16 *) opt->val) = cpu_to_le16(val);
+		put_unaligned_le16(cpu_to_le16(val), opt->val);
 		break;
 
 	case 4:
-		*((__le32 *) opt->val) = cpu_to_le32(val);
+		put_unaligned_le32(cpu_to_le32(val), opt->val);
 		break;
 
 	default:
-- 
1.7.3.1

