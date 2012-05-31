Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2EaV4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:56:44 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43640 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab2EaV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:56:42 -0400
X-Greylist: delayed 2165 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 17:56:42 EDT
Date: Thu, 31 May 2012 23:20:25 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: x86@kernel.org, Feng Tang <feng.tang@intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/moorestown: change to __devinit in order to suppress
  warning
Message-ID: <20120531212025.GA8519@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allmodconfig hits:

|WARNING: vmlinux.o(.text+0x6553d): Section mismatch in reference from the function intel_scu_devices_create() to the function .devinit.text: spi_register_board_info()
|The function intel_scu_devices_create() references
|the function __devinit spi_register_board_info().
|This is often because intel_scu_devices_create lacks a __devinit
|annotation or the annotation of spi_register_board_info is wrong.
|
|WARNING: vmlinux.o(.text+0x655f1): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c _register_board_info()
|The function intel_scu_devices_create() references
|the function __init i2c_register_board_info().
|This is often because intel_scu_devices_create lacks a __init
|annotation or the annotation of i2c_register_board_info is wrong.

This patch marks intel_scu_devices_create() as devinit because it calls
a devinit function, spi_register_board_info().
The second problem with i2c_register_board_info() does not go away and
should crash once build as a module because i2c_register_board_info() is
long gone. Therefore this function should not be used from a module.
Going through all the code here makes me ask, why don't use DT here for
all that I2C and friends?

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
And I looked like this while going over the code:
   http://download.breakpoint.cc/meme/moorestown_no_dt.png

 arch/x86/platform/mrst/mrst.c        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e31bcd8..fd41a92 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -782,7 +782,7 @@ BLOCKING_NOTIFIER_HEAD(intel_scu_notifier);
 EXPORT_SYMBOL_GPL(intel_scu_notifier);
 
 /* Called by IPC driver */
-void intel_scu_devices_create(void)
+void __devinit intel_scu_devices_create(void)
 {
 	int i;
 
