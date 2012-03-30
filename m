Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613Ab2C3WBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:01:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935985Ab2C3VRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:22 -0400
Message-Id: <20120330194827.911922971@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>,
        Adrian <agib@gmx.de>, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [ 015/175] staging: r8712u: Fix regression introduced by commit a5ee652
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9f4bc8cf3fe750ed093856a5f5d41c11cc12ad22 upstream.

In commit a5ee652 "staging: r8712u: Interface-state not fully tracked",
the private boolean "bup" was set false when the interface was brought down,
as that seemed appropriate. This change has not caused any problems when
using NetworkManager or manual control of the device; however, when wicd
control is used, there is a locking problem in wpa_supplicant, as shown in
https://bugzilla.kernel.org/show_bug.cgi?id=42818.

This fix reverts the only code change in commit a5ee652. My
analysis is that "bup" is badly named. In its present form, it
seems to indicate the up/down state of the device, but its usage
is more consistent with an initialized/uninitialized state. That
problem will be addressed in a later patch.

Note: Commit 8c213fa, which introdued asynchronous firmware loading
for this driver, exposed this bug to a greater extent. That bug
is addressed in the next patch in this series.

This bug is also responsible for the bug in
https://bugzilla.kernel.org/show_bug.cgi?id=42815. and this bug is
also part of the problems discussed at https://bugs.archlinux.org/task/27996#comment89950.

Tested-by: Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>
Tested-by: Adrian <agib@gmx.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/os_intfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -476,8 +476,6 @@ static int netdev_close(struct net_devic
 	r8712_free_assoc_resources(padapter);
 	/*s2-4.*/
 	r8712_free_network_queue(padapter);
-	/* The interface is no longer Up: */
-	padapter->bup = false;
 	release_firmware(padapter->fw);
 	/* never exit with a firmware callback pending */
 	wait_for_completion(&padapter->rtl8712_fw_ready);


