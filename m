Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1KNGuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 01:50:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55511 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1KNGut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 01:50:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
References: <8762inleno.fsf@spindle.srvr.nix>
	<CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
Date: Sun, 13 Nov 2011 22:50:47 -0800
X-Google-Sender-Auth: UC8u5mI_x52eoCfBL6TpMYgXm2s
Message-ID: <CAL82V5M6TgDme3swFKxF2ZXqTtcCPEr_+FK1F6zXzKr_scmQew@mail.gmail.com>
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

On 13 November 2011 18:36, Andrew Lutomirski <luto@mit.edu> wrote:
>
> On Sun, Nov 13, 2011 at 4:40 PM, Nix <nix@esperi.org.uk> wrote:
> > With this commit installed:
> >
> > commit 5cec93c216db77c45f7ce970d46283bcb1933884
> > Author: Andy Lutomirski <luto@MIT.EDU>
> > Date:   Sun Jun 5 13:50:24 2011 -0400
> >
> >    x86-64: Emulate legacy vsyscalls
> >
> > With CONFIG_SECCOMP set, and the Chromium seccomp sandbox compiled in
> > and enabled (which is not the default), on a system running glibc 2.12.x
> > (thus, relying on emulated vsyscalls), Chromium renderers sometimes hang
> > or abruptly abort before rendering anything (both of which show as pages
> > that never complete rendering and eventually get a Chromium kill request
> > dialog). The hang is consistent for a given page, but not all pages
> > hang. (One that *does* hang is the chrome://extensions page, so network
> > access is not the problem here.)
> >
> > vsyscall=native does not help.
> >
> > Turning off CONFIG_SECCOMP, or running Chromium with the seccomp sandbox
> > disabled, fixes it.
> >
> > I speculate that do_emulate_vsyscall() is broken, but it's hard to debug
> > the Chromium renderer sandboxing to see what's failing because the
> > multiple layers of sandboxing get in the way, as they are designed to :)
>
> I don't buy that explanation -- with vsyscall=native,
> do_emulate_vsyscall shouldn't be called at all.  I have a much simpler
> explanation: the Chromium sandbox is calling vsyscalls in seccomp
> mode, which has no business working.

I think the problem is that seccomp-sandbox attempts to patch the
vsyscall page.  It replaces the SYSCALL instructions in this page with
jumps to seccomp-sandbox's handler.  (More accurately, seccomp-sandbox
creates a patched copy of the vsyscall page.  It redirects glibc's
indirect jumps so that they go to the patched copy of the vsyscall
page instead of to the original.)  The code for this is in
patchVSystemCalls() in library.cc
(http://code.google.com/p/seccompsandbox/source/browse/trunk/library.cc).

If the vsyscall page's code no longer invokes the kernel via SYSCALL
instructions but via some other trap, seccomp-sandbox's trick will no
longer work, because it doesn't know to patch the instructions that do
this new trap.

Mark
