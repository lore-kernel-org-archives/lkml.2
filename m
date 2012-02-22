Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab2BVKno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:43:44 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37407 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2BVKnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:43:37 -0500
Date: Wed, 22 Feb 2012 11:43:24 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
Message-ID: <20120222104324.GA26845@aftab>
References: <20120220145920.GB5728@aftab>
 <4F438CE9.7080807@redhat.com>
 <20120221141231.GA15515@aftab>
 <1329835698.25686.60.camel@gandalf.stny.rr.com>
 <20120221145943.GB15515@aftab>
 <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:58:37AM +0000, Luck, Tony wrote:
> I'm also struggling to understand an end-user use case where you would
> want filtering.  Mauro - can you expand a bit on why someone would just
> want to see the errors from memory controller 1?
> 
> My mental model of the world is that large systems have some background
> noise - a trickle of corrected errors that happen in normal operation.
> User shouldn't care about these errors unless they breach some threshold.
> 
> When something goes wrong, you may see a storm of corrected errors, or
> some uncorrected errors. In either case you'd like to get as much information
> as possible to identify the component that is at fault. I'd definitely like
> to see some structure to the error reporting, so that mining for data patterns
> in a storm isn't hideously platform dependent.

Yep, I'm on the same page here.

> It might be easier to evaluate the competing ideas here with some sample
> output in addition to the code.

Well, to clarify:

When you get a decoded error, you get the same format as what you get in
dmesg, for example:

[ 2666.646070] [Hardware Error]: CPU:64   MC1_STATUS[-|CE|MiscV|PCC|-|CECC]: 0x9a05c00007010011
[ 2666.655003] [Hardware Error]: Instruction Cache Error: L1 TLB multimatch.
[ 2666.655008] [Hardware Error]: cache level: L1, tx: INSN

And with the decoded string tracepoint, that thing above is a single
string. If you use trace_mce_record(), you still can get the single
MCE fields which we carry to userspace from struct mce, _in addition_.
The hypothetical problem is for userspace not being able to use the
tracepoint format to parse reported fields easily and in an unambiguous
manner. Instead, it gets a single string which, I admit, is not that
pretty.

Now, the problem is if we want to use a single tracepoint for all errors
- it is unfeasible that any fields sharing can be done there except
maybe the TSC stamp when it happened, the CPU that caught it and etc.
not so important details.

IOW, the error format is different for each error type, almost, and
there's no marrying between them. OTOH, ff we start adding tracepoints
for each error type, we'll hit the other end - bloat. So also a no-no.

Maybe the compromise would be to define a single tracepoint per
_hardware_ error reporting scheme. That is, MCA has an own tracepoint,
PCIE AER has its own error reporting tracepoint, then there's an EDAC
!x86 one which doesn't use MCA for reporting and also any other scheme a
hw vendor would come up with...

This will keep the bloat level to a minimum, keep the TPs apart and
hopefully make all of us happy :).

Opinions?


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
