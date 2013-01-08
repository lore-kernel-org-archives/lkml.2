Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3AHHTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:19:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11556 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3AHHTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:19:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Jan 2013 23:14:44 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/4] gpio: introduce descriptor-based interface
Date: Tue, 8 Jan 2013 16:18:51 +0900
Message-ID: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduce a first take at implementing the RFC for the new GPIO API
that I submitted last month. It proposes a new, opaque descriptor-based GPIO API
that becomes available when GPIOlib is compiled, and provides a safer, more
abstract alternative to the current integer-based interface. GPIOlib internals
are also switched to use the descriptor logic, and the former integer API
becomes a lightweight wrapper around the new descriptor-based API.

Functionally speaking the new API is identical to the integer-based API, with
only the prefix changing from gpio_ to gpiod_. However, the second patch
introduces new functions for obtaining GPIOs from a device and a consumer name,
in a fashion similar to what is done with e.g. regulators and PWMs.

GPIOs can then be provided either by board-specific lookup tables, or through
the device tree. Device tree lookup might require some attention as it does not
handle properties with multiple descriptors yet. Also, there is currently no
equivalent of gpio_request_array() and GPIOs can only be allocated one-by-one.
Feedback about the relevancy of batch requesting GPIOs is welcome.

This patch series also prepares GPIOlib for the next step, which is getting rid
of ARCH_NR_GPIOS and of the static array in GPIOlib and replace the latter with
per-chip arrays that are allocated when the chip is added. Some challenge may
arise from the fact that gpiochip_add is potentially called before kmalloc is
available.

Anyway, I expect this patchset to go through several iterations in order to
address the points mentioned above (and of course the ones I missed). As usual,
your valuable feedback is most welcome.

Alexandre Courbot (4):
  gpiolib: introduce descriptor-based GPIO interface
  gpiolib: add gpiod_get and gpiod_put functions
  gpiolib: of: convert OF helpers to descriptor API
  gpiolib: add documentation for new gpiod_ API

 Documentation/gpio.txt        |  94 +++++-
 drivers/gpio/devres.c         |  59 +++-
 drivers/gpio/gpiolib-of.c     |  26 +-
 drivers/gpio/gpiolib.c        | 648 ++++++++++++++++++++++++++++--------------
 include/asm-generic/gpio.h    | 176 ++++--------
 include/linux/gpio/consumer.h | 128 +++++++++
 include/linux/gpio/driver.h   | 171 +++++++++++
 include/linux/of_gpio.h       |  73 +----
 8 files changed, 956 insertions(+), 419 deletions(-)
 create mode 100644 include/linux/gpio/consumer.h
 create mode 100644 include/linux/gpio/driver.h

-- 
1.8.1

