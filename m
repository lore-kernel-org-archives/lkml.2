Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0HHMAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:00:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32974 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0HHMAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=MxPHH0Am6fwGC5PK/i4SJnkQeeCEQQD7AadBNtu0qaNxvoXUX43Va6/rG9nUHb9oao
         otDHGwuAbvR4gPGYuhIOypHgufgEWOhyM99z3NuOPEBKwLbvni7mvoa7kEGpfdqHrUsA
         brTFuO5US5KQgJUYvvPIXu7AYv1SOB87UCbvA=
MIME-Version: 1.0
Date: Sun, 8 Aug 2010 14:00:29 +0200
Message-ID: <AANLkTinf8Y_AfpcA+=6u-R8QPGnnTM3Gu3j12qdvXXER@mail.gmail.com>
Subject: attempting to git bisect a panic - I must be doing something wrong...
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main issue: out-of-tree, proprietary broadcom-sta wireless works
in 2.6.35-git1
 and panics in following kernels tried (-git2, -git3, -git4, -git5) at
load time; RIPs don't
 get logged on disk and have been different at least two out of three
times (once
 in neigh_invalidate, once in acpi_enter_idle_bm).

As -git2 is a large increment over -git1, I decided to give my first
try at bisecting, so
 I installed git and ran

 git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
linux-git

Then (I only later found out how to map -gitN kernels with their git
IDs, so bear a
 bit with me please) I told git that HEAD was bad and v2.6.35 was good, and went
 off bisecting, with this partial result:

[asuardi@duff linux-git]$ git bisect log
git bisect start
# good: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
git bisect good 9fe6206f400646a2322096b56c59891d530e8d51
# bad: [4a386c3e177ca2fbc70c9283d0b46537844763a0] Merge branch
'x86-xsave-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 4a386c3e177ca2fbc70c9283d0b46537844763a0
# bad: [6ba74014c1ab0e37af7de6f64b4eccbbae3cb9e7] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
git bisect bad 6ba74014c1ab0e37af7de6f64b4eccbbae3cb9e7
# good: [b7753c8cd51dce67a0b152efb456a21ff1cc241b] cfg80211: fix dev
<-> wiphy typo
git bisect good b7753c8cd51dce67a0b152efb456a21ff1cc241b
# good: [f63b759c44b0561c76a67894c734157df3313b42] Merge branch
'v4l_for_2.6.35' of
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
git bisect good f63b759c44b0561c76a67894c734157df3313b42
# good: [5e83f6fbdb020b70c0e413312801424d13c58d68] Merge branch
'kvm-updates/2.6.36' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 5e83f6fbdb020b70c0e413312801424d13c58d68
# good: [8e86acd7d5968e08b3e1604e685a8c45f6fd7f40] e1000e: Fix
irq_synchronize in MSI-X case
git bisect good 8e86acd7d5968e08b3e1604e685a8c45f6fd7f40
# good: [ed6f2b4da32913875355f5c9cbbb38e4168b7801] zero the stack
buffer before giving random garbage to the SCU
git bisect good ed6f2b4da32913875355f5c9cbbb38e4168b7801
# good: [f46e9913faeebcb6bd29edf795f12b60acbff171] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
git bisect good f46e9913faeebcb6bd29edf795f12b60acbff171
# good: [3ff1c25927e3af61c6bf0e4ed959504058ae4565] phy/marvell: add
88ec048 support
git bisect good 3ff1c25927e3af61c6bf0e4ed959504058ae4565
# good: [c4799c7570475352c8c5de82ae938f7a02f206fa] amd64_edac: Minor
formatting fix
git bisect good c4799c7570475352c8c5de82ae938f7a02f206fa

During this bisect run, I've been puzzled by the fact that the Makefile flipped
 versions between 2.6.35 and 2.6.35-rc1 - why -rc1, isn't that a version
 prior to the one I flagged as "good" ? But since the bisect run progressed
 and reported decreasing attempts towards the pinpointing, I kept going...

The issue is that the current proposed kernel *appears* to be a 2.6.34-rc7
 of some sort, according to the Makefile... but not only, as the out-of-tree
 module NOW fails to build on that kernel:

  CC [M]  /download/kernel/v2.6/bcm4322/src/wl/sys/wl_linux.o
/download/kernel/v2.6/bcm4322/src/wl/sys/wl_linux.c: In function
‘_wl_set_multicast_list’:
/download/kernel/v2.6/bcm4322/src/wl/sys/wl_linux.c:1449: warning:
assignment from incompatible pointer type
/download/kernel/v2.6/bcm4322/src/wl/sys/wl_linux.c:1449: error:
‘struct netdev_hw_addr’ has no member named ‘next’
make[1]: *** [/download/kernel/v2.6/bcm4322/src/wl/sys/wl_linux.o] Error 1
make: *** [_module_/download/kernel/v2.6/bcm4322] Error 2

That build issue is known, and is supposed to be introduced in 2.6.35, of
 course the other way round - that is, the patch that fixes 2.6.35 doesn't
 play well with pre-2.6.35 versions. If I revert that broadcom-sta patch,
 the module builds again.

But doesn't that mean I'm trying a kernel which comes before the one I
 thought I flagged as "good" ?

I would now discard my previous bisect run and attempt to bisect between
 -git1 and -git2 given that kernel.org does publish their git IDs, but since
 what should in theory have been just a longer process turned out to be
 incorrect, I'd rather ask for some help in showing me what I did wrong.


Thanks in advance,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
