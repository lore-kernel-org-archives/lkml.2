Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1AZX7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:59:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:40197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab1AZX7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cdUsABc1TcBFFh/zA6YURCCaDuTrCUb7hiSPuXr8fbBX5TPFzsbfq79p8X0AkAS+Nd
         p8a8KhYkxjoYt2WRevpQ==
MIME-Version: 1.0
In-Reply-To: <20110126024608.GB28283@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com> <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
 <20110126024608.GB28283@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Wed, 26 Jan 2011 15:58:46 -0800
Message-ID: <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
To: Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 6:46 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 25, 2011 at 03:12:52PM -0800, Mike Waychison wrote:
>> On Mon, Jan 24, 2011 at 7:17 PM, Greg KH <greg@kroah.com> wrote:
>> > On Mon, Jan 24, 2011 at 04:24:49PM -0800, Mike Waychison wrote:
>> >> +struct gsmi_ioctl {
>> >> +     uint16_t        length;         /* total length including data */
>> >> +     int             version;        /* structure version */
>> >> +     int             command;        /* ioctl command */
>> >
>> > Ick.  Use proper data types if you are going to create a new ioctl.
>> > Same goes for the structures above (hint, use __u32 and friends, not the
>> > unit??_t crap.
>> >
>> > I'd strongly suggest NOT creating a new ioctl though, that' just going
>> > to be a pain in the long run.
>>
>> Ok.  I'll change these.  Even if the __u32 vs u32 vs uint32_t
>> differentiation is non-sense :(
>
> Well, it really isn't nonsense.  __u32 and u32 can be different, and who
> really knows what uint32_t means in the end.

The following is probably off-topic for this thread, but it makes for
an interesting conversation anyhow.   Other responses to your other
questions are further below.

<type-discussion>

It's pretty clear in the standard what uint32_t means.  I don't know
how you could come up with a different interpretation.  See C99
section 7.18.1.1 for a definition.

> (hint the _t things are for
> userspace, not kernelspace, remember the issues of running 64bit kernels
> with 32bit userspace programs.)

I don't see what you mean.   _t does not mean "for userspace".  It's
reserved in the POSIX.1 environment, but the kernel itself isn't
written to a POSIX.1 environment (except UML perhaps?), so that
doesn't really apply.

I understand that type widths change in a compat setting.  So what?
Code in each environment is written to it's own namespace anyhow.


Here's what *I* think *you* think about __u32 vs u32 vs uint32_t.
Correct me if I'm totally off-base here:

  - u32: It's short and sweet, and gets the job done.  Awesome to use
in kernel sources.
  - __u32: Exists because we can't export identifiers like u32 in
headers and expect that users can include them without namespace
collisions.  We revert to using a double-underscore identifier prefix
in those headers, because users should know better than to use an
identifier reserved for the implementation.
  - uint32_t: Newer than the rest of the kernel and too verbose in the
code.  _t looks ugly.  Not clear if it is safe to export to userland
as there isn't a good way to know if they are defined or knows if they
are defined or not.

I believe the above is non-sense because there is no concerted effort
to ever let userland include kernel headers in any meaningful way.
Including kernel headers in userland code breaks all the time and
users are discouraged from doing so for a variety of reasons
(incompatibilities with the system call wrappers exposed by their
libc, exposes unmaintained internal implementation details to userland
code, there are no guarantees there won't be namespace collisions,
etc...)

Linux kernel headers are just as broken when used by userland as when
a .S file tries to #include a random <asm/*.h> file.  If users
shouldn't be including headers, why should anyone ever bother to
differentiate between u32 and __u32 (or uint32_t)?

</type-discussion>

>
> Actually, that reminds me, what are you going to do about 32/64bit
> issues?  This is one reason why ioctls really really suck.

Sure, it isn't always obvious how to write ioctls properly when you
don't know what you are doing.  In this case, the structures are by
definition packed, use exact width fields and don't embed pointers.
I'm not committed to this interface, but it does do the job.

> Not to
> mention the fact that you really are just adding special syscalls to the
> system here, which is another reason people hate them.

Well, personally I like ioctls and system calls.  They don't bloat the
system with unneeded crud and abstractions that aren't very useful.
So what if you can't easily interface with them from a bare shell.
That's what userland utilities are for anyhow.

>
> So, let me ask, what specifically are you wanting to import/export
> to/from the kernel here?  Have you thought about other kernel/user apis
> instead of ioctls?  What is forcing you to use ioctls?

I'm not sure if you are trying to suggest that there is a better way
to solve these problems without actually saying so.  We could probably
use a different interface, sure.
