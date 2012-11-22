Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2KVVDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:03:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:11680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab2KVS4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="250957811"
Subject: [PATCH] serial:ifx6x60:Delete SPI timer when shut down port
From: chao bi <chao.bi@intel.com>
To: alan@linux.intel.com
Cc: richardx.r.gorby@intel.com, jun.d.chen@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Nov 2012 16:43:07 +0800
Message-ID: <1353573787.22077.8.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When shut down SPI port, it's possible that MRDY has been asserted and a SPI
timer was activated waiting for SRDY assert, in the case, it needs to delete
this timer.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
Signed-off-by: channing <chao.bi@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 5b9bc19..467020b 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -552,7 +552,10 @@ static void ifx_port_shutdown(struct tty_port *port)
 		container_of(port, struct ifx_spi_device, tty_port);
 
 	mrdy_set_low(ifx_dev);
-	clear_bit(IFX_SPI_STATE_TIMER_PENDING, &ifx_dev->flags);
+	if (test_and_clear_bit(IFX_SPI_STATE_TIMER_PENDING,
+		&ifx_dev->flags)) {
+		del_timer(&ifx_dev->spi_timer);
+	}
 	tasklet_kill(&ifx_dev->io_work_tasklet);
 }
 
-- 
1.7.1



