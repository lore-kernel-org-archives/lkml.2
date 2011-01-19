Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1ASM5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:57:31 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60041 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1ASM5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:57:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A6piG0cjF6G4MS2wcIbjrmKxkEY0RsFp8GRnEMkz41Hh4ooPuZhs0x9hTStmF8qgd+
         XGQM5ALXb20mFHdFVrhz4Pc3Ocd0xaGi9cEHfdutfeLfNfoVa0x570JtMPC4mC4j3J2S
         hyKUaAPhe/hK881Jl5EwywcwOHFXSpJr0zDkQ=
Date: Wed, 19 Jan 2011 15:57:22 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: walter harms <wharms@bfs.de>, kernel-janitors@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] arm: mach-omap2: potential NULL dereference
Message-ID: <20110119125721.GA9203@albatros>
References: <1295258922-31242-1-git-send-email-segoon@openwall.com>
 <4D341C35.80506@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D341C35.80506@bfs.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc() may fail, if so return -ENOMEM.  Also Walter Harms suggested
to use kasprintf() instead of kzalloc+strcpy+strcat.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/arm/mach-omap2/smartreflex.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 77ecebf..697d8d4 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -260,9 +260,11 @@ static int sr_late_init(struct omap_sr *sr_info)
 	if (sr_class->class_type == SR_CLASS2 &&
 		sr_class->notify_flags && sr_info->irq) {
 
-		name = kzalloc(SMARTREFLEX_NAME_LEN + 1, GFP_KERNEL);
-		strcpy(name, "sr_");
-		strcat(name, sr_info->voltdm->name);
+		name = kasprintf(GFP_KERNEL, "sr_%s", sr_info->voltdm->name);
+		if (name == NULL) {
+			ret = -ENOMEM;
+			goto error;
+		}
 		ret = request_irq(sr_info->irq, sr_interrupt,
 				0, name, (void *)sr_info);
 		if (ret)
-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
