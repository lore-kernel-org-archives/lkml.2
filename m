Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab1IBGSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 02:18:21 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:52415 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab1IBGSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 02:18:04 -0400
X-AuditID: 12074422-b7ba7ae000000a14-b6-4e607515a2ef
Message-ID: <4E607506.8030708@mit.edu>
Date: Fri, 02 Sep 2011 02:17:42 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com> <4E582EAA.1040108@zytor.com>
In-Reply-To: <4E582EAA.1040108@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsUixCmqrStWmuBn0H2N1WL7usPMFtM2iltc
	3jWHzWLLpWZWi82bpjJbPOp7y+7A5nGr7Q+zx85Zd9k93p07x+5xYsZvFo/Pm+Q8TrR8YQ1g
	i+KySUnNySxLLdK3S+DKeHFrGVPBat6KE39lGxh3c3UxcnJICJhI9Kw4zghhi0lcuLeeDcQW
	EtjHKLFjn3EXIxeQvZ5R4uSGLYwQzn0mieP/pjCDVPEKqEkcnDqLCcRmEVCVWDr/OFicTUBF
	omPpA7C4qECQxJsFO1kh6gUlTs58wgJiiwDVTP/5iQlkKLPAWUaJ3ic7wc4QFtCVOD71AzPE
	ti5GiV/L54NN4hTQlLixqwVoEgdQh7XEt91FIGFmAXmJ7W/nME9gFJyFZMcshKpZSKoWMDKv
	YpRNya3SzU3MzClOTdYtTk7My0st0jXVy80s0UtNKd3ECIoFdhelHYw/DyodYhTgYFTi4Q1Y
	Hu8nxJpYVlyZe4hRkoNJSZT3XlGCnxBfUn5KZUZicUZ8UWlOavEhRgkOZiUR3oksQDnelMTK
	qtSifJiUNAeLkjgv104HPyGB9MSS1OzU1ILUIpisDAeHkgRvYAlQo2BRanpqRVpmTglCmomD
	E2Q4D9BwS5Aa3uKCxNzizHSI/ClGRSlxXjmQhABIIqM0D64XlqpeMYoDvSIM0c4DTHNw3a+A
	BjMBDf6nHQ8yuCQRISXVwDhV/xR3da3RVBfeC2p1ylv+Nep9dv/LWcP6arXJ20sm1z5pR/aY
	LW72YVh3ecaLmB1L38pLsJRFv2YqmrVA4KSJRsq198/2Crn9v+snfE3q5g2+4Az1+suCS3Zl
	+q56svCBm83enGfbbxueuF7HPFc6eNW/W/ppolKGpvtqNER++z7TiV3f9F6JpTgj0VCLuag4
	EQCcVcitMAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 07:39 PM, H. Peter Anvin wrote:
> On 08/26/2011 04:13 PM, Linus Torvalds wrote:
>>>
>>> The extra bit would be masked off and only affect device drivers like
>>> input which relies on is_compat().
>>
>> So a couple of questions:
>>
>>   - why do we need another system call model at all?
>
> We think we can get more performance for a process which doesn't need
> more than 4 GiB of virtual address space by allowing them to keep
> pointers 4 bytes long, while still giving them the advantage of 16
> 64-bit registers, PC-relative addressing, and so on.  Furthermore, there
> are users who seem more willing to port code known to not be 64-bit
> clean to x32 than to do a whole new port.
>
> If the question is "why not just thunk this in userspace", the answer is
> that we'd like to take advantage of the compat layer already in the kernel.
>
> If the question is "why not just use int $0x80" we actually did that in
> early prototyping, but SYSCALL64 is much faster.

This may be a dumb question, but:

Why not just set some high bit of rax to enable compat syscalls to be 
issued with the 64-bit SYSCALL instruction.  This could be done with 
zero overhead for normal 64-bit code (you can just adjust the existing 
system-call-number-too-high path) and the total kernel patch should be 
just a handful of lines.  Does x32 need any more kernel support than 
that?  You'll confuse strace on new binaries, but that shouldn't be a 
big deal.

Also, why do ioctls and userspace structs need any translation at all? 
This is a new ABI -- why not just teach x32 code to stick zeros in its 
structs in the appropriate places to use the 64-bit layout.

--Andy
