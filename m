Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0GIBkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:40:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066Ab0GIBkS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
Date: Thu, 8 Jul 2010 18:34:25 -0700
Message-ID: <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Shawn Starr <shawn.starr@rogers.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 4:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Unresolved regressions
> ----------------------
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16353
> Subject         : 2.6.35 regression
> Submitter       : Zeev Tarantov <zeev.tarantov@gmail.com>
> Date            : 2010-07-05 13:04 (4 days old)
> Message-ID      : <loom.20100705T144459-919@post.gmane.org>
> References      : http://marc.info/?l=linux-kernel&m=127836002702522&w=2

This is a gcc-4.5 issue. Whether it's also something that we should
change in the kernel is unclear, but at least as of now, the rule is
that you cannot compile the kernel with gcc-4.5. No idea whether the
compiler is just entirely broken, or whether it's just that it
triggers something iffy by being overly clever.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16346
> Subject         : 2.6.35-rc3-git8 - include/linux/fdtable.h:88 invoked rcu_dereference_check() without protection!
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2010-07-04 22:04 (5 days old)
> Message-ID      : <AANLkTinof0k28rk4rMr66aubxcRL2rFa5ZEArj1lqD3o@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127828107815930&w=2

I'm not entirely sure if these RCU proving things should count as regressions.

Sure, the option to enable RCU proving is new, but the things it
reports about generally are not new - and they are usually not even
bugs in the sense that they necessarily cause any real problems.

That particular one is in the single-thread optimizated case for fget_light, ie

        if (likely((atomic_read(&files->count) == 1))) {
                file = fcheck_files(files, fd);

where I think it should be entirely safe in all ways without any
locking. So I think it's a false positive too.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16334
> Subject         : reiserfs locking (v2)
> Submitter       : Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date            : 2010-07-02 9:34 (7 days old)
> Message-ID      : <20100702093451.GA3973@swordfish.minsk.epam.com>
> References      : http://marc.info/?l=linux-kernel&m=127806306303590&w=2

Frederic? Al? I assume this is some late fallout from the BKL removal
ages ago.. It's the old filldir-vs-mmap crud, but normally it should
be impossible to trigger because the inode for a directory should
never be mmap'able, so we should never have the same i_mutex lock used
for both mmap and for filldir protection.

We saw some of that oddity long ago, I wonder if it's lockdep being
confused about some inodes.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16333
> Subject         : iwl3945: HARDWARE GONE??
> Submitter       : Priit Laes <plaes@plaes.org>
> Date            : 2010-07-02 16:02 (7 days old)
> Message-ID      : <1278086575.2889.8.camel@chi>
> References      : http://marc.info/?l=linux-kernel&m=127808659705983&w=2

This either got fixed, or will be practically impossible to debug. The
reporter ends up being unable to reproduce the issue.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16332
> Subject         : Kernel crashes in tty code (tty_open)
> Submitter       : werner@guyane.yi.org
> Date            : 2010-07-02 3:34 (7 days old)
> Message-ID      : <1278041650.12788@guyane.yi.org>
> References      : http://marc.info/?l=linux-kernel&m=127804167511930&w=2

This seems to be due to CONFIG_MRST (Moorestown).

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16330
> Subject         : Dynamic Debug broken on 2.6.35-rc3?
> Submitter       : Thomas Renninger <trenn@suse.de>
> Date            : 2010-07-01 15:44 (8 days old)
> Message-ID      : <201007011744.19564.trenn@suse.de>
> References      : http://marc.info/?l=linux-kernel&m=127799907218877&w=2

There's a suggested patch in

  http://marc.info/?l=linux-kernel&m=127862524404291&w=2

but no reply to it yet.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16329
> Subject         : 2.6.35-rc3: Load average climbing to 3+ with no apparent reason: CPU 98% idle, with hardly no I/O
> Submitter       : Török Edwin <edwintorok@gmail.com>
> Date            : 2010-07-01 7:40 (8 days old)
> Message-ID      : <20100701104022.404410d6@debian>
> References      : http://marc.info/?l=linux-kernel&m=127797005030536&w=2

This seems to be partly a confusion about what "load average" is. It's
not a CPU load, it's a system load average, and disk-wait processes
count towards it. He has some problem with his CD-ROM, and it sounds
like it might be hardware on the verge of going bad.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16324
> Subject         : Oops while running fs_racer test on a POWER6 box against latest git
> Submitter       : divya <dipraksh@linux.vnet.ibm.com>
> Date            : 2010-06-30 11:34 (9 days old)
> Message-ID      : <4C2B28F3.7000006@linux.vnet.ibm.com>
> References      : http://marc.info/?l=linux-kernel&m=127789697303061&w=2

I wonder if this is the writeback problem. That POWER crash dump is
unreadable, so it's hard to tell, but the load in question makes that
at least likely.

If so, it should hopefully be fixed in today's git (commit
83ba7b071f30f7c01f72518ad72d5cd203c27502 and friends).

> Bug-entry    : http://bugzilla.kernel.org/show_bug.cgi?id=16323
> Subject         : 2.6.35-rc3-git4 - kernel/sched.c:616 invoked rcu_dereference_check() without protection!
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2010-07-01 12:21 (8 days old)
> Message-ID      : <AANLkTini6hz2LFeZi8CMUmY3xw1MU7NxmyesuxZ4oCdo@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127798693125541&w=2

See earlier about these being marked as regressions, but it should be
fixed by commit dc61b1d6 ("sched: Fix PROVE_RCU vs cpu_cgroup").

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16322
> Subject         : WARNING: at /arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5a/0x70()
> Submitter       : boris64 <bugzilla.kernel.org@boris64.net>
> Date            : 2010-07-01 13:54 (8 days old)
> Handled-By      : H. Peter Anvin <hpa@zytor.com>

Magic. Strange and dark magic.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16311
> Subject         : [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
> Submitter       : Shawn Starr <shawn.starr@rogers.com>
> Date            : 2010-06-28 0:45 (11 days old)
> Message-ID      : <201006272045.17004.shawn.starr@rogers.com>
> References      : http://marc.info/?l=linux-kernel&m=127768633705286&w=2

I think this might be usefully bisected. Shawn?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16309
> Subject         : 2.6.35-rc3 oops trying to suspend.
> Submitter       : Andrew Hendry <andrew.hendry@gmail.com>
> Date            : 2010-06-27 12:40 (12 days old)
> Message-ID      : <AANLkTinUH2p33-AWxOVDrLsNkn9rgEVrlwn5mfK7P8NH@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127764249926781&w=2

I'm pretty sure this was fixed by Nick in commit 57439f878afa ("fs:
fix superblock iteration race").

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16307
> Subject         : i915 in kernel 2.6.35-rc3, high number of wakeups
> Submitter       : Enrico Bandiello <enban@postal.uv.es>
> Date            : 2010-06-26 16:57 (13 days old)
> Message-ID      : <4C26317A.5070309@postal.uv.es>
> References      : http://marc.info/?l=linux-kernel&m=127757403404259&w=2

I don't think anybody noticed this one. Jesse?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16304
> Subject         : i915 - high number of wakeups
> Submitter       : Enrico Bandiello <enban@postal.uv.es>
> Date            : 2010-06-27 09:52 (12 days old)

Duplicate of that 16307 one.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16284
> Subject         : Hitting WARN_ON in hw_breakpoint code
> Submitter       : Paul Mackerras <paulus@samba.org>
> Date            : 2010-06-23 12:57 (16 days old)
> Message-ID      : <20100623125740.GA3368@brick.ozlabs.ibm.com>
> References      : http://marc.info/?l=linux-kernel&m=127729789113432&w=2

This has "I have a fix, will post it very soon." in the thread from
Frederic, but I'm not seeing anything else. Frederic?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16265
> Subject         : Why is kslowd accumulating so much CPU time?
> Submitter       : Theodore Ts'o <tytso@mit.edu>
> Date            : 2010-06-09 18:36 (30 days old)
> First-Bad-Commit: http://git.kernel.org/linus/fbf81762e385d3d45acad057b654d56972acf58c
> Message-ID      : <E1OMQ88-0002a1-Gb@closure.thunk.org>
> References      : http://marc.info/?l=linux-kernel&m=127610857819033&w=4

Dave, Jesse?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16234
> Subject         : [2.6.35-rc3] reboot mutex 'bug'...
> Submitter       : Daniel J Blueman <daniel.blueman@gmail.com>
> Date            : 2010-06-14 15:16 (25 days old)
> Message-ID      : <AANLkTimDcTnyEPmt2ZcCM1UWtn4AYKotiqyjobJApkO7@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127652861118933&w=2

Ok, this is definitely harmless. Whether we should silence the warning
somehow is a separate question.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16230
> Subject         : inconsistent IN-HARDIRQ-W -> HARDIRQ-ON-W usage: fasync, 2.6.35-rc3
> Submitter       : Dominik Brodowski <linux@dominikbrodowski.net>
> Date            : 2010-06-13 9:53 (26 days old)
> Message-ID      : <20100613095305.GA13231@comet.dominikbrodowski.net>
> References      : http://marc.info/?l=linux-kernel&m=127642282208277&w=2

Fixed by commit f4985dc714d7.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16228
> Subject         : BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
> Submitter       : Brian Bloniarz <phunge0@hotmail.com>
> Date            : 2010-06-16 17:57 (23 days old)
> Handled-By      : Bjorn Helgaas <bjorn.helgaas@hp.com>

This has a butt-ugly suggested patch that certainly won't be applied.
I saw the thread, but lost sight of it. Jesse, did that end up with
some resolution?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16221
> Subject         : 2.6.35-rc2-git5 -- [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2010-06-11 20:31 (28 days old)
> Message-ID      : <AANLkTim0jVRyqkwlGOcrg_XTvUQwcBYfWJX-aRzkkrLG@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127628828119623&w=2

I dunno. Old, and apparently seen by two people. Dave?

Might be helped by bisection.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16205
> Subject         : acpi: freeing invalid memtype bf799000-bf79a000
> Submitter       : Marcin Slusarz <marcin.slusarz@gmail.com>
> Date            : 2010-06-09 20:09 (30 days old)
> Message-ID      : <20100609200910.GA2876@joi.lan>
> References      : http://marc.info/?l=linux-kernel&m=127611427029914&w=2
>                  http://marc.info/?l=linux-kernel&m=127688398513862&w=2

This should be fixed by commit b945d6b2554d ("rbtree: Undo augmented
trees performance damage and regression").

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16199
> Subject         : 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked rcu_dereference_check() without protection!
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2010-06-07 18:14 (32 days old)
> Message-ID      : <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127593447812015&w=2

Another RCU proving thing.  And this one looks the same as the 16323
one above, and fixed by the same commit as that one.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16197
> Subject         : [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
> Submitter       : Ryan Wang <openspace.wang@gmail.com>
> Date            : 2010-06-07 0:23 (32 days old)
> Message-ID      : <AANLkTincwMZPnYW3S4uz4k2GOn52RpgBIBRfzyD010Yo@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127587022219378&w=2

These should all be gone. See commit 3be434f0244ee by Jesse ('Revert
"PCI: create function symlinks in /sys/bus/pci/slots/N/"').

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16187
> Subject         : Carrier detection failed in dhcpcd when link is up
> Submitter       : Christian Casteyde <casteyde.christian@free.fr>
> Date            : 2010-06-12 15:15 (27 days old)
> First-Bad-Commit: http://git.kernel.org/linus/10708f37ae729baba9b67bd134c3720709d4ae62
> Handled-By      : Andrew Morton <akpm@linux-foundation.org>

David? This bisects to a networking commit. Doesn't look sensible, but
what do I know?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16184
> Subject         : Container, X86-64, i386, iptables rule
> Submitter       : Jean-Marc Pigeon <jmp@safe.ca>
> Date            : 2010-06-12 04:17 (27 days old)
> Handled-By      : Patrick McHardy <kaber@trash.net>

Patrick, Davem? Ping?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16179
> Subject         : 2.6.35-rc2 completely hosed on intel gfx?
> Submitter       : Norbert Preining <preining@logic.at>
> Date            : 2010-06-06 11:55 (33 days old)
> Message-ID      : <20100606115534.GA9399@gamma.logic.tuwien.ac.at>
> References      : http://marc.info/?l=linux-kernel&m=127582534931581&w=2

Hmm. That one is the vt.c bug coupled with another problem, which in
turn got opened as a separate bugzilla entry:

   http://bugzilla.kernel.org/show_bug.cgi?id=16252

which in turn then got closed. I dunno.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16175
> Subject         : 2.6.35-rc1 system oom, many processes killed but memory not free
> Submitter       : andrew hendry <andrew.hendry@gmail.com>
> Date            : 2010-06-05 0:46 (34 days old)
> Message-ID      : <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127569877714937&w=2

Not a regression or a kernel bug at all. See the thread. Big ramdisk
filled up all of memory when it was filled by the builds.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16145
> Subject         : Unable to boot unless "notsc" or "clocksource=hpet", or acpi_pad disabling the TSC
> Submitter       : Tom Gundersen <teg@jklm.no>
> Date            : 2010-06-07 13:11 (32 days old)
> Handled-By      : Venkatesh Pallipadi <venki@google.com>
>                  Len Brown <lenb@kernel.org>

This is not a regression. See the full bugzilla details. The same
problem persists at least back to 2.6.30 with his config. So it's
somehow specific to his particular config use that requires "notsc" to
boot.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16122
> Subject         : 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2010-06-04 13:18 (35 days old)
> Handled-By      : Jens Axboe <axboe@kernel.dk>

This looks like a duplicate of that 16312 bugzilla entry. Jens, has
this been resolved?

                               Linus
