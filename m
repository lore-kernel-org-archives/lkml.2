Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1DUJHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:07:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36718 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1DUJHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=A83K/05vEskFCG7q0+ScCS9ZhlqkZL2LSrCGpHaqzB+JHF9vqQOEBdsKpgRQn7CSgf
         Q77GYSveBMDKfQL+wiLNVdfyBa7Fok3Gdn8SUgcY4GpAjpGnrRDWrgOfga8jEJADZLA0
         aIs6em/BY3YAqaHvijznaCQ0Lldo5YTL167uA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110421050823.GA4487@linux.vnet.ibm.com>
References: <BANLkTikd2MpRPF37R+vCwnb7Lzzd6EiS7A@mail.gmail.com>
	<BANLkTinq=mC9rs5R3U8FPLCp-GgCJris_g@mail.gmail.com>
	<BANLkTimT9OhHLL5NaPOP30MdiMfmmmEcyQ@mail.gmail.com>
	<BANLkTikVW9Z=WxD7=w9c=Z6kHO-Za2ru8A@mail.gmail.com>
	<20110414224411.GF2141@linux.vnet.ibm.com>
	<20110421050823.GA4487@linux.vnet.ibm.com>
Date: Thu, 21 Apr 2011 11:07:38 +0200
Message-ID: <BANLkTinFmG5GVq6D8+wq_89OPF8snsQ=Jw@mail.gmail.com>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 7:08 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Apr 14, 2011 at 03:44:11PM -0700, Paul E. McKenney wrote:
>> On Fri, Apr 15, 2011 at 12:19:34AM +0200, Sedat Dilek wrote:
>> > On Thu, Apr 14, 2011 at 12:19 PM, Sedat Dilek
>> > <sedat.dilek@googlemail.com> wrote:
>> > > On Thu, Apr 14, 2011 at 11:16 AM, Sedat Dilek
>> > > <sedat.dilek@googlemail.com> wrote:
>> > >> [ Adding CC to RCU maintainer (Hi Paul :-)) ]
>> > >>
>> > >> Helping me for now with (see also Documentation/RCU/stallwarn.txt):
>> > >>
>> > >> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
>> > >> 0
>> > >>
>> > >> # echo "1" > /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
>> > >>
>> > >> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
>> > >> 1
>> > >>
>> > >> - Sedat -
>> > >>
>> > >
>> > > That workaround helped till a system-freeze when generating a tarball
>> > > from my current kernel-tree.
>> > > I switched back to my yesterday's linux-next kernel.
>> > >
>> > > - Sedat -
>> > >
>> >
>> > I isolated the culprit so far:
>> >
>> > commit 900507fc62d5ba0164c07878dbc36ac97866a858
>> > "rcu: move TREE_RCU from softirq to kthread"
>> >
>> > With this revert my system does not show the symptoms I have reported.
>>
>> Hmmm...  I never was able to reproduce this, but did find a workload
>> that slowed up the grace periods.  I fixed that (which turned out to
>> be a wakeup problem), but my hopes that it would also fix your problem
>> were clearly unfounded.  I have once again stopped exporting this commit
>> to -next.
>
> I have added some debug tracing, which are available at branch
> "sedat.2011.04.19a" in the git repository at:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
>
> Alternatively, if it is easier, the shown below can be used.  FWIW,
> this patch is against 2.6.39-rc3.
>
> Either way, if you get a chance to run your tests on this, could you
> please run the attached script (collectdebugfs.sh) and capture its output?
> Sample output is attached as well (collectdebugfs.sh.out):  the script
> should output something vaguely like the sample output every 15 seconds
> or so.
>
> The script assumes that debugfs is enabled (along with CONFIG_RCU_TRACE=y)
> and mounted as follows:
>
>        mount -t debugfs none /sys/kernel/debug/
>
> Or if you mount debugfs somewhere else, please set the script's DEBUGFS_MP
> variable accordingly.
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>

Welcome to operation "Kill that RCU brainbug" (Starship troopers part X)!

Of course I can help with testing.

Paul, did you see recent RCU-related fixes to fs between rc3 and rc4?

commit c1530019e311c91d14b24d8e74d233152d806e45
vfs: Fix absolute RCU path walk failures due to uninitialized seq number

fff3e5ade4455a4b42a19c95dd7a167a3cb7956a
fs: synchronize_rcu when unregister_filesystem success not failure

IIRC, Jens has pending block/plugging patches in his for-linus tree.
Especially this one (CONFIG_PREEMPT):

5f45c69589b7d2953584e6cd0b31e35dbe960ad0
cfq-iosched: read_lock() does not always imply rcu_read_lock()

Some questions to test-scenario:

Shall I test from linux-2.6-rcu.git#sedat.2011.04.19a GIT tree?
I think that's the ideal solution.
Or shall I pull sedat.2011.04.19a GIT branch into "BROKEN" linux-next
(next-20110414)?

Again, with which RCU/HZ/PREEMPT kernel-config options shall I test?
This is from my yesterday's linux-next:

# egrep 'RCU|_HZ |PREEMPT' /boot/config-2.6.39-rc4-next20110420.4-686-small
# RCU Subsystem
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60

Regards,
- Sedat -

P.S.: Is that intended you have no master GIT defined?

$ git clone git://git.us.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
Cloning into linux-2.6-rcu...
remote: Counting objects: 2012268, done.
remote: Compressing objects: 100% (323153/323153), done.
Receiving objects: 100% (2012268/2012268), 418.89 MiB | 341 KiB/s, done.
remote: Total 2012268 (delta 1675063), reused 2007602 (delta 1670549)
Resolving deltas: 100% (1675063/1675063), done.
warning: remote HEAD refers to nonexistent ref, unable to checkout.

$ ls -l linux-2.6-rcu/
total 32
drwxr-xr-x  3 sd sd  4096 Apr 21 10:26 .
drwxr-xr-x 39 sd sd 20480 Apr 21 10:26 ..
drwxr-xr-x  7 sd sd  4096 Apr 21 10:49 .git

$ du -s -h linux-2.6-rcu/
473M    linux-2.6-rcu/

$ cd linux-2.6-rcu/

$ git pull
You asked me to pull without telling me which branch you
want to merge with, and 'branch.master.merge' in
your configuration file does not tell me, either. Please
specify which branch you want to use on the command line and
try again (e.g. 'git pull <repository> <refspec>').
See git-pull(1) for details.

If you often merge with the same branch, you may want to
use something like the following in your configuration file:

    [branch "master"]
    remote = <nickname>
    merge = <remote-ref>

    [remote "<nickname>"]
    url = <url>
    fetch = <refspec>

See git-config(1) for details.

$ git pull master
fatal: 'master' does not appear to be a git repository
fatal: The remote end hung up unexpectedly

$ git branch -r | grep sedat
  origin/sedat.2011.04.19a

$ git checkout -b sedat.2011.04.19a origin/sedat.2011.04.19a
Checking out files: 100% (36702/36702), done.
Branch sedat.2011.04.19a set up to track remote branch
sedat.2011.04.19a from origin.
Switched to a new branch 'sedat.2011.04.19a'

$ ls -l
total 480
-rw-r--r--  1 sd sd  18693 Apr 21 10:54 COPYING
-rw-r--r--  1 sd sd  93908 Apr 21 10:54 CREDITS
drwxr-xr-x 91 sd sd  12288 Apr 21 10:54 Documentation
-rw-r--r--  1 sd sd   2464 Apr 21 10:54 Kbuild
-rw-r--r--  1 sd sd    252 Apr 21 10:54 Kconfig
-rw-r--r--  1 sd sd 192586 Apr 21 10:54 MAINTAINERS
-rw-r--r--  1 sd sd  52374 Apr 21 10:54 Makefile
-rw-r--r--  1 sd sd  17525 Apr 21 10:54 README
-rw-r--r--  1 sd sd   3371 Apr 21 10:54 REPORTING-BUGS
drwxr-xr-x 26 sd sd   4096 Apr 21 10:55 arch
drwxr-xr-x  2 sd sd   4096 Apr 21 10:55 block
drwxr-xr-x  3 sd sd   4096 Apr 21 10:55 crypto
drwxr-xr-x 92 sd sd   4096 Apr 21 10:55 drivers
drwxr-xr-x 37 sd sd   4096 Apr 21 10:55 firmware
drwxr-xr-x 71 sd sd   4096 Apr 21 10:55 fs
drwxr-xr-x 22 sd sd   4096 Apr 21 10:55 include
drwxr-xr-x  2 sd sd   4096 Apr 21 10:55 init
drwxr-xr-x  2 sd sd   4096 Apr 21 10:55 ipc
drwxr-xr-x  8 sd sd   4096 Apr 21 10:55 kernel
drwxr-xr-x  8 sd sd   4096 Apr 21 10:55 lib
drwxr-xr-x  2 sd sd   4096 Apr 21 10:55 mm
drwxr-xr-x 53 sd sd   4096 Apr 21 10:55 net
drwxr-xr-x  9 sd sd   4096 Apr 21 10:55 samples
drwxr-xr-x 13 sd sd   4096 Apr 21 10:55 scripts
drwxr-xr-x  8 sd sd   4096 Apr 21 10:55 security
drwxr-xr-x 22 sd sd   4096 Apr 21 10:55 sound
drwxr-xr-x  9 sd sd   4096 Apr 21 10:55 tools
drwxr-xr-x  2 sd sd   4096 Apr 21 10:55 usr
drwxr-xr-x  3 sd sd   4096 Apr 21 10:55 virt

- EOT -
