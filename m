Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab2FOXxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:53:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2FOXxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:53:37 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=Mnlr5044LsmvfCo_fhMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339804415.25903.63.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 15 Jun 2012 19:53:35 -0400
In-Reply-To: <20120615231318.GD8205@kroah.com>
References: <1339649173.13377.191.camel@gandalf.stny.rr.com>
	 <20120614045930.GA10508@kroah.com>
	 <1339671715.13377.209.camel@gandalf.stny.rr.com>
	 <20120614154153.GD17140@kroah.com>
	 <1339693625.13377.242.camel@gandalf.stny.rr.com>
	 <20120615042233.GA10973@localhost> <20120615043017.GA9587@kroah.com>
	 <20120615120430.GB23681@gmail.com> <20120615231318.GD8205@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 16:13 -0700, Greg Kroah-Hartman wrote:

> > Please apply Steve's fix, fix it yourself or revert the changes that
> > regressed printk().
> 
> I thought Steve's patch was just a RFC thing, is it really something
> that everyone wants to see applied?

It was, and still is, an RFC. I'd like to fix the double printing of the
time stamps as well.

It was really a compromise, as the new printk() is a serious
functionality change. Even though I mostly use trace_printk(), there are
still times that I like to use printk in some hot spots. For example I
sometimes to do:

printk("a");
some_code();
printk("b");
more_code();
printk("c");
continued_code();
[etc]


And watch a stream of 'abcabcabc...' and see where finally something
causes the machine to triple fault and reboot.

Because the bug would cause a triple fault, there would be no time to
recover data from trace_printk(). But as the code is quite hot, my use
of printk is to be as small as possible and with no new lines.

But now this method is gone. Not to mention, digging through the complex
maze of the new printk, I realize that it's not optimize for speed at
all. But printing to the serial console makes it not that big of a deal.

I have patches that just force printk() to be early_printk(), and in
fact, we have in the -rt patch this:

http://git.kernel.org/?p=linux/kernel/git/rt/linux-stable-rt.git;a=blobdiff;f=kernel/printk.c;h=5a172f9e5027b7416a82e54dfc29afbda71296ee;hp=c4426061e228c252e226feb67193d80cdba3af5b;hb=865407ef06e61c97cdd9091082ed8038c801f535;hpb=c09d1c02743a7d2df13574d93dea9f21ccf02560

I had my own patch that did pretty much the same thing, and I was very
happy to see that Ingo had the same mind set.

Actually, I think that patch really should go mainline, and give others
some of the luxury that us -rt folks enjoy.

But back to this patch. I was irritated that we blamed the wrong code
because the printk functionality changed. And instead of writing some
drastic changes that would be controversial, I suggested a
'printk_flush()' that would work similar to a fflush(). Yeah, buffering
is good and lets lines fit together, but there's times where getting the
partial line out to the screen is more important that keeping it
together.

If other printks were interleaved and it didn't crash, we wouldn't care
(or even notice). But if it did crash, I'll even argue seeing the
interleaved printks would provide a hint to why it crashed.

-- Steve


