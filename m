Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0D0TJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:09:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0D0TJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:09:04 -0400
Date: Tue, 27 Apr 2010 16:09:01 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] export new cpuid KVM_CAP
Message-ID: <20100427190901.GS16166@mothafucka.localdomain>
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
 <1272303988-21929-2-git-send-email-glommer@redhat.com>
 <1272303988-21929-3-git-send-email-glommer@redhat.com>
 <1272303988-21929-4-git-send-email-glommer@redhat.com>
 <1272303988-21929-5-git-send-email-glommer@redhat.com>
 <4BD7291F.6010809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD7291F.6010809@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 09:12:47PM +0300, Avi Kivity wrote:
> On 04/26/2010 08:46 PM, Glauber Costa wrote:
> >Since we're changing the msrs kvmclock uses, we have to communicate
> >that to the guest, through cpuid. We can add a new KVM_CAP to the
> >hypervisor, and then patch userspace to recognize it.
> >
> >And if we ever add a new cpuid bit in the future, we have to do that again,
> >which create some complexity and delay in feature adoption.
> >
> >Instead, what I'm proposing in this patch is a new capability, called
> >KVM_CAP_X86_CPUID_FEATURE_LIST, that returns the current feature list
> >currently supported by the hypervisor. If we ever want to add or remove
> >some feature, we only need to tweak into the HV, leaving userspace untouched.
> >
> >Signed-off-by: Glauber Costa<glommer@redhat.com>
> >---
> >  arch/x86/include/asm/kvm_para.h |    4 ++++
> >  arch/x86/kvm/x86.c              |    6 ++++++
> >  include/linux/kvm.h             |    1 +
> >  3 files changed, 11 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> >index 9734808..f019f8c 100644
> >--- a/arch/x86/include/asm/kvm_para.h
> >+++ b/arch/x86/include/asm/kvm_para.h
> >@@ -16,6 +16,10 @@
> >  #define KVM_FEATURE_CLOCKSOURCE		0
> >  #define KVM_FEATURE_NOP_IO_DELAY	1
> >  #define KVM_FEATURE_MMU_OP		2
> >+/* This indicates that the new set of kvmclock msrs
> >+ * are available. The use of 0x11 and 0x12 is deprecated
> >+ */
> >+#define KVM_FEATURE_CLOCKSOURCE2        3
> 
> Please document this in Documentation/kvm/cpuid.txt (also /msr.txt).
> 
> >
> >  #define MSR_KVM_WALL_CLOCK  0x11
> >  #define MSR_KVM_SYSTEM_TIME 0x12
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index a2ead7f..04f04aa 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -1545,6 +1545,12 @@ int kvm_dev_ioctl_check_extension(long ext)
> >  	case KVM_CAP_MCE:
> >  		r = KVM_MAX_MCE_BANKS;
> >  		break;
> >+	case KVM_CAP_X86_CPUID_FEATURE_LIST:
> >+		r = (1<<  KVM_FEATURE_CLOCKSOURCE) |
> >+		(1<<  KVM_FEATURE_NOP_IO_DELAY) |
> >+		(1<<  KVM_FEATURE_MMU_OP) |
> >+		(1<<  KVM_FEATURE_CLOCKSOURCE2);
> >+		break;
> >  	default:
> >  		r = 0;
> >  		break;
> 
> Hmm.  We already have an API to get cpuid bits:
> KVM_GET_SUPPORTED_CPUID2.  The nice thing about it is that it will
> mean -cpu host will work out of the box.

Ok, from what I understand, KVM_GET_CPUID2 gets a set of features, and tells
userspace which of them are available. Right?

If this is the case, userspace could ask for 0xffffffff, and then we tell them
which of them are present.

Does that make sense?

