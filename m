Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1AAUjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 15:39:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61404 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1AAUjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 15:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=a1u+IKfb/BmwmO52CJHhaHZRhTHUL9N1Zrt8doEzKIV9Y3GOi+AQ7C/KG/LwCZ2PRj
         4fP5z+CKbs7z/r2XrYeu0xe3I2wGGTuvkObxbNaeMwCW4sCMskRK3bkbDsZShKPWhn1G
         h5Q8LkR2Jv8AuY5QV3W5HQtQGlu+6swJKnWtQ=
MIME-Version: 1.0
In-Reply-To: <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at> <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Sun, 2 Jan 2011 05:38:19 +0900
Message-ID: <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 1, 2011 at 4:12 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> +#define ADJ_SETOFFSET          0x0040  /* add 'time' to current time */

As you know, it conflicts with MOD_PPSMAX.  And also, it is logically
the same as ADJ_OFFSET, unless the kernel PLL is enabled explicitly.

So here's my simple solution:

---
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index c631168..d492887 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -119,14 +119,21 @@
 	return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }

-static void ntp_update_offset(long offset)
+static void ntp_update_offset(long offset, struct timespec *ts)
 {
 	s64 freq_adj;
 	s64 offset64;
 	long secs;

-	if (!(time_status & STA_PLL))
+	if (!(time_status & STA_PLL)) {
+		offset64 = offset;
+		if (!(time_status & STA_NANO))
+			offset64 *= NSEC_PER_USEC;
+
+		set_normalized_timespec(ts, ts->tv_sec, offset64 + ts->tv_nsec);
+
 		return;
+	}

 	if (!(time_status & STA_NANO))
 		offset *= NSEC_PER_USEC;
@@ -430,7 +437,7 @@
 		time_tai = txc->constant;

 	if (txc->modes & ADJ_OFFSET)
-		ntp_update_offset(txc->offset);
+		ntp_update_offset(txc->offset, ts);

 	if (txc->modes & ADJ_TICK)
 		tick_usec = txc->tick;
@@ -526,6 +533,9 @@

 	write_sequnlock_irq(&xtime_lock);

+	if ((txc->modes & ADJ_OFFSET) && !(time_status & STA_PLL))
+		do_settimeofday(&ts);
+
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
 	if (!(time_status & STA_NANO))
--
