Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2JZAde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:33:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55706 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2JZAdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:33:32 -0400
Date: Thu, 25 Oct 2012 17:33:25 -0700
From: Kees Cook <kees@outflux.net>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Enabling hardlink restrictions to the Linux VFS in 3.6 by default
Message-ID: <20121026003325.GB17208@outflux.net>
References: <alpine.LRH.2.02.1210251028470.640@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1210251028470.640@diagnostix.dwd.de>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Holger,

On Thu, Oct 25, 2012 at 12:13:40PM +0000, Holger Kiehl wrote:
> as of linux 3.6 hardlink restrictions to the Linux VFS have been enabled
> by default. This breaks the application AFD [1] of which I am the author.

Sorry this created a problem for you!

> Internally it uses hardlink to distribute files. The reason for hardlinks
> is that AFD can distribute one file to many destinations and for each
> distributing process it creates a directory with hardlinks to the original
> file. That way AFD itself never needs to copy the content of a file. Another
> nice feature about hardlinks was that there is no need to have any logic in
> the code needing AFD to know where the original file was, each distributing
> process could delete its hardlink and the last one would delete the real
> file. This way AFD could distribute files at rates of more then 20000 files
> per second (in benchmarks). This has worked from the first linux kernel
> up to 3.5.7 and with solaris, hpux, aix, ftx, irix. As of 3.6 this does
> not work for files where AFD does not have write permissions. It was always
> sufficient to just have read permission on a file it wants to distribute.

Just to clarify, not even read access was needed for hardlinks:

$ whoami
kees
$ ls -l /etc/shadow
-r--r----- 1 root shadow 3112 Oct 22 17:02 /etc/shadow
$ ln /etc/shadow /tmp/ohai
$ ls -l /tmp/ohai
-r--r----- 2 root shadow 3112 Oct 22 17:02 ohai

You mention "the last one would delete the real file". That would have
required AFD to have write permission to the directory where the original
file existed? Maybe there is something in your architecture that could
take advantage of that? Directory group-write set-gid? I haven't taken
a look at AFD's code.

> The fix for the "at" daemon [2] mentioned in the commitdiff [3] cannot
> be used for AFD since it is not run with root privileges. Is there any
> other way I can "fix" my application? I currently can see no other way
> then doing it via: echo 0 > /proc/sys/fs/protected_hardlinks

You said you have read access to these files, so perhaps you can make
a copy when you have read but not write, and then all the subsequent
duplication would be able to hardlink?

If you wanted to turn off the sysctl, you could have AFD could ship
files in /etc/sysctl.d/ (or your distro equivalent) to turn it off.

I'm sure there are plenty of options available.

> Why is such a fundamentally change to the linux kernel activated by default?

Based on about two years of testing in Ubuntu, the number of problems
was vanishingly small, so the security benefit is seen to outweigh
the downside.

> Would it not be better if it is the other way around, that the system
> administrator or distributions enable this?

Virtually all distributions would have turned this on by default,
so it seemed better to many people to just make it the default in the
kernel. Only unusual corner-cases would need it disabled.

I hope that helps!

-Kees

-- 
Kees Cook                                            @outflux.net
