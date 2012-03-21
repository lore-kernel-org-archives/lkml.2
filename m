Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333Ab2CUVTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:19:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44688 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247Ab2CUVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:18:55 -0400
Message-Id: <20120321211533.461417061@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:15:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clemens Eisserer <linuxhippy@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 8/9] iwl3945: fix possible il->txq NULL pointer dereference in delayed works
In-Reply-To: <20120321211539.GA28899@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 210787e82a0ac1ffb5d7be1c796f0c51050849ad upstream.

On il3945_down procedure we free tx queue data and nullify il->txq
pointer. After that we drop mutex and then cancel delayed works. There
is possibility, that after drooping mutex and before the cancel, some
delayed work will start and crash while trying to send commands to
the device. For example, here is reported crash in
il3945_bg_reg_txpower_periodic():
https://bugzilla.kernel.org/show_bug.cgi?id=42766#c10

Patch fix problem by adding il->txq check on works that send commands,
hence utilize tx queue.

Reported-by: Clemens Eisserer <linuxhippy@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>



---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    7 ++++---
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -1870,11 +1870,12 @@ static void iwl3945_bg_reg_txpower_perio
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 					     _3945.thermal_periodic.work);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
 	mutex_lock(&priv->mutex);
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) || priv->txq == NULL)
+		goto out;
+
 	iwl3945_reg_txpower_periodic(priv);
+out:
 	mutex_unlock(&priv->mutex);
 }
 
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -2513,7 +2513,7 @@ static void iwl3945_bg_alive_start(struc
 	    container_of(data, struct iwl_priv, alive_start.work);
 
 	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) || priv->txq == NULL)
 		goto out;
 
 	iwl3945_alive_start(priv);


