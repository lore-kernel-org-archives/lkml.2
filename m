Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2JPEfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:35:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48415 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab2JPEfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:35:20 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, vgoyal@redhat.com, ebiederm@xmission.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        d.hatayama@jp.fujitsu.com
Date: Tue, 16 Oct 2012 13:35:17 +0900
Message-ID: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple CPUs are useful for CPU-bound processing like compression and
I do want to use compression to generate crash dump quickly. But now
we cannot wakeup the 2nd and later cpus in the kdump 2nd kernel if
crash happens on AP. If crash happens on AP, kexec enters the 2nd
kernel with the AP, and there BSP in the 1st kernel is expected to be
haling in the 1st kernel or possibly in any fatal system error state.

To wake up AP, we use the method called INIT-INIT-SIPI. INIT causes
BSP to jump into BIOS init code. A typical visible behaviour is hang
or immediate reset, depending on the BIOS init code.

AP can be initiated by INIT even in a fatal state: MP spec explains
that processor-specific INIT can be used to recover AP from a fatal
system error. On the other hand, there's no method for BSP to recover;
it might be possible to do so by NMI plus any hand-coded reset code
that is carefully designed, but at least I have no idea in this
direction now.

Therefore, the idea I do in this patch set is simply to disable BSP if
vboot cpu is AP.

My motivation is to use multiple CPUs in order to quickly generate
crash dump on the machine with huge amount of memory. I assume such
machine tends to also have a lot of CPUs. So disabling one CPU would
be no problem.

On most BIOSs, BSP is always assigned to cpu#1; on other BIOSs, BSP
could probably be assigned to a fixed cpu number. Assuming this fact,
it might be possible to choose an idea that waking up the cpus except
for cpu#1, not waking up cpu#1 only. But I don't choose this in this
patch set because:

- It's ugly desgin to keep switch in sysfs that can unintentionally
  cause system to enter undefined behaviour.

- Memory space for BSP is never used if BSP is not running. Amount of
  reserved memory for 2nd kernel is typically from 128MB to 512MB
  only, severely limited. If BSP is unused, I want to use the space
  for another AP instead.

Note: recent upstream kernel fails reserving memory for kdump 2nd
kernel. To run kdump, please apply the patch below on top of this
patch set:
https://lkml.org/lkml/2012/8/31/238

---

HATAYAMA Daisuke (2):
      x86, apic: Disable BSP if boot cpu is AP
      x86, apic: Introduce boot_cpu_is_bsp indicating whether boot cpu is BSP or not


 arch/x86/include/asm/mpspec.h |    5 ++++-
 arch/x86/kernel/acpi/boot.c   |   10 +++++++++-
 arch/x86/kernel/apic/apic.c   |   34 +++++++++++++++++++++++++++++++++-
 arch/x86/kernel/devicetree.c  |    2 +-
 arch/x86/kernel/mpparse.c     |   15 +++++++++++++--
 arch/x86/kernel/setup.c       |    2 ++
 arch/x86/platform/sfi/sfi.c   |    2 +-
 7 files changed, 63 insertions(+), 7 deletions(-)

-- 
Thanks.
HATAYAMA, Daisuke
