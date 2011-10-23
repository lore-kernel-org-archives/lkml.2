Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1JWGgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:36:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab1JWGeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:16 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:39 2011
Message-Id: <20111023062538.869936744@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:38 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@redhat.com>
Subject: [10/27] HID: magicmouse: ignore ivalid report id while switching modes, v2
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 35d851df23b093ee027f827fed2213ae5e88fc7a upstream.

This is basically a more generic respin of 23746a6 ("HID: magicmouse: ignore
'ivalid report id' while switching modes") which got reverted later by
c3a492.

It turns out that on some configurations, this is actually still the case
and we are not able to detect in runtime.

The device reponds with 'invalid report id' when feature report switching it
into multitouch mode is sent to it.

This has been silently ignored before 0825411ade ("HID: bt: Wait for ACK
on Sent Reports"), but since this commit, it propagates -EIO from the _raw
callback .

So let the driver ignore -EIO as response to 0xd7,0x01 report, as that's
how the device reacts in normal mode.

Sad, but following reality.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=35022

Reported-by: Chase Douglas <chase.douglas@canonical.com>
Reported-by: Jaikumar Ganesh <jaikumarg@android.com>
Tested-by: Chase Douglas <chase.douglas@canonical.com>
Tested-by: Jaikumar Ganesh <jaikumarg@android.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-magicmouse.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -501,9 +501,17 @@ static int magicmouse_probe(struct hid_d
 	}
 	report->size = 6;
 
+	/*
+	 * Some devices repond with 'invalid report id' when feature
+	 * report switching it into multitouch mode is sent to it.
+	 *
+	 * This results in -EIO from the _raw low-level transport callback,
+	 * but there seems to be no other way of switching the mode.
+	 * Thus the super-ugly hacky success check below.
+	 */
 	ret = hdev->hid_output_raw_report(hdev, feature, sizeof(feature),
 			HID_FEATURE_REPORT);
-	if (ret != sizeof(feature)) {
+	if (ret != -EIO && ret != sizeof(feature)) {
 		hid_err(hdev, "unable to request touch data (%d)\n", ret);
 		goto err_stop_hw;
 	}


