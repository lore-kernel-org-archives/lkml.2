Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1AYVO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:14:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47441 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1AYVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=izLOLKv+P/MuKj1HXMFo3jye7fyv4BwAnvOKh4K4DaudXRYm+rZObN3xsLRblHX31k
         yKWcNxosdEn8xVRVWloWzFJHEgBooFIR/t5rBexelIEsqGdeaTjlH0r6Cwr01rsqMA8O
         mjHHYuU9EnKQjzDAdhZ+m8zwYEk/pNsfr1FuE=
MIME-Version: 1.0
In-Reply-To: <1295864750-1238-1-git-send-email-s.neumann@raumfeld.com>
References: <20110124101701.GE16202@n2100.arm.linux.org.uk> <1295864750-1238-1-git-send-email-s.neumann@raumfeld.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 26 Jan 2011 05:06:23 +0800
Message-ID: <AANLkTinrxiHx6jX9jFzVzjq5FH-W=MLoDThAtRq2a1zZ@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: fix suspend on PXA3XX
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this instead?

diff --git a/arch/arm/mach-pxa/pm.c b/arch/arm/mach-pxa/pm.c
index 978e1b2..1807c9a 100644
--- a/arch/arm/mach-pxa/pm.c
+++ b/arch/arm/mach-pxa/pm.c
@@ -33,7 +33,7 @@ int pxa_pm_enter(suspend_state_t state)
 #endif

 	/* skip registers saving for standby */
-	if (state != PM_SUSPEND_STANDBY) {
+	if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->save) {
 		pxa_cpu_pm_fns->save(sleep_save);
 		/* before sleeping, calculate and save a checksum */
 		for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
@@ -44,7 +44,7 @@ int pxa_pm_enter(suspend_state_t state)
 	pxa_cpu_pm_fns->enter(state);
 	cpu_init();

-	if (state != PM_SUSPEND_STANDBY) {
+	if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->restore) {
 		/* after sleeping, validate the checksum */
 		for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
 			checksum += sleep_save[i];
