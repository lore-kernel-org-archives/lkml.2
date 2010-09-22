Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0IVI7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:59:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46338 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0IVI7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iWB/OXS7yxYtBkt3kSk5QbfJhjTIt3cEHHV47XHEXSbs/mweLt6It8hBc65F6yBPrY
         /4udPcIkly+orKmMm2A587tdvYUG6O12TlFv3zP8wCutrAyvG+zMfYafLlSzTlReUhFv
         iEtI80jnjwfreaBpCniHF1ZRGbiXiBVCkyciU=
Date: Wed, 22 Sep 2010 12:00:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] avoid second smp_processor_id() call in __touch_watchdog
Message-ID: <20100922090012.GA5459@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <20100818123346.02028e96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818123346.02028e96.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Per our previous conversation:

Andrew Morton wrote:
> Fair enough, although strictly speaking this should be done in a
> separate and later patch.
> 


Avoid double smp_processor_id() call in __touch_watchdog (smp_processor_id() 
itself and later call in __get_cpu_var())

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7f9c3c5..03d97c5 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -116,8 +116,7 @@ static unsigned long get_sample_period(void)
 static void __touch_watchdog(void)
 {
 	int this_cpu = smp_processor_id();
-
-	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
+	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
 }
 
 void touch_softlockup_watchdog(void)

