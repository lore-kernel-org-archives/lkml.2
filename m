Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030533Ab2CFMRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:17:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030477Ab2CFMRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:17:40 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=OPymKhBv_mMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=KIw4CoETl2062FVbIjUA:9 a=79ew_hguPh6ONTqhQnEA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331036257.25686.365.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT] seqlock/rt: Prevent livelocks with seqlocks in RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Carsten Emde <cbe@osadl.org>, Peter Zijlstra <peterz@infradead.org>
Date: Tue, 06 Mar 2012 07:17:37 -0500
In-Reply-To: <alpine.LFD.2.02.1203060911000.2742@ionos>
References: <1331006584.25686.362.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1203060911000.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 09:18 +0100, Thomas Gleixner wrote:

> Errm. rt15 has 
> 
> /*
>  * Starvation safe read side for RT
>  */
> static inline unsigned read_seqbegin(seqlock_t *sl)
> {
>         unsigned ret;
> 
> repeat:
>         ret = sl->seqcount.sequence;
>         if (unlikely(ret & 1)) {
>                 /*
>                  * Take the lock and let the writer proceed (i.e. evtl
>                  * boost it), otherwise we could loop here forever.
>                  */
>                 spin_lock(&sl->lock);
>                 spin_unlock(&sl->lock);
>                 goto repeat;
>         }
>         return ret;
> }
> #endif

You're right it does!

I didn't see this as the lock up showed it was locked up in
read_seqcount_begin(), it was late and I was tired.

Here's the real fix then:

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 723274d..29ffd4f 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -177,7 +177,7 @@ typedef struct {
 /*
  * Read side functions for starting and finalizing a read side section.
  */
-#ifndef CONFIG_PREEMPT_RT
+#ifndef CONFIG_PREEMPT_RT_FULL
 static inline unsigned read_seqbegin(const seqlock_t *sl)
 {
 	return read_seqcount_begin(&sl->seqcount);


