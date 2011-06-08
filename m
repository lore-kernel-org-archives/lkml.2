Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1FHODt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:03:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35624 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1FHODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:03:48 -0400
Date: Wed, 8 Jun 2011 15:03:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mathias Krause <minipli@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Message-ID: <20110608140340.GU11521@ZenIV.linux.org.uk>
References: <1306772228-1603-1-git-send-email-minipli@googlemail.com>
 <20110606161254.5f02d855.akpm@linux-foundation.org>
 <BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>
 <20110608104727.GT11521@ZenIV.linux.org.uk>
 <BANLkTi=qBx0Mk=b2wsA3RZVKk0RUckeN6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=qBx0Mk=b2wsA3RZVKk0RUckeN6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:14:56PM +0200, Mathias Krause wrote:

> SPARC, TILE and Xtensa don't call set_fs(USER_DS), albeit have
> different definitions for USER_DS and KERNEL_DS. So those might need
> fixing. I'm not familiar with those architectures, so someone else has
> to answer this.
 
sparc (both sparc32 and sparc64) does that in flush_thread() (i.e. triggered
by flush_old_exec()); the only difference is that sparc64 is trying to avoid
writing to %asi if we already had USER_DS.  Any failure exit past the call
of flush_old_exec() will send us a SIGKILL (and will not return -ENOEXEC,
so no further handlers will be called anyway).

No idea about tile and xtensa - asking on linux-arch might be a good idea.

FWIW, looking at the ->load_binary() instances...  binfmt_som does not
bother with SIGKILL, which is Not Nice(tm) - there's nowhere to return
from sys_execve() at that point.  binfmt_elf_fdpic.c has a couple of
bogosities - it sends SIGSEGV instead of SIGKILL (which is probably OK,
since signal handlers are already switched to default, and SIGSEGV would
kill just as well as SIGKILL; the only question is whether the state of
process is suitable for coredump at that point) *and* we have one case
where both SIGKILL and SIGSEGV are sent (setup_arg_pages() failure).
And binfmt_flat looks just plain weird wrt failure exits...
