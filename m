Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1FPHHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:07:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:36220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab1FPHG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:06:58 -0400
Subject: Re: Oops in VMA code
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <BANLkTimB5gEZ2S=b9EiiWR-_u+o+wEPyjw@mail.gmail.com>
Date: Thu, 16 Jun 2011 09:06:55 +0200
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4DDCD104-305E-48B1-8155-BD17380632F2@suse.de>
References: <47FAB15C-B113-40FD-9CE0-49566AACC0DF@suse.de> <BANLkTimubRW2Az2MmRbgV+iTB+s6UEF5-w@mail.gmail.com> <CDE289EC-7844-48E1-BB6A-6230ADAF6B7C@suse.de> <BANLkTikLLfJ6yGNVcZ+o1RFmRoqRVrRSYQ@mail.gmail.com> <96D27CEC-8492-49F2-913F-F587DEC5E95E@suse.de> <BANLkTimB5gEZ2S=b9EiiWR-_u+o+wEPyjw@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16.06.2011, at 08:54, Linus Torvalds wrote:

> On Wed, Jun 15, 2011 at 11:20 PM, Alexander Graf <agraf@suse.de> wrote:
>> 
>> On 16.06.2011, at 07:59, Linus Torvalds wrote:
>>> 
>>> r26 has the value 0xc00090026236bbb0, and that "90" byte in the middle
>>> there looks bogus. It's not a valid pointer any more, but if that "9"
>>> had been a zero, it would have been.
>> 
>> Please see my reply to Ben here.
> 
> Your reply to Ben seems to say that 0xc00000026236bbb0 wouldn't have
> been a valid address, because you don't have that much memory.
> 
> But that's clearly not true. All the other registers have valid
> pointers in them, and the stack pointer (r1) is c000000262987cd0, for
> example. And that stack is clearly valid - if the kernel stack pointer
> was corrupted, you'd never have gotten as far as reporting the oops.
> 
> So you may have only 8GB of RAM in that machine, but if so, there's
> some empty unmapped physical space. Because clearly your RAM is _not_
> limited to being mapped to below 0xc000000200000000.

Ah, yes. The PowerMacs have this nice memory hole, so RAM is actually mapped non-linearly:

Top of RAM: 0x280000000, Total RAM: 0x200000000

So you're right. The address does look valid.

> To recap: I'm pretty sure the memory corruption is just the "90" byte.
> The rest of the pointer looks too much like a pointer to be otherwise.
> Whether that's due to a two-bit error (unlikely) or a wild byte write
> (or 16-bit write with zeroes) is hard to say. USUALLY when we have
> wild pointer errors, the corruption is more than just a few bits, but
> it could have been something that sets a few bits in software, and
> just sets them using a stale pointer.

That could very well be - the unaligned location is very odd indeed. So some ORing function sounds likely.

>> Yup, so let's keep this documented for now. Actually, the more I think about it the more it looks like simple random memory corruption by someone else in the kernel - and that's basically impossible to track and will give completely different bugs next time around :(.
> 
> We've had several bugs found by the pattern of the corruption, so I
> wouldn't say "impossible to track". Even if the next time ends up
> being a completely different oops (because the corruption happened in
> a totally different kind of data structure), it might be possible that
> there's that same "90" byte pattern, for example.
> 
> But it needs more than one bug report to see what the pattern is.
> Usually it takes a _lot_ more..

Yeah, let's wait for that moment then :). For now everything's pure speculation.


Alex

