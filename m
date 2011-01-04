Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1ADHaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:30:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63269 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1ADHaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:30:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=YKKjhKo4hrg1A6cjf8ucxUUO9h5T7hcEDTwcKX3VE+lSdMQ++OrBgrWPzZpFm1fSrG
         YEIouPm5RjVlNw9sklutFeXBLh9FcOnRfKrljpiyOqa+pdaCr6yFdsVbbyl+jhz1UJq2
         yyO3z1MI39j1Vb35Dgm/DczqD9ZkLL9IaE7u0=
MIME-Version: 1.0
From: Thomas Taranowski <tom@baringforge.com>
Date: Mon, 3 Jan 2011 23:29:47 -0800
X-Google-Sender-Auth: L0_8TllwfpaT18ByY6s3JZXzHTE
Message-ID: <AANLkTikTWejPTTS1Xt6mk86u=_HKSX==Y=d2iyqKFb8m@mail.gmail.com>
Subject: [PATCH] RapidIO: Fix hang on RapidIO doorbell queue full condition
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fsl_rio_dbell_handler, the code currently simply acknowledges the QFI queue
full interrupt, but does nothing to resolve the queue full condition.  Instead,
it jumps to the end of the isr.  When a queue full condition occurs, the isr is
then re-entered immediately and continually, forever.

The fix is to just fall through and read out current doorbell entries.

Tested against 2.6.26-rc8 on a p2020

Signed-off-by: Thomas Taranowski <tom@baringforge.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 9725369..9f99bef 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -973,7 +973,6 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
        if (dsr & DOORBELL_DSR_QFI) {
                pr_info("RIO: doorbell queue full\n");
                out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
-               goto out;
        }

        /* XXX Need to check/dispatch until queue empty */
-- 
1.7.0.4


Thomas Taranowski
Certified netburner consultant
baringforge.com
