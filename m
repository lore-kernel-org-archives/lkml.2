Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2KUPYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:24:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2KUPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:24:11 -0500
Message-ID: <50ACF210.5020802@gmail.com>
Date: Wed, 21 Nov 2012 23:24:00 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, mtosatti@redhat.com,
        Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        zhangyanfei@cn.fujitsu.com
Subject: [PATCH v6 0/2] x86: vmclear vmcss on all cpus when doing kdump if
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
  x86/kexec: VMCLEAR vmcss on all cpus if necessary
  KVM-INTEL: add a notifier and a bitmap to support VMCLEAR in kdump

 arch/x86/include/asm/kexec.h |    2 +
 arch/x86/kernel/crash.c      |   25 +++++++++++++
 arch/x86/kvm/vmx.c           |   77 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 103 insertions(+), 1 deletions(-)
