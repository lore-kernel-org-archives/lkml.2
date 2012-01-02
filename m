Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2ABIqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:46:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54866 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2ABIq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:46:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120102082514.GG18381@ponder.secretlab.ca>
References: <20111228194949.ff20a609745e816c266f7d91@canb.auug.org.au>
 <1325068334.6632.43.camel@pasglop> <20120102082514.GG18381@ponder.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 2 Jan 2012 01:39:06 -0700
X-Google-Sender-Auth: 6guiRdax9Chtw1KIzj-ZmUV1qm4
Message-ID: <CACxGe6txjt62u8fm8UBEfBDHmftgXO0XJJKQmAmh2Cy86ZfRaA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (powerpc related)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Benoit Cousson <b-cousson@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 1:25 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Dec 28, 2011 at 09:32:14PM +1100, Benjamin Herrenschmidt wrote:
>> On Wed, 2011-12-28 at 19:49 +1100, Stephen Rothwell wrote:
>> > Hi ,
>> >
>> > After merging the final tree, today's linux-next build (powerpc
>> > allyesconfig) failed like this:
>> >
>> > kernel/built-in.o: In function `irq_dispose_mapping':
>> > (.opd+0x159f0): multiple definition of `irq_dispose_mapping'
>> > arch/powerpc/kernel/built-in.o:(.opd+0x960): first defined here
>> > kernel/built-in.o: In function `irq_create_of_mapping':
>> > (.opd+0x15a20): multiple definition of `irq_create_of_mapping'
>> > arch/powerpc/kernel/built-in.o:(.opd+0x9a8): first defined here
>> > kernel/built-in.o: In function `.irq_create_of_mapping':
>> > (.text+0x147030): multiple definition of `.irq_create_of_mapping'
>> > arch/powerpc/kernel/built-in.o:(.text+0x9de0): first defined here
>> > kernel/built-in.o: In function `.irq_dispose_mapping':
>> > (.text+0x146f4c): multiple definition of `.irq_dispose_mapping'
>> > arch/powerpc/kernel/built-in.o:(.text+0x9684): first defined here
>> >
>> > I am not sure what caused this. And have just left it broken.
>>
>> Grant, is your irq remapper misbehaving ?
>
> Hmmmm, that's odd.  I've not touched it.  I'll investigate.

It looks like CONFIG_IRQ_DOMAIN is getting selected by TWL4030_CORE.
Drivers must not select that config symbol.  It looks like commit
da28adbd (mfd: twl-core: Add initial DT support for twl4030/twl6030)
is the culprit.

The following patch should solve the problem:

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 13c468e..e43a570 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -200,8 +200,7 @@ config MENELAUS

 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
-	depends on I2C=y && GENERIC_HARDIRQS
-	select IRQ_DOMAIN
+	depends on I2C=y && GENERIC_HARDIRQS && IRQ_DOMAIN
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
