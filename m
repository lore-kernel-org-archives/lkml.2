Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1JCNF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:05:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61816 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1JCNFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <20111003090846.GA25136@localhost.pp.htv.fi>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 3 Oct 2011 06:04:53 -0700
X-Google-Sender-Auth: _nhfgcrM2m435FsDP01dRBaIa98
Message-ID: <CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
To: Adrian Bunk <bunk@stusta.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 2:08 AM, Adrian Bunk <bunk@stusta.de> wrote:
> After upgrading a kernel the existing userspace should just work
> (assuming it did work before ;-) ), but when I upgraded my kernel
> from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.
>
> dmesg said:
>  linux-2.6.30.1[3800] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb9c498 ax:ffffffffff600000 si:0 di:606790
>  linux-2.6.30.1[3856] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb13168 ax:ffffffffff600000 si:0 di:606790
>
> Looking throught the changelog I ended up at commit 3ae36655
> ("x86-64: Rework vsyscall emulation and add vsyscall= parameter").
>
> Linus suggested in https://lkml.org/lkml/2011/8/9/376 to default to
> vsyscall=native.
>
> That sounds reasonable to me, and fixes the problem for me.

At this point in the -rc cycle, this sounds fine.

That being said, I'd like to fix it for real for 3.2.  This particular
failure is suspicious -- the "vsyscall fault" message means that
sys_gettimeofday returned EFAULT, which means that the old (3.0 and
before) vgettimeofday should *also* have segfaulted.  We do have a bit
of a bug in that the new code doesn't report si_addr properly, but
that sounds unlikely as a culprit.  Did you try with the offending
commit reverted (i.e. fce8dc0)?  I bet that it also fails there.

What's the .config for your UML binary?  I'd like to see if I can
reproduce this.

--Andy

>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> ---
>  Documentation/kernel-parameters.txt |    7 ++++---
>  arch/x86/kernel/vsyscall_64.c       |    2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 854ed5ca..d6e6724 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2706,10 +2706,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                        functions are at fixed addresses, they make nice
>                        targets for exploits that can control RIP.
>
> -                       emulate     [default] Vsyscalls turn into traps and are
> -                                   emulated reasonably safely.
> +                       emulate     Vsyscalls turn into traps and are emulated
> +                                   reasonably safely.
>
> -                       native      Vsyscalls are native syscall instructions.
> +                       native      [default] Vsyscalls are native syscall
> +                                   instructions.
>                                    This is a little bit faster than trapping
>                                    and makes a few dynamic recompilers work
>                                    better than they would in emulation mode.
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 18ae83d..b56c65de 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -56,7 +56,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
>        .lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
>  };
>
> -static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
> +static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
>
>  static int __init vsyscall_setup(char *str)
>  {
> --
> 1.7.6.3
>
>
