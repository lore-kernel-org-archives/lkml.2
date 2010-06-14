Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0FNO5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:57:08 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:44018 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753712Ab0FNO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:57:06 -0400
Date: Mon, 14 Jun 2010 10:56:59 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [regression, bisected] SysRq commands trigger without holding
 sysrq.
Message-ID: <20100614145659.GA2594@elliptictech.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that the new SysRq handling stuff totally ignores key
releases: I don't have to hold down any of the keys to trigger sysrq
commands.  For example, if I press and release left-alt, then press and
release print screen, then press b, the system reboots.  The order in
which I press the keys matters, but I can press other keys between them
and still trigger sysrq commands (e.g. I can press and release alt, type
a bunch, press print screen, then start triggering commands by pressing
letters).

The result is that it is very easy to accidentally trigger sysrq
commands, to the detriment of a system's usefulness.  It also renders
the printscreen key completely useless after either alt key has been
pressed once since system bootup (printscreen works fine until alt is
pressed).

Bisection reveals the following, and reverting the implicated commit
(resolving a trivial conflict) solves the issue.

97f5f0cd8cd0a05449cbb77d1e6f02e026875802 is the first bad commit
commit 97f5f0cd8cd0a05449cbb77d1e6f02e026875802
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sun Mar 21 22:31:26 2010 -0700

    Input: implement SysRq as a separate input handler
    
    Instead of keeping SysRq support inside of legacy keyboard driver split
    it out into a separate input handler (filter). This stops most SysRq input
    events from leaking into evdev clients (some events, such as first SysRq
    scancode - not keycode - event, are still leaked into both legacy keyboard
    and evdev).
    
    [martinez.javier@gmail.com: fix compile error when CONFIG_MAGIC_SYSRQ is
     not defined]
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

:040000 040000 7aadaa6e08d64b8021420b14fb04708a8f9970e8 cfaa4f20884a0ac6e492cb7d1fffb95523bd85ed M	drivers
:040000 040000 f37a5cbce56d6611dbf83359522ded3b2530d3b1 7ba6f8e3c4705fe375f4bc05b80179ee3b113b0a M	include
:040000 040000 d5e24354f25c824866b495e03ba7b7e2040a1983 3e3d6b55c318625c8aa37cb53f2227431a4182c5 M	kernel

git bisect start
# bad: [7908a9e5fc3f9a679b1777ed231a03636c068446] Merge branch 'kvm-updates/2.6.35' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect bad 7908a9e5fc3f9a679b1777ed231a03636c068446
# good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
# bad: [a02c37891a9b2d7ce93f9d09455b4f67c4c23b95] vhost: fix the memory leak which will happen when memory_access_ok fails
git bisect bad a02c37891a9b2d7ce93f9d09455b4f67c4c23b95
# good: [2ec8c6bb5d8f3a62a79f463525054bae1e3d4487] Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
git bisect good 2ec8c6bb5d8f3a62a79f463525054bae1e3d4487
# good: [bd7fc2f2d807fdb254f7efc542f8eec3f23e289e] Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev
git bisect good bd7fc2f2d807fdb254f7efc542f8eec3f23e289e
# good: [c3ad33c9bcb6616999953af76f16318120fe3691] Merge branch 'for-linus/i2c-2635' of git://git.fluff.org/bjdooks/linux
git bisect good c3ad33c9bcb6616999953af76f16318120fe3691
# bad: [a0fe3cc5d36a5f5b4f60abfe1a4b1caf4a5cce5a] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect bad a0fe3cc5d36a5f5b4f60abfe1a4b1caf4a5cce5a
# good: [266d38c8e3d7f62152b1448fd9a7265f32f32d87] ASoC: tpa6130a2: Define output pins with SND_SOC_DAPM_OUTPUT
git bisect good 266d38c8e3d7f62152b1448fd9a7265f32f32d87
# bad: [97f5f0cd8cd0a05449cbb77d1e6f02e026875802] Input: implement SysRq as a separate input handler
git bisect bad 97f5f0cd8cd0a05449cbb77d1e6f02e026875802
# good: [b91c4be730668e801aa6a2ea95f467cd9a1e0983] Input: add PCF8574 I2C keypad input device driver
git bisect good b91c4be730668e801aa6a2ea95f467cd9a1e0983

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
