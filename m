Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2LNJeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:34:23 -0500
Received: from canardo.mork.no ([148.122.252.1]:42737 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab2LNJdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:33:43 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: linux-kernel@vger.kernel.org
Cc: Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Bisected oops regression between v3.7-rc8 and v3.7: nmi_watchdog
Organization: m
Date: Fri, 14 Dec 2012 10:33:33 +0100
Message-ID: <87y5h1c70y.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was a bit surprised by v3.7 hanging "all the time", usually just
freezing but sometimes with a stack dump pointing to timerqueue_del
calling rb_erase and oopsing there. Of course I could never make it dump
anything when prepared to capture it via netconsole, so the best I have
is this picture: http://www.mork.no/~bjorn/20121213_203557.jpg

I discovered that the freeze was related to plugging AC power and
started bisecting from v3.7-rc3, which I had been running for quite a
while and therefore was confident did not have this problem.  The bisect
log ended up as this:

bjorn@canardo:/usr/local/src/build-tmp/linux$ git bisect log
# bad: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
# good: [8f0d8163b50e01f398b14bcd4dc039ac5ab18d64] Linux 3.7-rc3
git bisect start 'v3.7' 'v3.7-rc3'
# good: [29282fde80d44e587f8c152b10049a56e61659f0] KVM: x86: Fix invalid secondary exec controls in vmx_cpuid_update()
git bisect good 29282fde80d44e587f8c152b10049a56e61659f0
# good: [2654ad44b5f7a5f1b12d722a37d9b9df69d57899] Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 2654ad44b5f7a5f1b12d722a37d9b9df69d57899
# good: [086486e46e4206cfa1140fb9682ad67c8a4502fb] Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6
git bisect good 086486e46e4206cfa1140fb9682ad67c8a4502fb
# good: [25a3bc6bd1ca03ab504b8c55c98f8d0135644d53] [parisc] open(2) compat bug
git bisect good 25a3bc6bd1ca03ab504b8c55c98f8d0135644d53
# bad: [cfd1f032f98e5ab3a04f23a0adbd53ff8744827d] Merge branch 'core-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad cfd1f032f98e5ab3a04f23a0adbd53ff8744827d
# good: [b69f0859dc8e633c5d8c06845811588fe17e68b3] Linux 3.7-rc8
git bisect good b69f0859dc8e633c5d8c06845811588fe17e68b3
# good: [ca50496eb487b639de1f502e77a48dde84152fb9] Merge branch 'for-3.7-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
git bisect good ca50496eb487b639de1f502e77a48dde84152fb9
# good: [70dcc535bdf30ffaef58b867fbde45c0287f34c6] Merge tag 'upstream-3.7-rc9' of git://git.infradead.org/linux-ubi
git bisect good 70dcc535bdf30ffaef58b867fbde45c0287f34c6
# good: [df2fc246c8ee8b6067af1fa55d3bc23107457f61] Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good df2fc246c8ee8b6067af1fa55d3bc23107457f61
# bad: [8d4516904b39507458bee8115793528e12b1d8dd] watchdog: Fix CPU hotplug regression
git bisect bad 8d4516904b39507458bee8115793528e12b1d8dd


and I can confirm that reverting 8d451690 does fix the problem.  After
having found this, it became clearer to me why the freeze was related to
plugging AC power: I use laptop-mode-tools in its default Debian
configuration, which will disable the nmi_watchdog on battery power and
enable it on AC power.

So the simple test case which will hang my (and presumably also your) PC
on plain v3.7 is:

 echo 0 > /proc/sys/kernel/nmi_watchdog
 echo 1 > /proc/sys/kernel/nmi_watchdog

without any cmdline nmi_watchdog parameters, i.e. enabled.

I'll followup with a proposed revert patch, but I guess you will want to
come up with something which fixes the original problem as well.  But
given the serious effect of the bug, causing a 100% reproducable freeze
on a standard distro laptop setup, I hope that the revert will go into
v3.7.1 unless a real fix can be prepared in time.


Thanks,
Bjørn
