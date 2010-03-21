Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab0CUESq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 00:18:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33437 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0CUESp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 00:18:45 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
	<1267697339-5491-7-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
	<4B900250.8020100@kernel.org>
	<Pine.LNX.4.64.1003050847170.21768@ask.diku.dk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 20 Mar 2010 21:18:34 -0700
In-Reply-To: <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk> (Julia Lawall's message of "Fri\, 5 Mar 2010 08\:47\:30 +0100 \(CET\)")
Message-ID: <m1eije71et.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tglx@linutronix.de, julia@diku.dk, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I haven't heard anything more on this, but I had reason to play with
coccinelle http://coccinelle.lip6.fr/ which I think is think think is
the semantic patcher you referred to.

In any case I was playing with it and I believe I have managed to whip
up a fairly robust semantic patch.  The last two hunks are to cleanup
earlier transforms, by removing unnecessary irq_to_desc chatter, and
removing unused variables.  I am a big grumpy that I couldn't figure
out how to add comments to my patch to explain the tricky bits,
but otherwise I am happy.

The patch appears to have the limitation that methods that are not in
the file where struct irq_chip is defined, which is an issue for the
msi irq_chip helper routines.  Other than that I don't know of any
issues.

I would suggest changing as much of the x86 non irq_chip helpers to
use irq_desc before applying this so it this the conversion can have
the chance to remove any irq variables.

Eric


@ DECL @
struct irq_chip CHIP;
identifier METHOD;
identifier METHOD_NAME;
@@
 CHIP.METHOD_NAME = METHOD;

@ @
identifier DECL.METHOD;
identifier IRQ;
@@
 METHOD(
-		unsigned int IRQ
+		struct irq_desc *unused
 , ...) {
 }

@ @
identifier DECL.METHOD;
identifier IRQ;
identifier DESC;
@@
 METHOD(
-		unsigned int IRQ
+		struct irq_desc *DESC
 , ...) {
+	unsigned int IRQ = DESC->irq;
 	...
-	struct irq_desc *DESC = irq_to_desc(IRQ);
	...
 }

@ @
identifier DECL.METHOD;
identifier IRQ;
identifier DESC;
@@
 METHOD(
-		unsigned int IRQ
+		struct irq_desc *DESC
 , ...) {
+	unsigned int IRQ = DESC->irq;
 	...
-	struct irq_desc *DESC;
	...
-	DESC = irq_to_desc(IRQ);
	...
 }

@ @
identifier DECL.METHOD;
identifier IRQ;
@@
 METHOD(
-		unsigned int IRQ
+		struct irq_desc *desc
 , ...) {
+	unsigned int IRQ = desc->irq;
 ...
 }

@ @
identifier DECL.METHOD;
identifier FUNC;
identifier IRQ;
@@
 FUNC(...) {
 <...
	METHOD(
-		IRQ
+		irq_to_desc(IRQ)
 		, ... )
 ...>
 }

@ @
identifier FUNC;
identifier DESC;
identifier IRQ;
@@
 FUNC(..., struct irq_desc *DESC, ...) {
 ...
 	unsigned int IRQ = DESC->irq;
 <...
-	irq_to_desc(IRQ)
+	DESC
 ...>
 }

@ @
identifier FUNC;
identifier DESC;
identifier IRQ;
@@
 FUNC(..., struct irq_desc *DESC, ...) {
 ...
-	unsigned int IRQ = DESC->irq;
 ... when != IRQ
 }
