Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161082Ab2JaJDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:03:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49335 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161033Ab2JaJDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:03:43 -0400
Message-ID: <1351674213.5359.1.camel@phoenix>
Subject: [PATCH] gpio: em: Fix build errors
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Date: Wed, 31 Oct 2012 17:03:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build errors:

  CC [M]  drivers/gpio/gpio-em.o
drivers/gpio/gpio-em.c: In function 'em_gio_probe':
drivers/gpio/gpio-em.c:306: error: 'err' undeclared (first use in this function)
drivers/gpio/gpio-em.c:306: error: (Each undeclared identifier is reported only once
drivers/gpio/gpio-em.c:306: error: for each function it appears in.)
drivers/gpio/gpio-em.c:308: error: label 'err3' used but not defined
drivers/gpio/gpio-em.c:279: error: label 'err2' used but not defined
drivers/gpio/gpio-em.c:265: error: label 'err1' used but not defined
drivers/gpio/gpio-em.c:250: error: label 'err0' used but not defined
drivers/gpio/gpio-em.c:309: warning: no return statement in function returning non-void
drivers/gpio/gpio-em.c: At top level:
drivers/gpio/gpio-em.c:311: error: expected identifier or '(' before 'if'
drivers/gpio/gpio-em.c:317: error: expected identifier or '(' before 'if'
drivers/gpio/gpio-em.c:323: warning: data definition has no type or storage class
drivers/gpio/gpio-em.c:323: warning: type defaults to 'int' in declaration of 'ret'
drivers/gpio/gpio-em.c:323: error: 'gpio_chip' undeclared here (not in a function)
drivers/gpio/gpio-em.c:323: error: initializer element is not constant
drivers/gpio/gpio-em.c:324: error: expected identifier or '(' before 'if'
drivers/gpio/gpio-em.c:328: error: expected identifier or '(' before 'return'
drivers/gpio/gpio-em.c:330: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
drivers/gpio/gpio-em.c:332: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
drivers/gpio/gpio-em.c:334: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
drivers/gpio/gpio-em.c:336: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
drivers/gpio/gpio-em.c:338: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
drivers/gpio/gpio-em.c:340: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
drivers/gpio/gpio-em.c:342: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
drivers/gpio/gpio-em.c:344: error: expected identifier or '(' before '}' token
drivers/gpio/gpio-em.c: In function 'em_gio_remove':
drivers/gpio/gpio-em.c:361: error: implicit declaration of function 'em_gio_irq_domain_cleanup'
make[2]: *** [drivers/gpio/gpio-em.o] Error 1
make[1]: *** [drivers/gpio] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-em.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index 88bdfe3..b007063 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -302,8 +302,8 @@ static int __devinit em_gio_probe(struct platform_device *pdev)
 	p->irq_domain = irq_domain_add_linear(pdev->dev.of_node,
 					      pdata->number_of_pins,
 					      &em_gio_irq_domain_ops, p);
-	if (!p->irq_domain)
-		err = -ENXIO;
+	if (!p->irq_domain) {
+		ret = -ENXIO;
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
 		goto err3;
 	}
@@ -358,7 +358,7 @@ static int __devexit em_gio_remove(struct platform_device *pdev)
 
 	free_irq(irq[1]->start, pdev);
 	free_irq(irq[0]->start, pdev);
-	em_gio_irq_domain_cleanup(p);
+	irq_domain_remove(p->irq_domain);
 	iounmap(p->base1);
 	iounmap(p->base0);
 	kfree(p);
-- 
1.7.9.5



