Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1KNBZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:25:05 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:38844 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1KNBZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:25:04 -0500
X-Greylist: delayed 2656 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Nov 2011 20:25:03 EST
From: Nix <nix@esperi.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@mit.edu>, mseaborn@chromium.org
Subject: [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884 breaks the Chromium seccomp sandbox
Emacs: because Hell was full.
Date: Mon, 14 Nov 2011 00:40:43 +0000
Message-ID: <8762inleno.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-dcc1-Metrics: spindle 1182; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this commit installed:

commit 5cec93c216db77c45f7ce970d46283bcb1933884
Author: Andy Lutomirski <luto@MIT.EDU>
Date:   Sun Jun 5 13:50:24 2011 -0400

    x86-64: Emulate legacy vsyscalls

With CONFIG_SECCOMP set, and the Chromium seccomp sandbox compiled in
and enabled (which is not the default), on a system running glibc 2.12.x
(thus, relying on emulated vsyscalls), Chromium renderers sometimes hang
or abruptly abort before rendering anything (both of which show as pages
that never complete rendering and eventually get a Chromium kill request
dialog). The hang is consistent for a given page, but not all pages
hang. (One that *does* hang is the chrome://extensions page, so network
access is not the problem here.)

vsyscall=native does not help.

Turning off CONFIG_SECCOMP, or running Chromium with the seccomp sandbox
disabled, fixes it.

I speculate that do_emulate_vsyscall() is broken, but it's hard to debug
the Chromium renderer sandboxing to see what's failing because the
multiple layers of sandboxing get in the way, as they are designed to :)
(also, I am not in any way shape or form a Chromium hacker). Chromium
does downright terrible things to convert syscalls into IPC calls
outside the seccomp sandbox (mostly to a separate, nonseccomped,
assembler thread in the same process, but in some cases via IPC to an
entirely separate process for validation followed by IPC back and
execution in that separate thread). I suspect this delicate dance (for
which see seccompsandbox/ in a Chromium source tree) has been disrupted.

I have raised Chromium bug
<http://code.google.com/p/chromium/issues/detail?id=104084> to attract
the Chromium hackers' attention to this, and am Cc:ing a Chromium hacker
whose fingers are all over the seccomp sandbox as well. Hopefully the
cause, or a diagnostic trick, will be obvious to someone other than me.

-- 
NULL && (void)
