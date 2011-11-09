Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936110Ab1KJERq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:17:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965205Ab1KJDlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:41:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:55 2011
Message-Id: <20111109213155.590760942@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dtor@mail.ru>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>
Subject: [134/264] WMI: properly cleanup devices to avoid crashes
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 023b9565972a4a5e0f01b9aa32680af6e9b5c388 upstream.

We need to remove devices that we destroy from the list, otherwise
we'll crash if there are more than one "_WDG" methods in DSDT.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=32052

Tested-by: Ilya Tumaykin <librarian_rus@yahoo.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/wmi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -754,9 +754,13 @@ static void wmi_free_devices(void)
 	struct wmi_block *wblock, *next;
 
 	/* Delete devices for all the GUIDs */
-	list_for_each_entry_safe(wblock, next, &wmi_block_list, list)
+	list_for_each_entry_safe(wblock, next, &wmi_block_list, list) {
+		list_del(&wblock->list);
 		if (wblock->dev.class)
 			device_unregister(&wblock->dev);
+		else
+			kfree(wblock);
+	}
 }
 
 static bool guid_already_parsed(const char *guid_string)


