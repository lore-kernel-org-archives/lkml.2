Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743Ab2E0BQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:16:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933929Ab2E0BQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:16:17 -0400
Message-Id: <20120527002513.857624990@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:38 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [ 32/91] USB: cdc-wdm: fix memory leak
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 2f338c8a1904e2e7aa5a8bd12fb0cf2422d17da4 upstream.

cleanup() is not called if the last close() comes after
disconnect(). That leads to a memory leak. Rectified
by checking for an earlier disconnect() in release()

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -625,6 +625,8 @@ static int wdm_release(struct inode *ino
 		kill_urbs(desc);
 		if (!test_bit(WDM_DISCONNECTING, &desc->flags))
 			desc->manage_power(desc->intf, 0);
+		else
+			cleanup(desc);
 	}
 	mutex_unlock(&wdm_mutex);
 	return 0;


