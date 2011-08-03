Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab1HCWEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:04:35 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14845 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab1HCWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:04:29 -0400
Message-ID: <4E39C5EB.8070701@cavium.com>
Date: Wed, 03 Aug 2011 15:04:27 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>
Subject: How to describe I2C and MDIO bus multiplexers with the device tree?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2011 22:04:28.0557 (UTC) FILETIME=[508EBBD0:01CC5229]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a board (ASCII art representation below) that has a bunch of
PHY devices that are connected behind a MDIO bus switch/multiplexer.
This multiplexer is in turn controlled by GPIO pins on a I2C GPIO port
expander.  which is in turn on a I2C bus switch/multiplexer.

There is another switch/multiplexer that is controlled directly via I2C.

Q: How can this be represented?

My attempt is below...

   I2C-0 
   MDIO-1            MDIO-0
    | 
    |                 |
    |         |--------------| 
    |                 |
    |         |              +---- I2C-A ----- 
    |                 |
    +---------+ multiplexor  | 
    |                 |
    |         |              +---- I2C-B ----- 
    |                 |
    |         |  I2C-0x70    | 
    |                 |
    |         |              +---- I2C-C ----- 
    |                 |
    |         |              | 
    |                 |
    |         |              +---- I2C-D ----- 
    |                 |
    |         |              | 
    |                 |
    |         |              +---- I2C-E ----- 
    |                 |
    |         |              | 
    |                 |
    |         |              +---- I2C-F --------+ 
    |                 |
    |         |              |                   | 
    |                 |
    |         |              +---- I2C-G --+     | 
    |                 |
    |         |--------------|             |     | 
    |                 |
    |                                      |     | 
    |                 |
    |        |------------|          +-----+     | 
    |                 |
    |        |            |          |           | 
    |                 |
    +--------+  ds1337 RTC|          |           | 
    |                 |
    |        | I2C-0x68   |          |     |-----+-----| 
|--------+---------|       |
    |        |------------|          |     | GPIO      |          | 
              |       |
    |                                |     | Port      +--Pin 3---+ 
multiplexor     |       |
    |                                |     | Expander  +--Pin 4---+ 
              |       |
    |                                |     |           |          | 
74CBTLV3253     |       |
    |                                |     |I2C-0x38   |          | 
              |       |
    |                                |     |           |          | 
              |       |
    |                                |     |-----------| 
|-+--------------+-|       |
    |                                |                              | 
            |         |
    |                                |                              | 
            |         |
    |                           |----+-----|                        M 
            M         |
    |                           | GPIO     |                        D 
            D         |
    |                           | Port     |                        I 
            I         |
    |                           | Expander |                        O 
            O         |
    |                           |          |                        | 
            |         |
    |                           |I2C-0x38  |                        W 
            X         |
    |                           |----------|                        | 
            |         |
    |                                                               | 
            |         |
    |                                                               | 
            |         |
    | 
|----+---|     |----+---|     |
    |                                                          | 
|     |        |     |
    |                                                          | PHY-11 
|     | PHY-21 |     |
    |                                                          | PHY-12 
|     | PHY-22 |     |
    |                                                          | PHY-13 
|     | PHY-23 |     |
    |                                                          | PHY-14 
|     | PHY-24 |     |
    | 
|--------|     |--------|     |
    | 
                      |
    |         |-------------| 
                      |
    |         | multiplexor | 
                      |
    |         |  I2C-0x77 
+----------------------------------------------------------------+
    +---------+   foo       |
    |         |             |
    |         |-+--------+--|
    |           |        |
                |        |
                M        M
                D        D
                I        I
                O        O
                |        |
                Y        Z
                |        |
          |-----+--|  |--+----|
          | PHY-3  |  | PHY-4 |
          |--------|  |-------|







/dts-v1/;
/ {
	model = "cavium,brfl";
	compatible = "cavium,brfl";
	#address-cells = <2>;
	#size-cells = <2>;
	interrupt-parent = <&ciu>;

	soc@0 {
	      .
	      .
	      .
		smi0: mdio@1180000001800 {
			compatible = "cavium,octeon-3860-mdio";
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0x11800 0x00001800 0x0 0x40>;
		};
		smi1: mdio@1180000001900 {
			compatible = "cavium,octeon-3860-mdio";
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0x11800 0x00001900 0x0 0x40>;
		};
	      .
	      .
	      .
		twsi0: i2c@1180000001000 {
			#address-cells = <1>;
			#size-cells = <0>;
			compatible = "cavium,octeon-3860-twsi";
			reg = <0x11800 0x00001000 0x0 0x200>;
			interrupts = <0 45>;
			clock-rate = <100000>;
			.
			.
			.
			i2c-mux@70 {
				compatible = "nxp,pca9548";
				reg = <0x38>;

				i2c@6 {
					#address-cells = <1>;
					#size-cells = <0>;
					cell-index = <6>;

					gpio66: gpio@38 {
						compatible = "nxp,pca8574";
						reg = <0x38>;
						#gpio-cells = <2>;
						gpio-controller;
					};
				}
			};
			.
			.
			.
			mdio-mux@77 {
				compatible = "bar,foo";
				reg = <0x77>;
				parent-bus = <&smi0>
				#address-cells = <1>;
				#size-cells = <0>;

				mdio@0 {
					#address-cells = <1>;
					#size-cells = <0>;
					cell-index = <0>;

					phy3: ethernet-phy@1 {
						reg = <1>;
						compatible = "marvell,88e1149r";
						marvell,reg-init = <3 0x10 0 0x5777>,
							<3 0x11 0 0x00aa>,
							<3 0x12 0 0x4105>,
							<3 0x13 0 0x0a60>;
					};
				mdio@1 {
					#address-cells = <1>;
					#size-cells = <0>;
					cell-index = <1>;

					phy4: ethernet-phy@1 {
						reg = <1>;
						compatible = "marvell,88e1149r";
						marvell,reg-init = <3 0x10 0 0x5777>,
							<3 0x11 0 0x00aa>,
							<3 0x12 0 0x4105>,
							<3 0x13 0 0x0a60>;
					};
			};
			.
			.
			.
		};
		mdio-mux@0 {
			compatible = "ti,sn74cbtlv3253"
			gpios = <&gpio66 3 1
				 &gpio66 4 1>
			parent-bus = <&smi1>
			#address-cells = <1>;
			#size-cells = <0>;

			mdio@2 {
				#address-cells = <1>;
				#size-cells = <0>;
				cell-index = <2>;

				phy11: ethernet-phy@1 {
					reg = <1>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
				phy12: ethernet-phy@1 {
					reg = <2>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
				phy13: ethernet-phy@1 {
					reg = <3>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
				phy14: ethernet-phy@1 {
					reg = <4>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
			};
			mdio@3 {
				#address-cells = <1>;
				#size-cells = <0>;
				cell-index = <3>;

				phy21: ethernet-phy@1 {
					reg = <1>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
				phy22: ethernet-phy@1 {
					reg = <2>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
				phy23: ethernet-phy@1 {
					reg = <3>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
				phy24: ethernet-phy@1 {
					reg = <4>;
					compatible = "marvell,88e1149r";
					marvell,reg-init = <3 0x10 0 0x5777>,
						<3 0x11 0 0x00aa>,
						<3 0x12 0 0x4105>,
						<3 0x13 0 0x0a60>;
				};
			};
		};

	      .
	      .
	      .
	};

};


Some notes/questions:

o mdio-mux@0 is a child of soc@0, but conceptually it might just as
   well be floating in space.

o The parent-bus property of both mdio-mux@0 and mdio-mux@77 denotes
   the connection of the multiplexer to its 'parent' bus.

o The cell-index property of the multiplexed bus instances denotes the
   sub-bus of the switch/multiplexer the children are connected to.
   Would a different property name be better here?

o For mdio-mux@0 the driver will use the cell-index to determine how
   to program the gpios that control the switch/multiplexer.

Am I totally insane?
David Daney
