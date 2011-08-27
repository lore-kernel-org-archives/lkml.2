Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1H0Bf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 21:35:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab1H0Bf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 21:35:58 -0400
Message-ID: <4E5849EC.4060406@zytor.com>
Date: Fri, 26 Aug 2011 18:35:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com> <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com> <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com> <4E58401A.2030002@zytor.com> <CA+55aFxtM0MbqBYQoTxfPOj8jVqj1Rc=s3YjDhg5wXUb3Y5BPQ@mail.gmail.com>
In-Reply-To: <CA+55aFxtM0MbqBYQoTxfPOj8jVqj1Rc=s3YjDhg5wXUb3Y5BPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 06:18 PM, Linus Torvalds wrote:
> On Fri, Aug 26, 2011 at 5:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Unfortunately, there is actually a reason for the use of "unsigned long"
>> here -- it means that the combination of the time and the _nsec fields
>> matches struct timespec.  struct timespec/struct timeval is one of those
>> things that it would be really nice if we *could* change (it's not
>> inherently pointer-sized, and it really should be 64 bits), but struct
>> timespec and struct timeval are embedded in a a number of memory
>> structures, some of which have pointers; and they are used by ioctls.
> 
> But for "struct stat"? You can't depend on that anyway.

No, but since we have the conversion function in the kernel already it
seems we might as well use it.

> And I really do think that a new 32-bit ABI is *much* better off
> trying to be compatible with x86-64 (and avoiding things like 2038)
> than it is trying to be compatible with the old-style x86-32 binaries.
> I realize that it may be *easier* to be compatible with x86-32 and
> just add a few new system calls, but I think it's wrong.

It is wrong to more than a small degree, to be sure.  However, "easier"
here is the difference of working through every data structure used by
every ioctl in every driver in the kernel and figure out which ones have
pointers or pointer-sized items, when that is work that has already been
done once.  Admittedly that does come with some legacy, but it does not
appear to be a significant extra cost.

Y2038 is certainly the single biggest issue here, and I fully admit to
not having a good answer on that one.  Note that applies to every single
32-bit ABI in the Linux kernel, including asm-generic which is used by
all brand new architectures.

	-hpa
