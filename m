Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1EXE7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:59:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45194 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1EXE7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:59:16 -0400
Message-ID: <4DDB3AFF.9030006@oracle.com>
Date: Mon, 23 May 2011 21:58:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: x86@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH/RFC] gpio: add GPIOF_ values regardless on kconfig settings
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523134815.fb87933a.randy.dunlap@oracle.com> <20110523224659.GB19533@opensource.wolfsonmicro.com> <20110523155343.2e68c265.randy.dunlap@oracle.com> <20110524000837.GA30515@opensource.wolfsonmicro.com> <4DDB082F.3010107@oracle.com> <20110524014959.GA27710@opensource.wolfsonmicro.com>
In-Reply-To: <20110524014959.GA27710@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DDB3B10.0051:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/11 18:50, Mark Brown wrote:
> On Mon, May 23, 2011 at 06:21:51PM -0700, Randy Dunlap wrote:
>> On 05/23/11 17:08, Mark Brown wrote:
> 
>>> No, really we should.  The GPIO APIs are stubbed out when not in use for
>>> a very good reason, think about the usability here.  The goal here isn't
>>> to litter the code with ifdefs - if architectures aren't able to keep up
>>> with API changes they should convert to using gpiolib so this stuff
>>> happens automatically (indeed, I can't think of any good reason for an
>>> architecture to not be using gpiolib at this point).
> 
>> No, I would say that there are a lot of drivers in sound/soc/codecs/
>> that are missing some GPIO pieces in the Kconfig file.
> 
> Have you actually looked at the code here?  Vanishingly few of the
> drivers need GPIOs at all, they can just optionally use GPIOs if the
> system makes them available.  There is absolutely no dependency on GPIOs
> for them, anything in Kconfig would be entirely unconstructive.
> 
>>>> MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
> 
>>> You've clearly not looked at MAINTAINERS for this one.
> 
>> It's not listed in the MAINTAINERS file.
> 
> MAINTAINERS has a pattern sound/soc/codecs/wm*.

Thanks for that hint.

>> But maybe you mean scripts/get_maintainer.pl, which I did try.
>> I found that using git log <that source file name> was better info
>> than using scripts/get_maintainer.pl.
> 
> get_maintainers is just a script that reads MAINTAINERS and trawls logs
> for it; the reason I mentioned MAINTAINERs was that you were saying you
> didn't use git.  In general you're better off doing things by hand
> rather than using get_maintainers.

Yes.

OK, I didn't mean to get into a blame game on this.
You mentioned stubs earlier and that's what is not working AFAICT.

Below is a patch that makes the 2 reported drivers build when
CONFIG_GPIOLIB is disabled and CONFIG_GENERIC_GPIO is disabled.
What do you think of the patch?


---
From: Randy Dunlap <randy.dunlap@oracle.com>

Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
is enabled by moving them to <linux/gpio.h>.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-generic/gpio.h |   10 ----------
 include/linux/gpio.h       |   11 +++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

--- linux-next-20110523.orig/include/asm-generic/gpio.h
+++ linux-next-20110523/include/asm-generic/gpio.h
@@ -170,16 +170,6 @@ extern int __gpio_cansleep(unsigned gpio
 
 extern int __gpio_to_irq(unsigned gpio);
 
-#define GPIOF_DIR_OUT	(0 << 0)
-#define GPIOF_DIR_IN	(1 << 0)
-
-#define GPIOF_INIT_LOW	(0 << 1)
-#define GPIOF_INIT_HIGH	(1 << 1)
-
-#define GPIOF_IN		(GPIOF_DIR_IN)
-#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
-#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
-
 /**
  * struct gpio - a structure describing a GPIO with configuration
  * @gpio:	the GPIO number
--- linux-next-20110523.orig/include/linux/gpio.h
+++ linux-next-20110523/include/linux/gpio.h
@@ -3,6 +3,17 @@
 
 /* see Documentation/gpio.txt */
 
+/* make these flag values available regardless of GPIO kconfig options */
+#define GPIOF_DIR_OUT	(0 << 0)
+#define GPIOF_DIR_IN	(1 << 0)
+
+#define GPIOF_INIT_LOW	(0 << 1)
+#define GPIOF_INIT_HIGH	(1 << 1)
+
+#define GPIOF_IN		(GPIOF_DIR_IN)
+#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
+#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
+
 #ifdef CONFIG_GENERIC_GPIO
 #include <asm/gpio.h>
 
