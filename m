Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1DLOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:38 -0400
Received: from kroah.org ([198.145.64.141]:57677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab1DLOic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143555.451487228@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [070/105] wl12xx: fix potential buffer overflow in testmode nvs push
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luciano Coelho <coelho@ti.com>

commit 09b661b33268698d3b453dceb78cda129ad899b4 upstream.

We were allocating the size of the NVS file struct and not checking
whether the length of the buffer passed was correct before copying it
into the allocated memory.  This is a security hole because buffer
overflows can occur if the userspace passes a bigger file than what is
expected.

With this patch, we check if the size of the data passed from
userspace matches the size required.

This bug was introduced in 2.6.36.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/testmode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -204,7 +204,10 @@ static int wl1271_tm_cmd_nvs_push(struct
 
 	kfree(wl->nvs);
 
-	wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	if (len != sizeof(struct wl1271_nvs_file))
+		return -EINVAL;
+
+	wl->nvs = kzalloc(len, GFP_KERNEL);
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
 		ret = -ENOMEM;


