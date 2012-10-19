Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab2JSJFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:05:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17940 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2JSJE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:04:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 19 Oct 2012 02:04:55 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v7 0/3] Runtime Interpreter Power Sequences
Date: Fri, 19 Oct 2012 18:06:26 +0900
Message-ID: <1350637589-7405-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a big redesign of the feature - both structures and code have been
simplified and should be easier to read and understand, data duplication is
avoided, and much less memory allocations take place at runtime. Usage
interface is also simpler and IMHO more logical.

What happened is that platform_power_seq and power_seq have been merged,
and so power sequences declared as platform data are used "as-is". The
"build" step is not needed anymore - resources are allocated when a
power sequence is added into a set.

There is still one design flaw that I would like to solve: sequences are
still tied to a device, i.e. if you have two devices that use the same
powering scheme, you have to declare two identical power sequences and assign
each of these to one device. It would be much more flexible if sequences could
be shared across devices. The problem is that the resources structure,
references by steps, cannot be shared. Actually we could share it by having
a linked list of devices and resolved resources in the resource structure and
thus share power sequences over devices. That would work for regulator and
PWM resources, which have a get_regulator/pwm(dev, id) function that could
return a different resource depending on the device that is passed.
But there is no similar get_gpio() function for GPIOs which number is directly
specified in the resource, and I don't know if such a function would make
sense otherwise. Opinions on the subject are welcome.

Alexandre Courbot (3):
  Runtime Interpreted Power Sequences
  pwm_backlight: use power sequences
  tegra: ventana: add PWM backlight to device tree

 .../devicetree/bindings/power/power_seq.txt        | 121 +++++++
 .../bindings/video/backlight/pwm-backlight.txt     |  72 +++-
 Documentation/power/power_seq.txt                  | 253 ++++++++++++++
 arch/arm/boot/dts/tegra20-ventana.dts              |  59 +++-
 drivers/power/Kconfig                              |   1 +
 drivers/power/Makefile                             |   1 +
 drivers/power/power_seq/Kconfig                    |   2 +
 drivers/power/power_seq/Makefile                   |   1 +
 drivers/power/power_seq/power_seq.c                | 376 +++++++++++++++++++++
 drivers/power/power_seq/power_seq_delay.c          |  65 ++++
 drivers/power/power_seq/power_seq_gpio.c           |  94 ++++++
 drivers/power/power_seq/power_seq_pwm.c            |  82 +++++
 drivers/power/power_seq/power_seq_regulator.c      |  83 +++++
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 161 +++++++--
 include/linux/power_seq.h                          | 203 +++++++++++
 include/linux/pwm_backlight.h                      |  18 +-
 17 files changed, 1553 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power_seq.txt
 create mode 100644 Documentation/power/power_seq.txt
 create mode 100644 drivers/power/power_seq/Kconfig
 create mode 100644 drivers/power/power_seq/Makefile
 create mode 100644 drivers/power/power_seq/power_seq.c
 create mode 100644 drivers/power/power_seq/power_seq_delay.c
 create mode 100644 drivers/power/power_seq/power_seq_gpio.c
 create mode 100644 drivers/power/power_seq/power_seq_pwm.c
 create mode 100644 drivers/power/power_seq/power_seq_regulator.c
 create mode 100644 include/linux/power_seq.h

-- 
1.7.12.3

