Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2BLMIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 07:08:19 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:54145 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2BLMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 07:08:16 -0500
Message-ID: <497b5023120625f839ac824e09a56986.squirrel@webmail.greenhost.nl>
In-Reply-To: <4F35A0A6.8020600@zytor.com>
References: <20120116183730.GB21112@redhat.com>
    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
    <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>
    <4F3007AD.50307@zytor.com>
    <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>
    <4F33110D.3050904@zytor.com>
    <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>
    <4F334B8C.2050005@zytor.com>
    <CAMe9rOrf-DrgdwsnpX7pa=h1p9qSpqa9fwJAQJvjSzgR9MAB_w@mail.gmail.com>
    <b3f79ce8b30e2985723eec1a3337317e.squirrel@webmail.greenhost.nl>
    <4F346FB0.9070203@zytor.com>
    <19ac5d5293110612dc17c514bc7e1ccd.squirrel@webmail.greenhost.nl>
    <cc95fcf4b1c28ee6f73e373d04593634.squirrel@webmail.greenhost.nl>
    <4F353D65.7070705@zytor.com>
    <d4b1bf80e0ecde82ed2595026e3f6ba7.squirrel@webmail.greenhost.nl>
    <4F35A0A6.8020600@zytor.com>
Date: Sun, 12 Feb 2012 13:07:26 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 9b84bad32751a42de3aa9e7877f1ca86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, February 10, 2012 23:56, H. Peter Anvin wrote:
> On 02/10/2012 02:42 PM, Indan Zupancic wrote:
>>> #include <stdnak.h>
>>
>> Could you please elaborate? Is it just the stealing of eflags bits that
>> irks you or are there technical problems too?
>
> Yes, I will not accept that unless it gets ok'd by the architecture
> people, which may take a long time.

The kernel x86 people or the Intel CPU people?

With the latest patch it doesn't matter what bits Intel decides to use in
the future, any clashes can always be handled unambiguously.

>> I understand some people would prefer a new regset, but that would force
>> everyone to use PTRACE_GETREGSET instead of whatever they are using now.
>> The problem with that is that not all archs support PTRACE_GETREGSET, so
>> the user space ptrace code needs to use different ptrace calls depending
>> on the architecture for no good reason. If PEEK_USER works then it's less
>> of a problem, then it's one extra ptrace call compared to the eflag way
>> if PTRACE_GETREGS is used. If this new info is exposed with a special
>> regset instead of being appended to normal regs then one extra ptrace
>> call per system call event needs to be done. You can as well add special
>> x86 ptrace requests then.
>
> Seriously... if you're mucking with registers on this level, youan
> architecture dependency is not a big deal, and perhaps it's a good sign
> that the laggard architectures need to catch up.  If multiple ptrace
> requests is a problem, then perhaps this is a good sign that we need a
> single way to get multiple regsets in a single request?

Well, if we're forcing people to use a different API then we can as well
overhaul the whole ptrace thing to have a decent interface instead of all
this mucking around with waitpid() and whatnot.

That is the main advantage of the stealing eflags bits approach, it's mostly
API independent. That it puts the info close to the data where it is used is
a bonus.

>> Or is the main advantage of using a regset that it shows up in coredumps?
>> That would merit the extra effort at least.
>
> That is another plus, which is significant, too.  The final advantage is
> expandability.

I just realized that if coredumping uses ptrace's code the eflags will
show up too. As for expandability, there are a few more bits left...
But more seriously, what other highly x86 specific flags are needed?
Other than maybe the syscall entry instruction, which I'm not convinced
of, I can't think of anything.

Greetings,

Indan


