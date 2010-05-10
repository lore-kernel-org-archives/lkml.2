Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab0EJXnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:43:42 -0400
Received: from kroah.org ([198.145.64.141]:32937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab0EJWvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:49 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223318.920040672@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [019/117] sfc: Wait at most 10ms for the MC to finish reading out MAC statistics
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit aabc5649078310094cbffb430fcbf9c25b6268f9 upstream.

The original code would wait indefinitely if MAC stats DMA failed.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sfc/siena.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/sfc/siena.c
+++ b/drivers/net/sfc/siena.c
@@ -454,8 +454,17 @@ static int siena_try_update_nic_stats(st
 
 static void siena_update_nic_stats(struct efx_nic *efx)
 {
-	while (siena_try_update_nic_stats(efx) == -EAGAIN)
-		cpu_relax();
+	int retry;
+
+	/* If we're unlucky enough to read statistics wduring the DMA, wait
+	 * up to 10ms for it to finish (typically takes <500us) */
+	for (retry = 0; retry < 100; ++retry) {
+		if (siena_try_update_nic_stats(efx) == 0)
+			return;
+		udelay(100);
+	}
+
+	/* Use the old values instead */
 }
 
 static void siena_start_nic_stats(struct efx_nic *efx)


