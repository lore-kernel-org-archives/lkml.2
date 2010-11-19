Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0KSVhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:37:31 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42481 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756744Ab0KSVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:37:28 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH v3 0/4] da850-evm: add gpio-{keys,leds} for UI and BB expanders
Date: Fri, 19 Nov 2010 16:37:19 -0500
Message-Id: <cover.1290201713.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1289935504.git.bengardiner@nanometrics.ca>
References: <cover.1289935504.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The da850-evm baseboard (BB) and its UI board both have tca6416 IO expanders.
They are bootstrapped to different I2C addresses so they can be used
concurrently.

The expander on the UI board is currently used to enable/disable the
peripherals that are available on the UI board. In addition to this
functionality the expander is also connected to 8 pushbuttons. The expander
on the baseboard is not currently used; it is connected to deep sleep enable,
sw reset, a push button, some switches and LEDs.

This proposed patch series enables the push buttons and switches on the UI and
BB expanders using the gpio-keys polling mode patch by Alexander Clouter. Some
work was performed to test irq-based gpio-keys support on the expanders (a WIP
patch can be posted on request) but I believe that it is not possible to use 
irq-based gpio-keys on IO expanders for arm systems at this time. 

The attempt started when I noticed the patch of Alek Du and Alan Cox [1] which 
was recently committed [2]; a stab at integrating irq-based gpio-keys support
based on that patch was attempted. I found that I either got a warning that the
irq could not be mapped for the given gpio ; or, when N_IRQ was increased, a
system freeze.

>From what I have read (particularly the message by Grant Likely [3]) IRQs on
IO expanders are not ready in ARM yet. I _think_ that the sparse IRQ rework by
Thomas Gleixner [4] will resolve the blocker to irq-based gpio-keys support. 

In the meantime we have buttons and switches that we would like to excersise
in our prototyping development. The patch to convert this series to irq-based
gpio-keys will be straighforward once the support in arch/arm is there.

There is an existing tca6416-keypad driver with polling support which I did not
employ because it isn't possible to keep the gpio's used for peripheral
enable/disable on the UI board or the LEDs on the baseboard registered while
simultaneously registering the pushbuttons or switches as a tca6416-keypad 
instance.

I tested this patch series using evtest on the resulting /dev/input/eventN 
devices and also on the event node of a non-polling gpio-keys instance to 
ensure that irq-based input handling is not broken by the introduction of the
polling-mode gpio-keys patch. The non-polling instance creation and
registration is not included in this series since it uses one of the boot-mode
DIP switches and woult not (I think) be suitable for mainline.

Disclaimer: 
I'm not an expert in irq's or gpio-keys; this is, in fact, my first proposed
feature. Please feel free to correct me -- I welcome the chance to learn from
your expertise.

[1] http://article.gmane.org/gmane.linux.kernel/1052551
[2] http://article.gmane.org/gmane.linux.kernel.commits.head/260919
[3] http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg01974.html
[4] http://article.gmane.org/gmane.linux.kernel.cross-arch/7786

Alexander Clouter (1):
  input: gpio_keys: polling mode support

Ben Gardiner (3):
  da850-evm: add UI Expander pushbuttons
  da850-evm: extract defines for SEL{A,B,C} pins in UI expander
  da850-evm: add baseboard GPIO expander buttons, switches and LEDs

 arch/arm/mach-davinci/Kconfig           |    3 +
 arch/arm/mach-davinci/board-da850-evm.c |  347 +++++++++++++++++++++++++++++--
 drivers/input/keyboard/gpio_keys.c      |  120 +++++++++--
 include/linux/gpio_keys.h               |    1 +
 4 files changed, 440 insertions(+), 31 deletions(-)

---
Changes since v2:
 * register a single input device for switches and keys on the baseboard since
   there is no benefit to separate devices with different polling intervals
   (Dmitry Torokhov)
 * use static array intialization and range intialization for platform data 
   structure to minimize the amount of runtime intialization needed:
   (Sekhar Nori)
 * Use the da850_evm variable name prefix for static symbols in
   board-da850-evm.c

Changes since v1:
 * use locally defined functions that are no-ops/error checkers when
   INPUT_POLLDEV is not defined.
 * disable polling mode support when input-polldev is a module and gpio_keys
   is builtin
 * set INPUT_POLLDEV default for DA850_EVM machine, but don't select it
   unconditionally
 * adding note to description about why tca6416-keypad was not used

