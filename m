Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2HYIbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:31:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63490 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2HYIb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:31:28 -0400
From: Bernhard Froemel <bfroemel@gmail.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: [PATCH v2 2/2] apple-gmux: Obtain version info from indexed gmux
Date: Sat, 25 Aug 2012 10:30:49 +0200
Message-Id: <1345883449-2790-2-git-send-email-bfroemel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345883449-2790-1-git-send-email-bfroemel@gmail.com>
References: <50388C45.6030707@gmail.com>
 <1345883449-2790-1-git-send-email-bfroemel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>

This patch extracts and displays version information from the indexed
gmux device as it is also done for the classic gmux device.

Signed-off-by: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
---
 drivers/platform/x86/apple-gmux.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index c38538e..0e43477 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -463,18 +463,22 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
 	ver_release = gmux_read8(gmux_data, GMUX_PORT_VERSION_RELEASE);
 	if (ver_major == 0xff && ver_minor == 0xff && ver_release == 0xff) {
 		if (gmux_is_indexed(gmux_data)) {
+			u32 version;
 			mutex_init(&gmux_data->index_lock);
 			gmux_data->indexed = true;
+			version = gmux_read32(gmux_data,
+				GMUX_PORT_VERSION_MAJOR);
+			ver_major = (version >> 24) & 0xff;
+			ver_minor = (version >> 16) & 0xff;
+			ver_release = (version >> 8) & 0xff;
 		} else {
 			pr_info("gmux device not present\n");
 			ret = -ENODEV;
 			goto err_release;
 		}
-		pr_info("Found indexed gmux\n");
-	} else {
-		pr_info("Found gmux version %d.%d.%d\n", ver_major, ver_minor,
-			ver_release);
 	}
+	pr_info("Found gmux version %d.%d.%d [%s]\n", ver_major, ver_minor,
+		ver_release, (gmux_data->indexed ? "indexed" : "classic"));
 
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_PLATFORM;
-- 
1.7.9.5

