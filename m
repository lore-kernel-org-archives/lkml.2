Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1KNQ0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:26:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48002 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1KNQ0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:26:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7H5Ktva16xTj9QBq6v2k66q5H13Vyvv_Piju6vTiaC9cA@mail.gmail.com>
References: <8762inleno.fsf@spindle.srvr.nix>
	<CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
	<CAL82V5M6TgDme3swFKxF2ZXqTtcCPEr_+FK1F6zXzKr_scmQew@mail.gmail.com>
	<CAObL_7H5Ktva16xTj9QBq6v2k66q5H13Vyvv_Piju6vTiaC9cA@mail.gmail.com>
Date: Mon, 14 Nov 2011 08:26:35 -0800
X-Google-Sender-Auth: k36ESom-b9Z9FP4O-K_YHaHKCYw
Message-ID: <CAL82V5MXVELBhU9uqQ2RjF6UXBEFybyVHVYZ_xP2CkZKegnW8Q@mail.gmail.com>
Subject: Re: [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884
 breaks the Chromium seccomp sandbox
From: Mark Seaborn <mseaborn@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Nix <nix@esperi.org.uk>, linux-kernel@vger.kernel.org,
        Markus Gutschke <markus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2011 00:38, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sun, Nov 13, 2011 at 10:50 PM, Mark Seaborn <mseaborn@chromium.org> wrote:
>> I think the problem is that seccomp-sandbox attempts to patch the
>> vsyscall page.  It replaces the SYSCALL instructions in this page with
>> jumps to seccomp-sandbox's handler.  (More accurately, seccomp-sandbox
>> creates a patched copy of the vsyscall page.  It redirects glibc's
>> indirect jumps so that they go to the patched copy of the vsyscall
>> page instead of to the original.)  The code for this is in
>> patchVSystemCalls() in library.cc
>> (http://code.google.com/p/seccompsandbox/source/browse/trunk/library.cc).
>>
>> If the vsyscall page's code no longer invokes the kernel via SYSCALL
>> instructions but via some other trap, seccomp-sandbox's trick will no
>> longer work, because it doesn't know to patch the instructions that do
>> this new trap.
>
> The vsyscall code is now:
>
>        mov $__NR_whatever %rax
>        syscall
>        ret
>
> It used to be weirder, but we changed to to avoid breaking things like
> this.  The secret is that, if vsyscall=emulate, the vsyscall page is
> not executable and we use the page fault to invoke
> do_emulate_vsyscall.  But userspace can't tell it's not executable
> without actually jumping there, and with vsyscall=native, it's just a
> normal syscall.

Ah, that's much nicer.  In that case, the fix should just be a case of
adding the new syscall numbers to the whitelist in
system_call_table.cc.

The current hang might just be occurring because libpthread's timeout
calculations come out wrong.  libpthread doesn't check for errors from
its calls to vsyscall routines, at least in
nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_timedwait.S in the
version I checked.


> I'll try to build a sandboxing copy of chromium tomorrow to see if I
> can reproduce it.

You don't necessarily need to build Chromium.  You can try running
"make test" in a checkout of seccompsandbox.  That might not catch the
problem, though.  I did not realise that the vsyscall page was still
used by glibc when I wrote those tests.

Cheers,
Mark
