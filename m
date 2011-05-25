Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1EYVn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:43:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40759 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab1EYVn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ay4dlm9/Lpk3sJR5IdSsyfA28PEvoVDa0zHkRGRCJUGpk1vCTCeaodVVfMLIqb6Cfk
         Zyaw0sznZK8+xibjBoEcY9pmJ1vXoYU2VZNVz3qCrXilT4UDUlco8gtG2ZsO8UytrCCs
         +GKrEzZEvFHt4WPrjcaifzhfejjqOm/xK8UZc=
MIME-Version: 1.0
In-Reply-To: <20110525134414.GB19118@elte.hu>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
	<20110524034023.GB25230@elte.hu>
	<987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
	<20110525134414.GB19118@elte.hu>
Date: Wed, 25 May 2011 14:43:56 -0700
X-Google-Sender-Auth: PeDr0xrlI_x8qaOx5ORwG-f0Mk4
Message-ID: <BANLkTin=j2BUDoQSH-Upvg3++z9dEgLP8Q@mail.gmail.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 Ingo Molnar <mingo@elte.hu>:
> Btw., the SIGKILL logic is probably overcomplicated: when it's clear
> that user-space can not recover why not do a do_exit() and be done
> with it? As long as it's called from a syscall level codepath and no
> locks/resources are held do_exit() can be called.

There is no SIGKILL - we use SIGBUS because it generally isn't clear
to the kernel whether the error is recoverable (the kernel can tell whether
it is *transparently* recoverable - e.g. by replacing a corrupt memory
page with a new copy read from disk in the case that the page is
mapped from a file and still marked as clean) - but if the kernel can't
recover, we want to give the application a shot at doing so. So we send
a SIGBUS with a payload specifying the virtual address and amount
of data that has been lost.

One database vendor has already used this mechanism in a demo
of application level recovery - a second is looking at doing so, and a
third was internally divided about whether the engineering cost of
doing this was justified given the rate of 2+bit memory errors.

[We do need a tweak here - it isn't helpful to have the application
drop a core file in the SIG_DFL case - so we really ought to stop
it from doing so]

>  - the conditions in filter expressions are pretty flexible so we
>   could do more than the current stack of severity bitmask ops. For
>   example a system could be configured to ignore the first N
>   non-fatal messages but panic the box if more than 10 errors were
>   generated. If there's a "message_seq_nr" field available in the
>   TRACE_EVENT() then this would be a simple "message_seq_nr >= 10"
>   filter condition. With the current severity code this would have
>   to be coded in, the ABI extended, etc. etc.

Generally you'd want to avoid rules based on absolute counts like this,
if you simply panic when you get to an event count of 10, then any system
that runs for long enough will eventually accrue this many errors and die.
Much better to use "events per time-window" (or a leaky bucket algorithm
that slowly "forgets" about old errors).  You might also want to keep
separate counts per component (e.g. DIMM stick) because 10 errors
from one DIMM stick may well indicate a problem with that DIMM, but
10 errors from different DIMMs is more likely an indication that your
power supply is glitchy.

I'll have to think about whether some parts of what is being done by
the existing severity code could be moved out to filters - I'm not
certain that they can - the code uses that table to parse whats in the
machine check banks as described in volume 3A, chapter 15 of the SDM to
determine just what is going on. The severity codes refer to each bank
(and each logical cpu nominally has its own set of banks - some banks
are actually shared between hyperthreads on the same core, or cores
on the same socket). The meanings are:

MCE_NO_SEVERITY = no error logged in this bank

MCE_KEEP_SEVERITY = something here, but is not useful in our
current context, leave it alone. The "S" bit in the MCi_STATUS register
is used to mark whether an entry should be processed by CMCI/poll of the
banks, or by the NMI machine check event hanlder (this resolves races
when a machine check is delivered while handling a CMCI)

MCE_SOME_SEVERITY = a real error, low severity (e.g. h/w has already
corrected it)

MCE_AO_SEVERITY = an uncorrected error has been found, but it need not
be handled
right away (e.g. patrol scrubber found a 2-bit error in memory that is
not currently being
accessed by any processor).

MCE_UC_SEVERITY - on pre-nehalem cpus uncorrected errors are never
recoverable, so
the AO and AR values are not used

MCE_AR_SEVERITY - an uncorrected error in current execution context - something
must be done, if OS can't figure out what, then this error is fatal.

MCE_PANIC_SEVERITY - instant death, no saving throw (log to NVRAM if you
have it)


So I think that we still need this triage - to tell us which sort of
perf/event to
generate (corrected vs. uncorrected, memory vs. something else, ...),
and whether
we need to take some action in the kernel immediately.

Probably all the event filtering can do is count and analyse the
stream of corrected
and recovered errors to look for patterns for some pre-emptive action - but the
bulk of the complex logic for this should be in the user level "RASdaemon"
that is consuming the perf/events.

-Tony
