Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2LFPg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:36:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55782 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2LFPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:36:58 -0500
Message-ID: <50C0BB90.1080804@gmail.com>
Date: Thu, 06 Dec 2012 23:36:48 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: kexec@lists.infradead.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 0/2] x86: vmclear vmcss on all cpus when doing kdump if
 necessary
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kdump just makes all the logical processors leave VMX operation by
executing VMXOFF instruction, so any VMCSs active on the logical processors may
be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
executing the VMXOFF instruction.

The patch set provides a way to VMCLEAR vmcss related to guests on all cpus before
executing the VMXOFF when doing kdump. This is used to ensure the VMCSs in the
vmcore updated and non-corrupted.

Changelog from v10 to v11:
1. regenerate the patch set against current queue branch in
   git://git.kernel.org/pub/scm/virt/kvm/kvm.git

Changelog from v9 to v10:
1. add rcu protect to the callback function

Changelog from v8 to v9:
1. KEXEC: use a callback function instead of a notifier.
2. KVM-INTEL: use a new vmclear function instead of just calling 
   vmclear_local_loaded_vmcss to make sure we just do the core vmclear
   operation in kdump.

Changelog from v7 to v8:
1. KEXEC: regression for using name crash_notifier_list
   and remove comments related to KVM
   and just call function atomic_notifier_call_chain directly.

Changelog from v6 to v7:
1. KVM-INTEL: in hardware_disable, we needn't disable the
   vmclear, so remove it.

Changelog from v5 to v6:
1. KEXEC: the atomic notifier list renamed:
   crash_notifier_list --> vmclear_notifier_list
2. KVM-INTEL: provide empty functions if CONFIG_KEXEC is
   not defined and remove unnecessary #ifdef's.

Changelog from v4 to v5:
1. use an atomic notifier instead of function call, so
   have all the vmclear codes in vmx.c.

Changelog from v3 to v4:
1. add a new percpu variable vmclear_skipped to skip
   vmclear in kdump in some conditions.

Changelog from v2 to v3:
1. remove unnecessary conditions in function
   cpu_emergency_clear_loaded_vmcss as Marcelo suggested.

Changelog from v1 to v2:
1. remove the sysctl and clear VMCSs unconditionally.

Zhang Yanfei (2):
  x86/kexec: VMCLEAR VMCSs loaded on all cpus if necessary
  KVM-INTEL: provide the vmclear function and a bitmap to support
    VMCLEAR in kdump

 arch/x86/include/asm/kexec.h |    2 + 
 arch/x86/kernel/crash.c      |   32 ++++++++++++++++++++
 arch/x86/kvm/vmx.c           |   67 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 0 deletions(-)
