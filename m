Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab1G3JO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 05:14:27 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:47431 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab1G3JOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 05:14:25 -0400
From: Jim Meyering <jim@meyering.net>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Matthias Schniedermeyer <ms@citd.de>,
        Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Coreutils <coreutils@gnu.org>
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for analysis and bugreporting
In-Reply-To: <4E33397F.4010908@draigBrady.com> (=?iso-8859-1?Q?=22P=E1drai?=
 =?iso-8859-1?Q?g?= Brady"'s message of
	"Fri, 29 Jul 2011 23:51:43 +0100")
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
	<20110725134533.GA23781@citd.de>
	<CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
	<20110729195904.GC1720@ucw.cz> <20110729213156.GA32685@citd.de>
	<4E33397F.4010908@draigBrady.com>
Date: Sat, 30 Jul 2011 11:14:16 +0200
Message-ID: <87bowcyvtj.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pádraig Brady wrote:
...
> `strace lsattr ...` shows it calls ioctl (...FS_IOC_GETFLAGS...)
> So there would be overhead.
> The output of ls is fairly constrained too for compat reasons.

One way by which ls -l could inform us that a file has
"attributes" like that would be via what POSIX calls the
"optional alternate access method flag".  Currently,
it can be a space, a "+", or a ".":

Since coreutils-7.1 (Feb 2009), ls -l has been doing this:

    ls -l now marks SELinux-only files with the less obtrusive '.',
    rather than '+'.  A file with any other combination of MAC and ACL
    is still marked with a '+'.

Using other printable characters to denote attributes (trumping
SELinux, MAC and ACL settings) is possible.  Does any other ls
implementation already do that?  There would be the cost of the
additional ioctl... we'd have to measure that before deciding
whether to impose this on every use of ls -l.

Another possibility is to further overload the file type decorations
("*", "|", "="), that you see with -F.  Already, "*" is obviously
not a type indicator, so adding more attributes is not shocking.

> However these flags are not specific to ext2 so it would fit
> quite well from that perspective.
> It might be something we could add to the stat command at least?

Yes, this definitely deserves a new stat format directive or two.
At least one for each single-byte "attribute" described in chattr(1),
and maybe another for a readable string so we don't have to look up
the likes of "T" ("top" dir hint, for orlov block allocator) and
"t" (no-tail-merge).
