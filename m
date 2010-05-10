Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab0EJXnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:43:14 -0400
Received: from kroah.org ([198.145.64.141]:32946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0EJWvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223319.101913409@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [021/117] sfc: Change falcon_probe_board() to fail for unsupported boards
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit e41c11ee0cc602bcde68916be85fb97d1a484324 upstream.

The driver needs specific PHY and board support code for each SFC4000
board; there is no point trying to continue if it is missing.
Currently unsupported boards can trigger an 'oops'.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sfc/falcon.c        |    4 +++-
 drivers/net/sfc/falcon_boards.c |   13 +++----------
 drivers/net/sfc/nic.h           |    2 +-
 3 files changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/net/sfc/falcon.c
+++ b/drivers/net/sfc/falcon.c
@@ -1317,7 +1317,9 @@ static int falcon_probe_nvconfig(struct
 
 	EFX_LOG(efx, "PHY is %d phy_id %d\n", efx->phy_type, efx->mdio.prtad);
 
-	falcon_probe_board(efx, board_rev);
+	rc = falcon_probe_board(efx, board_rev);
+	if (rc)
+		goto fail2;
 
 	kfree(nvconfig);
 	return 0;
--- a/drivers/net/sfc/falcon_boards.c
+++ b/drivers/net/sfc/falcon_boards.c
@@ -728,15 +728,7 @@ static const struct falcon_board_type bo
 	},
 };
 
-static const struct falcon_board_type falcon_dummy_board = {
-	.init		= efx_port_dummy_op_int,
-	.init_phy	= efx_port_dummy_op_void,
-	.fini		= efx_port_dummy_op_void,
-	.set_id_led	= efx_port_dummy_op_set_id_led,
-	.monitor	= efx_port_dummy_op_int,
-};
-
-void falcon_probe_board(struct efx_nic *efx, u16 revision_info)
+int falcon_probe_board(struct efx_nic *efx, u16 revision_info)
 {
 	struct falcon_board *board = falcon_board(efx);
 	u8 type_id = FALCON_BOARD_TYPE(revision_info);
@@ -754,8 +746,9 @@ void falcon_probe_board(struct efx_nic *
 			 (efx->pci_dev->subsystem_vendor == EFX_VENDID_SFC)
 			 ? board->type->ref_model : board->type->gen_type,
 			 'A' + board->major, board->minor);
+		return 0;
 	} else {
 		EFX_ERR(efx, "unknown board type %d\n", type_id);
-		board->type = &falcon_dummy_board;
+		return -ENODEV;
 	}
 }
--- a/drivers/net/sfc/nic.h
+++ b/drivers/net/sfc/nic.h
@@ -156,7 +156,7 @@ extern struct efx_nic_type siena_a0_nic_
  **************************************************************************
  */
 
-extern void falcon_probe_board(struct efx_nic *efx, u16 revision_info);
+extern int falcon_probe_board(struct efx_nic *efx, u16 revision_info);
 
 /* TX data path */
 extern int efx_nic_probe_tx(struct efx_tx_queue *tx_queue);


