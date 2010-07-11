Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab0GKGH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 02:07:28 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:58397 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0GKGH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 02:07:27 -0400
Date: Sun, 11 Jul 2010 08:07:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] tracing: properly align linker defined symbols
Message-ID: <20100711060723.GA16125@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> <20100709203301.GA13839@merkur.ravnborg.org> <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com> <1278721339.1537.166.camel@gandalf.stny.rr.com> <20100710063459.GA14596@merkur.ravnborg.org> <AANLkTindHPEQHhmrB562ZlFZMtAIN-S6yMmT7zubS2D_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTindHPEQHhmrB562ZlFZMtAIN-S6yMmT7zubS2D_@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 03:25:02PM -0700, Linus Torvalds wrote:
> On Fri, Jul 9, 2010 at 11:35 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > We define a number of symbols in the linker scipt like this:
> >
> >    __start_syscalls_metadata = .;
> >    *(__syscalls_metadata)
> >
> > But we do not know the alignment of "." when we assign
> > the __start_syscalls_metadata symbol.
> > gcc started to uses bigger alignment for structs (32 bytes),
> > so we saw situations where the linker due to alignment
> > constraints increased the value of "." after the symbol assignment.
> 
> Ok, why not clean this up a bit more, and use a helper macro for this
> pattern. There's a fair number of users of that kind of pattern, so
> that actually removes a few lines.
> 
> Here's an example patch. Untested. Whatever. But just this part
> 
>  1 files changed, 21 insertions(+), 31 deletions(-)
> 
> says to me that it's a good idea, and there are other cases that could
> use the new SYMBOL_SECTION() helper.
> 
> What do people think?

Looks good.
I especially like how we with this standardize on the alignment.
I will make sure a working version hits next merge window.

A few comments.

+#define SYMBOL_SECTION(name, section)          \
+       . = ALIGN(32);                          \
+       VMLINUX_SYMBOL(__start_##section) = .;  \
+       *(name)                                 \
+       VMLINUX_SYMBOL(__stop_##section) = .;

The arguments to this macro is confusing.
Something like this:

    #define SYMBOL_SECTION(section, symbol_suffix)

To encourage people to use the section name as suffix
the __start / __stop variables we could
introduce an additional define:

#define SYMBOL_SECTION(section) SYMBOL_SECTION_SUFFIX(section, section)

#define SYMBOL_SECTION_SUFFIX(section, symbol_suffix) \
+       . = ALIGN(32);                                \
+       VMLINUX_SYMBOL(__start_##symbol_suffix) = .;  \
+       *(section)                                    \
+       VMLINUX_SYMBOL(__stop_##symbol_suffix) = .;


I will update the patch to reflect this (+ the fix you pointed out).
But it will wait until Steven has decided what patch to forward
to fix the discussed regression.

	Sam
