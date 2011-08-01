Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1HAXZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab1HAXZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.811062655@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keng-Yu Lin <kengyu@canonical.com>, Matthew Garrett <mjg@redhat.com>
Subject: [22/70] Revert: "dell-laptop: Toggle the unsupported hardware killswitch"
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keng-Yu Lin <kengyu@canonical.com>

commit be65dde82a4a402e9607c2f306f343bf0912623c upstream.

This reverts commit a3d77411e8b2ad661958c1fbee65beb476ec6d70,

as it causes a mess in the wireless rfkill status on some models.
It is probably a bad idea to toggle the rfkill for all dell models
without the respect to the claim that it is hardware-controlled.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/dell-laptop.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -290,12 +290,9 @@ static int dell_rfkill_set(void *data, b
 	dell_send_request(buffer, 17, 11);
 
 	/* If the hardware switch controls this radio, and the hardware
-	   switch is disabled, don't allow changing the software state.
-	   If the hardware switch is reported as not supported, always
-	   fire the SMI to toggle the killswitch. */
+	   switch is disabled, don't allow changing the software state */
 	if ((hwswitch_state & BIT(hwswitch_bit)) &&
-	    !(buffer->output[1] & BIT(16)) &&
-	    (buffer->output[1] & BIT(0))) {
+	    !(buffer->output[1] & BIT(16))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -401,23 +398,6 @@ static const struct file_operations dell
 
 static void dell_update_rfkill(struct work_struct *ignored)
 {
-	int status;
-
-	get_buffer();
-	dell_send_request(buffer, 17, 11);
-	status = buffer->output[1];
-	release_buffer();
-
-	/* if hardware rfkill is not supported, set it explicitly */
-	if (!(status & BIT(0))) {
-		if (wifi_rfkill)
-			dell_rfkill_set((void *)1, !((status & BIT(17)) >> 17));
-		if (bluetooth_rfkill)
-			dell_rfkill_set((void *)2, !((status & BIT(18)) >> 18));
-		if (wwan_rfkill)
-			dell_rfkill_set((void *)3, !((status & BIT(19)) >> 19));
-	}
-
 	if (wifi_rfkill)
 		dell_rfkill_query(wifi_rfkill, (void *)1);
 	if (bluetooth_rfkill)


