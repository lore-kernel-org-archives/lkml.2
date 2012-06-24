Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2FXEkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 00:40:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35025 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2FXEj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 00:39:57 -0400
Message-ID: <4FE69A14.6040904@landley.net>
Date: Sat, 23 Jun 2012 23:39:48 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: daniel.santos@pobox.com
CC: Daniel Santos <danielfsantos@att.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 0/13] Generic Red-Black Trees
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <4FE64AB4.1010904@landley.net> <4FE661F8.3000109@att.net>
In-Reply-To: <4FE661F8.3000109@att.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 07:40 PM, Daniel Santos wrote:
> First off, thanks for your lively commentary!
> 
> On 06/23/2012 06:01 PM, Rob Landley wrote:
>> On 06/22/2012 11:00 PM, Daniel Santos wrote:
>>> Theory of Operation
>>> ===================
>>> Historically, genericity in C meant function pointers, the overhead of a
>>> function call and the inability of the compiler to optimize code across
>>> the function call boundary.  GCC has been getting better and better at
>>> optimization and determining when a value is a compile-time constant and
>>> compiling it out.  As of gcc 4.6, it has finally reached a point where
>>> it's possible to have generic search & insert cores that optimize
>>> exactly as well as if they were hand-coded. (see also gcc man page:
>>> -findirect-inlining)
>> For those of us who stopped upgrading gcc when it went to a non-open
>> license, and the people trying to escape to llvm/pcc/open64/tcc/qcc/etc
>> and build the kernel with that, this will simply be "less optimized"
>> rather than "you're SOL, hail stallman"?
> Forgive me, but I'm a little stumped here.  When did GCC move to a
> "non-open" license?

About when it decided anti-tivoization was within its mandate, so
delivering the modified code (satisfying "open source") was no longer
good enough for the FSF, so they added additional restrictions on how
you're allowed to install it on devices.

Can 'o worms. The list has been over this at great length.

> Either way, yes, one thing that must be considered with this is that
> code compiled prior to gcc 4.6 is indeed "less optimized." For gcc 4.2
> through 4.5, the difference is very minor (the compare function is not
> inlined).  From there back, it starts to grow.  In gcc 3.4.6, it's
> fairly ugly.

Less optimized but still works with old compilers is fine. (Less
optimized comes with the territory with old compilers.)

> I haven't performed tests on other compilers yet, but I wouldn't be
> surprised if llvm/clang does this better.  My next phase is to build a
> test module so we can quickly get performance data on various platforms
> & compilers.  Either way, an alternate compiler will have to support at
> least some of gcc's extensions to compile Linux.

Or patch them out, like tccboot did. Or incorporate them into new
standards, as c99 did. Or submit patches to the kernel ala the c99
structure initializers...

And who's talking "if"?

LLVM/CLANG builds a bootabe linux kernel:
http://lwn.net/Articles/441018/

Open64 builds a bootable linux kernel:
http://article.gmane.org/gmane.comp.compilers.open64.devel/2498

The PCC guys make an adorable token effort which is largely ignored:
http://bsdfund.org/bundle/

Heck, Fabrice bellard did it himself with tinycc back in 2004:
http://bellard.org/tcc/tccboot.html

(Yes, that was a modified subset of an obsolete version, and then a
little side project called "qemu" started taking up all his time, so the
tinycc project stagnated in 2005. But it _was_ the first non-gcc
compiler to pull this off, not counting Intel's closed-source ICC. And
reviving tinycc and gluing qemu's tiny code generator onto it as a
back-end so I don't have to handle target support myself is on my todo
list: http://landley.net/notes-2012.html#14-06-2012 )

LLVM is the leader this space because Apple's funding it, but I really
can't get that enthused about a C compiler written in C++. Of course
gcc's been moving that way since 2008 (http://lwn.net/Articles/286539/)
so LLVM isn't actually worse there. Highly questionable wither either is
really _progress_, though.

> Another question that has to be asked is "Is Linux ready for this?"  The
> answer today may be "yes" or "no", but to say that it can never be ready
> is pure folly.

I'm saying that adding complexity is not necessarily an improvement, and
that over-optimizing at the expense of portability may turn out to be a
mistake in the long run.

That said, reducing code duplication is a good thing. I'm just not
convinced "how well gcc 4.6 optimizes this" is the only relevant test
criteria here.

> Eventually, you have to decide to stop supporting older
> compilers and move to newer paradigms that lower the maintenance burden,

You keep using the word "paradigm". Voluntarily. I find this odd.

> enabling your developers to work on more important things.  C++ offers
> lots of these types of paradigms, but the compilers just aren't good
> enough yet (of course, there's the laundry list of reasons to not use C++).

Um, yes.  Yes there is:

http://landley.net/notes-2011.html#16-03-2011
http://landley.net/notes-2011.html#19-03-2011
http://landley.net/notes-2011.html#20-03-2011

>>> Layer 2: Type-Safety
>>> --------------------
>>> In order to achieve type-safety of a generic interface in C, we must
>>> delve deep into the darkened Swamps of The Preprocessor and confront the
>>> Prince of Darkness himself: Big Ugly Macro.  To be fair, there is an
>>> alternative solution (discussed in History & Design Goals), the
>>> so-called "x-macro" or "supermacro" where you #define some pre-processor
>>> values and include an unguarded header file.  With 17 parameters, I
>>> choose this solution for its ease of use and brevity, but it's an area
>>> worth debate.
>> Because this is just _filling_ me with confidence about portability and
>> c99 compliance.
> This is actually C99 compliant, even though it wont work on all
> compilers.  Somebody tested it on msvc and told me that it broke
> (*faints*).

LLVM/CLANG is bsd licensed (alas, with advertising clause, but code from
it might actually be incorporatable into the linux kernel, unlke gcc,
which is under a license extensively incompatible with the linux kernel).

Open64 is GPLv2, same license as the linux kernel.

The old tcc code was LGPLv2 but I have email from Fabrice saying he's ok
with his code being used under BSD, and I'm working on the clearances
and/or cleaning out the old code from people other than him to do 2
clause BSD on that. (Just for kicks at the moment. This became harder
when the tinycc website bit-rotted so badly 3 years after its last
release that the mailing list archive went away, but I'm dinking away at
it regardless...)

http://pcc.ludd.ltu.se/ is bsd licensed. It seems llvm has taken a bit
of the wind out of its' sails (having Apple devote multiple full-time
engineers will do that), but development is still chugging along.

Somebody glued Linus's Sparse to the LLVM backend last year:
http://lwn.net/Articles/456709/

Rather a large number of people reacted to gcc going GPLv3 the same way
they reacted to David Dawes changing the XFree86 license. They tend to
be quiet about it because the FSF guys scream bloody murder if they find
out (a heretic being worse than an atheist, as always). But the "shut up
and show me the code" aspects have been chugging along steadily.

They all seem to have decided to start over from scratch instead of
doing another egcs style fork like x.org did in response to that
relicensing. Possibly this is because the one thing GPLv3 _did_ manage
to do was undermine GPLv2 to the point that lots of people (myself
included) bit the bullet and started releasing BSD code.

(Now when you hear "the code is GPL", you can't tell from that whether
or not you can incorporate it in a given project. I struggled with that
for years before deciding it was untenable in the long run. Copyleft
only seems to work when there's a single unified pool whose network
effects made a single license a category killer, which GPLv2 was but
GPLv3 isn't. Sun tried splitting the community with CDDL, but it took
the FSF to have the leverage to truly poison the GPL with a CDDL2 six
years _after_ Linus announced he wouldn't switch to such a thing.
Section 6 of http://www.dwheeler.com/essays/gpl-compatible.html is
downright ironic in retrospect.)

Anyway, as I said: can 'o worms. You're welcome to disagree with my
assesment, but I'm not alone in it. I'm just usually open about it. Most
people who've lost faith in the GPL stay quiet about it, and several
mouth the words when everybody else sings from the hymbook to avoid the
inquisition.

(And yes, the transcript of
http://sf.geekitude.com/content/pros-and-cons-gnu-general-public-license-linucon-2005
is also retroactively ironic. Possibly in the Alanis Morisette sense of
"actually just unfortunate".)

> The "iffy" macro is IFF_EMPTY(), which uses a similar
> mechanism to kconfig.h's IS_ENABLED() macro.  I kinda doubt that one
> would break and not the other.  It's fairly easy to test though.

Yeah, people kept emailing me that because I implemented ENABLE macros
back in 2006 for BusyBox:

http://git.busybox.net/busybox/commit/?id=7bfa88f315d71c7f7a1b76fcec3886c7506aca24

At the time I played around with various preprocessor macros but wasn't
happy with the readability of any of it, so I modified kconfig and threw
some sed in the makefile instead. Alas, when I tried to push some of the
config infrastructure upstream, the kconfig maintainer at the time threw
up all over it, and it devolved into bikeshedding, and I lost interest
(as usual when that happens):

http://lkml.indiana.edu/hypermail/linux/kernel/0707.1/1741.html

(Also, if you typo a macro name then "build break" instead of "silently
always false" is a _feature_, not a bug. Macros that convert #ifdef
CONFIG_BLAH to if (ENABLE_BLAH) tend to go the second way because that's
the input they work with. Yeah, code review will catch it eventually,
but...)

So yay standard C99 micro stuff. I'm a little worried about being able
to unwrap it all and understand what's going on, but unlike templates we
have cc -E to fall back on here, so ok.

It's when you say "won't work on all compilers" that I start to worry.
C99 is a fairly reasonable standard. My understanding is that our
divergences from it are mostly historical (the kernel predates C99).

> Aside from that, is the size of the macro.  After stripping comments,
> the size is roughly 4155 bytes, indeed beyond the C99's minimum required
> size of 4096 bytes (even though most compilers use a much larger
> buffer).

Eh, I'm not worried about that. That _is_ a "fix your compiler" issue.
(Hardwired buffer sizes in 2012... tsk.)

> So that's another issue that can break on other compilers,
> unless it stores the macro with whitespace condensed, which would bring
> it down to 3416 bytes.
>> (Or I suppose C11!!one! compliance. The new thing that puts asserts in
>> the base language and makes u8 a keyword since _that_ won't break
>> existing code and putting utf8 string constants within quotes wasn't
>> previously possible.)
>>
>> I'm not saying the standard's perfect, I'm saying a web page that ties
>> itself to mozilla at the expense of working on firefox, let alone
>> chrome, might be a bit short-sighted these days. XFree86 begat x.org,
>> OpenOffice begat libre, etc. The FSF went nuts again and this time
>> around EGCS is called LLVM, so talking about gcc 4.6-only features
>> thrills some of us less than you might expect.
> It's really just a "not broken on gcc 4.6", since -findirect-inlining
> was introduced in gcc 4.4 or some such.

Ok, so "designed with gcc 4.6's optimizer in mind, regression tested
back to 3.4 for at least minimal functionality, and not intentionally
breaking other compilers".

That's what I wanted to know, and it sounds good to me.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
