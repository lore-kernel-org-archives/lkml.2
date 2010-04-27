Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0D0KgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:36:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50618 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0D0KgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:36:22 -0400
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
In-Reply-To: <200910290902.13724.rusty@rustcorp.com.au>
References: <200910290902.13724.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 13:31:45 +0300
Message-ID: <1272364305.26036.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Apr 2010 10:35:59.0247 (UTC) FILETIME=[6D0801F0:01CAE5F5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 09:02 +1030, Rusty Russell wrote:
> (Thanks to Takashi-san, who found the oops and kept reading the code to spot
>  the others.  A more complete fix is pending, but this works for 2.6.32 and
>  -stable: see commit message and FIXME in code.)
> 
> The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-param-fixes.git master
> 
> Rusty Russell (3):
>       param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
>       param: fix NULL comparison on oom
>       param: fix setting arrays of bool
> 
>  include/linux/moduleparam.h |    1 -
>  kernel/params.c             |   17 ++++++-----------
>  2 files changed, 6 insertions(+), 12 deletions(-)
> 
> commit 65afac7d80ab3bc9f81e75eafb71eeb92a3ebdef
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Thu Oct 29 08:56:16 2009 -0600
> 
>     param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
>     
>     e180a6b7759a "param: fix charp parameters set via sysfs" fixed the case
>     where charp parameters written via sysfs were freed, leaving drivers
>     accessing random memory.
>     
>     Unfortunately, storing a flag in the kparam struct was a bad idea: it's
>     rodata so setting it causes an oops on some archs.  But that's not all:
>     
>     1) module_param_array() on charp doesn't work reliably, since we use an
>        uninitialized temporary struct kernel_param.
>     2) there's a fundamental race if a module uses this parameter and then
>        it's changed: they will still access the old, freed, memory.
>     
>     The simplest fix (ie. for 2.6.32) is to never free the memory.  This
>     prevents all these problems, at cost of a memory leak.  In practice, there
>     are only 18 places where a charp is writable via sysfs, and all are
>     root-only writable.

Hmm, is it really only about changing the parameters via sysfs? We see
the following kmemleak complaints in 2.6.32 (I think it will be the same
in the latest kernel, but I did not check):

kmemleak: unreferenced object 0xdeff3c80 (size 64):
kmemleak:   comm "modprobe", pid 788, jiffies 4294933427
kmemleak:   backtrace:
kmemleak:     [<c00e59b8>] __save_stack_trace+0x34/0x40
kmemleak:     [<c00e5ad0>] create_object+0x10c/0x208
kmemleak:     [<c03ae0ec>] kmemleak_alloc+0x40/0x84
kmemleak:     [<c00dca74>] __kmalloc_track_caller+0x140/0x154
kmemleak:     [<c00c47ac>] kstrdup+0x38/0x54
kmemleak:     [<c0081854>] param_set_charp+0x68/0x94
kmemleak:     [<c0081108>] parse_args+0x18c/0x280
kmemleak:     [<c009fc74>] load_module+0x11e8/0x1644
kmemleak:     [<c00a0130>] sys_init_module+0x60/0x1f4
kmemleak:     [<c003c040>] ret_fast_syscall+0x0/0x38

So we are leaking on every insmod/rmmod, AFAICS, not just in the sysfs
case.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

