Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926Ab2FVX4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:56:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2FVX4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:56:32 -0400
X-Authority-Analysis: v=2.0 cv=cIliQyiN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=AqGylah1dMg2c9Xj8t4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340409391.27036.288.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 22 Jun 2012 19:56:31 -0400
In-Reply-To: <20120622164917.3121168a.akpm@linux-foundation.org>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
	 <1340408464.27036.282.camel@gandalf.stny.rr.com>
	 <20120622164917.3121168a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 16:49 -0700, Andrew Morton wrote:

> If a driver does
> 
> 	printk("testing the frobnozzle ...");
> 	do_test();
> 	printk(" OK\n");
> 
> and do_test() hangs up, we really really want the user to know that
> there was a frobnozzle testing problem.  Please tell me this isn't
> broken.

OK, then I wont tell you :-)  But this is exactly what happened to me.
There was a config that caused the function tracer self test to triple
fault the machine. The test does exactly what you just described:

	printk("Testing trace %s: ", tracer->name);
	ret = run_tests(tracer);
	if (ret == 0)
		printk("PASSED!\n");
	else
		printk("FAILED!\n");

But because of this new buffering, that didn't print. And unfortunately,
the previous printk was the start of the rcu torture test. Thus when
Fengguang saw that the last thing printed before his machine crashed was
the rcu torture tests starting, he obviously (but incorrectly) blamed it
on the rcu torture test.

Yes, I think this is broken by design. But I have an idea for a fix.
I'll work on it on Monday, and it wont require adding a pr_flush() like
I did in this patch set.

-- Steve



