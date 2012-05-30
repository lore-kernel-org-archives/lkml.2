Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2E3Chj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:37:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57041 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab2E3Chh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:37:37 -0400
MIME-Version: 1.0
In-Reply-To: <201205292325.q4TNPBPw007366@terminus.zytor.com>
References: <201205292325.q4TNPBPw007366@terminus.zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 May 2012 19:37:15 -0700
X-Google-Sender-Auth: zYGRM55KcN5caPPju9UhWQS7L4s
Message-ID: <CA+55aFyjcbaRcK5yfi-xLc2W+AAk0EAY9fhNOc+-_uQdDzck6w@mail.gmail.com>
Subject: Re: [GIT PULL] x86 trampoline rework for 3.5
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 4:25 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> The rework of relocs.c is already in upstream.  I know you don't like
> lambda merges, but I did one for this branch, because I found that
> without it git will silently mismerge relocs.c between your tree and
> this branch; with the lambda merge in place it merges correctly.

So as far as I can tell, the merge does nothing useful. I merged both
with and without your merge, and either way the result is dubious.

The reason I call it dubious is that when I do the merge by hand, it's
ambigiuous what the resolution should be (but I have an opinion on
what the correct thing likely is), and if I take yours that "resolves"
the ambiguous case, but not in the way you then claim in this email.

> If you prefer to do this manually, you can instead pull
> 61f5446169046c217a5479517edac3a890c3bee7; however, make sure that
> arch/x86/tools/relocs.c ends up being the one from your current
> upstream tree.

Both your merge, *and* mine end up having a simple issue: your
original import of that file happened separately two different times,
and they don't agree.

In particular, the two branches disagree about what the
sym_regex_realmode[S_NSYMTYPES] array should look like. In my previous
head (and the one you claim is the right one), it has just two
patterns:

 /*
  * These are 16-bit segment symbols when compiling 16-bit code.
  */
        [S_SEG] =
        "^real_mode_seg$",

 /*
  * These are offsets belonging to segments, as opposed to linear addresses,
  * when compiling 16-bit code.
  */
        [S_LIN] =
        "^pa_",

but in your branch that "^pa_" pattern is duplicated for S_REL:

 /*
  * These symbols are known to be relative, even if the linker marks them
  * as absolute (typically defined outside any section in the linker script.)
  */
        [S_REL] =
        "^pa_",

 /*
  * These are 16-bit segment symbols when compiling 16-bit code.
  */
        [S_SEG] =
        "^real_mode_seg$",

 /*
  * These are offsets belonging to segments, as opposed to linear addresses,
  * when compiling 16-bit code.
  */
        [S_LIN] =
        "^pa_",

which looks odd.

But that case with three patterns is the one you selected in your
merge - *not* the current state of relocs.c that you claim should be
selected.

So I'm not pulling or merging anything until I understand what's going
on. Should I take the two-pattern one (which is what I have now, and
that seems sensible), or should that "^pa_" pattern really be merged
for two different cases (doesn't that just mean that the last one will
effectively override the first one)?

Also, your branch adds an "x86-relocs" thing to the scripts/.gitignore
file that you seem to have removed in the merge. What was going on
there?

                          Linus
