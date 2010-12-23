Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0LWP5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:57:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0LWP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:57:35 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=pPXw3_qIy5IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BGGqSoGpTEjORBJSsjMA:9 a=vthUAKeTK5shys7suphapjz2JMYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: ftrace: trace_pipe_raw interface broken
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
In-Reply-To: <AANLkTinEFVeVfMj9HgfO90wHVgCrzK+RSaDyXqeJuHUh@mail.gmail.com>
References: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com>
	 <1292903569.22905.123.camel@gandalf.stny.rr.com>
	 <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
	 <AANLkTikkwQC8pHPw=dvf5h++MnSOo9YY0dagNhv6s11B@mail.gmail.com>
	 <AANLkTinFjuFFAp3ayeF8L5x813248zeVJbPbgKK02Rjv@mail.gmail.com>
	 <AANLkTinEFVeVfMj9HgfO90wHVgCrzK+RSaDyXqeJuHUh@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 10:57:33 -0500
Message-ID: <1293119853.22802.33.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for looking deeper into this.

On Wed, 2010-12-22 at 16:37 -0800, David Sharp wrote:

> Regarding the strange "commit" values:
> 
> I noticed just now that it appears the low 16-bits are the correct
> value for "commit", bits 16-31 are c000, and bits 32-63 are ffffffff.

Ah yeah, I use 32bits so it would be the same on both 32 and 64.

> 
> ring_buffer_read_page can store the number of missing events at the
> end of the page if there is room. It signals it has done so with two
> bits in commit, bits 30 and 31. That's c0000000. This points to the
> ffffffff being a signed math problem, because these bits are added
> using "local_add".
> 
> Here's how the bits are defined:
> 
> /* Flag when events were overwritten */
> #define RB_MISSED_EVENTS	(1 << 31)
> /* Missed count stored at end */
> #define RB_MISSED_STORED	(1 << 30)
> 
> well, those would come out as signed int, and 1<<31 is 0x80000000, aka
> INT_MIN. When passed to local_add, which takes signed long, that would
> be sign-extended to 0xffffffff80000000.
> 
> Well, mystery solved at least. Now, how should it be fixed? Or is this
> intended behavior?

Not quite intended, but not something to worry about either. We mask off
the 30 bits to determine the size.

> 
> By my count that leaves only one mystery: why are we seeing this extra
> page at the beginning with pre-overflow data?

If you did not reset the buffer, there's a chance that the writer is on
the reader page. The reader page is always outside the ring buffer, but
it points into the ring buffer. If this occurs, then you will get the
reader page data, plus the rest of the ring buffer (which is the full
size you asked for).

-- Steve


