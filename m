Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0L1UsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:48:01 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51024 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0L1UsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OFEIK4ZlrO5e3ICZsGpZFk32OOnGk+2v68lwcq92v53a3xiMpS0mGCciJn2BiqXEd+
         DmlXlQoJEP7AI5lxHxrXJ71JKc0ixfYWgJXg0r1qfdLR/SeFyaGAfmBa3P4ONDdBEaGg
         oP3U4hA9F43SB3ISREhoAFfG2W4RCKtgjbUIU=
MIME-Version: 1.0
In-Reply-To: <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org> <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Wed, 29 Dec 2010 05:47:19 +0900
Message-ID: <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
Subject: Re: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 8:40 AM, John Stultz <john.stultz@linaro.org> wrote:
> From: Richard Cochran <richardcochran@gmail.com>
>
> This patch adds a new mode bit into the timex structure. When set, the
> bit instructs the kernel to add the given time value to the current time.

I came up with this simple solution: "Just use ADJ_OFFSET as usual,
but don't forget to disable the kernel PLL."

Here's my (untested) patch.

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
+		offset64 = (s64)offset;
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
