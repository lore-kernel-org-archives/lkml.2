Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3AHHTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:19:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10816 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3AHHTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:19:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 Jan 2013 23:16:40 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 4/4] gpiolib: add documentation for new gpiod_ API
Date: Tue, 8 Jan 2013 16:18:55 +0900
Message-ID: <1357629535-26033-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/gpio.txt | 94 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 2 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 77a1d11..871ccda 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -120,7 +120,8 @@ example, a number might be valid but temporarily unused on a given board.
 
 Whether a platform supports multiple GPIO controllers is a platform-specific
 implementation issue, as are whether that support can leave "holes" in the space
-of GPIO numbers, and whether new controllers can be added at runtime.  Such issues
+of GPIO numbers, and whether new controllers can be added at runtime.  Such
+issues
 can affect things including whether adjacent GPIO numbers are both valid.
 
 Using GPIOs
@@ -302,7 +303,8 @@ are claimed, three additional calls are defined:
 	 * 'flags', identical to gpio_request() wrt other arguments and
 	 * return value
 	 */
-	int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+	int gpio_request_one(unsigned gpio, unsigned long flags, const char
+*label);
 
 	/* request multiple GPIOs in a single call
 	 */
@@ -773,3 +775,91 @@ differences between boards from user space.  This only affects the
 sysfs interface.  Polarity change can be done both before and after
 gpio_export(), and previously enabled poll(2) support for either
 rising or falling edge will be reconfigured to follow this setting.
+
+GPIO descriptor interface
+=========================
+A more secure, alternative GPIO interface is available through GPIOlib. Instead
+of relying on integers (which can easily be forged and used without being
+properly requested) to reference GPIOs, it uses a system of opaque descriptors
+that must be properly obtained and disposed through the common get/put set of
+functions. This ensures that all GPIO descriptors are valid at any time and
+makes it unnecessary to check the validity of a GPIO. Apart from this
+difference, the interface is similar to the integer-based one, excepted that the
+gpio_ prefix is changed to gpiod_.
+
+This interface can be used in conjonction with the integer-based API, however
+new drivers should really try to use the safer descriptor-based interface.
+Drivers using this interface should depend on CONFIG_GPIOLIB being set, as it is
+only available when GPIOlib is compiled in.
+
+Using GPIOs
+-----------
+GPIO consumers should include <linux/gpio/consumer.h> which declares the
+consumer-side GPIO functions. GPIOs are obtained through gpiod_get:
+
+	struct gpio_desc *gpiod_get(struct device *dev,
+				    const char *con_id);
+
+This will return the GPIO descriptor corresponding to the con_id function of
+dev, or an error code in case of error. A devm variant is also available:
+
+	struct gpio_desc *devm_gpiod_get(struct device *dev,
+					 const char *con_id);
+
+GPIO descriptors are disposed using the corresponding put functions:
+
+	void gpiod_put(struct gpio_desc *desc);
+	void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
+
+A valid descriptor can then be used with one of the gpiod_ functions. Their
+interface is identical to the integer-based API, excepted that they take a GPIO
+descriptor instead of an integer:
+
+	int gpiod_direction_input(struct gpio_desc *desc);
+	int gpiod_direction_output(struct gpio_desc *desc, int value);
+	int gpiod_get_value(struct gpio_desc *desc);
+	void gpiod_set_value(struct gpio_desc *desc, int value);
+	...
+
+If you need to convert a descriptor to an integer or vice-versa, you can use
+gpio_to_desc or desc_to_gpio:
+
+	struct gpio_desc *gpio_to_desc(unsigned gpio);
+	int desc_to_gpio(const struct gpio_desc *desc);
+
+The same GPIO can be used by both interfaces as long as it has properly been
+acquired by one of them (i.e. using either gpio_request() or gpiod_get()).
+
+Declaring GPIOs
+---------------
+GPIOs can be made available for devices either through board-specific lookup
+tables, or using the device tree.
+
+Board-specific lookup tables match a device name and consumer ID to a GPIO chip
+and GPIO number relative to that chip. They are declared as follows:
+
+	static struct gpio_lookup board_gpio_lookup[] = {
+		GPIO_LOOKUP("tegra-gpio", 28, "backlight.1", "power"),
+	};
+
+	static void __init board_init(void)
+	{
+		...
+		gpiod_add_table(board_gpio_lookup,
+				ARRAY_SIZE(board_gpio_lookup));
+		...
+	}
+
+In the driver side, the following code:
+
+	gpiod_get(dev, "power");
+
+will return the descriptor for GPIO 28 of the "tegra-gpio" chip provided
+strcmp(dev_name(dev), "backlight.1") == 0.
+
+If the device tree is used, then the same "power" GPIO can be declared into the
+device's node as follows:
+
+	power-gpios = <&gpio 28 0>;
+
+Note that gpiod_get() only allows to access the first GPIO specifier.
\ No newline at end of file
-- 
1.8.1

