Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1HEWLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:11:36 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43682 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1HEWLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <4E3C6982.5050901@zytor.com>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com>
 <20110805212153.GL5782@one.firstfloor.org> <CAObL_7GuauANLqM9DnbYnhRuOsnqE+fTEoM10qCfjc40eFHaUA@mail.gmail.com>
 <4E3C6982.5050901@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 5 Aug 2011 18:11:11 -0400
X-Google-Sender-Auth: Shd98E6HKeOYT_Hjeon1U7RxiSw
Message-ID: <CAObL_7GB_wpNhn=oKcmutWuB+RiQ9QXwtZ7v-duOy3wjyCLpNg@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 6:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/05/2011 02:26 PM, Andrew Lutomirski wrote:
>>
>> For a boot time switch, it might be nicer to just switch between the
>> current int 0xcc sequence and the older
>>
>> mov cx, 0x<magic>
>> int 0xcc
>> ret
>>
>> sequence.
>>
>> That way there's a ret in the vsyscall page but no syscall instruction.
>>
>
> Refresh my memory... we have what... six legacy vsyscall entry points?
> We could, hypothetically, burn six interrupt vectors with them.  If we
> get them from the 0x40-0x4f range, then they are harmless standalone REX
> prefixes (and INC/DEC instructions in 32-bit mode.)

Only three.  I have no real objection to burning two more vectors.
0xCD would also be safe.  ISTR that lower numbers like 0x40 might
actually mean something (ISA?).  32-bit semantics are irrelevant
because 32-bit code can't jump to the vsyscall page anyway.

>
> The issue with pin as far as I understand is that it's executing an
> instruction at a different address and expecting it to have identical
> semantics, which is an incorrect assumption for trapping instructions
> (consider doing that for something like SYSENTER!).

Agreed.  I think that no matter what we do we should encourage
userspace apps to stop doing dumb things.

>
> Now, as far as RET is concerned I don't see how it does anything that
> the INT instruction doesn't do already; ANY of the emulated instructions
> have to return to the address on the stack in order to work at all, OR
> they can return to the next address and do RET.

True.  But the emulated vsyscalls will segfault unless the registers
are valid points that they can write to, which makes them a little
harder to use than ret.

(And some day we could have a sysctl to turn off even the emulated syscalls.)

--Andy
