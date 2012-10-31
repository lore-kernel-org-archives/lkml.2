Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935382Ab2JaLGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:06:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35458 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580Ab2JaLGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:06:14 -0400
Date: Wed, 31 Oct 2012 12:06:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 6/9] compiler.h, bug.h: Prevent double error messages
 with BUILD_BUG{,_ON}
Message-ID: <20121031110609.GD16410@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Rientjes <rientjes@google.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
 <1351457835-7553-6-git-send-email-daniel.santos@pobox.com>
 <20121030161933.GD28499@liondog.tnic>
 <5090B875.7030902@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5090B875.7030902@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:34:45AM -0500, Daniel Santos wrote:
> Yes, the __build_bug_on_failed message is much more informative.  This
> will only increase with these patches.  For example, the line
> 
> BUILD_BUG_ON(sizeof(*c) != 4);
> 
> emits this error:
> 
> arch/x86/kernel/cpu/amd.c: In function ‘early_init_amd’:
> arch/x86/kernel/cpu/amd.c:486:2: error: call to
> ‘__build_bug_on_failed_486’ declared with attribute error: BUILD_BUG_ON
> failed: sizeof(*c) != 4
> make[1]: *** [arch/x86/kernel/cpu/amd.o] Error 1
> make: *** [arch/x86/kernel/cpu/amd.o] Error 2
> 
> It's true that there is some redundancy in there as well as the
> gibberish line number embedded in the function name, but the end of the
> line spits out the exact statement that failed.

I guess that's as good as it gets. But it's fine IMO, it tells you
exactly what you need to know.

> But as far as rather the fallback is first or the __compiletime_error
> function is a matter of asthetics, since it's really an either/or
> situation.  Either the __build_bug_on_failedxxx function will be
> declared with __attribute__((error(message))) and the fallback will
> expand to a no-op, or the fallback will produce code that (presumably
> always?) breaks the build.  For insurance, a link-time error will occur
> if the fallback code fails to break the build.

Right, but my suggestion was to have the more informative message always
trigger first, if possible and if gcc supports it (practically, more
and more systems will be upgrading gcc which has the error attribute
with time) and have the less informative one be the more seldom one. The
"fallback" naming is just a minor issue.

This way, the error message would be precise on most modern toolchains.
Older toolchains will issue something about negative array size, which
is not really helpful so one would have to fire up an editor and
actually look at the code :).

> Realistically, a single macro could be defined in compiler*.h that
> encapsulates the entirety of this mechanism and only exposes a "black
> box" macro, that will simply expand to something that breaks the build
> in the most appropriate fashion based upon the version of gcc.  In
> essence, the new BUILD_BUG_ON_MSG macro attempts to fill that roll.

Yes.

> I guess I'll fix it up (and address the emails on the other patches)
> and do a v5 then for the whole set? (is that the right way to resubmit
> with these corrections?)

Well, you could wait a couple of days first to gather feedback from
other people and then resend. This way you give chance to people to take
a look without them seeing too many versions of the patchset and getting
confused.

What I always do is send out the patchset, collect and discuss changes,
add in the required changes and test it while the discussions go on.
After they settle down (and they do in a couple of days, in most cases)
I then send out the newly tested version out.

That whole exercise takes more or less a week if you're doing other
stuff in between :)

-- 
Regards/Gruss,
    Boris.
