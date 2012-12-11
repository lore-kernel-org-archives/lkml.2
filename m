Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2LKV27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:28:59 -0500
Received: from www84.your-server.de ([213.133.104.84]:51756 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2LKV26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:28:58 -0500
Message-ID: <1355261290.31675.7.camel@wall-e>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, aarcange@redhat.com
Date: Tue, 11 Dec 2012 22:28:10 +0100
In-Reply-To: <CALCETrVAhncj7R7pCTBqn9erC_fKoWzaO-PFBdf=d6-wQJCzTg@mail.gmail.com>
References: <1355242260-28762-1-git-send-email-stefani@seibold.net>
	 <50C78927.6080302@linaro.org> <1355259259.30831.13.camel@wall-e>
	 <CALCETrVAhncj7R7pCTBqn9erC_fKoWzaO-PFBdf=d6-wQJCzTg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 11.12.2012, 13:18 -0800 schrieb Andy Lutomirski:
> On Tue, Dec 11, 2012 at 12:54 PM, Stefani Seibold <stefani@seibold.net> wrote:
> > Am Dienstag, den 11.12.2012, 11:27 -0800 schrieb John Stultz:
> >> On 12/11/2012 08:11 AM, stefani@seibold.net wrote:
> >> > From: Stefani Seibold <stefani@seibold.net>
> >> >
> >> > This small patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> >> > and vdso_time() support to the VDSO for x86 32-bit kernels.
> >> >
> >> > The reason to do this was to get a fast reliable time stamp. Many developers
> >> > uses TSC to get a fast time time stamp, without knowing the pitfalls. VDSO
> >> > time functions a fast and reliable way, because the kernel knows the best time
> >> > source and the P- and C-state of the CPU.
> >> Very cool. There have been similar implementations of this patch over
> >> the years, but they were all bit more hackish then this.
> >>
> > Thanks, i think it is not more hackish than the x86 64 code.
> >
> >>
> >> > For x86 the vclock_gettime.c currently supports only the HPET and TSC timer,
> >> > the ACPI timer should be easily to add with an other patch.
> >> Although the ACPI PM timer requires port-io which would need tweaking to
> >> allow normal users to access it. And I'm not sure if the performance
> >> would be much improved, as the port-io probably dominates the
> >> performance cost.
> >>
> >
> > It was only an idea. I think it would be easy to give the ioperm read
> > for the ACPI Timer without breaking anything.
> 
> I think you'll have to be careful not to make context switches slower
> if you do this.  IIRC ioperm bitmaps live in the task structure (the
> i386 thing, not task_struct) and require extra slow instructions.
> 

Good point. I will measure the overhead. But for now, it was only an
idea.

> I still think we should do TSC only.
> 

HPET is still necessary, since many system have no stable TSC, because
of the C1E (enhanced halt). And with the VDSO the kernel overhead for
system call will go away, this is better than nothing.

> >> Could you expand a bit as to why a compat layer isn't possible? It seems
> >> we could easily convert the vsyscall_gtod_data to a more explicit
> >> arch-neutral size. Or is it the actual data page mapping?
> >>
> >
> > This could be done in a subsequent patch. First i want not change to
> > much, to make the review easier. Converting the vsyscall_gtod_data to
> > arch neutral is not so easy, because the size of time_t, timezone and
> > timespec differs. So currently 32 bit programs running under a 64 bit
> > kernel will not get a VDSO with time functions. But real 32 bit kernel
> > will provide it.
> >
> >
> 
> How would you address the vvar page in 32-bit userspace on a 64-bit
> kernel?  Would you map it low for 32-bit tasks or play descriptor
> games?
> 

As i mentioned, this is currently not implemented. On a 64 bit kernel
there is no VDSO time functions for 32 bit programs available. This
sugar will be come maybe with an other patch if it is possible to map he
vvar page to the low 32-bit address space. But for now a 32 bit programs
on 32 kernel will get the advantage.

- Stefani


