Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971Ab2DKBkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:40:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab2DKBkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:40:04 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4725182"
Message-ID: <4F84E0DF.8040206@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 09:39:43 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: avi@redhat.com, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, joerg.roedel@amd.com,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 0/4] Export offsets of VMCS fields as note information for
 kdump
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:39:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:39:29,
	Serialize complete at 2012/04/11 09:39:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set exports offsets of VMCS fields as note information for
kdump. We call it VMCSINFO. The purpose of VMCSINFO is to retrieve
runtime state of guest machine image, such as registers, in host
machine's crash dump as VMCS format. The problem is that VMCS
internal is hidden by Intel in its specification. So, we reverse
engineering it in the way implemented in this patch set. Please note
that this processing never affects any existing kvm logic. The
VMCSINFO is exported via sysfs to kexec-tools just like VMCOREINFO.

Here is an example:
Processor: Intel(R) Core(TM)2 Duo CPU     E7500  @ 2.93GHz

$cat /sys/kernel/vmcsinfo
1cba8c0 2000

crash> rd -p 1cba8c0 1000
         1cba8c0:  0000127b00000009 53434d5600000000   ....{.......VMCS
         1cba8d0:  000000004f464e49 4e4f495349564552   INFO....REVISION
         1cba8e0:  49460a643d44495f 5f4e495028444c45   _ID=d.FIELD(PIN_
         1cba8f0:  4d565f4445534142 4f435f434558455f   BASED_VM_EXEC_CO
         1cba900:  303d294c4f52544e 0a30383130343831   NTROL)=01840180.
         1cba910:  504328444c454946 5f44455341425f55   FIELD(CPU_BASED_
         1cba920:  5f434558455f4d56 294c4f52544e4f43   VM_EXEC_CONTROL)
         1cba930:  393130343931303d 28444c4549460a30   =01940190.FIELD(
         1cba940:  5241444e4f434553 4558455f4d565f59   SECONDARY_VM_EXE
         1cba950:  4f52544e4f435f43 30346566303d294c   C_CONTROL)=0fe40
         1cba960:  4c4549460a306566 4958455f4d562844   fe0.FIELD(VM_EXI
         1cba970:  4f52544e4f435f54 346531303d29534c   T_CONTROLS)=01e4
         1cba980:  4549460a30653130 4e455f4d5628444c   01e0.FIELD(VM_EN
         1cba990:  544e4f435f595254 33303d29534c4f52   TRY_CONTROLS)=03
         1cba9a0:  460a303133303431 45554728444c4549   140310.FIELD(GUE
         1cba9b0:  45535f53455f5453 3d29524f5443454c   ST_ES_SELECTOR)=
         1cba9c0:  4549460a30303530 545345554728444c   0500.FIELD(GUEST
         1cba9d0:  454c45535f53435f 35303d29524f5443   _CS_SELECTOR)=05
         ......

TODO:
  1. In kexec-tools, get VMCSINFO via sysfs and dump it as note information
     into vmcore.
  2. Dump VMCS region of each guest vcpu and VMCSINFO into qemu-process
     core file. To do this, we will modify kernel core dumper, gdb gcore
     and crash gcore.
  3. Dump guest image from the qemu-process core file into a vmcore.

zhangyanfei (4):
  x86: Add helper variables and functions to hold VMCSINFO
  KVM: VMX: Add functions to fill VMCSINFO
  ksysfs: export VMCSINFO via sysfs
  kexec: Add crash_save_vmcsinfo to update VMCSINFO

 arch/x86/include/asm/vmcsinfo.h |   42 +++++
 arch/x86/kernel/Makefile        |    2 +
 arch/x86/kernel/vmcsinfo.c      |   70 ++++++++
 arch/x86/kvm/vmx.c              |  350 +++++++++++++++++++++++++++++++++++++++
 include/linux/kexec.h           |    1 +
 kernel/kexec.c                  |   14 ++
 kernel/ksysfs.c                 |   19 ++
 7 files changed, 498 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/vmcsinfo.h
 create mode 100644 arch/x86/kernel/vmcsinfo.c
