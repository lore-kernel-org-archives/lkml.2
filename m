Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1C1Rev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:34:51 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:33574 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754834Ab1C1Reu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:34:50 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: I8JnlU0VM1lmyxQR4k6I97k.IszHD3f2HpRrPEQ4j639KZg
 QeGDsCaNG2f.mCJVPtA2I0kDAX6aMJequVh3.NOkLQ62u7p20oytiURVgLdA
 XLcj.LgAIG2wU6aNQkf1y41sGGhfcrxCzDRodFcCfW8mzMhzGfUzK7KjHaXy
 iccb11rDTs_zaJs17eHvN7F4sDL.PVnvzFiCTzPcvlqerkwiBnbzmh0gqpDC
 KUlFMf4R27jQdvkM2po5fSfpoQSJbDdqRW8j7LPvpox5ymvo4Vl.kDkgi08e
 rVwgqNOo8KST_8E87MqZS95ipILdTDe2A3hRHwb8Xq2grP4ElOc3UPC6QTR4
 qiPfbijUWuxid4UxNzw.tSdxn
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 28 Mar 2011 12:34:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: linux-kernel@vger.kernel.org
Subject: Kernel simply enters cpu_idle() if more than 3 cpus are used in
 kvm
Message-ID: <alpine.DEB.2.00.1103281229460.12567@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel by Linus.

kvm is started using

kvm ~/kvm/qmdr -kernel arch/x86/boot/bzImage -append "root=/dev/hda1
earlyprintk=ttyS0,115200 console=ttyS0,115200 numa=fake=4 $2" --nographic
-m 2048 -smp 3

The above boots fine. However, when I replace -smp 3 with -smp 4 then the
kernel
hangs on boot with all processors in idle state:

(gdb) target remote tcp::1234
Remote debugging using tcp::1234
0xffffffff8102f1c6 in native_safe_halt () at
/home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:49
49		asm volatile("sti; hlt": : :"memory");
(gdb) thread apply all bt
[New Thread 2]
[New Thread 3]
[New Thread 4]

Thread 4 (Thread 4):
#0  0xffffffff8102f1c6 in native_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:49
#1  arch_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:90
#2  default_idle () at arch/x86/kernel/process.c:388
#3  0xffffffff810288a6 in cpu_idle () at arch/x86/kernel/process_64.c:139
#4  0xffffffff81cc19ee in start_secondary (unused=<value optimized out>)
at arch/x86/kernel/smpboot.c:297
#5  0x0000000000000000 in ?? ()

Thread 3 (Thread 3):
#0  0xffffffff8102f1c6 in native_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:49
#1  arch_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:90
#2  default_idle () at arch/x86/kernel/process.c:388
#3  0xffffffff810288a6 in cpu_idle () at arch/x86/kernel/process_64.c:139
#4  0xffffffff81cc19ee in start_secondary (unused=<value optimized out>) at arch/x86/kernel/smpboot.c:297
#5  0x0000000000000000 in ?? ()

Thread 2 (Thread 2):
#0  0xffffffff8102f1c6 in native_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:49
#1  arch_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:90
#2  default_idle () at arch/x86/kernel/process.c:388
#3  0xffffffff810288a6 in cpu_idle () at arch/x86/kernel/process_64.c:139
#4  0xffffffff81cc19ee in start_secondary (unused=<value optimized out>)
at arch/x86/kernel/smpboot.c:297
#5  0x0000000000000000 in ?? ()

Thread 1 (Thread 1):
#0  0xffffffff8102f1c6 in native_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:49
#1  arch_safe_halt () at /home/christoph/n/linux-2.6/arch/x86/include/asm/irqflags.h:90
#2  default_idle () at arch/x86/kernel/process.c:388
#3  0xffffffff810288a6 in cpu_idle () at arch/x86/kernel/process_64.c:139
#4  0xffffffff814d39be in rest_init () at init/main.c:375
#5  0xffffffff81c8cb99 in start_kernel () at init/main.c:625
#6  0xffffffff81c8c2a8 in x86_64_start_reservations (real_mode_data=<value optimized out>) at arch/x86/kernel/head64.c:124
#7  0xffffffff81c8c399 in x86_64_start_kernel (real_mode_data=0x13740 <Address 0x13740 out of bounds>) at arch/x86/kernel/head64.c:94
#8  0x0000000000000000 in ?? ()
(gdb)

