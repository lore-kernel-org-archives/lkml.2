Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab1IBIHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:07:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33484 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875Ab1IBIHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B327A3A0@HQMAIL01.nvidia.com>
References: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B3279BD7@HQMAIL01.nvidia.com>
	<CACRpkdaWbgiaJvvjDgBWFTpC6P=XcG6fm+L8rnjv9rxDxgs_YQ@mail.gmail.com>
	<CACRpkda4PRd_WUPrnEBVADbHnmSOgVB=WCXvVR4dFMektyQ2tQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B327A3A0@HQMAIL01.nvidia.com>
Date: Fri, 2 Sep 2011 10:07:47 +0200
Message-ID: <CACRpkdYj+4tPgBQWd6MhWJStkdSmorGDBUr68LtsWwnpfTo_5w@mail.gmail.com>
Subject: Re: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 9:43 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Looking forward a little, I expect that different SoCs have such a
> different set of biasing/driver-strength/... options that actually having
> some formalized semantic representation of what those options are doesn't
> make sense; all we need is a standard API to set the values for a given
> pin or pingroup;

I'm still thinking about this thing, when I (and others) wer trying to
shoehorn this kind of stuff into the GPIO layer I actually started to
enumerate the different things you could do with a pin, beginning
like this:

+/*
+ * Bias modes for GPIOs - if you have more biases, add them here or provide
+ * custom enumerators for your driver if you find they are not generally
+ * useful.
+ *
+ * GPIO_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
+ * GPIO_CONFIG_BIAS_FLOAT: no specific bias, the GPIO will float or state
+ *     is not controlled by software
+ * GPIO_CONFIG_BIAS_PULL_UP: the GPIO will be pulled up (usually with high
+ *     impedance to VDD)
+ * GPIO_CONFIG_BIAS_PULL_DOWN: the GPIO will be pulled down (usually with high
+ *     impedance to GROUND)
+ * GPIO_BIAS_HIGH: the GPIO will be wired high, connected to VDD
+ * GPIO_BIAS_GROUND: the GPIO will be grounded, connected to GROUND
+ */
+#define GPIO_CONFIG_BIAS_UNKNOWN       0x1000
+#define GPIO_CONFIG_BIAS_FLOAT         0x1001
+#define GPIO_CONFIG_BIAS_PULL_UP       0x1002
+#define GPIO_CONFIG_BIAS_PULL_DOWN     0x1003
+#define GPIO_CONFIG_BIAS_HIGH          0x1004
+#define GPIO_CONFIG_BIAS_GROUND        0x1005
+
+/*
+ * Drive modes for GPIOs (output) - if you have more custom modes either
+ * add them here or keep them to your driver if you think they are not
+ * generally useful.
+ *
+ * GPIO_CONFIG_DRIVE_UNKNOWN: we don't know the drive mode of this GPIO, for
+ *     example since it is controlled by hardware or the information is not
+ *     accessible but we need a meaningful enumerator in e.g. initialization
+ *     code
+ * GPIO_CONFIG_DRIVE_PUSH_PULL: the GPIO will be driven actively high and
+ *     low, this is the most typical case and is typically achieved with two
+ *     active transistors on the output
+ * GPIO_CONFIG_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain (open
+ *     collector) which means it is usually wired with other output ports
+ *     which are then pulled up with an external resistor
+ * GPIO_CONFIG_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
+ *     (open emitter) which is the same as open drain mutatis mutandis but
+ *     pulled to ground
+ * GPIO_CONFIG_DRIVE_OFF: the GPIO pin is set to inactive mode, off
+ */
+#define GPIO_CONFIG_DRIVE_UNKNOWN      0x2010
+#define GPIO_CONFIG_DRIVE_PUSH_PULL    0x2011
+#define GPIO_CONFIG_DRIVE_OPEN_DRAIN   0x2012
+#define GPIO_CONFIG_DRIVE_OPEN_SOURCE  0x2013
+#define GPIO_CONFIG_DRIVE_OFF          0x2014

The basic assumption is that there are not that infinitely many
things you may want to do with a pin after all.

I can already think about interesting enumerators for
GPIO_CONFIG_INPUT_SCHMITT_TRIGGER
GPIO_CONFIG_INPUT_LOAD_CAPACITANCE
etc. But not unenumerable things.

The upside of this scheme is that we might have some handle on
trying to consolidate common functionality between drivers,
also to sort of consolidate the knowledge of what you can
do with pins in one place, even if you can't share any code.

For a stupid example the generic debugfs files could give you a list
of all pins in any system and what bias mode they're in, no
matter what platform we're dealing with, which would give the
some kind of cosy consensus for developers that platforms
are not that different after all.

Yours,
Linus Walleij
