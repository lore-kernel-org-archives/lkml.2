Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2LKUaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:30:01 -0500
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:44744 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753915Ab2LKU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:29:59 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3] Enable A20 using KBC for some MSI laptops to fix S3 resume
Date: Tue, 11 Dec 2012 21:29:12 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201210261056.44225.zary@gsystems.sk> <201212111959.15808.linux@rainbow-software.org> <50C78486.9070700@zytor.com>
In-Reply-To: <50C78486.9070700@zytor.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212112129.13248.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2012 20:07:50 H. Peter Anvin wrote:
> On 12/11/2012 10:59 AM, Ondrej Zary wrote:
> > As I said before, the BIOS probably breaks on resume before any Linux
> > code is executed. So any fix must be done before suspending.
>
> Well, that code should be independent of A20, being in low memory, but
> if the BIOS itself crashes, then that's... yeah.
>
> > I hate quirks too. A general solution would be to always enable A20 using
> > KBC (if KBC is present) but that's probably not acceptable.
>
> I don't see why not.  If so we could just do it as part of the
> initialization of the i8042 driver.

Something like this? (It works.)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index d6cc77a..0807ac7 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -921,6 +921,7 @@ static int __init i8042_platform_init(void)
 	int retval;
 
 #ifdef CONFIG_X86
+	u8 a20_on = 0xdf;
 	/* Just return if pre-detection shows no i8042 controller exist */
 	if (!x86_platform.i8042_detect())
 		return -ENODEV;
@@ -960,6 +961,13 @@ static int __init i8042_platform_init(void)
 
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = true;
+
+	/*
+	 * A20 was already enabled during early kernel init. But some buggy
+	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
+	 * resume from S3. So we do it here and hope that nothing breaks.
+	 */
+	i8042_command(&a20_on, 0x10d1);
 #endif /* CONFIG_X86 */
 
 	return retval;
-- 
Ondrej Zary
