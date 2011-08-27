Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1H0BS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 21:18:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785Ab1H0BS5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 21:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <4E58401A.2030002@zytor.com>
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
 <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com> <4E58401A.2030002@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Aug 2011 18:18:04 -0700
Message-ID: <CA+55aFxtM0MbqBYQoTxfPOj8jVqj1Rc=s3YjDhg5wXUb3Y5BPQ@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 5:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Unfortunately, there is actually a reason for the use of "unsigned long"
> here -- it means that the combination of the time and the _nsec fields
> matches struct timespec.  struct timespec/struct timeval is one of those
> things that it would be really nice if we *could* change (it's not
> inherently pointer-sized, and it really should be 64 bits), but struct
> timespec and struct timeval are embedded in a a number of memory
> structures, some of which have pointers; and they are used by ioctls.

But for "struct stat"? You can't depend on that anyway.

I do agree that it would be nice to just make "struct timeval" always
be 64 bits, and I actually think it *should* be done for any new ABI.
If for no other reason than "time_t" should be 64-bit, in order to
avoid all the issues with 2038.

Because the POSIX defintion of 'timeval' is *not* that the fields must
be 'long'. It's "time_t" + "suseconds_t", so it should be entirely
possible to make 'struct timeval' use 64-bit fields.

"struct timespec" seems to be designed as "time_t" + "long" which is
sad. But again, we could easily make it be

  typedef __u64 time_t;

  struct timespec {
    time_t tv_sec;
    long tv_nsec;
    long tv_unused;
  }

and it would actually be perfectly compatible with x86-64.

And I really do think that a new 32-bit ABI is *much* better off
trying to be compatible with x86-64 (and avoiding things like 2038)
than it is trying to be compatible with the old-style x86-32 binaries.
I realize that it may be *easier* to be compatible with x86-32 and
just add a few new system calls, but I think it's wrong.

2038 is a long time away for legacy binaries. It's *not* all that long
away if you are introducing a new 32-bit mode for performance.

                       Linus

But I think that's independent of 'struct stat' anyway.
