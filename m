Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660Ab2D0Szg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:55:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44614 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2D0Sze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
References: <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com>
 <4F9A6ABA.6050503@msgid.tls.msk.ru> <CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
 <20120427.143402.1028957981042061092.davem@davemloft.net> <CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 11:55:12 -0700
X-Google-Sender-Auth: xFeE5hFRI-B66DDXLFSvWHqcH_g
Message-ID: <CA+55aFyLk-uPMVaic19YOWdvdj2pv4R+E3s7UQ6voAy6UkO_Sg@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: David Miller <davem@davemloft.net>
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:42 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> There's no question that systemd is broken.

Actually, I'll take that back.

Yes, systemd has breakage. But it's actually automount that is the
truly broken piece of sh*t.

I think that 'automount' is even more broken. The fact that the
automount maintainers knew about this, and added TOTALLY BROKEN code
to their automount source tree, over five years ago, because the
authors clearly did not understand what the f*ck they were doing,
that's the real problem.

Look at the automount source code:

        if (pkt_len % 8) {
                if (strcmp(un.machine, "alpha") == 0 ||
                    strcmp(un.machine, "ia64") == 0 ||
                    strcmp(un.machine, "x86_64") == 0 ||
                    strcmp(un.machine, "ppc64") == 0)
                        pkt_len += 4;

        }

and realize that the above is *wrong*. It's complete and utter shit.
It's actively insane. The above source code makes zero sense.

The whole issue does not *exist* on alpha, ia64, or ppc64 (or sparc64,
which isn't even listed), because those architectures don't have the
issue that their 32-bit version has different default alignment for a
64-bit entity.

So autofs-tools was and remains actively *wrong*.

In contrast, the systemd source code actually makes sense. We should
point to it as the *correct* user, and autofs as the legacy bug.

Which is why I actually think that it makes more sense to special-case
the real bug - in automount. It's why I think that it's ok to do the
strcmp(), and why the strcmp should check for "automount", not
"systemd".

I just think it needs a big honking comment that explains it. Something like

   int autofs_compat_interface()
   {
      if (!is_compat_task())
            return 0;
      /* "autofs" has crazy shit going on working around an old compat
bug, and actually
          expects the non-compat size with a 64-bit kernel */
      if (!strcmp(current->comm, "automount"))
            return 0;
      return 1;
   }

because it really is an autofs bug.

If the autofs people had understood what they were doing, none of this
would ever have happened.

Still, checking for strings is ugly. I do think it would be even
better if we could trigger on another difference, but whatever..

                    Linus
