Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab2KOVzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:55:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56404 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2KOVzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:55:46 -0500
Date: Thu, 15 Nov 2012 21:55:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: new execve/kernel_thread design
Message-ID: <20121115215529.GU2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
 <CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
 <20121017160702.GY2616@ZenIV.linux.org.uk>
 <20121017161953.GZ2616@ZenIV.linux.org.uk>
 <CAHTX3dJN4Jun2KVXpda1wTrwkjT0mmH4fYmUUwq69d9sCTjXnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHTX3dJN4Jun2KVXpda1wTrwkjT0mmH4fYmUUwq69d9sCTjXnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 05:41:16PM +0100, Michal Simek wrote:
> Here is the branch based on rc5 (information below)
> and here is giweb.
> http://developer.petalogix.com/git/gitweb.cgi?p=linux-2.6-microblaze.git;a=shortlog;h=refs/heads/viro/arch-microblaze-rc5
> 
> I have also looked at your sys_fork / sys_vfork / sys_clone unification
> and I have fixed it for Microblaze.
> 
> Also I have done some tests on it for sure.
> 
> I would add sys_execve/kernel_execve/kernel_thread patches to my next branch.
> Are you OK with that?

Umm...  In principle - yes, but I've a couple of question abouts those.

1) What's that set_fs(USER_DS) in start_thread() for?  Note that we do the same
thing in flush_old_exec(), at the same time we remove PF_KTHREAD from
current->flags.

While we are at it, if we *ever* hit do_signal() with KERNEL_DS, we are
very deep in trouble.  set_fs(USER_DS) in setup_{rt_,}frame() is pointless.

2) your definition of current_pt_regs() is an exact copy of on in
include/linux/ptrace.h; why is "microblaze: Define current_pt_regs"
needed at all?  IOW, I'd rather added #include <linux/ptrace.h> to
arch/microblaze/kernel/process.c instead...
