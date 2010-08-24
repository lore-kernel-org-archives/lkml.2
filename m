Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0HXJ0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:26:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64278 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0HXJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YXS6RM+5/ilaxCPKFeCVRjkZfSFdKLosHAlH8hmetVkcr27YLbfSC+70mM/moqRhHO
         nIcc4hKVwqt009s2OoUXqxcCUu6Oh7MqysX5eqLnZDiZwjWlhMAYmMMfu5lIZYoF/BaL
         S6++gig3E0DzmEkFL5VB+y7vDtFB8/pnWtrpY=
Date: Tue, 24 Aug 2010 13:26:23 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] gpiolib: Add 'struct gpio_chip' forward declaration for
 !GPIOLIB case
Message-ID: <20100824092623.GA20334@oksana.dev.rtsoft.ru>
References: <1282631168.22370.517.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1282631168.22370.517.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_GPIOLIB=n, the 'struct gpio_chip' is not declared,
so the following pops up on PowerPC:

  cc1: warnings being treated as errors
  In file included from arch/powerpc/platforms/52xx/mpc52xx_common.c:19:
  include/linux/of_gpio.h:74: warning: 'struct gpio_chip' declared
                              inside parameter list
  include/linux/of_gpio.h:74: warning: its scope is only this definition
                              or declaration, which is probably not what
			      you want
  include/linux/of_gpio.h:75: warning: 'struct gpio_chip' declared
                              inside parameter list
  make[2]: *** [arch/powerpc/platforms/52xx/mpc52xx_common.o] Error 1

This patch fixes the issue by providing the proper forward declaration.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

On Tue, Aug 24, 2010 at 04:26:08PM +1000, Benjamin Herrenschmidt wrote:
> I get that with my current stuff:
> 
> cc1: warnings being treated as errors
> In file included from [..]/mpc52xx_common.c:19:
> of_gpio.h:74: error: ‘struct gpio_chip’ declared inside parameter list
[...]
> make[3]: *** Waiting for unfinished jobs....

That's because with GPIOCHIP=n no one declares struct gpio_chip.

It should be either of_gpio.h or gpio.h. Let's make it gpio.h, as
this feels more generic, and we already have some !GPIOLIB handling
in there.

 include/linux/gpio.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 03f616b..85207d2 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -15,6 +15,12 @@
 struct device;
 
 /*
+ * Some code might rely on the declaration. Still, it is illegal
+ * to dereference it for !GPIOLIB case.
+ */
+struct gpio_chip;
+
+/*
  * Some platforms don't support the GPIO programming interface.
  *
  * In case some driver uses it anyway (it should normally have
-- 
1.7.0.5

