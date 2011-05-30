Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab1E3R3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:29:55 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:38977 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757649Ab1E3R3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:29:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Jr5OQH7kzIc5G5pZ5IIBWgwkZTT6jiJz+W6gujug4CwZG3O2iPwKKuxUbRVcboc/lR5SzKJMTVUdyqAipDcGmaywQUIm+abFbGmquzf5SDEnaLUnkwLOmzb0h6ynMFLk;
Date: Mon, 30 May 2011 10:29:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@MIT.EDU>, David Woodhouse <dwmw2@infradead.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-Id: <20110530102952.ede4089a.rdunlap@xenotime.net>
In-Reply-To: <20110530113036.GA22324@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<20110530113036.GA22324@elte.hu>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 13:30:36 +0200 Ingo Molnar wrote:

> 
> * Theodore Tso <tytso@MIT.EDU> wrote:
> 
> > 
> > On May 30, 2011, at 6:58 AM, Ingo Molnar wrote:
> > 
> > > 
> > > * Theodore Tso <tytso@MIT.EDU> wrote:
> > > 
> > >> I'd think that "make ARCH=x86_64 oldconfig"
> > >> 
> > >> ... where the old configuration contained CONFIG_X86_32
> > >> should trigger a warning, if not an outright error that 
> > >> stops the build....
> > > 
> > > That would be a rather sad regression for me: i use that command 
> > > regularly to transform .configs that came in bugreports into a config 
> > > suitable for a testbox that has a different bitness userspace 
> > > installed.
> > 
> > OK, so to clarify, what you want is for ARCH=xxx to always override 
> > whatever is in .config? [...]
> 
> If 'xxx' clearly signals both architecture and bitness then it should 
> override both the architecture and the bitness of the .config - 
> that's both common-sense and currently implemented (and relied on) 
> behavior.
> 
> 'ARCH=x86 oldconfig' should maintain bitness in the .config like it 
> does today, because the 'xxx' only specifies the architecture.
> 
> [ Btw., 'override the architecture' usecase is not just theoretical: 
>   i sometimes use this form to convert existing .config's *between* 
>   architectures, not just from 32-bit to 64-bit. So if i get an ARM 
>   bugreport that gives me the appearance of a core kernel bug i will 
>   often start by converting that to an x86 .config via 'make 
>   ARCH=x86_64 oldconfig'. ]
> 
> >  Are we all on the same page here? [...]
> 
> I think this thread makes it rather clear that David and me are not 
> on the same page. Not sure about you :)
> 
> > [...]  I thought David was arguing that what was in .config should 
> > always be more important, since he regards "ARCH=xxxx" as "legacy".
> 
> Well i (and current behavior) argue that what the user types actually 
> has a meaning and a purpose and provides an override to other 
> environmental data.
> 
> > Or maybe I'm missing something here.... since people seem to be 
> > slinging around examples what should or should not work, as opposed 
> > to simply saying, "ARCH=xxx" must always override all else, even in 
> > cases like "oldconfig", "randconfig", etc.  Is that what the patch 
> > is going to do?
> 
> I said it from mail #1 on that "ARCH=xxx" must override the .config 
> [except in cases like ARCH=x86 where 'xxx' does not imply bitness] 
> and must modify/filter other typed arguments 
> (randconfig/allnoconfig/allyesconfig, etc.) in an intuitive and 
> common-sense fashion.
> 
> > All this talk of how it's OK for randconfig to give you i386 50% of 
> > the time even when ARCH=x86_64 is specified is confusing me?  Maybe 
> > that was just intended to be sarcasm?
> 
> That was the original regression i reported to David. So yes, i do 
> argue, and argued from day 1 on (which was 2 years ago) that 
> 'ARCH=i386' and 'ARCH=x86_64' should override secondary sources of 
> environment.

AFAIK, command line options in kbuild always override other settings,
so this should remain consistent.

And yes, I also use lots of these same commands that Ingo uses, both in
scripts and non-scripted (by hand).

> It's just that David has not accepted my reasoning and has given a 
> changelog that describes the topic in a rather one-sided fashion.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
