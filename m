Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0KXSTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:19:16 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:55623
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab0KXSTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:19:13 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015L10d1Izz1202hzzz32i691h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIUZ-01-37Z-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested Virtualization
Date: Wed, 24 Nov 2010 19:18:26 +0100
Message-ID: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Hi Marcelo,

here is a patch-set to make the instruction emulator aware of nested
virtualization. It basically works by introducing a new callback into
the x86_ops to check if a decoded instruction must be intercepted. If it
is intercepted the instruction emulator returns straight into the guest.

I am not entirely happy with this solution because it partially
duplicates the code in the x86_emulate_insn function. But there are so
many SVM specific cases that need to be taken care of that I consider
this solution the better one (even when looking at the diff-stat).
Keeping this (SVM-specific) complexity in the SVM specific code is
better than extending the generic instruction emulator code path.

The last patch removes the ugly hacks which were required without this
patch-set to correctly handle the selective-cr0-write intercept.

I appreciate your feedback.

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/kvm_emulate.h |    2 +
 arch/x86/include/asm/kvm_host.h    |    3 +
 arch/x86/kvm/svm.c                 |  330 ++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx.c                 |    8 +
 arch/x86/kvm/x86.c                 |    5 +
 5 files changed, 297 insertions(+), 51 deletions(-)

Shortlog:

Joerg Roedel (9):
      KVM: Add infrastructure to emulate instruction intercepts
      KVM: SVM: Add checks for CRx read and write intercepts
      KVM: SVM: Add checks for DRx read and write intercepts
      KVM: SVM: Add intercept checks for descriptor table accesses
      KVM: SVM: Add checks for all group 7 instructions
      KVM: SVM: Add intercept checks for remaining twobyte instructions
      KVM: SVM: Add intercept checks for one-byte instructions
      KVM: SVM: Add checks for IO instructions
      KVM: SVM: Remove nested sel_cr0_write handling code


