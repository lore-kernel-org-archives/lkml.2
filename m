Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2EJCd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:33:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46890 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2EJCdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:33:24 -0400
Message-ID: <1336617173.25027.4.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 04:32:53 +0200
In-Reply-To: <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	 <1336475689.1179.12.camel@mop>
	 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	 <20120509070710.GA29981@gmail.com>
	 <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	 <1336611278.728.9.camel@mop>
	 <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 18:18 -0700, Linus Torvalds wrote:
> On Wed, May 9, 2012 at 5:54 PM, Kay Sievers <kay@vrfy.org> wrote:
> >
> > How about this? It relaxes the need for KERN_CONT, but it limits
> > continuation lines to repeated calls of the same thread.
> 
> Fair enough, looks reasonable.
> 
> Except your case-statement sucks. Having a "case 'c':" that basically
> then immediately has an "if (it was not 'c')" is just disturbing. Just
> move the code that is common to all the cases outside the case
> statement entirely, and make the 'c' case not do anything at all, and
> remove that crazy extraneous if-statement.


From: Kay Sievers <kay@vrfy.org>
Subject: printk() - do not merge continuation lines of different threads

This prevents the merging of printk() continuation lines of different
threads, in the case they race against each other.

It should properly isolate "atomic" single-line printk() users from
continuation users, to make sure the single-line users will never be
merged with the racy continuation ones.

Signed-off-by: Kay Sievers <kay@vrfy.org>
---

 kernel/printk.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1230,12 +1230,13 @@ asmlinkage int vprintk_emit(int facility
 	static size_t buflen;
 	static int buflevel;
 	static char textbuf[LOG_LINE_MAX];
+	static struct task_struct *cont;
 	char *text = textbuf;
 	size_t textlen;
 	unsigned long flags;
 	int this_cpu;
 	bool newline = false;
-	bool cont = false;
+	bool prefix = false;
 	int printed_len = 0;
 
 	boot_delay_msec();
@@ -1295,20 +1296,16 @@ asmlinkage int vprintk_emit(int facility
 		case '0' ... '7':
 			if (level == -1)
 				level = text[1] - '0';
-			text += 3;
-			textlen -= 3;
-			break;
-		case 'c':	/* KERN_CONT */
-			cont = true;
 		case 'd':	/* KERN_DEFAULT */
+			prefix = true;
+		case 'c':	/* KERN_CONT */
 			text += 3;
 			textlen -= 3;
-			break;
 		}
 	}
 
-	if (buflen && (!cont || dict)) {
-		/* no continuation; flush existing buffer */
+	if (buflen && (prefix || dict || cont != current)) {
+		/* flush existing buffer */
 		log_store(facility, buflevel, NULL, 0, buf, buflen);
 		printed_len += buflen;
 		buflen = 0;
@@ -1342,6 +1339,10 @@ asmlinkage int vprintk_emit(int facility
 				  dict, dictlen, text, textlen);
 			printed_len += textlen;
 		}
+		cont = NULL;
+	} else {
+		/* remember thread which filled the buffer */
+		cont = current;
 	}
 
 	/*


