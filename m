Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1JWKU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:20:28 -0400
Received: from mail.southpole.se ([193.12.106.18]:34910 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1JWKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:23 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH RFC 0/8] Signal: harmonize syscall restart logic
Date: Sun, 23 Oct 2011 12:19:54 +0200
Message-Id: <cover.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65220-02305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been looking into trying to harmonize the architecture specific
signal handling code.  With a couple of helper functions to mask some
of the architecture specific bits, the code for do_signal and handle_signal
(implemented by essentially everybody) start to look identical across
all arch's and could likely be made generic.

The big helper is the one in this series.  This one moves the syscall
restart logic out to a common helper.  The arch specific bit here is
the register manipulations required to actually effect the restart;
this patch series moves those manipulations to the asm/syscall.h header
which already attempts to define a generic syscall interface for several
arch's today.

Where this series remains an RFC is due to a couple of open questions:

i)  ARM (and a few arch's copied from it) does its restart logic in two
    steps so that a debugger can intervene; is there still value in
    this approach or would the single step approach in this patch series
    be sufficient for ARM (and others)?

ii) The syscall.h interface requires that the information needed to do
    the register manipulations be in the pt_regs struct.  This isn't
    the case for all arch's today.  Are there any issues with putting that
    info into pt_regs for those arch's?

With the rest of the cleanups in this series it currently comes to 64
patches, so I'm just posting a couple of the syscall restart patches
now for comment in order not to flood the lists.  I'll post the remainder
of the series later based on the feedback from this series.

/Jonas

Jonas Bonn (8):
  signal: introduce generic syscall restart logic
  blackfin: implement syscall restart generically
  frv: implement syscall restart generically
  mips: implement syscall restart generically
  x86: implement syscall restart generically
  m68k: implement syscall restart generically
  ia64: implement syscall restart generically
  tile: implement syscall restart generically

 arch/blackfin/include/asm/syscall.h |   26 +++++++++-
 arch/blackfin/kernel/signal.c       |   47 +-----------------
 arch/frv/include/asm/syscall.h      |   23 ++++++++-
 arch/frv/kernel/signal.c            |   48 +-----------------
 arch/ia64/include/asm/syscall.h     |   21 ++++++++
 arch/ia64/kernel/signal.c           |   54 +--------------------
 arch/m68k/include/asm/syscall.h     |   87 +++++++++++++++++++++++++++++++++
 arch/m68k/kernel/signal_mm.c        |   45 +----------------
 arch/m68k/kernel/signal_no.c        |   46 +----------------
 arch/mips/include/asm/syscall.h     |   91 +++++++++++++++++++++++++++++++++++
 arch/mips/kernel/signal.c           |   40 +--------------
 arch/tile/include/asm/syscall.h     |   28 ++++++++++-
 arch/tile/kernel/signal.c           |   52 ++------------------
 arch/x86/include/asm/syscall.h      |   21 ++++++++
 arch/x86/kernel/signal.c            |   43 +---------------
 include/asm-generic/syscall.h       |   46 +++++++++++++++++-
 include/linux/signal.h              |    3 +
 kernel/signal.c                     |   72 +++++++++++++++++++++++++++-
 18 files changed, 435 insertions(+), 358 deletions(-)
 create mode 100644 arch/m68k/include/asm/syscall.h
 create mode 100644 arch/mips/include/asm/syscall.h

-- 
1.7.5.4

