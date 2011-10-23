Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099Ab1JWSwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 14:52:49 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:53968 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1JWSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 14:52:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/lkml
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE mappings
In-Reply-To: Linus Torvalds's message of  Saturday, 22 October 2011 21:32:38 +0300 <CA+55aFx_9D8jY2sqcZ+Tm305W9d8o+ZhEv8XNWuN4--S2bqRwQ@mail.gmail.com>
References: <20111021213916.914462C0A5@topped-with-meat.com>
	<CA+55aFy3ALC34AyrsHi9yjBgRMwg9G5w2PhDfr_JVti1M8GbNQ@mail.gmail.com>
	<20111022172450.0BCCE2C0A9@topped-with-meat.com>
	<CA+55aFx_9D8jY2sqcZ+Tm305W9d8o+ZhEv8XNWuN4--S2bqRwQ@mail.gmail.com>
X-Zippy-Says: Here we are in America...  when do we collect unemployment?
Message-Id: <20111023185243.EFE2F2C08F@topped-with-meat.com>
Date: Sun, 23 Oct 2011 11:52:43 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=27hm96M904wA:10
		a=kj9zAlcOel0A:10 a=tys9ew6eAAAA:8 a=_C0ai6uGk0x0ruEvfK0A:9
		a=G7n9rwaVaIkQmA91zYMA:7 a=CjuIK1q_8ugA:10 a=lJD7HqoX89cA:10
		a=eZWaBbVgQVUNtcZ3:21 a=nV3BwX-ylQ4AHCoi:21 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The app can try to be robust by doing the mmap(PROT_NONE), but if that
> fails, then the app should just let it go.

Indeed the application does not get unhappy about the mmap failing.  It
does need to try it in a loop, moving up a page after each failure, though.
Its own robustness requirement mandates that space up to 0x10000 be blocked
off, even if the system is only enforcing it up to 0x1000, for example.

> But that's no reason for the kernel to *allow* the mapping.

I don't have a problem with that.

> So I was looking for some *other* reason for the patch.

As I explained, the rationale was not to have any LSM modules (such as
SELinux) complaining about the attempt.

> Btw, if the only concern is "you don't want to elevate the selinux
> denial to be some user-visible thing", then I'd suggest attacking
> *that* issue directly.

That's fine with me too.

> For example, maybe we could fail the PROT_NONE mmap (ie not actually
> create any mapping at all, and certainly not create anything that is
> then mprotectable), but return success and not elevate it to be
> reported.

That works, though AFAICT it needs this slightly more complex logic
repeated in each different LSM.

> But then it really is important to return success, because otherwise
> it would be a "silent probe" of the security model (ie a bad user
> could use the mmap(PROT_NONE) to see if min_mmap_addr is on or not
> without triggering any selinux warnings).

Agreed.

> And unlike your patch, it wouldn't open up some new interface
> (mprotect) to worry about.

I agree that is better.  What's important is that the application can rely
on the low memory range never being made accessible by any mmap.

> So I think it might be valid to say "always allow mmap(PROT_NONE)
> under mmap_min_limit, by simply turning it into a no-op".

Note that there is also CONFIG_LSM_MMAP_MIN_ADDR to consider, but yes.

> On Sun, Oct 23, 2011 at 2:08 AM, Kevin Easton <kevin@guarana.org> wrote:
> >
> > Won't this still allow silent probing, because the malicious user can
> > just try to create the mapping, then check in /proc/self/maps to see
> > if it really worked?
> 
> Yup, right you are.

Not if the application is already running inside a sandbox that prevents
direct access to /proc (e.g. in a private FS namespace, as my application
in fact is).

> So we shouldn't do that either, and probably just leave the current
> semantics, unless Roland (or others) can convince me that complicating
> the kernel  mmap security model really is worth it.

I'm really only concerned with two things:

1. The application can do something after which it can rely, with maximal
   paranoia, on the [0,0x10000) range never being used by any later
   non-MAP_FIXED mmap, regardless of kernel variant or local system
   configuration.
2. Whatever LSM stuff might be in use distinguishes the actions that ensure
   this from a "potentially malicious" attempt to do a usable mapping in
   that range.

So either the "pretend to succeed" or the "fail without LSM whining" models
can fit those needs as well as the "really succeed for PROT_NONE only"
model I proposed.  (Though I agree with your point above that "pretend to
succeed" is a little bit better because of potentially revealing less about
the exact constraints the system is imposing.)  In the status quo today,
AIUI the only way to do "fail without whining" under SELinux is with a
"dontaudit" policy rule for the MMAP_ZERO permission check for the given
application--but that doesn't distinguish the harmless PROT_NONE attempts
from an actual "malicious" attempt, so it's suboptimal.  (And I don't know
about other LSM implementations that might do their own kinds of whining.)

So it may be sufficient just to change SELinux (and perhaps other LSM
implementations) to treat PROT_NONE specially for purposes of the whining.
LSM folks will have to say how best to make that happen.


Thanks,
Roland
