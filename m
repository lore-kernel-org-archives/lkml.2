Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab1HEWHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:07:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46274 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab1HEWHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:07:11 -0400
Message-ID: <4E3C6982.5050901@zytor.com>
Date: Fri, 05 Aug 2011 15:06:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Subject: Re: New vsyscall emulation breaks JITs
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com> <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org> <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org> <CAObL_7GuauANLqM9DnbYnhRuOsnqE+fTEoM10qCfjc40eFHaUA@mail.gmail.com>
In-Reply-To: <CAObL_7GuauANLqM9DnbYnhRuOsnqE+fTEoM10qCfjc40eFHaUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 02:26 PM, Andrew Lutomirski wrote:
> 
> For a boot time switch, it might be nicer to just switch between the
> current int 0xcc sequence and the older
> 
> mov cx, 0x<magic>
> int 0xcc
> ret
> 
> sequence.
> 
> That way there's a ret in the vsyscall page but no syscall instruction.
> 

Refresh my memory... we have what... six legacy vsyscall entry points?
We could, hypothetically, burn six interrupt vectors with them.  If we
get them from the 0x40-0x4f range, then they are harmless standalone REX
prefixes (and INC/DEC instructions in 32-bit mode.)

The issue with pin as far as I understand is that it's executing an
instruction at a different address and expecting it to have identical
semantics, which is an incorrect assumption for trapping instructions
(consider doing that for something like SYSENTER!).

Now, as far as RET is concerned I don't see how it does anything that
the INT instruction doesn't do already; ANY of the emulated instructions
have to return to the address on the stack in order to work at all, OR
they can return to the next address and do RET.

	-hpa
