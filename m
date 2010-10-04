Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0JDW1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:27:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44352 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0JDW1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wWVgycaTcDyzbvWvs3iebVi7YcQTYjeAJY0gC6+KyzLIxTI6JCj1KzCDr1mLshC17A
         H5Y++F84s6kd50LDunmpziGsDRheOdCJB1dpx0jVmAsCHYUUbJCcuzM2u5Uzv/Ijy+Ts
         UNqVwuA9mYg8aE/UE9D64iLMk7/nb89owmZ24=
MIME-Version: 1.0
In-Reply-To: <4CAA53A2.6070703@zytor.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	<20101004154633.GA2900@redhat.com>
	<4CAA4C7D.8040006@zytor.com>
	<1286230518.6750.76.camel@gandalf.stny.rr.com>
	<4CAA53A2.6070703@zytor.com>
Date: Mon, 4 Oct 2010 23:27:16 +0100
Message-ID: <AANLkTimw4TgH_PXbmNVgGsH30F5x=GyinmpSjLZTx4xn@mail.gmail.com>
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Nick Lowe <nick.lowe@gmail.com>
To: nick.lowe@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I'm aware, the check is just broken in VMs that trace their
lineage to Connectix's VirtualPC that Microsoft acquired back in 2006.
Is this correct? On balance, is this really to be cared about?
As far as 'common' processors that don't play nicely with NOPL...

VIA Edens based on the 'Samuel 2' design do not support CMOV or NOPL.
All VIA Edens based on the 'Nehemiah' design support CMOV but not
NOPL. (Introduced in
2003.)

Via C3s based on the 'Samuel 2'or 'Ezra'/'Ezra-T' design do not
support CMOV or NOPL.
All C3s based on the 'Nehemiah' design support CMOV but not NOPL.
(Introduced in 2003)

National Semi's GXm, GXLV and GX1 do not support CMOV or NOPL.
All Geodes since and including National Semi's GX2 support CMOV but
not NOPL. (Introduced in
2002)
The AMD branded Geodes (GX and LX) support CMOV but not NOPL.

The Cyrix 6x86 processors do not support CMOV or NOPL.
The Cyrix 8x86MX / Cyrix MII do support CMOV but not NOPL.

The AMD K6 and K6-2 do not support CMOV or NOPL.

There are probably a few more I've forgotten about...
Nick

On Mon, Oct 4, 2010 at 11:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> On 10/04/2010 03:15 PM, Steven Rostedt wrote:
> >>
> >> We tried exactly this type of dynamic selection before, and it doesn't
> >> work on broken virtualizers; in particular Microsoft VirtualPC can pass
> >> the exception test and yet fail later.
> >
> > So the code is broken because of broken virtualizers??
> >
>
> Yup.  Fun, isn't it?  :(  Unfortunately, broken virtualizers appear as
> broken CPUs to us.  We used to do the #UD probe for NOPL, but it didn't
> work.
>
> >>
> >> The end result is very simple: you can always use NOPL on 64 bits, you
> >> can never use NOPL on 32 bits.
> >>
> >> 66 66 66 66 90 will always *work* (as in, it will never fail) but it's
> >> pretty slow on older CPUs which took a hit on handle prefixes -- but it
> >> might still be faster than a jump on those.  Thus, in your code the JMP
> >> case will never be reached anyway.
> >
> > The jmp was there because of paranoia, and I never expected it to be
> > reached.
> >
> >>
> >> There isn't, of course, a classic 5-byte sequence, although the sequence:
> >>
> >>      2E 8D 75 26 00
> >>
> >> ... should work (leal %ds:0(,%esi,1),%esi).  However, 66 ... 90 is
> >> likely to work better on modern processors (although I haven't measured it.)
> >
> > The point is, this nop will be at _every_ function call (it replaces the
> > mcount call). Not just scattered throughout the kernel. It is imperative
> > that we have the best nop available.
> >
> > So what would you recommend?
> >
>
> NOPL is special, because it's the only NOP sequence that isn't actually
> *supported* on all processors (and we have found that we can't even use
> it on 32 bits, even though the vast majority of all real-life 32-bit
> processors do support it.)
>
> Borislav is just checking to see if we can just use NOPL unconditionally
> on 64 bits; as far as 32 bits is concerned the only option for picking
> what is "best" is probably to benchmark some set of sequences on the set
> of processors we care about.  However, I suspect that on any modern
> processors either 66 66 66 66 90 or 2E 8D 75 26 00 will work equally well.
>
> With a bit of benchmarking I think we could adopt the policy of using
> NOPL on 64 bits and one of the above sequences on 32 bits.
>
>        -hpa
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
