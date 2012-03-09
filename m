Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab2CISOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:14:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52272 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2CISOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:14:42 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] dt: pinctrl: Document device tree binding
Date: Fri,  9 Mar 2012 11:14:33 -0700
Message-Id: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core pin controller bindings define:
* The fact that pin controllers expose pin configurations as nodes in
  device tree.
* That the bindings for those pin configuration nodes is defined by the
  individual pin controller drivers.
* A standardized set of properties for client devices to define numbered
  or named pin configuration states, each referring to some number of the
  afore-mentioned pin configuration nodes.
* That the bindings for the client devices determines the set of numbered
  or named states that must exist.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 .../bindings/pinctrl/pinctrl-bindings.txt          |  118 ++++++++++++++++++++
 1 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
new file mode 100644
index 0000000..cce9f01
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -0,0 +1,118 @@
+== Introduction ==
+
+Hardware modules that control pin multiplexing or configuration parameters
+such as pull-up/down, tri-state, drive-strength etc are designated as pin
+controllers. Each pin controller must be represented as a node in device tree,
+just like any other hardware module.
+
+Hardware modules whose signals are affected by pin configuration are
+designated client devices. Again, each client device must be represented as a
+node in device tree, just like any other hardware module.
+
+For a client device to operate correctly, certain pin controllers must
+set up certain specific pin configurations. Some client devices need a
+single static pin configuration, e.g. set up during initialization. Others
+need to reconfigure pins at run-time, for example to tri-state pins when the
+device is inactive. Hence, each client device can define a set of named
+states. The number and names of those states is defined by the client device's
+own binding.
+
+The common pinctrl bindings defined in this file provide an infra-structure
+for client device device tree nodes to map those state names to the pin
+configuration used by those states.
+
+Note that pin controllers themselves may also be client devices of themselves.
+For example, a pin controller may set up its own "active" state when the
+driver loads. This would allow representing a board's static pin configuration
+in a single place, rather than splitting it across multiple client device
+nodes. The decision to do this or not somewhat rests with the author of
+individual board device tree files, and any requirements imposed by the
+bindings for the individual client devices in use by that board, i.e. whether
+they require certain specific named states for dynamic pin configuration.
+
+== Pinctrl client devices ==
+
+For each client device individually, every pin state is assigned an integer
+ID. These numbers start at 0, and are contiguous. For each state ID, a unique
+property exists to define the pin configuration. Each state may also be
+assigned a name. When names are used, another property exists to map from
+those names to the integer IDs.
+
+Each client device's own binding determines the set of states the must be
+defined in its device tree node, and whether to define the set of state
+IDs that must be provided, or whether to define the set of state names that
+must be provided.
+
+Required properties:
+pinctrl-0:	List of phandles, each pointing at a pin configuration
+		node. These referenced pin configuration nodes must be child
+		nodes of the pin controller that they configure. Multiple
+		entries may exist in this list so that multiple pin
+		controllers may be configured, or so that a state may be built
+		from multiple nodes for a single pin controller, each
+		contributing part of the overall configuration. See the next
+		section of this document for details of the format of these
+		pin configuration nodes.
+
+		In some cases, it may be useful to define a state, but for it
+		to be empty. This may be required when a common IP block is
+		used in an SoC either without a pin controller, or where the
+		pin controller does not affect the HW module in question. If
+		the binding for that IP block requires certain pin states to
+		exist, they must still be defined, but may be left empty.
+
+Optional properties:
+pinctrl-1:	List of phandles, each pointing at a pin configuration
+		node within a pin controller.
+...
+pinctrl-n:	List of phandles, each pointing at a pin configuration
+		node within a pin controller.
+pinctrl-names:	The list of names to assign states. List entry 0 defines the
+		name for integer state ID 0, list entry 1 for state ID 1, and
+		so on.
+
+For example:
+
+	/* For a client device requiring named states */
+	device {
+		pinctrl-names = "active", "idle";
+		pinctrl-0 = <&state_0_node_a>;
+		pinctrl-1 = <&state_1_node_a &state_1_node_b>;
+	};
+
+	/* For the same device if using state IDs */
+	device {
+		pinctrl-0 = <&state_0_node_a>;
+		pinctrl-1 = <&state_1_node_a &state_1_node_b>;
+	};
+
+== Pin controller devices ==
+
+Pin controller devices should contain the pin configuration nodes that client
+devices reference.
+
+For example:
+
+	pincontroller {
+		... /* Standard DT properties for the device itself elided */
+
+		state_0_node_a {
+			...
+		};
+		state_1_node_a {
+			...
+		};
+		state_1_node_b {
+			...
+		};
+	}
+
+The contents of each of those pin configuration child nodes is defined
+entirely by the binding for the individual pin controller device. There
+exists no common standard for this content.
+
+The pin configuration nodes need not be direct children of the pin controller
+device; they may be grand-children for example. Whether this is legal, and
+whether there is any interaction between the child and intermediate parent
+nodes, is again defined entirely by the binding for the individual pin
+controller device.
-- 
1.7.0.4

