Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1I1Wj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab1I1Wjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220128.509316247@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [031/244] carl9170: Fix mismatch in carl9170_op_set_key mutex lock-unlock
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 66cb54bd24086b2d871a03035de9b0e79b2b725e upstream.

If is_main_vif(ar, vif) reports that we have to fall back
to software encryption, we goto err_softw; before locking ar->mutex.
As a result, we have unprotected call to carl9170_set_operating_mode
and unmatched mutex_unlock.

The patch fix the issue by adding mutex_lock before goto.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-By: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/carl9170/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1066,8 +1066,10 @@ static int carl9170_op_set_key(struct ie
 	 * the high througput speed in 802.11n networks.
 	 */
 
-	if (!is_main_vif(ar, vif))
+	if (!is_main_vif(ar, vif)) {
+		mutex_lock(&ar->mutex);
 		goto err_softw;
+	}
 
 	/*
 	 * While the hardware supports *catch-all* key, for offloading


