Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0GFOYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 10:24:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0GFOYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 10:24:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Luotao Fu <l.fu@pengutronix.de>
Subject: Re: Problem with tty changes in linux-next
Date: Tue, 6 Jul 2010 16:23:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>
References: <20100706130403.GD3991@pengutronix.de>
In-Reply-To: <20100706130403.GD3991@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007061623.48363.arnd@arndb.de>
X-Provags-ID: V02:K0:64Rqrs9mFnfPskfuwapC6xI6C1wo8m4Edd108Tisolv
 BgsYlvKQ2pSor06fgVZL24mugJSSPlUhAx5uWHRjtoxu0VAKVg
 fH+aRv2nNuuu/3ahVRrmxGqKe5E1bzzXAU/fUzx2z+5Iio/0fB
 IWNcdMwZfE6PFVpEkvQWEchJJmCcJZRJvge/irmQMAGQsM7tzB
 +f6Q+MVL7QfhCZPEz4M1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 July 2010, Luotao Fu wrote:

> I just tried to get latest linux-next (HEAD=288092896e2097eebee7d4bf1df9a0c7b550e225)
> run on my ARM system (a PXA270 base PCM990 board. The board maps its console to its
> ttyS0. During the tests I experienced two problems with the new shiny bkl-free
> tty stuff:

Sorry about the warning, I have been aware of this for some time but have
not yet pushed the fix into -next because of other dependencies.

The fix is the first patch in the 'config' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git

It would probably be best if either Stephen pulls that branch into -next
or Frederic includes it in his tree that is already getting pulled in.

> Indeed the bkl is held by kernel_init, so we will kind of _always_ run
> into this. Seemed that the tty_lock stuff was reworked in
> 4a179218b78d346e0de37c6d428d5be01fadae9c by Arnd. I'd say that the
> check of a holding lock in non-tty_mutex system should be changed here,
> probably exclusive check for tty locks.

The check is only there for CONFIG_TTY_MUTEX=n, otherwise you get the
same information from lockdep. The warning is useful in general
because when it gets triggered this normally means that running with
CONFIG_TTY_MUTEX disabled would be broken.

The particular case of holding the lock from the init code is
a false positive though, because the init code does not get
converted to the tty mutex and in fact the patch referenced above
makes the init code BKL-free as well, which is the intended fix.
 
> 2. A more serious problem is that printing kernel message no more works
> after running into userspace.
> ....
> Freeing init memory: 100K
> 3sy||_|_|
> phyCORE login:
> ....
> The boot message between init and login sheel is printed only
> partly. The cursor jumps back and forward. It seems that part the
> special characters like new line etc. are cutted away so that the
> printout is shown in such a funny manner. After a tty is spawned, every
> thing works just well. I can log in onto the system and it seems to work
> so far. I bisected the kernel and identified eventually
> fb11bee14186af87ee6abb833cf1a2a6be59c65b as the
> first bad commit. The actual problem should be, however,
> 36c621d82b956ff6ff72273f848af53e6c581aba, where tty_port_block_til_ready()
> is introduced. Seems to me that there are locking problems. I
> unfortunately don't have any insights of tty layer to tell where the
> exact problem is.

I'm sorry you had to bisect this. I did the same bisect and already
submitted a patch for this, which probably got stuck in Greg's inbox
while he was preparing the stable releases. I can't find the patch
in the archives now, which could also mean that it never left my local
machine.

I have the patch on a different machine, but will resend it to Greg
when I get there to make sure it doesn't get lost.

	Arnd
