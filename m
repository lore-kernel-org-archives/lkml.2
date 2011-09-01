Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab1IAOOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:14:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36007 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420Ab1IAOOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:14:52 -0400
Message-ID: <4E5F930A.6070006@zytor.com>
Date: Thu, 01 Sep 2011 07:13:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de> <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de> <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com> <4E5E6AC0.60000@zytor.com> <4E5F88F8.2040008@redhat.com>
In-Reply-To: <4E5F88F8.2040008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 06:30 AM, Avi Kivity wrote:
> On 08/31/2011 08:09 PM, H. Peter Anvin wrote:
>>>  I really think that "x32" should try to aim *VERY* hard at using the
>>>  64-bit system calls, and seeing itself as being a "32-bit application
>>>  in a 64-bit world".  That's not just true for time_t (which I think
>>>  should be 64-bit on anything new that expects to survive for any
>>>  amount of time), but in general.
>>
>> We're trying for it.  The things we're trying to avoid is to muck (too
>> much) with the compat layer for the mega-multiplex system calls like
>> ioctl.  We can't just use the 64-bit ioctl because ioctl structures
>> generally contain pointers.
>>
> 
>      struct iovec
>      {
>          void __user *iov_base;    /* BSD uses caddr_t (1003.1g requires 
> void *) */
>          __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
>      } __attribute__((x32_abi_64));
> 
>      typedef long time_t __attribute__((x32_abi_64));
> 
> The x32_abi_64 attribute converts pointers and longs back to 64-bit and 
> adjusts the alignment accordingly.  If we tag all userspace visible 
> structures with this attribute, we can use the 64-bit ABI without changes.
> 
> Issues:
> &my_iovec->iov_base yields something that is not a void ** (reads of a 
> 64-bit pointer decay to a 32-bit pointer, writes zero extend).
>    printf formats will break
>    if someone embeds an iovec in a structure, it will occupy more space 
> than expected
> 

Yes, the idea of a compiler extension was floated... however, we'd
prefer not to go there if at all possible.

	-hpa
