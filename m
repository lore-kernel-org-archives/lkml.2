Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293Ab2JSQ4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab2JSQ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:56:15 -0400
From: David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 0/5] tools, perf: Fix up for x86 UAPI disintegration
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net
Cc: dhowells@redhat.com, davem@davemloft.net, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 19 Oct 2012 17:55:58 +0100
Message-ID: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are some potential fix ups for perf and other tools.  They need to be
applied on top of the x86 UAPI disintegration patch.

There are five patches:

 (1) Use a makefile $(call ...) function in tools/Makefile to make it easier
     to deal with.

     [NOTE!  I think the rule for selftests_install is wrong since it attempts
      to discard '_clean' from the end of the target name instead of
      '_install']

 (2) Fix handling of O= with a relative path when doing something like:

	make tools/perf O=foo

     from the top-level directory in the kernel source tree for all tools.

 (3) Make perf work for x86 by adding -I flags and changing long #includes
     with "../../include" in them into short <asm/foo.h> type things.

Now there are two patches that I'm not sure whether you want.  There are three
header files with bits used by perf that are not in the UAPI.  If these are
disintegrated then perf does not need to look in any KAPI headers at all and
the -I flag pointing there can be dropped after the first of these patches.

 (4) UAPI disintegrate asm/svm.h and asm/vmx.h.

 (5) UAPI disintegrate asm/perf_regs.h and convert a "../../include" style
     path into <asm/perf_regs.h>.

I'm not sure whether these should be exported to userspace, though this commit:

	commit 26bf264e871a4b9a8ac09c21a2b518e7f23830d5
	Author: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
	Date:   Mon Sep 17 16:31:13 2012 +0800
	KVM: x86: Export svm/vmx exit code and vector code to userspace

suggests that at least the first two should be - though since it didn't modify
Kbuild, this was not effective.

I haven't tried building perf for other arches at this time.

David
---
David Howells (5):
      x86: UAPI Disintegrate asm/perf_regs.h
      x86: Disintegrate asm/svm.h and asm/vmx.h to produce UAPI components for perf
      perf: Make perf build for x86 with UAPI disintegration applied
      tools: Honour the O= flag when tool build called from a higher Makefile
      tools: Define a Makefile function to do subdir processing


 Makefile                                |    6 +
 arch/x86/include/asm/perf_regs.h        |   33 --------
 arch/x86/include/asm/svm.h              |  133 -------------------------------
 arch/x86/include/asm/vmx.h              |   87 --------------------
 arch/x86/include/uapi/asm/perf_regs.h   |   33 ++++++++
 arch/x86/include/uapi/asm/svm.h         |  131 +++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/vmx.h         |  108 +++++++++++++++++++++++++
 tools/Makefile                          |   24 +++---
 tools/perf/Makefile                     |   15 +++
 tools/perf/arch/x86/include/perf_regs.h |    2 
 tools/perf/builtin-kvm.c                |    6 +
 tools/perf/perf.h                       |   16 +---
 tools/scripts/Makefile.include          |   18 ++++
 13 files changed, 329 insertions(+), 283 deletions(-)
 delete mode 100644 arch/x86/include/asm/perf_regs.h
 create mode 100644 arch/x86/include/uapi/asm/perf_regs.h
 create mode 100644 arch/x86/include/uapi/asm/svm.h
 create mode 100644 arch/x86/include/uapi/asm/vmx.h

