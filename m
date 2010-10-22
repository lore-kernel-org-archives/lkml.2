Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0JVTXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:23:35 -0400
Received: from kroah.org ([198.145.64.141]:33939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759197Ab0JVSz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.402222397@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [012/103] HID: hidraw, fix a NULL pointer dereference in hidraw_write
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Antonio Ospite <ospite@studenti.unina.it>

commit e42dee9a99a3ecd32b5c027e8f7411fb5bc11eb6 upstream.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa0f0a625>] hidraw_write+0x3b/0x116 [hid]
[...]

This is reproducible by disconnecting the device while userspace writes
to dev node in a loop and doesn't check return values in order to exit
the loop.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hidraw.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -111,6 +111,12 @@ static ssize_t hidraw_write(struct file
 	int ret = 0;
 
 	mutex_lock(&minors_lock);
+
+	if (!hidraw_table[minor]) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	dev = hidraw_table[minor]->hid;
 
 	if (!dev->hid_output_raw_report) {


