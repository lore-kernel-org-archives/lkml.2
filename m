Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1CHQH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:07:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1CHQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VN6HJGPPK2r9ULFY0jiCGlB2aWXTG9j19jOqpZ3/Gi7OhrUmiyAnZDAj5gQQYtl5Br
         8W2ealfXsZ2znO2W+QYh41GV+XGVvcnFtHpFmhHnqz6zquNVTDa02mGw8Ly5Lz5RXIyU
         uMwJV8q74fqzgLjIsoXPXTpg67JNVRKkchy8s=
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 00:07:54 +0800
Message-ID: <AANLkTinN=eYJB3wF9jw7vbbTtUgOzr8oap4+i21Uei5X@mail.gmail.com>
Subject: [2.6.38-rc8, patch] fix hci_dev_list locking
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No response from original post, and it missed getting taken into -rc7
and -rc8, so repost:

Release acquired lock on error path, fixing potential hang up.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index f827fd9..ace8726 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -111,8 +111,10 @@ static int read_index_list(struct sock *sk)

 	body_len = sizeof(*ev) + sizeof(*rp) + (2 * count);
 	skb = alloc_skb(sizeof(*hdr) + body_len, GFP_ATOMIC);
-	if (!skb)
+	if (!skb) {
+		read_unlock(&hci_dev_list_lock);
 		return -ENOMEM;
+	}

 	hdr = (void *) skb_put(skb, sizeof(*hdr));
 	hdr->opcode = cpu_to_le16(MGMT_EV_CMD_COMPLETE);--
-- 
Daniel J Blueman
