Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab0FEMJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 08:09:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61611 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224Ab0FEMI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 08:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ex9Np5g/1VGcT8iwOVjkKpt34fSauSW+K7qefjXfahauo0eDueOJCW3g37/OoclCit
         IUpKqHIH9cs3UgzO7TlTKb0+//uX+xAdDPOTjDxmH7vbyhqTlFFxCJz06EUK5FsSUKlP
         +c1eVOSclAJTE0ukKbhaTY1NEHiZGWvxT3YgE=
MIME-Version: 1.0
In-Reply-To: <20100602013839.GB17579@us.ibm.com>
References: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com>
	<20100601193230.GA17579@us.ibm.com>
	<AANLkTinxCKl7RVe62UhIpNe5EriCufkgaih2D2mLLmC4@mail.gmail.com>
	<20100602013839.GB17579@us.ibm.com>
Date: Sat, 5 Jun 2010 08:08:37 -0400
Message-ID: <AANLkTinFGblE4fW35O0LchJZ22tz_5-qervpGC_lpUj_@mail.gmail.com>
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
From: Albert Cahalan <acahalan@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 9:38 PM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
> | Come on, seriously, you know it's ia64 and hppa that
> | have issues. Maybe the nommu ports also have issues.
> |
> | The only portable way to specify the stack is base and offset,
> | with flags or magic values for "share" and "kernel managed".
>
> Ah, ok, we have not yet ported to IA64 and I see now where the #ifdef
> comes in.
>
> But are you saying that we should force x86 and other architectures to
> specify base and offset for eclone() even though they currently specify
> just the stack pointer to clone() ?

Even for x86, it's an easier API. Callers would be specifying
two numbers they already have: the argument and return value
for malloc. Currently the numbers must be added together,
destroying information, except on hppa (must not add size)
and ia64 (must use what I'm proposing already).

This also provides the opportunity for the kernel (perhaps not
in the initial implementation) to have a bit of extra info about
some processes. The info could be supplied to gdb, used to
harden the system against some types of security exploits,
presented in /proc, and so on.

> That would remove the ifdef, but could be a big change to applications
> on x86 and other architectures.

It's no change at all until somebody decides to use the new
system call. At that point, you're making changes anyway.
It's certainly not a big change compared to eclone() itself.

> | > I don't understand how "making up some numbers (pids) that will work"
> | > is more portable/cleaner than the proposed eclone().
> |
> | It isolates the cross-platform problems to an obscure tool
> | instead of polluting the kernel interface that everybody uses.
>
> Sure, there was talk about using an approach like /proc/<pid>/next_pid
> where you write your target pid into the file and the next time you
> fork() you get that target pid. But it was considered racy and ugly.

Oh, you misunderstood what I meant by making up numbers
and I didn't catch it. I wasn't meaning PID numbers. I was meaning
stack numbers for processes that your strange tool is restarting.

You ignored my long-ago request to use base/size to specify
the stack. My guess was that this was because you're focused
on restarting processes, many of which will lack stack base info.
I thus suggested that you handle this obscure legacy case by
making up some reasonable numbers.

For example, suppose a process allocates 0x40000000 to
0x7fffffff (a 1 GiB chunk) and uses 0x50000000 to 0x5fffffff as
a thread stack. If done using the old clone() syscall on i386,
you're only told that 0x5fffffff is the last stack address. You
know nothing of 0x50000000. Your tool can see the size and
base of the whole mapping though, so 0x40000000...0x5fffffff
is a reasonable place to assume the stack lives. You therefore
call eclone with base=0x40000000 size=0x2000000 when
restarting the process.

For everybody NOT writing an obscure tool to restart processes,
my requested change eliminates #ifdef mess and/or needless
failure to support some architectures.

Right now user code must be like this:

base=malloc(size);
#if defined(__hppa__)
tid=clone(fn,base,flags,arg);
#elif defined(__ia64__)
tid=clone2(fn,base,size,flags,arg);
#else
tid=clone(fn,base+size,flags,arg);
#endif

The man page is likewise messy.

Note that if clone2 were available for all architectures,
we wouldn't have this mess. Let's not perpetuate the
mistakes that led to the mess. Please provide an API
that, like clone2, uses base and size. It'll work for every
architecture. It'll even be less trouble to document.
