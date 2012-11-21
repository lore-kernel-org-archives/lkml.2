Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2KUCXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:23:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2KUCXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:23:52 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242699"
Message-ID: <50AC3AA9.7080004@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:21:29 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v5 0/2] x86: vmclear vmcss on all cpus when doing kdump if
 necessary
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:23:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:23:03,
	Serialize complete at 2012/11/21 10:23:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
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
 arch/x86/kernel/crash.c      |   25 ++++++++++++
 arch/x86/kvm/vmx.c           |   85 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 0 deletions(-)
