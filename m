Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0GaV3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:29:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:60007 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0GaV3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:29:11 -0400
Date: Sat, 31 Jul 2010 23:29:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Roman Zippel <zippel@linux-m68k.org>,
        Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH v2 0/9] kconfig: introduce saveconfig and alldefconfig
	(+more)
Message-ID: <20100731212907.GA7554@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update of patches previous posted.

Version 2 have addressed the following feedback:
- Drop the idea of introducing allrandconfig (Michal, Randy)
- Do more code refactoring (Michal)
- Use long options in conf.c (Michal)
- savedefconfig shall list symbols in same order as in .config (Uwe)
 
The major feature is the introduction of "make savedefconfig".

Make savedefconfig creates a minimal configuration
as have been discussed recently and which is already
done for arm and powerpc.
savedefconfig utilise the knowledge kconfig has to do so
much faster than the phyton script posted.

The implementation was checked against several arm defconfigs.
This was btw. a great source as it allowed me to finetune the
implementation without having to spent hours looking at the
generated files.

One minor issue was not solved..
when a symbol has a default value that is not within
a valid range (the range may be limited by another symbol),
then savedefconfig saves the config symbol with the default value.
The final configuration is OK and this is so seldom that
it does not matter in practice.
[I found only one symbol that in a few configurations triggered this]

Introducing savedefconfig does not say that I dislike the idea
of specifying defconfigs partly/fully using Kconfig fragments.
We just needed something better than the brute-force phython
script and I could see this being usefull anyway.


The patch also introduce another new target: alldefconfig
alldefconfig creates a configuration with all symbols equals
their default value.
Now where we start to use the default values even more this
can be usefull to check that there is a sensible set of
default values.

alldefconfig proved good as testing for savedefconfig

    make alldefconfig
    make savedefconfig

Creates an empty defconfig file - because all symbols has
their default value.


The patchset in addition contains the following changes:
- use long options in conf.c.
  This increased the readability of this file quite a lot
- rename of loose_nonint_oldconfig to oldnoconfig
- replace nonint_oldconfig with listnewconfig
  listnewconfig does not exit with a failure code
  if there is new options. nonint_oldconfig did so
- improved warnings for recursive dependencies
  this also fixes a segmentation fault I have seen in handling
  recursive dependecies

I consider this version ready for merge.
The patches are created on top of kbuild.git for-next.

I will trim cc: in the actual patches.

Note: the patch from Roman Zippel is an old patch I digged up.
Unfortunately I have not heard from Roman lately.
I have in private mail suggested Michal to take over
kconfig maintainership to document the current state of affairs.

	Sam

Roman Zippel (1):
      kconfig: print more info when we see a recursive dependency

Sam Ravnborg (8):
      kconfig: use long options in conf
      kconfig: rename loose_nonint_oldconfig => oldnoconfig
      kconfig: change nonint_oldconfig to listnewconfig
      kconfig: save location of config symbols
      kconfig: add alldefconfig
      kconfig: refactor code in symbol.c
      kconfig: code refactoring in confdata.c
      kconfig: add savedefconfig

 Documentation/kbuild/kconfig.txt |    2 +-
 scripts/kconfig/Makefile         |   87 ++++++-------
 scripts/kconfig/conf.c           |  196 ++++++++++++++--------------
 scripts/kconfig/confdata.c       |  213 +++++++++++++++++++++----------
 scripts/kconfig/expr.h           |    1 +
 scripts/kconfig/lkc.h            |    2 +
 scripts/kconfig/lkc_proto.h      |    1 +
 scripts/kconfig/menu.c           |    2 +
 scripts/kconfig/symbol.c         |  264 ++++++++++++++++++++++++++++++++++----
 9 files changed, 526 insertions(+), 242 deletions(-)

