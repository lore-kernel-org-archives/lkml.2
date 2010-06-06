Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab0FFN2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 09:28:16 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:37778 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710Ab0FFN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 09:28:13 -0400
Message-Id: <201006061319.AA01345@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Sun, 06 Jun 2010 22:19:18 +0900
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100603153016.cbe6ff0c.akpm@linux-foundation.org>
References: <20100603153016.cbe6ff0c.akpm@linux-foundation.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.11
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for the review.

On Thu, 3 Jun 2010 15:30:16 -0700 Andrew Morton wrote:

> > +	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)
> > +			The period of panic blink can be computed by the
> > +			formula T = 7200 / W, where T is the period in milli-
> > +			seconds, W is the speed in wpm (words per minute).
> > +			Should be 5 or less when running under a hypervisor
> 
> Nobody will know what "wpm" means.  What is a "word" in this context?
> Unclear.
> 
> How about "bpm": "blinks per minute".  That's nice and direct.

The current explanation of panicblink= still makes no sense, indeed.

"bpm" seems to be nice and direct, but the range at a practicable
blinking speed will be 8.33 to 833 bpm.  That is too wide and the step
size is too small for the speed of panic blink.  That will be hard to
deal with.

OTOH, the range at a practicable blinking speed in "wpm" fits in 1 to
100.  I think that will sit well with us.

Now, I need to explain what "wpm" means and what a "word" in the con-
text is:

The speed of morse code is measured in wpm, which defines the speed of
morse transmission as the timing needed to send the word "PARIS" a
given number of times per minute.

The time for one (minimum) unit can be computed by the formula T =
1200 / W, where T is the unit time in milliseconds, W is the speed in
wpm.  The panic blink here is assumed as a word of infinite length to
which "T" continues (i.e. "TTTTTTTT...").  The letter "T" represents
three units long and the short gap (between letters) also represents
three units long.  The period of panic blink thus can be computed by
the formula T = 7200 / W.

However, IMO, it is gauche to say such a explanation of panicblink=
in kernel-parameters.txt.

After all, I will just explain concisely the important matters (range
is 1 to 100, the lower the slower, the higher the faster, default is
12).

> > +	if (panic_blink_wpm <= 0 || panic_blink_wpm > 100)
> > +		panic_blink_wpm = 12;
> 
> hm, OK.  Or we could do
> 
> 	if (panic_blink_wpm <= 0)
> 		panic_blink_wpm = 1;
> 	if (panic_blink_wpm > 100)
> 		panic_blink_wpm = 100;
> 
> which is handily encapsulated in the clamp() macro which nobody uses.

OK, I will use the clamp() macro here.

> > +	if (!panic_blink)
> > +		panic_blink = no_blink;
> 
> Can we initialise panic_blink to no_blink at compile-time then remove this?

Perhaps, we cannot initialize panic_blink to no_blink at compile time
because panic_blink is dynamically set/unset the panic callback when
module_init()/module_exit() is called.

Since there are few changes this time, I will post the patch as PATCH
v2.1.  Andrew, would you please readd the patch to the -mm tree.

Regards,
TAMUKI Shoichi
