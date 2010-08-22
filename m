Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0HVUdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 16:33:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0HVUdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 16:33:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 0/4] initramfs: remove sparse warnings
Date: Sun, 22 Aug 2010 22:33:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com> <20100820120001.GR31363@ZenIV.linux.org.uk> <1282318601.1626.9.camel@leonhard>
In-Reply-To: <1282318601.1626.9.camel@leonhard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201008222233.01739.arnd@arndb.de>
X-Provags-ID: V02:K0:oU8pSs9NvncJhKP0PBh5DrTxXAYORHyz2p+cBwIiLvi
 0EpXpI6mjZnxUUwceYZE2i2uwzsncuCxVQ+x3CB2mJaeEeupHc
 9mm6/bn7Q45xmi9wNSWr1pw1wL46+XnixCRH65Cs+MbKpEduYO
 Faw3QjtukQs6IKvjjSzVZAtNgbnEFPVxRV/Ok52v1KVSRBkj4W
 WxwP4ZadiyMG5OhxSzIUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 17:36:41 Namhyung Kim wrote:
> 
> 2010-08-20 (금), 13:00 +0100, Al Viro:
> > No.  This code should NOT use the VFS guts, TYVM.  The whole fscking point
> > is that this puppy is a sequence of plain vanilla syscalls, ideally run
> > simply in userland thread.  We used to have a magical mystery shite in there
> > and it had been a huge PITA.
> 
> So is it worth to work on removing the warnings like this patchset does?
> Or else, how can I improve the code even a bit? Can you please give me a
> direction?

It would be useful to add annotations in those places where they are
obviously just missing but don't require adding __force.
Even better would be patches that fix actual bugs found by sparse.

Simply throwing in extra __force arguments will just make people
nervous, because it is often a sign of papering over a bug instead
of fixing it, and warnings in the core kernel are there exactly
because there is no easy correct fix for them.

Try producing patches that clean up the code and result in using
fewer annotations and especially few __force where possible.
Also, in places where you need __force, make sure that a person
reading that code understands why it's needed and that the use is
correct (or at least permissable).

One possible solution in this particular case would be to add
helper functions like 

/* wrapper for sys_newlstat for use in the init code */
static inline int kern_newlstat(const char * filename, struct stat * statbuf)
{
	mm_segment_t fs = get_fs();
	int ret;

	set_fs(KERNEL_DS);
	ret = sys_newlstat((const char __user __force*)filename,
			   (struct stat __user __force *)statbuf);
	set_fs(fs);

	return ret;
}

Such a function makes it clear that it can only accept a kernel pointer,
and it documents how the conversion to a __user pointer happens (by
calling set_fs).
Then again, it adds some bloat, and it may encourage people to do the
same thing in device drivers, which could be argued against such helpers.

In general, my recommendation would be to leave code alone if you can't
come up with a patch that clearly improves it. There is enough
bad code in the kernel that can use some help along the lines of
your other patches, so you may want to focus on that.

	Arnd
