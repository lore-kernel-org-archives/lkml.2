Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab0FQVVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:21:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46241 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759948Ab0FQVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WYg1MqlDFE3cAu4vy6JDfuCKeAf3Qw7wcsHEIClHKA2sU4Uo7vgz+Lp0PBX7Y7VEhi
         AXbFugD1ayGvKZRkw+FsNXg7YzIJWa9aZK0covUWVL7LQ12UlAF+oSDJwffWzoc2ruCh
         cJX2Xn6EiPbXE0zfIXBkQTXqUNp5SAafPA0L4=
Subject: [PATCH] Two fixes for my mmc/sd cardreader
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc <linux-mmc@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 00:21:35 +0300
Message-ID: <1276809695.28201.13.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are 2 fixes for my card reader.


First patch fixes old issue with system hand on suspend to disk/ram with
mmc card inserted.
I updated description, and pm notification registration order.
I think this patch can an should go to 2.6.35, because it fixes long
standing and nasty regression.

The second patch is a result of my work trying to understand why my card
reader sometimes dies on resume.
This reader has a special MMC function which steals MMC cards, and until
now had no driver. A way to disable it was found, and while it works, it
has (at least here) a side effect of killing the controller on resume
from ram/disk (and it happens often, and doesn't depend of whether card
was in slot or not during suspend).

Fortunately it turned out that MMC part is _almost_ standard SDHCI
controller.
This patch adds support for this device to standard sdhci driver.
Unfortunately, this support still contais small hack.
It waits 1/2 of a second on resume before initializing the controller.
Not doing so, and resuming with MMC card present results in confused
controller. It is not dead though. A card reinsert makes it work again
with all cards.
Yet the 1st patch is must for this because otherwise mmc core seeing
that controller doesn't respond, removes the card, therefore hangs the
system.
It doesn't happen when I wait these 1/2 of second though.

I think that this patch is also ok for 2.6.35, because it only adds new
functionality.
You are free to disable MMC controller using the same
CONFIG_MMC_RICOH_MMC.

If you don't disable it though, instead of full lack of functionality
you will get full featured MMC controller.

Best regards,
Maxim Levitsky



