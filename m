Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab2LMOKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:10:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44765 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab2LMOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 160/241] HID: microsoft: do not use compound literal - fix build
Date: Thu, 13 Dec 2012 11:58:45 -0200
Message-Id: <1355407206-17100-161-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 6b90466cfec2a2fe027187d675d8d14217c12d82 upstream.

In patch "HID: microsoft: fix invalid rdesc for 3k kbd" I fixed
support for MS 3k keyboards. However the added check using memcmp and
a compound statement breaks build on architectures where memcmp is a
macro with parameters.

hid-microsoft.c:51:18: error: macro "memcmp" passed 6 arguments, but takes just 3

On x86_64, memcmp is a function, so I did not see the error.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/hid/hid-microsoft.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 3899989..259b9f4 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -47,9 +47,9 @@ static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		rdesc[559] = 0x45;
 	}
 	/* the same as above (s/usage/physical/) */
-	if ((quirks & MS_RDESC_3K) && *rsize == 106 &&
-			!memcmp((char []){ 0x19, 0x00, 0x29, 0xff },
-				&rdesc[94], 4)) {
+	if ((quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
+			rdesc[95] == 0x00 && rdesc[96] == 0x29 &&
+			rdesc[97] == 0xff) {
 		rdesc[94] = 0x35;
 		rdesc[96] = 0x45;
 	}
-- 
1.7.9.5

