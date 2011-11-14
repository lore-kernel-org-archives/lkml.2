Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1KNChJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 21:37:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55271 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1KNChI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 21:37:08 -0500
MIME-Version: 1.0
In-Reply-To: <8762inleno.fsf@spindle.srvr.nix>
References: <8762inleno.fsf@spindle.srvr.nix>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 13 Nov 2011 18:36:46 -0800
X-Google-Sender-Auth: XSssmuGpaz5Fp43b1TjaWJgt_gw
Message-ID: <CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
Subject: Re: [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884
 breaks the Chromium seccomp sandbox
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, mseaborn@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 4:40 PM, Nix <nix@esperi.org.uk> wrote:
> With this commit installed:
>
> commit 5cec93c216db77c45f7ce970d46283bcb1933884
> Author: Andy Lutomirski <luto@MIT.EDU>
> Date:   Sun Jun 5 13:50:24 2011 -0400
>
>    x86-64: Emulate legacy vsyscalls
>
> With CONFIG_SECCOMP set, and the Chromium seccomp sandbox compiled in
> and enabled (which is not the default), on a system running glibc 2.12.x
> (thus, relying on emulated vsyscalls), Chromium renderers sometimes hang
> or abruptly abort before rendering anything (both of which show as pages
> that never complete rendering and eventually get a Chromium kill request
> dialog). The hang is consistent for a given page, but not all pages
> hang. (One that *does* hang is the chrome://extensions page, so network
> access is not the problem here.)
>
> vsyscall=native does not help.
>
> Turning off CONFIG_SECCOMP, or running Chromium with the seccomp sandbox
> disabled, fixes it.
>
> I speculate that do_emulate_vsyscall() is broken, but it's hard to debug
> the Chromium renderer sandboxing to see what's failing because the
> multiple layers of sandboxing get in the way, as they are designed to :)

I don't buy that explanation -- with vsyscall=native,
do_emulate_vsyscall shouldn't be called at all.  I have a much simpler
explanation: the Chromium sandbox is calling vsyscalls in seccomp
mode, which has no business working.

The attached patch (in vsyscall=native mode) should help diagnose
exactly what's wrong.  But I wouldn't be surprised if you can trigger
the exact same failure on older kernels by doing

# echo acpi_pm >/sys/devices/system/clocksource/clocksource0/current_clocksource

and then going to the broken page.  Just because vgettimeofday
sometimes doesn't issue a syscall (and is therefore not caught by the
seccomp code) doesn't mean it never issues a syscall.

If the crash is in vtime instead, then there's an argument to be made
that time and vtime should be allowed in seccomp mode, in which case
it's an easy change to make.  But if I'm right, I think that Chromium
should stop using vsyscalls from inside the sandbox.

--Andy
