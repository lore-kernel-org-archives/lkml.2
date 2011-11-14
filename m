Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1KNIjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 03:39:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1KNIjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 03:39:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAL82V5M6TgDme3swFKxF2ZXqTtcCPEr_+FK1F6zXzKr_scmQew@mail.gmail.com>
References: <8762inleno.fsf@spindle.srvr.nix> <CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
 <CAL82V5M6TgDme3swFKxF2ZXqTtcCPEr_+FK1F6zXzKr_scmQew@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 14 Nov 2011 00:38:48 -0800
X-Google-Sender-Auth: h4saiJ4erXMyluXTas-2JjZMbzM
Message-ID: <CAObL_7H5Ktva16xTj9QBq6v2k66q5H13Vyvv_Piju6vTiaC9cA@mail.gmail.com>
Subject: Re: [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884
 breaks the Chromium seccomp sandbox
To: Mark Seaborn <mseaborn@chromium.org>
Cc: Nix <nix@esperi.org.uk>, linux-kernel@vger.kernel.org,
        Markus Gutschke <markus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 10:50 PM, Mark Seaborn <mseaborn@chromium.org> wrote:
> On 13 November 2011 18:36, Andrew Lutomirski <luto@mit.edu> wrote:
>>
>> On Sun, Nov 13, 2011 at 4:40 PM, Nix <nix@esperi.org.uk> wrote:
>> > With this commit installed:
>> >
>> > commit 5cec93c216db77c45f7ce970d46283bcb1933884
>> > Author: Andy Lutomirski <luto@MIT.EDU>
>> > Date:   Sun Jun 5 13:50:24 2011 -0400
>> >
>> >    x86-64: Emulate legacy vsyscalls
>> >
>> > With CONFIG_SECCOMP set, and the Chromium seccomp sandbox compiled in
>> > and enabled (which is not the default), on a system running glibc 2.12.x
>> > (thus, relying on emulated vsyscalls), Chromium renderers sometimes hang
>> > or abruptly abort before rendering anything (both of which show as pages
>> > that never complete rendering and eventually get a Chromium kill request
>> > dialog). The hang is consistent for a given page, but not all pages
>> > hang. (One that *does* hang is the chrome://extensions page, so network
>> > access is not the problem here.)
>> >
>> > vsyscall=native does not help.
>> >
>> > Turning off CONFIG_SECCOMP, or running Chromium with the seccomp sandbox
>> > disabled, fixes it.
>> >
>> > I speculate that do_emulate_vsyscall() is broken, but it's hard to debug
>> > the Chromium renderer sandboxing to see what's failing because the
>> > multiple layers of sandboxing get in the way, as they are designed to :)
>>
>> I don't buy that explanation -- with vsyscall=native,
>> do_emulate_vsyscall shouldn't be called at all.  I have a much simpler
>> explanation: the Chromium sandbox is calling vsyscalls in seccomp
>> mode, which has no business working.
>
> I think the problem is that seccomp-sandbox attempts to patch the
> vsyscall page.  It replaces the SYSCALL instructions in this page with
> jumps to seccomp-sandbox's handler.  (More accurately, seccomp-sandbox
> creates a patched copy of the vsyscall page.  It redirects glibc's
> indirect jumps so that they go to the patched copy of the vsyscall
> page instead of to the original.)  The code for this is in
> patchVSystemCalls() in library.cc
> (http://code.google.com/p/seccompsandbox/source/browse/trunk/library.cc).
>
> If the vsyscall page's code no longer invokes the kernel via SYSCALL
> instructions but via some other trap, seccomp-sandbox's trick will no
> longer work, because it doesn't know to patch the instructions that do
> this new trap.

The vsyscall code is now:

        mov $__NR_whatever %rax
        syscall
        ret

It used to be weirder, but we changed to to avoid breaking things like
this.  The secret is that, if vsyscall=emulate, the vsyscall page is
not executable and we use the page fault to invoke
do_emulate_vsyscall.  But userspace can't tell it's not executable
without actually jumping there, and with vsyscall=native, it's just a
normal syscall.

I'll try to build a sandboxing copy of chromium tomorrow to see if I
can reproduce it.

--Andy
