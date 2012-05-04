Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2EDUrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:47:52 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab2EDUrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:47 -0400
Message-Id: <20120504204229.925284230@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 65/75] b43: only reload config after successful initialization
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit dbdedbdf4fbff3d4962a0786f37aa86dfdc48a7e upstream.

Commit 2a19032 (b43: reload phy and bss settings after core restarts)
introduced an unconditional call to b43_op_config() at the end of
b43_op_start(). When firmware fails to load this can wedge the system.
There's no need to reload the configuration after a failed
initialization anyway, so only make the call if initialization was
successful.

BugLink: http://bugs.launchpad.net/bugs/950295
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43/main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4841,8 +4841,14 @@ static int b43_op_start(struct ieee80211
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
-	/* reload configuration */
-	b43_op_config(hw, ~0);
+	/*
+	 * Configuration may have been overwritten during initialization.
+	 * Reload the configuration, but only if initialization was
+	 * successful. Reloading the configuration after a failed init
+	 * may hang the system.
+	 */
+	if (!err)
+		b43_op_config(hw, ~0);
 
 	return err;
 }


