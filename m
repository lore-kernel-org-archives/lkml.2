Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab1D0TCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:02:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53957 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1D0TCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:02:00 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gu6fZOg2AAAA:8 a=Os8dhU_S_VNIN34lcKIA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <4DB86163.2070201@zytor.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
	 <1303926576.18763.75.camel@gandalf.stny.rr.com>
	 <4DB86163.2070201@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 15:01:58 -0400
Message-ID: <1303930918.18763.95.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 11:33 -0700, H. Peter Anvin wrote:
> On 04/27/2011 10:49 AM, Steven Rostedt wrote:
> > On Tue, 2011-04-26 at 16:45 -0300, Thiago Farina wrote:
> >> This macro is arguably more readable than its variants:
> >> - !strcmp(a, b)
> >> - strcmp(a, b) == 0
> > 
> > Actually, this was proposed way back in 2002 my Rusty and I did not see
> > anyone arguing against it. I wonder why it never was incorporated back
> > then?
> > 
> > http://marc.info/?l=linux-kernel&m=103284339813100&w=2
> > 
> > [ added Cc's of some of those that replied to this thread ]
> > 
> 
> Because !strcmp() is idiomatic C.
> 
> This is the same kind of stupidity as
> 
> #define BEGIN {
> #define END   }

I argue that this is totally different than your example. Your example
demonstrates changing the syntax of C to simulate another language. This
has nothing to do with simulating any other language. The problem with 
!strcmp() is that it goes against the semantics of C, as '!' means not.
And to think '!' is an equal can get a bit confusing.

It is also the reason we already have two semantics in the kernel for
this:

	!strcmp(a, b) and strcmp(a, b) == 0

Personally, I'm fine with just using strcmp(a, b) == 0, as I have
learned to understand it. And when reading code, I've actually been able
to teach myself !strcmp(a, b) is equality (although with a slight hiccup
in my thought process).

But I still get stuck when I see the use of strcmp(a, b) meaning a != b.
This is where my brain stops completely to analyze if this is really
what the author of the code meant.

> 
> It doesn't matter if it is more readable *to you*... learn the language,
> please.

I have learned the language (it's my mother tongue), but I think
strcmp() is an anomaly of it. It was a mistake that libc never included
a streq(). If it had, we would not even be having this discussion.
Another note is that strcmp is not really part of the language itself as
we must write it ourselves.

Heck, we could add:

#ifndef __HAVE_ARCH_STREQ
/**
 * streq - Test if two strings are equal
 * @cs: One string
 * @ct: Another string
 */
#undef streq
int streq(const char *cs, const char *ct)
{
	unsigned char c1, c2;

	while (1) {
		c1 = *cs++;
		c2 = *ct++;
		if (c1 != c2)
			return 0;
		if (!c1)
			break;
	}
	return 1;
}
EXPORT_SYMBOL(streq);
#endif

And this would be just like adding another helper function.

-- Steve


