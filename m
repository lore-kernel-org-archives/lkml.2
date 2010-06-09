Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0FIWbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:31:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64882 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab0FIWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:31:10 -0400
Date: Wed, 9 Jun 2010 15:29:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH] input: fixup X86_MRST selects
Message-Id: <20100609152921.61fb7db9.randy.dunlap@oracle.com>
In-Reply-To: <20100609133443.38f1f957.sfr@canb.auug.org.au>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4C101604.0021:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Some of the recent X86_MRST additions make some "select"s
conditional on X86_MRST but missed some related kconfig symbols,
causing:

drivers/built-in.o: In function `ps2_end_command':
(.text+0x257ab2): undefined reference to `i8042_check_port_owner'
drivers/built-in.o: In function `ps2_end_command':
(.text+0x257ae1): undefined reference to `i8042_unlock_chip'
drivers/built-in.o: In function `ps2_begin_command':
(.text+0x257b40): undefined reference to `i8042_check_port_owner'
drivers/built-in.o: In function `ps2_begin_command':
(.text+0x257b6f): undefined reference to `i8042_lock_chip'

when SERIO_I8042=m, SERIO_LIBPS2=y, KEYBOARD_ATKBD=y.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:	Jacob Pan <jacob.jun.pan@intel.com>
---
[found in linux-next but also applies to mainline]

 drivers/input/keyboard/Kconfig |    3 ++-
 drivers/input/mouse/Kconfig    |    2 +-
 drivers/input/serio/Kconfig    |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20100609.orig/drivers/input/keyboard/Kconfig
+++ linux-next-20100609/drivers/input/keyboard/Kconfig
@@ -70,9 +70,10 @@ config KEYBOARD_ATARI
 
 config KEYBOARD_ATKBD
 	tristate "AT keyboard" if EMBEDDED || !X86
+	depends on !X86 || (X86 && !X86_MRST)
 	default y
 	select SERIO
-	select SERIO_LIBPS2
+	select SERIO_LIBPS2 if !X86_MRST
 	select SERIO_I8042 if X86 && !X86_MRST
 	select SERIO_GSCPS2 if GSC
 	help
--- linux-next-20100609.orig/drivers/input/mouse/Kconfig
+++ linux-next-20100609/drivers/input/mouse/Kconfig
@@ -16,7 +16,7 @@ config MOUSE_PS2
 	tristate "PS/2 mouse"
 	default y
 	select SERIO
-	select SERIO_LIBPS2
+	select SERIO_LIBPS2 if !X86_MRST
 	select SERIO_I8042 if X86 && !X86_MRST
 	select SERIO_GSCPS2 if GSC
 	help
--- linux-next-20100609.orig/drivers/input/serio/Kconfig
+++ linux-next-20100609/drivers/input/serio/Kconfig
@@ -168,7 +168,7 @@ config SERIO_MACEPS2
 	  module will be called maceps2.
 
 config SERIO_LIBPS2
-	tristate "PS/2 driver library" if EMBEDDED
+	tristate "PS/2 driver library" if EMBEDDED && !X86_MRST
 	depends on SERIO_I8042 || SERIO_I8042=n
 	help
 	  Say Y here if you are using a driver for device connected
