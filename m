Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab1CUXqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:46:23 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:50409 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1CUXqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:46:20 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.130
X-Originating-IP: 134.134.137.75
Message-ID: <4D87E2CD.6020306@pbjtriplett.org>
Date: Mon, 21 Mar 2011 16:44:13 -0700
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-kernel@vger.kernel.org
Subject: Re: BITS handling of CPU microcode updates
References: <4D65EE74.1050709@pbjtriplett.org> <20110312023001.GB27550@khazad-dum.debian.net>
In-Reply-To: <20110312023001.GB27550@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed response; I wanted to make sure I could give you 
an answer that would agree with the Intel Software Developer's Manual, 
and that ended up meaning I needed to start the process of updating the 
relevant part of the SDM. :)

On 3/11/2011 6:30 PM, Henrique de Moraes Holschuh wrote:
> The BITS handling of Intel CPU microcode updates does not match either the
> official documentation I cold find, or the Linux kernel code.
>
> The documentation clearly states that microcode revision levels are a
> *signed* 32-bit number, and that implies it should be subject to signed
> comparisons.
>
> The Linux kernel code considers it an unsigned 32-bit number, and does an
> unsigned comparison (this is likely a bug).
>
> And the BITS code mentions something called a "BWG", and will always install
> a microcode with a revision<  0, it will never install a microcode with a
> revision of zero, and does a normal version comparison if the revision is
> greater than zero.
>
> AFAIK, just like extended signatures (which are yet to be seen in the wild),
> microcoes with negative or zero revision levels have never been published to
> operating system vendors, so those discrepancies have had, so far, no impact
> in the field.  But they could well be latent bugs.
>
> Can you please clarify what is the correct behaviour ?

The Intel SDM correctly identifies microcode revision numbers as signed. 
  However, a simple signed comparison doesn't actually capture the 
correct logic, nor does an unsigned comparison, though in both cases the 
problem doesn't tend to come up in common cases.

Negative microcode revision numbers only appear on microcodes used in 
test environments for debugging purposes.

For the following explanation, let X = the version of the microcode 
currently in the CPU, and let Z = the version of the microcode you 
potentially want to load depending on the revision check.

If you have a microcode with Z < 0, the user knows what they're doing 
and they want to load that microcode regardless of revision.  Always 
load such a microcode regardless of X (it doesn't matter if X < Z or X > Z).

If you have a microcode with Z > 0, and X > 0 as well (the CPU has a 
production microcode in it), then load the microcode only if newer (Z > 
X).  Since microcodes with negative revisions only appear in test lab 
environments (as you noted, they don't appear in the wild), and since 
with positive revisions this behavior matches either a simple signed or 
unsigned comparison, the subtly wrong results haven't appeared outside 
of test lab environments. :)

The interesting case comes up when X < 0 and Z > 0: the CPU already has 
a microcode loaded with a negative revision, and you have a production 
microcode you might want to load.  In this case, the correct behavior 
differs based on whether the microcode loader runs automatically (such 
as the tools that load microcode at Linux boot time), or acts with 
*explicit* user action (such as BITS, the BIOS int 15 handler, or the 
Linux tools *if* they can distinguish the case where the user explicitly 
ran them from the case of running automatically without user intervention).

Tools which run automatically, without explicit user action, should not 
attempt to load a microcode if (X < 0) and (Z > 0).  Doing so makes life 
very difficult for people in those test lab environments: they put a 
microcode they want to test in the BIOS or load it via BITS, but then 
the OS driver automatically overrides it with the latest production 
microcode.  So, tools which run automatically without explicit user 
action should follow this rule:
if ((Z < 0) || (Z > 0 && X > 0 && Z > X)) load_microcode();

Tools which load microcode in response to *explicit* user actions should 
override a negative-revision microcode with a positive-revision 
microcode.  Such tools should follow this rule:
if ((Z < 0) || (Z > 0 && Z > X)) load_microcode();


Currently, as far as I know, the Linux microcode driver and userspace 
tools do not distinguish these two cases: the logic invoked 
automatically at boot time matches the logic run if the user invokes 
microcode_ctl explicitly.  Given that, the revision logic in the kernel 
or microcode_ctl should match the "tools which run automatically, 
without explicit user action" case above:
if ((Z < 0) || (Z > 0 && X > 0 && Z > X)) load_microcode();

If microcode_ctl added an option to distinguish these two cases, it 
could apply the alternative logic when explicitly requested.

Note that you should *not* see production systems shipping with 
negative-revision microcodes.


I've started the process of getting the SDM changed to document the 
logic described above, and distinguish the two different types of 
microcode-loading tools.

Hope that helps,
Burt Triplett
