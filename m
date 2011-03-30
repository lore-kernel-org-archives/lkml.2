Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab1C3UTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:19:09 -0400
Received: from ist.d-labs.de ([213.239.218.44]:45247 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab1C3UTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:19:07 -0400
From: Florian Mickler <florian@mickler.org>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Lee, Chun-Yi" <jlee@novell.com>,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH] acer-wmi: does not set persistence state by rfkill_init_sw_state
Date: Wed, 30 Mar 2011 22:17:57 +0200
Message-Id: <1301516277-1752-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <joeyli.kernel@gmail.com>

Acer BIOS keeps devices state when system reboot, but reset to default
device states (Wlan on, Bluetooth off, wwan on) if system cold boot.
That means BIOS's initial state is not always real persistence.

So, removed rfkill_init_sw_state because it sets initial state to
persistence then replicate to other new killswitch when rfkill-input
enabled.
After removed it, acer-wmi set initial soft-block state after rfkill
register, and doesn't allow set_block until rfkill initial finished.

Reference: bko#31002
	https://bugzilla.kernel.org/show_bug.cgi?id=31002

Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Tested-by: OldÅich JedliÄka <oldium.pro@seznam.cz>
Signed-off-by: Florian Mickler <florian@mickler.org>
---

This fixes a regression, but no stable annotation was given...

Oversight? Matthew/Chun-Yi please take a look. 


 drivers/platform/x86/acer-wmi.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index d798314..652a84e 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -217,6 +217,7 @@ struct acer_debug {
 static struct rfkill *wireless_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *threeg_rfkill;
+static bool rfkill_inited;
 
 /* Each low-level interface must define at least some of the following */
 struct wmi_interface {
@@ -1157,9 +1158,13 @@ static int acer_rfkill_set(void *data, bool blocked)
 {
 	acpi_status status;
 	u32 cap = (unsigned long)data;
-	status = set_u32(!blocked, cap);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
+
+	if (rfkill_inited) {
+		status = set_u32(!blocked, cap);
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
+	}
+
 	return 0;
 }
 
@@ -1183,14 +1188,16 @@ static struct rfkill *acer_rfkill_register(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	status = get_device_status(&state, cap);
-	if (ACPI_SUCCESS(status))
-		rfkill_init_sw_state(rfkill_dev, !state);
 
 	err = rfkill_register(rfkill_dev);
 	if (err) {
 		rfkill_destroy(rfkill_dev);
 		return ERR_PTR(err);
 	}
+
+	if (ACPI_SUCCESS(status))
+		rfkill_set_sw_state(rfkill_dev, !state);
+
 	return rfkill_dev;
 }
 
@@ -1225,6 +1232,8 @@ static int acer_rfkill_init(struct device *dev)
 		}
 	}
 
+	rfkill_inited = true;
+
 	schedule_delayed_work(&acer_rfkill_work, round_jiffies_relative(HZ));
 
 	return 0;
-- 
1.7.4.1

