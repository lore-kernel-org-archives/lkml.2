Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab2JQQHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:07:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55851 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2JQQHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:07:21 -0400
Date: Wed, 17 Oct 2012 17:07:03 +0100
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
Message-ID: <20121017160702.GY2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
 <CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 04:27:06PM +0200, Michal Simek wrote:

> In the patch above there is directly used current_pt_regs() function
> which works good for newly created threads
> when pt_regs are exactly in current_pt_regs() position but not for
> pt_regs which are saved on the stack
> which is the init task case.

init_task does *not* do kernel_execve().  It's PID 0, not PID 1.
init is spawned by it.

> My question is how should /init be called? Because I need to save
> pt_regs to current_pt_regs() position where
> generic kernel_execve expects it.

What happens during boot is this:
	* init_task (not to be confused with init) is used as current during
infrastructure initializations.  Once everything needed for scheduler and
for working fork is set, we spawn two threads - future init and future
kthreadd.  The last thing we do with init_task is telling init that kthreadd
has been spawned.  After that init_task turns itself into an idle thread.
	* future init waits for kthreadd to be spawned (it would be more
natural to fork them in opposite order, but we want init to have PID 1 -
too much stuff in userland depends on that).  Then it does the rest of
initialization, including setting up initramfs contents.  And does
kernel_execve() on /init.  Note that this is a task that had been created
by kernel_thread() and is currently in function called from
ret_from_kernel_thread().  Its kernel stack has been set up by copy_thread().
That's where pt_regs need to be set up; note that they'll be passed to
start_thread() before you return to userland.  If there are any magic bits
in pt_regs needed by return-from-syscall code, set them in kthread case of
copy_thread().
