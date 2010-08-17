Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab0HQKkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:40:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55732 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab0HQKkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kM/+Q2+9fgdgfN+TUpIJHnHJqTG4gnOIgnPpPDefQw8waXM93V/+rEdIM+KEgHJn2s
         Q20bBetK5o91f9bp6reIslr2ieyTLEB8eNhtF1Cryp2U+E5S5er3lpVVbPN3kxTSfKDI
         vInLx+fM4uoWepHAvVKQnn6+CFaDHpJsgD3Ec=
Date: Tue, 17 Aug 2010 13:39:48 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100817103948.GA5352@swordfish.minsk.epam.com>
References: <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
 <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please kindly review.

---

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..22dd388 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -116,13 +116,12 @@ static unsigned long get_sample_period(void)
 static void __touch_watchdog(void)
 {
 	int this_cpu = smp_processor_id();
-
-	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
+	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__get_cpu_var(watchdog_touch_ts) = 0;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -142,7 +141,7 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	__get_cpu_var(watchdog_nmi_touch) = true;
+	__raw_get_cpu_var(watchdog_nmi_touch) = true;
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);

