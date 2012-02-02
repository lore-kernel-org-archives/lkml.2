Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab2BBXZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:25:20 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50067 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab2BBXZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:25:18 -0500
X-Greylist: delayed 1558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Feb 2012 18:25:18 EST
Date: Thu, 2 Feb 2012 23:59:17 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chinmay V S <chinmay.v.s@pathpartnertech.com>
Cc: linux-kernel@vger.kernel.org, cvs268@gmail.com, tglx@linutronix.de,
        sebastian@breakpoint.cc, arjan@linux.intel.com,
        jeff.chua.linux@gmail.com
Subject: Re: [RFC] [PATCH] [timer] Optimise apply_slack() for size and speed.
Message-ID: <20120202225917.GA1189@kibibi>
References: <1328002652-7700-1-git-send-email-chinmay.v.s@pathpartnertech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1328002652-7700-1-git-send-email-chinmay.v.s@pathpartnertech.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chinmay V S | 2012-01-31 15:07:32 [+0530]:

>This patch modifies the masking logic to a bit-shift logic, therby
>reducing the complexity and number of operations. Thus obtaining a minor
>speed-up.
>diff --git a/kernel/timer.c b/kernel/timer.c
>index a297ffc..0379658 100644
>--- a/kernel/timer.c
>+++ b/kernel/timer.c
>@@ -785,9 +785,7 @@ EXPORT_SYMBOL(mod_timer_pending);
>@@ -811,9 +809,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
> 
> 	bit = find_last_bit(&mask, BITS_PER_LONG);
> 
>-	mask = (1 << bit) - 1;
>-
>-	expires_limit = expires_limit & ~(mask);
>+	expires_limit = (expires_limit >> bit) << bit;

The question is whether a shift left is more efficient compared to an
and operation. Besides that you save atleast one operation because you
don't need to load -1 into a register for creating a mask. So it looks
like less code.

Sebastian
