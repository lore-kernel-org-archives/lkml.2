Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0LHAek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:34:40 -0500
Received: from kroah.org ([198.145.64.141]:54816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab0LHAeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:37 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:42 2010
Message-Id: <20101208000642.051994835@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [25/44] acpi-cpufreq: fix a memleak when unloading driver
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit dab5fff14df2cd16eb1ad4c02e83915e1063fece upstream.

We didn't free per_cpu(acfreq_data, cpu)->freq_table
when acpi_freq driver is unloaded.

Resulting in the following messages in /sys/kernel/debug/kmemleak:

unreferenced object 0xf6450e80 (size 64):
  comm "modprobe", pid 1066, jiffies 4294677317 (age 19290.453s)
  hex dump (first 32 bytes):
    00 00 00 00 e8 a2 24 00 01 00 00 00 00 9f 24 00  ......$.......$.
    02 00 00 00 00 6a 18 00 03 00 00 00 00 35 0c 00  .....j.......5..
  backtrace:
    [<c123ba97>] kmemleak_alloc+0x27/0x50
    [<c109f96f>] __kmalloc+0xcf/0x110
    [<f9da97ee>] acpi_cpufreq_cpu_init+0x1ee/0x4e4 [acpi_cpufreq]
    [<c11cd8d2>] cpufreq_add_dev+0x142/0x3a0
    [<c11920b7>] sysdev_driver_register+0x97/0x110
    [<c11cce56>] cpufreq_register_driver+0x86/0x140
    [<f9dad080>] 0xf9dad080
    [<c1001130>] do_one_initcall+0x30/0x160
    [<c10626e9>] sys_init_module+0x99/0x1e0
    [<c1002d97>] sysenter_do_call+0x12/0x26
    [<ffffffff>] 0xffffffff

https://bugzilla.kernel.org/show_bug.cgi?id=15807#c21

Tested-by: Toralf Forster <toralf.foerster@gmx.de>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -742,6 +742,7 @@ static int acpi_cpufreq_cpu_exit(struct
 		per_cpu(drv_data, policy->cpu) = NULL;
 		acpi_processor_unregister_performance(data->acpi_data,
 						      policy->cpu);
+		kfree(data->freq_table);
 		kfree(data);
 	}
 


