Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab1CaIuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:50:00 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:36016 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933027Ab1CaItz (ORCPT
	<rfc822;groupwise-jlee@novell.com:8:1>);
	Thu, 31 Mar 2011 04:49:55 -0400
Message-Id: <4D94DADF020000230002AA96@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 31 Mar 2011 02:49:51 -0600
From: "Joey Lee" <jlee@novell.com>
To: <florian@mickler.org>
Cc: <corentincj@iksaif.net>, <stable@kernel.org>, <dtor@mail.ru>,
        <mjg@redhat.com>, <johannes@sipsolutions.net>,
        <carlos@strangeworlds.co.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acer-wmi: does not set persistence state by
 rfkill_init_sw_state
References: <1301516277-1752-1-git-send-email-florian@mickler.org>
 <20110331103054.73438ab5@schatten.dmk.lab>
In-Reply-To: <20110331103054.73438ab5@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2011-03-31 於 10:30 +0200，Florian Mickler 提到：
> On Wed, 30 Mar 2011 22:17:57 +0200
> Florian Mickler <florian@mickler.org> wrote:
> 
> > From: Lee, Chun-Yi <joeyli.kernel@gmail.com>
> > 
> > Acer BIOS keeps devices state when system reboot, but reset to default
> > device states (Wlan on, Bluetooth off, wwan on) if system cold boot.
> > That means BIOS's initial state is not always real persistence.
> > 
> > So, removed rfkill_init_sw_state because it sets initial state to
> > persistence then replicate to other new killswitch when rfkill-input
> > enabled.
> > After removed it, acer-wmi set initial soft-block state after rfkill
> > register, and doesn't allow set_block until rfkill initial finished.
> > 
> > Reference: bko#31002
> > 	https://bugzilla.kernel.org/show_bug.cgi?id=31002
> > 
> > Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> > Cc: Matthew Garrett <mjg@redhat.com>
> > Cc: Dmitry Torokhov <dtor@mail.ru>
> > Cc: Corentin Chary <corentincj@iksaif.net>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > Tested-by: OldÅich JedliÄka <oldium.pro@seznam.cz>
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > ---
> > 
> > This fixes a regression, but no stable annotation was given...
> > 
> > Oversight? Matthew/Chun-Yi please take a look. 
> > 
> 
> I forgot: This is upstream
> commit 8215af019040ce9182728afee9642d8fdeb17f59 .
> 
> As for the Tested-by:, I think that's borked in git. At least I can't
> get it out of git correctly. It should be:
> Tested-by: Oldřich Jedlička <oldium.pro@seznam.cz> 
> 
> Thanks,
> Flo
> 

Oldřich's name is good in my patch, just like the following attached,
but I don't know how to fix it in git tree:


>From 09bb9cac4345b0ca69216fd2cae17f20e145128b Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@novell.com>
Date: Mon, 28 Mar 2011 14:49:15 +0800
Subject: [PATCH] acer-wmi: does not set persistence state by rfkill_init_sw_state

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
Cc: Oldřich Jedlička <oldium.pro@seznam.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 drivers/platform/x86/acer-wmi.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 5839fac..5b38ae4 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -222,6 +222,7 @@ struct acer_debug {
 static struct rfkill *wireless_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *threeg_rfkill;
+static bool rfkill_inited;
 
 /* Each low-level interface must define at least some of the following */
 struct wmi_interface {
@@ -1162,9 +1163,13 @@ static int acer_rfkill_set(void *data, bool blocked)
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
 
@@ -1188,14 +1193,16 @@ static struct rfkill *acer_rfkill_register(struct device *dev,
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
 
@@ -1230,6 +1237,8 @@ static int acer_rfkill_init(struct device *dev)
 		}
 	}
 
+	rfkill_inited = true;
+
 	schedule_delayed_work(&acer_rfkill_work, round_jiffies_relative(HZ));
 
 	return 0;
-- 
1.6.0.2




