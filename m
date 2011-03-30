Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab1C3Vga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:36:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933631Ab1C3VgY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <201103302247.16339.rjw@sisk.pl>
References: <201103292143.12777.rjw@sisk.pl> <AANLkTi=nfzR=EQNaiPL_g=V_hfMY_61D7oKoPKAK=ETO@mail.gmail.com>
 <201103302247.16339.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 14:36:03 -0700
Message-ID: <AANLkTikoBbbq223q7+2kS_nLDi7XUtgT2hczu9P6nQCx@mail.gmail.com>
Subject: Re: [GIT PULL] Power management Kconfig modification for 2.6.39
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 1:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, otherwise I'd have to change CONFIG_HIBERNATION to something else
> throughout the tree and then add CONFIG_HIBERNATION as a user-visible option.
> Perhaps that would be better from the user's viewpoint, but the confusion would
> be still there.

Umm. It would be *less* confusing than the thing you sent me.

I would heartily support just renaming them all. Who cares about patch
size? What matters is the end result not being confusing.

Your current patch results in an end result that doesn't make sense.
That's what I'm complaining about. The #ifdef's don't make sense, and
the question to the user doesn't make sense.

It is in all ways _inferior_ to the current situation. So I simply
won't pull it.

The thing it tries to fix (some crazy Xen detail) is not worth messing
up the main code for.

So I'd be happy to fix up whatever issues Xen has, but not at the cost
of making all the _sane_ configurations more confusing.

> Now, I agree, to the users it would be _less_ confusing to rename
> CONFIG_HIBERNATION everywhere to eg. CONFIG_HIBERNATE_CALLBACKS and then
> change every instance of CONFIG_HIBERNATE_CALLBACKS that's not about callbacks
> to CONFIG_HIBERNATE (or CONFIG_HIBERNATION again), but that's going to
> be confusing to every maintainer of the affected code (which is the majority
> of architectures in the tree).  I simply wasn't quite sure which one to
> choose, so I took an easier path.  If you want the more complicated one, then
> so be it.

Well, so having looked at the current #ifdef'fery, I actually think
the Xen people would need to do more than that to make sense.

For example, just renaming CONFIG_HIBERNATION to
CONFIG_HIBERNATE_CALLBACKS is insane too. It makes some of the
#ifdef's look just completely insane. Looking at the current state of
<linux/mm.h>, for example, we have things like this:

#ifdef CONFIG_HIBERNATION
extern bool kernel_page_present(struct page *page);
#endif /* CONFIG_HIBERNATION */
#else
static inline void
kernel_map_pages(struct page *page, int numpages, int enable) {}
static inline void enable_debug_pagealloc(void)
{
}
#ifdef CONFIG_HIBERNATION
static inline bool kernel_page_present(struct page *page) { return true; }
#endif /* CONFIG_HIBERNATION */
#endif

which is just nasty, but at least reading it makes sense ("ok,
kernel_page_present() is about HIBERNATION"). But would that be a
"callback" case? That's what your old patch implies (because it wasn't
changed to an "interface" case in your patch). But that makes no sense
either. What does that function have to do with the callbacks?

So once you split up CONFIG_HIBERNATION into multiple cases (and that
is true both for the HIBERNATION_INTERFACE and HIBERNATION_CALLBACKS
case), what is the rule for something like kernel_page_present()?
Something that sounds logical? Taking into account that the config
option needs to be logical for the person who actually sees the
_question_ too (which was the problem with the "INTERFACE" approach).

That mm.h thing - it sure doesn't look like some callback thing. Or if
it is, I'd like an explanation about it.

And why was the low-level x86 register save code under "interface"?
That made no logical sense either. To me, the _interface_ is about
things like /sys/power/disk etc, not about some low-level x86 code.

So I'd expect that

 (a) the main question to the user - and config variable) should be
CONFIG_HINBERNATE, matching CONFIG_SUSPEND. We're already a bit
illogical ("HIBERNATION" vs "SUSPEND" - if you google for those two
words, you'll notice that the top answers actually talk about
"hibernate" vs "suspend"), we shouldn't make it worse.

     This one is just a no-brainer. We shouldn't ask users about
"interfaces" in the first place, but more importantly, to the user the
HIBERNATE vs SUSPEND question are about the exact same kind of thing,
so if we _did_ ask about interfaces, then we should be consistent, and
change it to SUSPEND_INTERFACE too.  And I don't think anybody really
would want that.

 (b) when writing code, the #ifdef's you need should not surprise you. Doing a

    git grep '#.*if.*CONFIG_HIBERNAT'

  shouldn't result in some WTF moment. I still don't understand why
CONFIG_HIBERNATE_INTERFACE was the one that picked the x86
hibernate_[asm]_$(BITS).o files, for example. That was a very WTF
moment to me in the patch.

What parts is it that Xen actually wants? It doesn't seem to be much
of the core hibernate code at all - a lot of the core hibernate code
seemed to go under "interface" in your patch. But what about
kernel_page_present()? That's the kind of WTF? question that made me
go "no, this makes things worse".

                       Linus
