Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0EDERs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 00:17:48 -0400
Received: from ozlabs.org ([203.10.76.45]:56106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0EDERq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 00:17:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: dedekind1@gmail.com
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
Date: Tue, 4 May 2010 11:53:50 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
References: <200910290902.13724.rusty@rustcorp.com.au> <1272364305.26036.21.camel@localhost> <1272365604.26036.30.camel@localhost>
In-Reply-To: <1272365604.26036.30.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005041154.24658.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 08:23:24 pm Artem Bityutskiy wrote:
> On Tue, 2010-04-27 at 13:31 +0300, Artem Bityutskiy wrote:
> > On Thu, 2009-10-29 at 09:02 +1030, Rusty Russell wrote:
> > > (Thanks to Takashi-san, who found the oops and kept reading the code to spot
> > >  the others.  A more complete fix is pending, but this works for 2.6.32 and
> > >  -stable: see commit message and FIXME in code.)
> > > 
> > > The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
> > >   Linus Torvalds (1):
> > >         Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus
> > > 
> > > are available in the git repository at:
> > > 
> > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-param-fixes.git master
> > > 
> > > Rusty Russell (3):
> > >       param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
> > >       param: fix NULL comparison on oom
> > >       param: fix setting arrays of bool
> > > 
> > >  include/linux/moduleparam.h |    1 -
> > >  kernel/params.c             |   17 ++++++-----------
> > >  2 files changed, 6 insertions(+), 12 deletions(-)
> > > 
> > > commit 65afac7d80ab3bc9f81e75eafb71eeb92a3ebdef
> > > Author: Rusty Russell <rusty@rustcorp.com.au>
> > > Date:   Thu Oct 29 08:56:16 2009 -0600
> > > 
> > >     param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
> > >     
> > >     e180a6b7759a "param: fix charp parameters set via sysfs" fixed the case
> > >     where charp parameters written via sysfs were freed, leaving drivers
> > >     accessing random memory.
> > >     
> > >     Unfortunately, storing a flag in the kparam struct was a bad idea: it's
> > >     rodata so setting it causes an oops on some archs.  But that's not all:
> > >     
> > >     1) module_param_array() on charp doesn't work reliably, since we use an
> > >        uninitialized temporary struct kernel_param.
> > >     2) there's a fundamental race if a module uses this parameter and then
> > >        it's changed: they will still access the old, freed, memory.
> > >     
> > >     The simplest fix (ie. for 2.6.32) is to never free the memory.  This
> > >     prevents all these problems, at cost of a memory leak.  In practice, there
> > >     are only 18 places where a charp is writable via sysfs, and all are
> > >     root-only writable.
> > 
> > Hmm, is it really only about changing the parameters via sysfs? We see
> > the following kmemleak complaints in 2.6.32 (I think it will be the same
> > in the latest kernel, but I did not check):
> > 
> > kmemleak: unreferenced object 0xdeff3c80 (size 64):
> > kmemleak:   comm "modprobe", pid 788, jiffies 4294933427
> > kmemleak:   backtrace:
> > kmemleak:     [<c00e59b8>] __save_stack_trace+0x34/0x40
> > kmemleak:     [<c00e5ad0>] create_object+0x10c/0x208
> > kmemleak:     [<c03ae0ec>] kmemleak_alloc+0x40/0x84
> > kmemleak:     [<c00dca74>] __kmalloc_track_caller+0x140/0x154
> > kmemleak:     [<c00c47ac>] kstrdup+0x38/0x54
> > kmemleak:     [<c0081854>] param_set_charp+0x68/0x94
> > kmemleak:     [<c0081108>] parse_args+0x18c/0x280
> > kmemleak:     [<c009fc74>] load_module+0x11e8/0x1644
> > kmemleak:     [<c00a0130>] sys_init_module+0x60/0x1f4
> > kmemleak:     [<c003c040>] ret_fast_syscall+0x0/0x38
> > 
> > So we are leaking on every insmod/rmmod, AFAICS, not just in the sysfs
> > case.
> 
> Rusty, correct me if I'm wrong, but it looks like the above memleak was
> introduced by e180a6b7759a99a28cbcce3547c4c80822cb6c2a, where you added
> the kstrdup(). So you kinda fixed the sysfs case (it still memleaks
> though), but at the cost of additional insmod/rmmod leak, right?

Yep!

Cheers,
Rusty.
