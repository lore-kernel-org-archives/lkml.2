Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310Ab2ESOfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:35:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34191 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab2ESOfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:35:30 -0400
Date: Sat, 19 May 2012 15:35:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
Message-ID: <20120519143519.GA11775@ZenIV.linux.org.uk>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
 <201205182158.59616.arnd@arndb.de>
 <4FB6C862.5060401@zytor.com>
 <201205190756.30492.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205190756.30492.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 07:56:30AM +0000, Arnd Bergmann wrote:

> * __kernel_time_t is not the only type that differs between 32 and 64
>   bit platforms: the structures also include a __kernel_mode_t, which
>   is different between 32/64 bit on at least s390, x86, arm and sparc.

... and said __kernel_mode_t needs to die.  Along with all remaining
instances of mode_t kernel-side.

BTW, ncp_mount_data (i.e. ncp mount with version less than 4) needs to be
added to feature-removal-schedule.txt.  That'll bury one of the few places
where we have that crap in public headers.

And no, assorted struct stat do not need that thing at all.  They should
use explicit types, TYVM.

BTW, why do we have __kernel_uid32_t?  As an invitation for some architecture
to come up with 64bit "32bit UID" type?  What's wrong with __u32, or
at least moving the default (== only, fortunately) definitions to
linux/posix_types.h and making them unconditional?  Same for gid32_t
stuff, of course...

__kernel_nlink_t is also a bad idea (and an invitation to bugs in the kernel,
while we are at it).  BTW, now that I look at it...  ulong_t as default is
also wrong; there's no point making the internal nlink_t different on different
platforms.  Fortunately, that one is really easy to kill; mips/parisc/ppc
stat.h instances switch to corresponding explictly-sized types, at which point
nothing in userland needs to see it and we can simply switch nlink_t
kernel-side to __u32 and be done with that...
