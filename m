Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2LRVEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:04:55 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42508 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2LRVEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:04:54 -0500
Date: Tue, 18 Dec 2012 13:04:49 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] firmware: make sure paths remain relative
Message-ID: <20121218210449.GA3329@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices have configurable firmware locations. If these configuration
mechanisms are exposed to unprivileged userspace, it may be possible to
load firmware from an unexpected location. To minimize the risk of this,
make sure the string "../" does not appear in the firmware name. This
means that neither the users of request_firmware, nor the uevent handler
have to do this filtering themselves.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Ming Lei <ming.lei@canonical.com>
---
v2:
 - add dev_err on failure, suggested by Ming Lei.
---
 drivers/base/firmware_class.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d814603..b7e095b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -814,6 +814,12 @@ _request_firmware_prepare(const struct firmware **firmware_p, const char *name,
 	if (!firmware_p)
 		return ERR_PTR(-EINVAL);
 
+	if (strstr(name, "../")) {
+		dev_err(device, "%s: parent directory in firmware name (%s)\n",
+			__func__, name);
+		return ERR_PTR(-EINVAL);
+	}
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
