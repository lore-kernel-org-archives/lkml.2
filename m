Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3AGSva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:51:30 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58330 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104Ab3AGSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:51:26 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 2/5] capemgr: Add beaglebone's cape driver bindings
Date: Mon,  7 Jan 2013 20:51:03 +0200
Message-Id: <1357584666-17374-3-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the beaglebone's cape driver bindings.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 .../devicetree/bindings/misc/capes-beaglebone.txt  | 110 +++++++++++++++++++++
 1 file changed, 110 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/capes-beaglebone.txt

diff --git a/Documentation/devicetree/bindings/misc/capes-beaglebone.txt b/Documentation/devicetree/bindings/misc/capes-beaglebone.txt
new file mode 100644
index 0000000..f73cab5
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/capes-beaglebone.txt
@@ -0,0 +1,110 @@
+* TI Beaglebone DT Overlay Cape Driver
+
+Required properties:
+
+- compatible: "ti,bone-capemgr"
+
+- eeprom: Contains the phandle beaglebone's baseboard i2c eeprom.
+
+- baseboardmaps - node containing a list of supported
+	beaglebone revisions; each node in should have the
+	following properties:
+	- board-name: The board name stored in the baseboard
+		eeprom.
+	- compatible-name: The name which will be used for
+		matching compatible capes.
+
+- slots: node containing a list of slot nodes (which in the beaglebone
+	case correspond to I2C addresses for dynamically probed capes,
+	or an override slot definition for hardcoded capes.
+	- eeprom: Contains the phandle beaglebone's cape i2c eeprom.
+
+	It is possible to define override slots that will be activated
+	when the baseboard matches, and/or if supplied on the kernel command
+	line and/or when dynamically requested on runtime.
+	In that case the slot is marked with
+	- ti,cape-override: Marks a slot override.
+	- compatible: any of the "runtime", "kernel", or any compatible-name
+	  on a matching baseboardmap node.
+	- Any of the eeprom-format-revision, board-name, version, manufacturer,
+	  part-number, number-of-pins, serial-number, pin-usage, vdd-3v3exp,
+	  vdd-5v, sys-5v, dc-supplied properties which fill in the simulated
+	  cape's EEPROM fields. The part-number field is required, the rest
+	  are optional taking into default values.
+
+- capemaps: node contains list of cape mappings, which allow converting
+	from a part-number & version tuple to the filename of the dtbo file.
+	- part-number: part number contained in the EEPROM
+	- version node containing a
+		- version: specific version to map to
+		- dtbo: name of the dtbo file 
+
+Example:
+bone_capemgr {
+	compatible = "ti,bone-capemgr";
+	status = "okay";
+
+	eeprom = <&baseboard_eeprom>;
+
+	baseboardmaps {
+		baseboard_beaglebone: board@0 {
+			board-name = "A335BONE";
+			compatible-name = "ti,beaglebone";
+		};
+	};
+
+	slots {
+		slot@0 {
+			eeprom = <&cape_eeprom0>;
+		};
+
+		slot@1 {
+			eeprom = <&cape_eeprom1>;
+		};
+
+		slot@2 {
+			eeprom = <&cape_eeprom2>;
+		};
+
+		slot@3 {
+			eeprom = <&cape_eeprom3>;
+		};
+	};
+
+	/* mapping between board names and dtb objects */
+	capemaps {
+		/* Weather cape */
+		cape@0 {
+			part-number = "BB-BONE-WTHR-01";
+			version@00A0 {
+				version = "00A0";
+				dtbo = "cape-bone-weather-00A0.dtbo";
+			};
+		};
+	};
+};
+
+Example of the override syntax when used on a bone compatible foo board.
+
+{
+	...
+
+	baseboardmaps {
+		...
+		baseboard_beaglebone: board@0 {
+			board-name = "A335FOO";
+			compatible-name = "ti,foo";
+		};
+
+		slot@6 {
+			ti,cape-override;
+			compatible = "ti,foo";
+			board-name = "FOO-hardcoded";
+			version = "00A0";
+			manufacturer = "Texas Instruments";
+			part-number = "BB-BONE-FOO-01";
+		};
+	};
+
+};
+	
-- 
1.7.12

