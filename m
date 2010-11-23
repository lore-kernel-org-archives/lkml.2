Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0KWUmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:42:09 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:10860
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752545Ab0KWUmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:42:03 -0500
X-SpamScore: 0
X-BigFish: VPS0(zz10d1Izz1202hzzz32i668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCCUTX-01-PZU-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <andreas.herrmann3@amd.com>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 0/2] FPU/xsave rework in preparation for LWP
Date: Tue, 23 Nov 2010 21:41:51 +0100
Message-ID: <1290544913-489129-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
References: <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please review and comment on these patches. They are based on tip/master
a17d38493c3dd2253828b107b5d405dd7cdcbf43. The first one is just a generic
cleanup of the xsave code that I already sent couple of weeks ago.


When my previous LWP patchset was reviewed I was told that it would be
much better to use only a single call to xsave and xrstor in the context
switch. This is basically what I try to achieve with the second patch:
base all "extended state" management on xsave/xrstor (with fallback to
fxsave/fxrstor or even fsave/frstor) and keep track of which extended
states a thread actually used. The actual LWP support is not included
here, I will work on this next. 

As a side effect of this rework, there will be a single simple interface
that can be used by other parts of the kernel that need to save and
restore extended states (thinking of KVM here). This should also improve
the general readability and maintainability of this code, although I
would agree that this isn't visible yet :)

There is a lot of room for cleaning things up here, which I will do
along with the LWP support. The LWP changes will require that each
thread will always have a xstate area, but I don't expect this to be
much of a problem. While this would add an overhead of around 1kb for
each thread that wouldn't need a xstate area otherwise, I expect that
there are only very few such threads on any reasonably modern system. I
will have to check that when the LWP support is done. This would allow
for another big cleanup by removing all the complexity of supporting
threads that don't have an xstate area.



Hans Rosenfeld (2):
  x86, xsave: cleanup xsave/xrstor support
  x86, xsave: rework xsave support

 arch/x86/include/asm/i387.h        |  111 +++++++----------------
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/include/asm/xsave.h       |   88 ++++++++-----------
 arch/x86/kernel/i387.c             |   11 ++-
 arch/x86/kernel/process_64.c       |   24 +++---
 arch/x86/kernel/traps.c            |   31 +------
 arch/x86/kernel/xsave.c            |  174 +++++++++++++++++++-----------------
 arch/x86/kvm/x86.c                 |    7 +-
 8 files changed, 188 insertions(+), 260 deletions(-)


