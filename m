Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0EaWBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:01:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40998 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab0EaWBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:01:21 -0400
Date: Mon, 31 May 2010 15:00:00 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531220000.GI4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <20100531112314.373b0f26@lxorguk.ukuu.org.uk>
 <20100531175008.GC4098@outflux.net>
 <20100531190936.03076096@lxorguk.ukuu.org.uk>
 <20100531190754.GF4098@outflux.net>
 <20100531195230.GS31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531195230.GS31073@ZenIV.linux.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Mon, May 31, 2010 at 08:52:30PM +0100, Al Viro wrote:
> On Mon, May 31, 2010 at 12:07:54PM -0700, Kees Cook wrote:
> > IIRC, screen, when setuid, allows users to share screen sessions (following
> > some system-defined ACLs) but it does it via the /tmp directory trees it
> > creates.  Per-user /tmp would break this (but yes, it's solvable using some
> > kind of /var/lib/screen which maybe even already exists).
> 
> screen(1) does *not* put directories in /tmp these days, TYVM.
> 
> al@duke:~/linux/trees/vfs-next$ ls -l /var/run/screen/
> total 1
> drwx------ 2 al al 1024 May 20 21:50 S-al

Okay, good; that's a relief.

> In any case, the suggested "improvement" breaks realistic use cases, AFAICS.
> In particular,
> 
> cd /tmp
> tar jxf foo-2.42.orig.tar.bz2
> <...>
> tar jxf foo-gtk-wank-wank-wank-2.69.orig.tar.bz2
> <...>
> ln -s foo-gtk-wank-wank-wank-2.69/docs/GNOME/design/ crap
> <...>
> lpr crap/taste-is-optional.ps
> lpr crap/why-options-are-wrong.ps
> 
> is going to break with that, isn't it?

Nope.  To be fair, it depends on the implementation of of LPR.  In the
case of CUPS, this is fine since lpr will run as the local user, follow
the symlink and read the file contents before POSTing the contents to
the CUPS server.  The privilege boundary is crossed at the network,
not the filesystem in this case.

I would note however that without the symlink following patch a hypothetical
attacker would be able to race you for the "foo-gtk-wank-wank-wank-2.69"
entry, or the "crap" entry, since either could be directed out from under
"tar" and "ln" to symlinks controlled by the attacker.  Unpacking archives
in a sticky world-writable directory is dangerous without this symlink
following patch.

-Kees

-- 
Kees Cook
Ubuntu Security Team
