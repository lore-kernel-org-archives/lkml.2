Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1KNLl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 06:41:57 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:39478 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1KNLl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 06:41:56 -0500
From: Nix <nix@esperi.org.uk>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Mark Seaborn <mseaborn@chromium.org>, linux-kernel@vger.kernel.org,
        Markus Gutschke <markus@chromium.org>
Subject: Re: [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884 breaks the Chromium seccomp sandbox
References: <8762inleno.fsf@spindle.srvr.nix>
	<CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
	<CAL82V5M6TgDme3swFKxF2ZXqTtcCPEr_+FK1F6zXzKr_scmQew@mail.gmail.com>
	<CAObL_7H5Ktva16xTj9QBq6v2k66q5H13Vyvv_Piju6vTiaC9cA@mail.gmail.com>
Emacs: the only text editor known to get indigestion.
Date: Mon, 14 Nov 2011 11:41:51 +0000
In-Reply-To: <CAObL_7H5Ktva16xTj9QBq6v2k66q5H13Vyvv_Piju6vTiaC9cA@mail.gmail.com>
	(Andrew Lutomirski's message of "Mon, 14 Nov 2011 00:38:48 -0800")
Message-ID: <87fwhrj5hc.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Nov 2011, Andrew Lutomirski stated:

> On Sun, Nov 13, 2011 at 10:50 PM, Mark Seaborn <mseaborn@chromium.org> wrote:
>> I think the problem is that seccomp-sandbox attempts to patch the
>> vsyscall page.

I grepped for vsyscall to try to avoid making an idiot of myself like
this. A shame I misspelt it. :/

> The vsyscall code is now:
>
>         mov $__NR_whatever %rax
>         syscall
>         ret
> 
> It used to be weirder, but we changed to to avoid breaking things like
> this.  The secret is that, if vsyscall=emulate, the vsyscall page is
> not executable and we use the page fault to invoke
> do_emulate_vsyscall.  But userspace can't tell it's not executable
> without actually jumping there, and with vsyscall=native, it's just a
> normal syscall.
>
> I'll try to build a sandboxing copy of chromium tomorrow to see if I
> can reproduce it.

If you look at line 909 of seccompsandbox/library.cc (in
http://git.chromium.org/external/seccompsandbox.git) the problem does
indeed jump out at you. That nice manual disassembly using == isn't
going to work anymore. It even helpfully dies with a message saying that
it can't patch the vsyscall page, but the message gets thrown away by
some higher layer.

I suspect we want two functions and something to recognize what the
vsyscall page looks like and choose between them, rather than making
this already tricky function even uglier.

(To build Chromium with sandboxing, the recipe is little more than
making sure you haven't passed in -Dselinux, and starting Chromium with
--enable-seccomp-sandbox. It's turned off by default because it slows
Chromium down, not because it doesn't work. :) )

-- 
NULL && (void)
