Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902Ab2FVXlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:41:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2FVXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:41:06 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=eGxSazS_8z_6xVDDWDoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340408464.27036.282.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 22 Jun 2012 19:41:04 -0400
In-Reply-To: <20120622145402.8047a669.akpm@linux-foundation.org>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 14:54 -0700, Andrew Morton wrote:
> On Thu, 21 Jun 2012 19:52:03 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > But with the new printk() changes, text without a newline gets buffered
> > and does not print out to the console at the location of the printk.
> 
> uh, how about we fix that?  The old behaviour was good, the new
> behaviour is noxious.
> 
> Please idenfity these "new printk() changes".  Was the new noxiousness
> an unavoidable effect of them?

See commit 7ff9554bb578 ("printk: convert byte-buffer to variable-length
record buffer") and related commits.

But that said, there may be a way that I can make it still always flush
and not add a new API. We can flush on partial writes, and keep track of
the current task (as it already does). If a new task comes in, we can
then force a newline before printing the content of the old task (if
there wasn't a newline printed before).

This is basically what it does now, except that it buffers the data. If
a new task were to do a print in between the two partial writes, it
flushes what was buffered and adds a newline before printing the new
text.

I think I may be able to implement the same behavior, except that it
wont buffer. It would just keep track of the state of the last write.

-- Steve



