Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1DUX1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 19:27:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55087 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab1DUX1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 19:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qdV8JHu3U/bJ18+uSOFao2q4EgWGzMVOHm2SkkOv2YkvCjUR4I4+tKWlmoiM4Ogq+r
         CPOwZbwtDRjn7GVfhDIfPnjoGdaXG4UwvmlhVv1iGSX2MXYWA4o8GEmcQ44h1ieRqTRO
         qCDxQRTlCmlWYEfukdkhzD5f/CcQnrvwpTsp0=
Date: Fri, 22 Apr 2011 03:27:03 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (battery tree related)
Message-ID: <20110421232703.GA16294@oksana.dev.rtsoft.ru>
References: <20110422080555.c7cd0e0b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110422080555.c7cd0e0b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Apr 22, 2011 at 08:05:55AM +1000, Stephen Rothwell wrote:
> Hi Anton,
> 
> After merging the final tree, today's linux-next build (s390 allyesconfig)
> failed like this:
> 
> drivers/built-in.o: In function `max8903_remove':
> drivers/power/max8903_charger.c:355: undefined reference to `free_irq'
> drivers/power/max8903_charger.c:357: undefined reference to `free_irq'
> drivers/power/max8903_charger.c:359: undefined reference to `free_irq'

I added the following patch to the battery-2.6.git, so this should be
fixed now. Thanks!

commit 6f9efe76cb213e9b0dd89e465efaf9725f4bf492
Author: Anton Vorontsov <cbouatmailru@gmail.com>
Date:   Fri Apr 22 03:08:22 2011 +0400

    max8903_charger: Add GENERIC_HARDIRQS as a dependency (fixes S390 build)
    
    S390 is special as it doesn't have IRQ lines, so these errors pop up:
    
    drivers/built-in.o: In function 'max8903_remove':
    drivers/power/max8903_charger.c:355: undefined reference to 'free_irq'
    drivers/power/max8903_charger.c:357: undefined reference to 'free_irq'
    drivers/power/max8903_charger.c:359: undefined reference to 'free_irq'
    
    This commit fixes the issue by making the driver depend on
    GENERIC_HARDIRQS feature.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 1f50ebc..cc019c9 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -205,6 +205,7 @@ config CHARGER_ISP1704
 
 config CHARGER_MAX8903
 	tristate "MAX8903 Battery DC-DC Charger for USB and Adapter Power"
+	depends on GENERIC_HARDIRQS
 	help
 	  Say Y to enable support for the MAX8903 DC-DC charger and sysfs.
 	  The driver supports controlling charger-enable and current-limit
