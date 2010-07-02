Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0GBEqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 00:46:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42946 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0GBEqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 00:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=toATotUhvBJzkB3HGnIu2KtUiwFuGYXBxnlsv2MJHyBgznFrGFdgpBQZOUpa3XDj5k
         IxhMb2gBmX96fqOSDCLDW4UOha6C2v3R9A0EA8T0yNjFv5AskvE+H2OV1I23cphsJJNq
         6o4NAcpG8vojSVWzPTV0vtihtBUfBbjVEf+6I=
Date: Thu, 1 Jul 2010 21:46:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, kphillisjr@gmail.com
Subject: Re: problem: Re: [PATCH] input: fixup X86_MRST selects
Message-ID: <20100702044607.GA1203@core.coreip.homeip.net>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
 <201006101204.45709.dmitry.torokhov@gmail.com>
 <4C28F210.7030909@oracle.com>
 <201006281318.16377.dmitry.torokhov@gmail.com>
 <4C2904D0.3000409@oracle.com>
 <43F901BD926A4E43B106BF17856F0755EA339079@orsmsx508.amr.corp.intel.com>
 <20100628224440.GA19087@core.coreip.homeip.net>
 <43F901BD926A4E43B106BF17856F0755EA339200@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F0755EA339200@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 04:22:03PM -0700, Pan, Jacob jun wrote:
> There is no DMI support yet in MRST FW.  We have a new x86 HW subarch
> ID in boot_param, then we use it to select x86_init abstractions. Both
> boot_param and x86_init are x86 arch specific so I guess we can use
> them in 8042 driver under CONFIG_X86. Not sure if it is possible to
> move x86 i8042_platform_init under x86_init (the x86 part).
> 

Moving i8042_platform_init() into platform code is quite invasive,
how about we to the following?

Thanks.

-- 
Dmitry


Input: i8042 - detect legacy-free platforms (Moorestown)

Moorestown does not have legacy hardware (i8042, i8259) and does not
like legacy ports being poked by drivers. Instead of playing with
Kconfig selections let's check if we set up dummy (null) legacy PIC
during startup and abort i8042 initialization as well. This should
fix the following bug:

	https://bugzilla.kernel.org/show_bug.cgi?id=16326

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/Kconfig        |    4 ++--
 drivers/input/mouse/Kconfig           |    2 +-
 drivers/input/serio/Kconfig           |    2 +-
 drivers/input/serio/i8042-x86ia64io.h |   18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)


diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index d3a99de..b25917b 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -69,11 +69,11 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86 || X86_MRST
+	tristate "AT keyboard" if EMBEDDED || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index eeb58c1..c714ca2 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -17,7 +17,7 @@ config MOUSE_PS2
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you have a PS/2 mouse connected to your system. This
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 256b9e9..3bfe8fa 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,7 @@ config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !X86_MRST
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 723106c..a6a4a2f 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -844,10 +844,28 @@ static inline int i8042_pnp_init(void) { return 0; }
 static inline void i8042_pnp_exit(void) { }
 #endif
 
+#if CONFIG_X86
+#include <asm/i8259.h>
+static bool i8042_legacy_free_platform(void)
+{
+	/*
+	 * Moorestown platform does not have i8042 nor does it
+	 * have other legacy devices, such as i8259. Use ths fact
+	 * to detect that we are running on a legacy-free platform.
+	 */
+	return legacy_pic == &null_legacy_pic;
+}
+#else
+static bool i8042_legacy_free_platform(void) { }
+#endif
+
 static int __init i8042_platform_init(void)
 {
 	int retval;
 
+	if (i8042_legacy_free_platform())
+		return -ENXIO;
+
 /*
  * On ix86 platforms touching the i8042 data register region can do really
  * bad things. Because of this the region is always reserved on ix86 boxes.
