Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1AXSHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:07:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab1AXSHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:07:53 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: [PATCH 00/16] New Proposal for steal time in KVM
Date: Mon, 24 Jan 2011 13:06:21 -0500
Message-Id: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello people

This is the new version of the steal time series, this time on steroids.
The steal time per se is not much different from the last time I posted, so
I'll highlight what's around it.

Since one of the main fights was around how to register the shared memory area,
which would end up with a new MSR, I decided to provide an MSR to end all MSR
allocations. This patchset contains a generic GuestKernel-to-Hypervisor memory
registering, that can be further used and abused without too much hassle, even by
letting userspace handle what the hypervisor won't - think of feature emulation in
older hosts, or any other thing.

To demonstrate that, and how it works, I ported kvmclock to this infrastructure.
After that, I used it to implement steal time information exchange.

Even our last discussions, I am keeping the steal time accounting in sched.c.
I still see value on that, as opposed to a lower level, because it will give us
easier access to the scheduler variables, such as the cpu runqueue.

The last patch in the series uses this to decrease CPU power according to the
current steal time information, leading to a possibly more smart scheduling.
This, in particular, is very early work, and advise on that - including "Stop now,
you idiot!" is very welcome.

TODO:
 * Handle unregister over reboots
 * Grab a list of current registrations, for migration
 * Write documentation
 * Check size in hv registerings, to prevent out of boundaries
   exploits


Glauber Costa (16):
  KVM-HDR: register KVM basic header infrastructure
  KVM-HV: KVM - KVM Virtual Memory hypervisor implementation
  KVM-HDR: KVM Userspace registering ioctl
  KVM-HV: KVM Userspace registering ioctl
  KVM-HDR: Implement wallclock over KVM - KVM Virtual Memory
  KVM-HDR: Implement wallclock over KVM - KVM Virtual Memory
  KVM-GST: Implement wallclock over KVM - KVM Virtual Memory
  KVM-HDR: Implement kvmclock systemtime over KVM - KVM Virtual Memory
  KVM-HV: Implement kvmclock systemtime over KVM - KVM Virtual Memory
  KVM-GST: Implement kvmclock systemtime over KVM - KVM Virtual Memory
  KVM-HDR: KVM Steal time implementation
  KVM-HV: KVM Steal time implementation
  KVM-HV: KVM Steal time calculation
  KVM-GST: KVM Steal time registration
  KVM-GST: KVM Steal time accounting
  KVM-GST: adjust scheduler cpu power

 arch/x86/include/asm/kvm_host.h |    3 +
 arch/x86/include/asm/kvm_para.h |   19 +++++++
 arch/x86/kernel/kvmclock.c      |  104 +++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm.c              |    4 ++
 arch/x86/kvm/vmx.c              |    4 ++
 arch/x86/kvm/x86.c              |   99 +++++++++++++++++++++++++++++--------
 include/linux/kvm.h             |   14 +++++-
 include/linux/kvm_host.h        |    1 +
 include/linux/sched.h           |    1 +
 kernel/sched.c                  |   44 ++++++++++++++++
 kernel/sched_fair.c             |   10 ++++
 11 files changed, 268 insertions(+), 35 deletions(-)

-- 
1.7.2.3

