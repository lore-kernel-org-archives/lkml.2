Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267Ab2CWAIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:08:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20237 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2CWAIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:08:35 -0400
Date: Fri, 23 Mar 2012 01:08:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] drivers/platform/x86/amilo-rfkill.c::amilo_rfkill_probe()
 avoid NULL deref
Message-ID: <alpine.LNX.2.00.1203230107100.2935@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/platform/x86/amilo-rfkill.c::amilo_rfkill_probe() the call
to dmi_first_match() may fail and return NULL. If it does return NULL,
then we'll be dereferencing a NULL pointer in the rfkill_alloc() call
where we do 'system_id->driver_data' --> KABOOM!

Avoid that problem by testing for a NULL return value from
dmi_first_match() and bailing out if it fails.

I was a bit uncertain about what to return in the failure case. In the
end I settled for -ENXIO as the most logical error to return.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/platform/x86/amilo-rfkill.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

 Compile tested only since I have no real way to test this.

diff --git a/drivers/platform/x86/amilo-rfkill.c b/drivers/platform/x86/amilo-rfkill.c
index 19170bb..a514bf6 100644
--- a/drivers/platform/x86/amilo-rfkill.c
+++ b/drivers/platform/x86/amilo-rfkill.c
@@ -97,9 +97,12 @@ static struct rfkill *amilo_rfkill_dev;
 
 static int __devinit amilo_rfkill_probe(struct platform_device *device)
 {
+	int rc;
 	const struct dmi_system_id *system_id =
 		dmi_first_match(amilo_rfkill_id_table);
-	int rc;
+
+	if (!system_id)
+		return -ENXIO;
 
 	amilo_rfkill_dev = rfkill_alloc(KBUILD_MODNAME, &device->dev,
 					RFKILL_TYPE_WLAN,
-- 
1.7.9.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

