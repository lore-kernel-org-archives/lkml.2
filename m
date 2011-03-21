Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1CUXTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:19:10 -0400
Received: from kroah.org ([198.145.64.141]:52850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab1CUXSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:29 2011
Message-Id: <20110321230329.612836554@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>,
        Kevin Hilman <khilman@ti.com>
Subject: [77/78] davinci: DM644x EVM: register MUSB device earlier
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 60d97a840175d3becb2e6de36537a5cdfc0ec3a9 upstream.

The MUSB driver doesn't see its platform device on DM644x EVM board anymore
since commit 73b089b052a69020b953312a624a6e1eb5b81fab (usb: musb: split davinci
to its own platform_driver) because the new probe is called as subsys_initcall()
now, and the device is registered later than that by the board code.  Move the
registration to davinci_evm_init() -- it's safe to do so because the MUSB core
device still gets initialized as fs_initcall() -- which is late enough for the
I2C GPIO expander (which controls VBUS) to be initialized.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Tested-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-davinci/board-dm644x-evm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -440,11 +440,6 @@ evm_u35_setup(struct i2c_client *client,
 	gpio_request(gpio + 7, "nCF_SEL");
 	gpio_direction_output(gpio + 7, 1);
 
-	/* irlml6401 switches over 1A, in under 8 msec;
-	 * now it can be managed by nDRV_VBUS ...
-	 */
-	davinci_setup_usb(1000, 8);
-
 	return 0;
 }
 
@@ -705,6 +700,9 @@ static __init void davinci_evm_init(void
 	davinci_serial_init(&uart_config);
 	dm644x_init_asp(&dm644x_evm_snd_data);
 
+	/* irlml6401 switches over 1A, in under 8 msec */
+	davinci_setup_usb(1000, 8);
+
 	soc_info->emac_pdata->phy_id = DM644X_EVM_PHY_ID;
 	/* Register the fixup for PHY on DaVinci */
 	phy_register_fixup_for_uid(LXT971_PHY_ID, LXT971_PHY_MASK,


