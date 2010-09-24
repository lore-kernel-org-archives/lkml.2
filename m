Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0IXNpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:45:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49832 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab0IXNpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type;
        b=kYT1HnUx8rDduMV6cSjhN63ETgK2ASQgXbXxoOrMJ3159PCNKujLa6b22TCzOe15m6
         oblV/9QOonQUrBcD3eKPHMJzTwuNykg/MA0JtIb/PGATwsl2Ojt5SrnjJfVWJg+9q7rd
         AaakCGCp2Df0ZHS8JVJeEtrer66ErXaiGoGh0=
MIME-Version: 1.0
Reply-To: pghatwork@gmail.com
Date: Fri, 24 Sep 2010 15:44:58 +0200
X-Google-Sender-Auth: kEyIejAKXnhJ3ir-PDjIl85GfI8
Message-ID: <AANLkTikibKh=NXbqtRC4W7JkzUfuHR9AKjByNFP9fgKQ@mail.gmail.com>
Subject: [PATCH 0/6] Support for ST-Ericsson CG2900 Connectivity Controller
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for the ST-Ericsson CG2900 Connectivity Combo
Controller (GPS & Bluetooth & FM : GBF).
It contains a core framework where users can register for specific channels.
The core API also allows registration of handlers for specific chips as well as
the transports supported.
The channels are also exposed to User space through character devices.
There is a BlueZ driver module included which connects BlueZ to the CG2900
Bluetooth channels.
There is also an audio driver where audio stacks can set the CG2900 internal
audio paths, e.g. routing FM to I2S and Bluetooth to PCM.

There are already changes planned for this driver that we will submit when
ready:
Currently board specific functionality is directly included through a header
file and source file (cg2900_devices.c and .h). This will be changed by using
platform driver mechanism instead.
The CG2900 core framework still has chip specific dependencies. We have plans
to remove them in order to be able to connect any connectivity chip to
the framework.

Par-Gunnar Hjalmdahl (6):
  This patch adds support for the ST-Ericsson CG2900 connectivity
    controller. This patch contains the framework for registering
    users, chip handlers, and transports as well as the needed files
    towards the mach-ux500 board.
  This patch adds support for the ST-Ericsson CG2900 connectivity
    controller. This patch registers into the CG2900 framework. It
    handles chip startup and shutdown together with firmware download.
    It also handles Bluetooth and FM flow control due to special H4
    channel management.
  This patch adds support for the ST-Ericsson CG2690 connectivity
    controller. This patch registers into the CG2900 framework. It
    handles chip startup and shutdown together with firmware download.
  This patch adds support for using UART as transport for the
    ST-Ericsson CG2690 connectivity controller. This patch registers
    into the CG2900 framework. It handles chip enable and disable as
    well baud rate settings. It also assembles received packets into
    full Bluetooth, GPS, and FM packets.
  This patch adds support for controlling the audio paths within the
    ST-Ericsson CG2900 connectivity controller. This patch registers as
    a user into the CG2900 framework for the bt_audio and fm_audio
    channels. It contains an API for controlling the audio paths that
    can also be reached from User space using a char device.
  This patch adds support for using the ST-Ericsson CG2900 connectivity
    controller as a driver for the BlueZ Bluetooth stack. This patch
    registers as a driver into the BlueZ framework and, when opened by
    BlueZ, it registers as user for bt_cmd, bt_acl, and bt_evt
    channels.

 arch/arm/mach-ux500/Makefile                      |    5 +
 arch/arm/mach-ux500/cg2900_devices.c              |  353 +++
 arch/arm/mach-ux500/include/mach/cg2900_devices.h |  120 +
 drivers/bluetooth/Kconfig                         |    7 +
 drivers/bluetooth/Makefile                        |    2 +
 drivers/bluetooth/cg2900_hci.c                    |  896 ++++++++
 drivers/mfd/Kconfig                               |   34 +
 drivers/mfd/Makefile                              |    1 +
 drivers/mfd/cg2900/Makefile                       |   14 +
 drivers/mfd/cg2900/cg2900_audio.c                 | 2475 +++++++++++++++++++++
 drivers/mfd/cg2900/cg2900_char_devices.c          |  709 ++++++
 drivers/mfd/cg2900/cg2900_char_devices.h          |   36 +
 drivers/mfd/cg2900/cg2900_chip.c                  | 2060 +++++++++++++++++
 drivers/mfd/cg2900/cg2900_chip.h                  |  421 ++++
 drivers/mfd/cg2900/cg2900_core.c                  | 2287 +++++++++++++++++++
 drivers/mfd/cg2900/cg2900_core.h                  |  303 +++
 drivers/mfd/cg2900/cg2900_debug.h                 |   77 +
 drivers/mfd/cg2900/cg2900_uart.c                  | 1587 +++++++++++++
 drivers/mfd/cg2900/hci_defines.h                  |  102 +
 drivers/mfd/cg2900/stlc2690_chip.c                | 1105 +++++++++
 drivers/mfd/cg2900/stlc2690_chip.h                |   37 +
 include/linux/mfd/cg2900.h                        |  205 ++
 include/linux/mfd/cg2900_audio.h                  |  583 +++++
 23 files changed, 13419 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-ux500/cg2900_devices.c
 create mode 100644 arch/arm/mach-ux500/include/mach/cg2900_devices.h
 create mode 100644 drivers/bluetooth/cg2900_hci.c
 create mode 100644 drivers/mfd/cg2900/Makefile
 create mode 100644 drivers/mfd/cg2900/cg2900_audio.c
 create mode 100644 drivers/mfd/cg2900/cg2900_char_devices.c
 create mode 100644 drivers/mfd/cg2900/cg2900_char_devices.h
 create mode 100644 drivers/mfd/cg2900/cg2900_chip.c
 create mode 100644 drivers/mfd/cg2900/cg2900_chip.h
 create mode 100644 drivers/mfd/cg2900/cg2900_core.c
 create mode 100644 drivers/mfd/cg2900/cg2900_core.h
 create mode 100644 drivers/mfd/cg2900/cg2900_debug.h
 create mode 100644 drivers/mfd/cg2900/cg2900_uart.c
 create mode 100644 drivers/mfd/cg2900/hci_defines.h
 create mode 100644 drivers/mfd/cg2900/stlc2690_chip.c
 create mode 100644 drivers/mfd/cg2900/stlc2690_chip.h
 create mode 100644 include/linux/mfd/cg2900.h
 create mode 100644 include/linux/mfd/cg2900_audio.h
