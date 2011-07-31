Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1GaCDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 22:03:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51688 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1GaCDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 22:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyimDdpCRER_7pc30S-QLhUkt0z-Y=gD48f7t=FxxFh7g@mail.gmail.com>
References: <20110730234630.7270.qmail@science.horizon.com>
 <CAF_S4t8TFour-Yw1T+qdG9mCzy9+tGBR0hQG83+ra6PRzPhNHQ@mail.gmail.com> <CA+55aFyimDdpCRER_7pc30S-QLhUkt0z-Y=gD48f7t=FxxFh7g@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 30 Jul 2011 22:02:24 -0400
Message-ID: <CAF_S4t9PhDQBBfaLLaq1sE9YkJvQq5Q+ULegpD0aoTnv0CPutw@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 21:35, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jul 30, 2011 at 3:02 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>>
>> The problem, as you can see here, is we need to test for the existence
>> of an architecture-specific HWRNG once for _every word processed_.
>
> See the patch I sent out. Not only doesn't it check an
> architecture-specific flag on x86, IT COSTS NOTHING AT ALL on other
> architectures. Not per byte, not per call, not at all.

Certainly, on architectures which never support fast hwrngs, you can
avoid the overhead. I'm concerned about whether you're actually coming
out ahead in the case where there _is_ an arch hwrng.

> On x86, it does have the cost of:
>
>  - basically one conditional for the whole loop (branching out if
> there is no rdrand support at all). You cannot do much better than
> that, except of course if you statically say "compile for an x86 that
> doesn't have rdrand")
>
>  - a per-word cost of checking CF - which you are supposed to do
> anyway (ie the rdrand hardware will return with CF clear if the data
> isn't reliable).
>
> So at least on x86, I think you can get pretty close to "optimal
> behavior" with my approach.

Ah, I see - I wasn't aware RDRAND could fail. In that case, it's not
so bad, although it would be nicer to directly branch on the carry
flag, rather than emitting code that will, eventually, do a setcc ->
and -> test -> branch.

In any case though, what about my suggestion - don't mess with urandom
at all, and let udev replace the /dev/urandom device node with one
directed to a fast hwrng device if one is detected? This has zero
extra overhead - you have to pass through the character device layer
no matter what, and you can go straight from there to either the
standard hwrng wrapper code, or to your own special extra-fast
implementation of dev_read. It should also satisfy Mr. Spelvin's
paranoia - he can just instruct his udev to not replace /dev/urandom.
And so we don't need to introduce any new APIs to the kernel at all,
nor do we need to touch any core code.

The downside, of course, is that in-kernel users of entropy won't have
this fast API - do we have the kind of high-volume non-blocking
entropy consumers in the kernel that might care about this?
