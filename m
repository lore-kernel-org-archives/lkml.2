Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1EQVtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:49:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4678 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab1EQVs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:48:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 May 2011 14:48:57 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Date: Tue, 17 May 2011 14:48:53 -0700
Subject: RE: [PATCH] drivers: create a pinmux subsystem v2
Thread-Topic: [PATCH] drivers: create a pinmux subsystem v2
Thread-Index: AcwTYU5m/PPDaG6EQtOiW5FJEpE3VwBc3W8g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04986AAB5F@HQMAIL01.nvidia.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
	<74CDBE0F657A3D45AFBB94109FB122FF04986AA6A2@HQMAIL01.nvidia.com>
 <BANLkTi=wTB6R8vjHVAWM3T0e5HjOq77tdA@mail.gmail.com>
In-Reply-To: <BANLkTi=wTB6R8vjHVAWM3T0e5HjOq77tdA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I think I get it now.

Just to make sure, let me augment your simple driver example from
Documentation/pinmux.txt in your patch for a hypothetical machine that
has a bus that can be 2, 4, or 8-bits in size:

static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
static unsigned int i2c0_pins[] = { 24, 25 };
static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
static unsigned int bus0_1_0_pins[] = { 1, 2, };
static unsigned int bus0_3_2_pins[] = { 3, 4, };
static unsigned int bus0_7_4_pins[] = { 5, 6, 7, 9 };

static struct foo_pmx_func myfuncs[] = {
	{
		.name = "spi0-0",
		.pins = spi0_0_pins,
		.num_pins = ARRAY_SIZE(spi0_1_pins),
	},
	{
		.name = "i2c0",
		.pins = i2c0_pins,
		.num_pins = ARRAY_SIZE(i2c0_pins),
	},
	{
		.name = "spi0-1",
		.pins = spi0_1_pins,
		.num_pins = ARRAY_SIZE(spi0_1_pins),
	},
	{
		.name = "bus0-1:0",
		.pins = bus0_1_0_pins,
		.num_pins = ARRAY_SIZE(bus0_1_0_pins),
	},
	{
		.name = "bus0-3:2",
		.pins = bus0_3_2_pins,
		.num_pins = ARRAY_SIZE(bus0_3_2_pins),
	},
	{
		.name = "bus0-7:4",
		.pins = bus0_7_4_pins,
		.num_pins = ARRAY_SIZE(bus0_7_4_pins),
	},
};

Now, some driver wishing to use those functions could pinmux_get() on:

* Just "bus0-1:0"
* Both "bus0-1:0" and "bus0-3:2"
* All of "bus0-1:0" and "bus0-3:2" and "bus0-7:4"

That all makes sense to me.

It'd be great if Documentation/pinmux.txt could spell out the "variable
sized bus" scenario above in a little more detail; it looks like at
least 2 or 3 people had similar questions regarding the explosion of
function definitions based on cross-products of configurations, all
I assume driven by the assumption there was a 1:1 mapping between device
and pinmux function, rather than 1:n.

The one remaining thing I don't understand:

The board provides a mapping from driver name to pinmux selections.
The example documentation includes:

+static struct pinmux_map pmx_mapping[] = {
+	{
+		.function = "spi0-1",
+		.dev_name = "foo-spi.0",
+	},
+	{
+		.function = "i2c0",
+		.dev_name = "foo-i2c.0",
+	},
+};

I don't think this fits the model of a driver needing to pinmux_get
e.g. 1, 2, or 3 pinmux functions. Rather, I think the .function field
should be an array of functions needed by the driver:

+static struct pinmux_map pmx_mapping[] = {
+	{
+		.functions = "spi0-1",
+		.dev_name = "foo-spi.0",
+	},
+	{
+		.function = "i2c0",
+		.dev_name = "foo-i2c.0",
+	},
+	{
+		.function = {"bus0-7:4", "bus0-3:2", "bus0-1:0"},
+		.dev_name = "foo-bus.0",
+	},
+};

(obviously that syntax is bogus, but you get the idea)

The intent being that the driver could perform single pinmux_get call
for "foo-bus.0" and then the subsequent pinmux_enable would enable all 3
entries in that device's .function array.

Now, you could argue that there be 3 entries in pmx_mapping[] above, each
with a different .dev_name, and each mapping to 1 of the 3 required
functions. However, since pinmux_get takes a struct device and extracts
the name from there, that wouldn't work.

As further justification for this, consider the following scenario,
which I imagine is pretty common in some incarnation:

Manufacturer creates an SoC. There are two packaging variants of this,
with just packaging and pinmuxing variations; all the SPI/I2C/foo-bus
modules are identical. Thus the driver is the same. The pinmux
differences extend to:

Package A: bus0 is split two ways for bits 7:4 and 3:0

Package B: bus0 is split the three ways from my previous example; 7:4,
3:2, 1:0.

In order to isolate the bus0 driver from this pure packaging difference,
The board's pinmux_map array above would be either:

Package A:

+	{
+		.function = {"bus0-7:4", "bus0-3:0"},
+		.dev_name = "foo-bus.0",
+	},

Package B:

+	{
+		.function = {"bus0-7:4", "bus0-3:2", "bus0-1:0"},
+		.dev_name = "foo-bus.0",
+	},

Does this seem reasonable?

Thanks for patiently answering my long-winded questions:-)

-- 
nvpublic

