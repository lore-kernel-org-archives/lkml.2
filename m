Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2HGDFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:05:34 -0400
Received: from zougloub.eu ([188.165.233.99]:37354 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab2HGDFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:05:32 -0400
Date: Mon, 6 Aug 2012 23:06:29 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Ingo Molnar" <mingo@kernel.org>,
        "Matt Fleming" <matt.fleming@linux.intel.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
Message-ID: <20120806230629.153d33bd@zougloub.eu>
In-Reply-To: <20120806223208.5301be0d@zougloub.eu>
References: <20120805172903.5f8bb24c@zougloub.eu>
	<501EF3A2.20200@zytor.com>
	<501F83F20200007800092C1C@nat28.tlf.novell.com>
	<20120806125216.GA11863@srcf.ucam.org>
	<501FDDD30200007800092DDE@nat28.tlf.novell.com>
	<20120806091627.2ad5ed2e@zougloub.eu>
	<20120806223208.5301be0d@zougloub.eu>
Organization: none
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012 22:32:08 -0400
Jérôme Carretero <cJ-ko@zougloub.eu> wrote:

> For troubleshooting purposes I edited over your patch.
> So far:
> [...]
> Maybe I can get more...

With the following:

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..46729f3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -97,8 +97,9 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
        unsigned long flags;
        efi_status_t status;
 
+       printk("%s: get_time=0x%p\n", __func__, efi.systab->runtime->get_time);
        spin_lock_irqsave(&rtc_lock, flags);
-       status = efi_call_virt2(get_time, tm, tc);
+       status = EFI_SUCCESS + 1;// efi_call_virt2(get_time, tm, tc);
        spin_unlock_irqrestore(&rtc_lock, flags);
        return status;
 }
@@ -270,8 +271,10 @@ static unsigned long efi_get_time(void)
        efi_time_cap_t cap;
 
        status = efi.get_time(&eft, &cap);
-       if (status != EFI_SUCCESS)
-               pr_err("Oops: efitime: can't read time!\n");
+       if (status != EFI_SUCCESS) {
+               /* fall back to RTC time */
+               return mach_get_cmos_time();
+       }
 
        return mktime(eft.year, eft.month, eft.day, eft.hour,
                      eft.minute, eft.second);

The system boots, at that point... I would say my BIOS is broken,
but it can be expected that others can have the same issue.

-- 
cJ

PS: Here's the log until the printk

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1-Bidule-00133-g42a579a-dirty (cJ@Bidule) (gcc version 4.7.1 (Gentoo 4.7.1 p1.0, pie-0.5.3) ) #30 SMP PREEMPT Mon Aug 6 22:53:47 EDT 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda3 video=efifb printk.time=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bd831fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd832000-0x00000000bd884fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd885000-0x00000000bd88ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd890000-0x00000000bdadbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdadc000-0x00000000bdaecfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdaed000-0x00000000bdafffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdb00000-0x00000000bdb01fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdb02000-0x00000000bdb0afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdb0b000-0x00000000bdb10fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdb11000-0x00000000bdb72fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdb73000-0x00000000bdd75fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdd76000-0x00000000bdefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000043effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.00 by American Megatrends
[    0.000000] efi:  SMBIOS=0xbdb71818  ACPI=0xbd885000  ACPI 2.0=0xbd885000 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x000000000004f000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x000000000004f000-0x0000000000060000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x0000000000060000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] efi: mem06: type=4, attr=0xf, range=[0x0000000001100000-0x000000000170d000) (6MB)
[    0.000000] efi: mem07: type=3, attr=0xf, range=[0x000000000170d000-0x0000000001713000) (0MB)
[    0.000000] efi: mem08: type=4, attr=0xf, range=[0x0000000001713000-0x0000000001729000) (0MB)
[    0.000000] efi: mem09: type=3, attr=0xf, range=[0x0000000001729000-0x000000000172c000) (0MB)
[    0.000000] efi: mem10: type=4, attr=0xf, range=[0x000000000172c000-0x000000000172d000) (0MB)
[    0.000000] efi: mem11: type=3, attr=0xf, range=[0x000000000172d000-0x000000000172e000) (0MB)
[    0.000000] efi: mem12: type=4, attr=0xf, range=[0x000000000172e000-0x0000000001794000) (0MB)
[    0.000000] efi: mem13: type=3, attr=0xf, range=[0x0000000001794000-0x000000000179e000) (0MB)
[    0.000000] efi: mem14: type=4, attr=0xf, range=[0x000000000179e000-0x00000000017a1000) (0MB)
[    0.000000] efi: mem15: type=3, attr=0xf, range=[0x00000000017a1000-0x00000000017a4000) (0MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x00000000017a4000-0x00000000017a5000) (0MB)
[    0.000000] efi: mem17: type=3, attr=0xf, range=[0x00000000017a5000-0x00000000017b1000) (0MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000017b1000-0x00000000017b3000) (0MB)
[    0.000000] efi: mem19: type=3, attr=0xf, range=[0x00000000017b3000-0x00000000017b5000) (0MB)
[    0.000000] efi: mem20: type=4, attr=0xf, range=[0x00000000017b5000-0x00000000017bb000) (0MB)
[    0.000000] efi: mem21: type=3, attr=0xf, range=[0x00000000017bb000-0x00000000017be000) (0MB)
[    0.000000] efi: mem22: type=4, attr=0xf, range=[0x00000000017be000-0x00000000017c2000) (0MB)
[    0.000000] efi: mem23: type=3, attr=0xf, range=[0x00000000017c2000-0x00000000017c4000) (0MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x00000000017c4000-0x00000000017c9000) (0MB)
[    0.000000] efi: mem25: type=3, attr=0xf, range=[0x00000000017c9000-0x00000000017ca000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x00000000017ca000-0x00000000017d3000) (0MB)
[    0.000000] efi: mem27: type=3, attr=0xf, range=[0x00000000017d3000-0x00000000017d6000) (0MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x00000000017d6000-0x0000000001bec000) (4MB)
[    0.000000] efi: mem29: type=3, attr=0xf, range=[0x0000000001bec000-0x0000000001bed000) (0MB)
[    0.000000] efi: mem30: type=4, attr=0xf, range=[0x0000000001bed000-0x0000000001bf1000) (0MB)
[    0.000000] efi: mem31: type=3, attr=0xf, range=[0x0000000001bf1000-0x0000000001bf3000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x0000000001bf3000-0x0000000001bf5000) (0MB)
[    0.000000] efi: mem33: type=3, attr=0xf, range=[0x0000000001bf5000-0x0000000001bf8000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x0000000001bf8000-0x0000000001c14000) (0MB)
[    0.000000] efi: mem35: type=3, attr=0xf, range=[0x0000000001c14000-0x0000000001c1c000) (0MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x0000000001c1c000-0x0000000001c1f000) (0MB)
[    0.000000] efi: mem37: type=3, attr=0xf, range=[0x0000000001c1f000-0x0000000001c22000) (0MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x0000000001c22000-0x0000000001c2c000) (0MB)
[    0.000000] efi: mem39: type=3, attr=0xf, range=[0x0000000001c2c000-0x0000000001c31000) (0MB)
[    0.000000] efi: mem40: type=4, attr=0xf, range=[0x0000000001c31000-0x0000000001c41000) (0MB)
[    0.000000] efi: mem41: type=3, attr=0xf, range=[0x0000000001c41000-0x0000000001c49000) (0MB)
[    0.000000] efi: mem42: type=4, attr=0xf, range=[0x0000000001c49000-0x0000000001c51000) (0MB)
[    0.000000] efi: mem43: type=3, attr=0xf, range=[0x0000000001c51000-0x0000000001c52000) (0MB)
[    0.000000] efi: mem44: type=4, attr=0xf, range=[0x0000000001c52000-0x0000000001c8c000) (0MB)
[    0.000000] efi: mem45: type=3, attr=0xf, range=[0x0000000001c8c000-0x0000000001c90000) (0MB)
[    0.000000] efi: mem46: type=4, attr=0xf, range=[0x0000000001c90000-0x0000000001c93000) (0MB)
[    0.000000] efi: mem47: type=3, attr=0xf, range=[0x0000000001c93000-0x0000000001cb2000) (0MB)
[    0.000000] efi: mem48: type=4, attr=0xf, range=[0x0000000001cb2000-0x0000000001cc2000) (0MB)
[    0.000000] efi: mem49: type=3, attr=0xf, range=[0x0000000001cc2000-0x0000000001cda000) (0MB)
[    0.000000] efi: mem50: type=4, attr=0xf, range=[0x0000000001cda000-0x0000000001ce1000) (0MB)
[    0.000000] efi: mem51: type=3, attr=0xf, range=[0x0000000001ce1000-0x0000000001cea000) (0MB)
[    0.000000] efi: mem52: type=4, attr=0xf, range=[0x0000000001cea000-0x0000000001cef000) (0MB)
[    0.000000] efi: mem53: type=3, attr=0xf, range=[0x0000000001cef000-0x0000000001cf7000) (0MB)
[    0.000000] efi: mem54: type=4, attr=0xf, range=[0x0000000001cf7000-0x0000000001cf8000) (0MB)
[    0.000000] efi: mem55: type=3, attr=0xf, range=[0x0000000001cf8000-0x0000000001cfa000) (0MB)
[    0.000000] efi: mem56: type=4, attr=0xf, range=[0x0000000001cfa000-0x0000000001cfe000) (0MB)
[    0.000000] efi: mem57: type=3, attr=0xf, range=[0x0000000001cfe000-0x0000000001d00000) (0MB)
[    0.000000] efi: mem58: type=4, attr=0xf, range=[0x0000000001d00000-0x0000000001d02000) (0MB)
[    0.000000] efi: mem59: type=3, attr=0xf, range=[0x0000000001d02000-0x0000000001d04000) (0MB)
[    0.000000] efi: mem60: type=4, attr=0xf, range=[0x0000000001d04000-0x0000000001d0f000) (0MB)
[    0.000000] efi: mem61: type=3, attr=0xf, range=[0x0000000001d0f000-0x0000000001d19000) (0MB)
[    0.000000] efi: mem62: type=4, attr=0xf, range=[0x0000000001d19000-0x0000000001d1e000) (0MB)
[    0.000000] efi: mem63: type=3, attr=0xf, range=[0x0000000001d1e000-0x0000000001d26000) (0MB)
[    0.000000] efi: mem64: type=4, attr=0xf, range=[0x0000000001d26000-0x0000000001d32000) (0MB)
[    0.000000] efi: mem65: type=3, attr=0xf, range=[0x0000000001d32000-0x0000000001d45000) (0MB)
[    0.000000] efi: mem66: type=4, attr=0xf, range=[0x0000000001d45000-0x0000000001d7c000) (0MB)
[    0.000000] efi: mem67: type=3, attr=0xf, range=[0x0000000001d7c000-0x0000000001d86000) (0MB)
[    0.000000] efi: mem68: type=4, attr=0xf, range=[0x0000000001d86000-0x0000000001d87000) (0MB)
[    0.000000] efi: mem69: type=3, attr=0xf, range=[0x0000000001d87000-0x0000000001d8b000) (0MB)
[    0.000000] efi: mem70: type=4, attr=0xf, range=[0x0000000001d8b000-0x0000000001d8c000) (0MB)
[    0.000000] efi: mem71: type=3, attr=0xf, range=[0x0000000001d8c000-0x0000000001d8f000) (0MB)
[    0.000000] efi: mem72: type=4, attr=0xf, range=[0x0000000001d8f000-0x0000000001d90000) (0MB)
[    0.000000] efi: mem73: type=3, attr=0xf, range=[0x0000000001d90000-0x0000000001d93000) (0MB)
[    0.000000] efi: mem74: type=4, attr=0xf, range=[0x0000000001d93000-0x0000000001d94000) (0MB)
[    0.000000] efi: mem75: type=3, attr=0xf, range=[0x0000000001d94000-0x0000000001dc4000) (0MB)
[    0.000000] efi: mem76: type=4, attr=0xf, range=[0x0000000001dc4000-0x0000000001ddc000) (0MB)
[    0.000000] efi: mem77: type=3, attr=0xf, range=[0x0000000001ddc000-0x0000000001de2000) (0MB)
[    0.000000] efi: mem78: type=4, attr=0xf, range=[0x0000000001de2000-0x0000000001dee000) (0MB)
[    0.000000] efi: mem79: type=3, attr=0xf, range=[0x0000000001dee000-0x0000000001df1000) (0MB)
[    0.000000] efi: mem80: type=4, attr=0xf, range=[0x0000000001df1000-0x0000000001df3000) (0MB)
[    0.000000] efi: mem81: type=3, attr=0xf, range=[0x0000000001df3000-0x0000000001e06000) (0MB)
[    0.000000] efi: mem82: type=4, attr=0xf, range=[0x0000000001e06000-0x0000000001eb2000) (0MB)
[    0.000000] efi: mem83: type=3, attr=0xf, range=[0x0000000001eb2000-0x0000000001eb8000) (0MB)
[    0.000000] efi: mem84: type=4, attr=0xf, range=[0x0000000001eb8000-0x0000000001ebe000) (0MB)
[    0.000000] efi: mem85: type=3, attr=0xf, range=[0x0000000001ebe000-0x0000000001ec1000) (0MB)
[    0.000000] efi: mem86: type=4, attr=0xf, range=[0x0000000001ec1000-0x0000000001ecb000) (0MB)
[    0.000000] efi: mem87: type=3, attr=0xf, range=[0x0000000001ecb000-0x0000000001ed0000) (0MB)
[    0.000000] efi: mem88: type=4, attr=0xf, range=[0x0000000001ed0000-0x0000000001ed4000) (0MB)
[    0.000000] efi: mem89: type=3, attr=0xf, range=[0x0000000001ed4000-0x0000000001eda000) (0MB)
[    0.000000] efi: mem90: type=4, attr=0xf, range=[0x0000000001eda000-0x0000000001edc000) (0MB)
[    0.000000] efi: mem91: type=3, attr=0xf, range=[0x0000000001edc000-0x0000000001ede000) (0MB)
[    0.000000] efi: mem92: type=4, attr=0xf, range=[0x0000000001ede000-0x0000000001ee1000) (0MB)
[    0.000000] efi: mem93: type=3, attr=0xf, range=[0x0000000001ee1000-0x0000000001ee3000) (0MB)
[    0.000000] efi: mem94: type=4, attr=0xf, range=[0x0000000001ee3000-0x0000000001f07000) (0MB)
[    0.000000] efi: mem95: type=3, attr=0xf, range=[0x0000000001f07000-0x0000000001f1b000) (0MB)
[    0.000000] efi: mem96: type=4, attr=0xf, range=[0x0000000001f1b000-0x0000000001f24000) (0MB)
[    0.000000] efi: mem97: type=3, attr=0xf, range=[0x0000000001f24000-0x0000000001f33000) (0MB)
[    0.000000] efi: mem98: type=4, attr=0xf, range=[0x0000000001f33000-0x0000000001f38000) (0MB)
[    0.000000] efi: mem99: type=3, attr=0xf, range=[0x0000000001f38000-0x0000000001f3f000) (0MB)
[    0.000000] efi: mem100: type=4, attr=0xf, range=[0x0000000001f3f000-0x0000000001f42000) (0MB)
[    0.000000] efi: mem101: type=3, attr=0xf, range=[0x0000000001f42000-0x0000000001f44000) (0MB)
[    0.000000] efi: mem102: type=4, attr=0xf, range=[0x0000000001f44000-0x0000000001f60000) (0MB)
[    0.000000] efi: mem103: type=3, attr=0xf, range=[0x0000000001f60000-0x0000000001f64000) (0MB)
[    0.000000] efi: mem104: type=4, attr=0xf, range=[0x0000000001f64000-0x0000000001f69000) (0MB)
[    0.000000] efi: mem105: type=3, attr=0xf, range=[0x0000000001f69000-0x0000000001f7a000) (0MB)
[    0.000000] efi: mem106: type=4, attr=0xf, range=[0x0000000001f7a000-0x0000000001fdb000) (0MB)
[    0.000000] efi: mem107: type=7, attr=0xf, range=[0x0000000001fdb000-0x0000000001fe0000) (0MB)
[    0.000000] efi: mem108: type=4, attr=0xf, range=[0x0000000001fe0000-0x0000000001ffe000) (0MB)
[    0.000000] efi: mem109: type=3, attr=0xf, range=[0x0000000001ffe000-0x0000000002412000) (4MB)
[    0.000000] efi: mem110: type=4, attr=0xf, range=[0x0000000002412000-0x0000000002911000) (4MB)
[    0.000000] efi: mem111: type=3, attr=0xf, range=[0x0000000002911000-0x0000000002912000) (0MB)
[    0.000000] efi: mem112: type=4, attr=0xf, range=[0x0000000002912000-0x000000000293d000) (0MB)
[    0.000000] efi: mem113: type=3, attr=0xf, range=[0x000000000293d000-0x000000000293f000) (0MB)
[    0.000000] efi: mem114: type=4, attr=0xf, range=[0x000000000293f000-0x0000000002941000) (0MB)
[    0.000000] efi: mem115: type=7, attr=0xf, range=[0x0000000002941000-0x0000000002942000) (0MB)
[    0.000000] efi: mem116: type=3, attr=0xf, range=[0x0000000002942000-0x0000000002960000) (0MB)
[    0.000000] efi: mem117: type=4, attr=0xf, range=[0x0000000002960000-0x0000000002965000) (0MB)
[    0.000000] efi: mem118: type=7, attr=0xf, range=[0x0000000002965000-0x0000000002982000) (0MB)
[    0.000000] efi: mem119: type=1, attr=0xf, range=[0x0000000002982000-0x000000000299f000) (0MB)
[    0.000000] efi: mem120: type=7, attr=0xf, range=[0x000000000299f000-0x00000000029e8000) (0MB)
[    0.000000] efi: mem121: type=4, attr=0xf, range=[0x00000000029e8000-0x0000000002d62000) (3MB)
[    0.000000] efi: mem122: type=2, attr=0xf, range=[0x0000000002d62000-0x0000000003ce9000) (15MB)
[    0.000000] efi: mem123: type=7, attr=0xf, range=[0x0000000003ce9000-0x0000000004000000) (3MB)
[    0.000000] efi: mem124: type=2, attr=0xf, range=[0x0000000004000000-0x0000000004f87000) (15MB)
[    0.000000] efi: mem125: type=7, attr=0xf, range=[0x0000000004f87000-0x000000008e9a4000) (2202MB)
[    0.000000] efi: mem126: type=2, attr=0xf, range=[0x000000008e9a4000-0x00000000bd832000) (750MB)
[    0.000000] efi: mem127: type=10, attr=0xf, range=[0x00000000bd832000-0x00000000bd885000) (0MB)
[    0.000000] efi: mem128: type=9, attr=0xf, range=[0x00000000bd885000-0x00000000bd890000) (0MB)
[    0.000000] efi: mem129: type=0, attr=0xf, range=[0x00000000bd890000-0x00000000bdab6000) (2MB)
[    0.000000] efi: mem130: type=6, attr=0x800000000000000f, range=[0x00000000bdab6000-0x00000000bdaba000) (0MB)
[    0.000000] efi: mem131: type=0, attr=0xf, range=[0x00000000bdaba000-0x00000000bdadc000) (0MB)
[    0.000000] efi: mem132: type=10, attr=0xf, range=[0x00000000bdadc000-0x00000000bdaed000) (0MB)
[    0.000000] efi: mem133: type=6, attr=0x800000000000000f, range=[0x00000000bdaed000-0x00000000bdafe000) (0MB)
[    0.000000] efi: mem134: type=5, attr=0x800000000000000f, range=[0x00000000bdafe000-0x00000000bdaff000) (0MB)
[    0.000000] efi: mem135: type=6, attr=0x800000000000000f, range=[0x00000000bdaff000-0x00000000bdb00000) (0MB)
[    0.000000] efi: mem136: type=10, attr=0xf, range=[0x00000000bdb00000-0x00000000bdb02000) (0MB)
[    0.000000] efi: mem137: type=5, attr=0x800000000000000f, range=[0x00000000bdb02000-0x00000000bdb03000) (0MB)
[    0.000000] efi: mem138: type=6, attr=0x800000000000000f, range=[0x00000000bdb03000-0x00000000bdb04000) (0MB)
[    0.000000] efi: mem139: type=5, attr=0x800000000000000f, range=[0x00000000bdb04000-0x00000000bdb0b000) (0MB)
[    0.000000] efi: mem140: type=10, attr=0xf, range=[0x00000000bdb0b000-0x00000000bdb11000) (0MB)
[    0.000000] efi: mem141: type=5, attr=0x800000000000000f, range=[0x00000000bdb11000-0x00000000bdb1e000) (0MB)
[    0.000000] efi: mem142: type=6, attr=0x800000000000000f, range=[0x00000000bdb1e000-0x00000000bdb60000) (0MB)
[    0.000000] efi: mem143: type=5, attr=0x800000000000000f, range=[0x00000000bdb60000-0x00000000bdb70000) (0MB)
[    0.000000] efi: mem144: type=6, attr=0x800000000000000f, range=[0x00000000bdb70000-0x00000000bdb73000) (0MB)
[    0.000000] efi: mem145: type=10, attr=0xf, range=[0x00000000bdb73000-0x00000000bdd76000) (2MB)
[    0.000000] efi: mem146: type=3, attr=0xf, range=[0x00000000bdd76000-0x00000000bdee4000) (1MB)
[    0.000000] efi: mem147: type=4, attr=0xf, range=[0x00000000bdee4000-0x00000000bdeeb000) (0MB)
[    0.000000] efi: mem148: type=3, attr=0xf, range=[0x00000000bdeeb000-0x00000000bdf00000) (0MB)
[    0.000000] efi: mem149: type=7, attr=0xf, range=[0x0000000100001000-0x000000043f000000) (13295MB)
[    0.000000] efi: mem150: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem151: type=11, attr=0x8000000000000001, range=[0x00000000fec10000-0x00000000fec11000) (0MB)
[    0.000000] efi: mem152: type=11, attr=0x8000000000000001, range=[0x00000000fec20000-0x00000000fec21000) (0MB)
[    0.000000] efi: mem153: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed01000) (0MB)
[    0.000000] efi: mem154: type=11, attr=0x8000000000000001, range=[0x00000000fed61000-0x00000000fed71000) (0MB)
[    0.000000] efi: mem155: type=11, attr=0x8000000000000001, range=[0x00000000fed80000-0x00000000fed90000) (0MB)
[    0.000000] efi: mem156: type=11, attr=0x8000000000000001, range=[0x00000000fef00000-0x0000000100000000) (17MB)
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX, BIOS 0813 10/24/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x43f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-DAFFF write-protect
[    0.000000]   DB000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000BDF00000 mask FFFFFFF00000 uncachable
[    0.000000]   3 base 0000BE000000 mask FFFFFE000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000043f000000 aka 17392M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbdf00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbdf00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbdefffff]
[    0.000000]  [mem 0x00000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbddfffff] page 2M
[    0.000000]  [mem 0xbde00000-0xbdefffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xbdefffff @ [mem 0x1fbfd000-0x1fffffff]
[    0.000000] early_memtest: # of tests: 1
[    0.000000]   0000010000 - 000004a000 pattern 0000000000000000
[    0.000000]   000004bd70 - 000004f000 pattern 0000000000000000
[    0.000000]   0000060000 - 0000097000 pattern 0000000000000000
[    0.000000]   000009d000 - 000009d800 pattern 0000000000000000
[    0.000000]   0000100000 - 0001100000 pattern 0000000000000000
[    0.000000]   0001fdb000 - 0001fe0000 pattern 0000000000000000
[    0.000000]   0002941000 - 0002942000 pattern 0000000000000000
[    0.000000]   0002965000 - 00029e8000 pattern 0000000000000000
[    0.000000]   0002d62000 - 0004000000 pattern 0000000000000000
[    0.000000]   0004c4c43e - 001fbfd000 pattern 0000000000000000
[    0.000000]   001fbff000 - 00bd832000 pattern 0000000000000000
[    0.000000] init_memory_mapping: [mem 0x100000000-0x43effffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000]  [mem 0x400000000-0x43effffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x43effffff @ [mem 0xbd830000-0xbd831fff]
[    0.000000] early_memtest: # of tests: 1
[    0.000000]   0100001000 - 043f000000 pattern 0000000000000000
[    0.000000] ACPI: RSDP 00000000bd885000 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000bd885068 0004C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000bd88dc30 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20120711/tbfadt-598)
[    0.000000] ACPI: DSDT 00000000bd885140 08AEC (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bdb0bf80 00040
[    0.000000] ACPI: APIC 00000000bd88dd28 0009E (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000bd88ddc8 0003C (v01 ALASKA    A M I 01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000bd88de08 00038 (v01 ALASKA    A M I 01072009 AMI  00000004)
[    0.000000] ACPI: SSDT 00000000bd88de40 01714 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000043effffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x43effffff]
[    0.000000]   NODE_DATA [mem 0x43effe000-0x43effffff]
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> [ffff88042e600000-ffff88043e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xbd831fff]
[    0.000000]   node   0: [mem 0xbdd76000-0xbdefffff]
[    0.000000]   node   0: [mem 0x100001000-0x43effffff]
[    0.000000] On node 0 totalpages: 4180299
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 28 pages reserved
[    0.000000]   DMA zone: 3892 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 756220 pages, LIFO batch:31
[    0.000000]   Normal zone: 53184 pages used for memmap
[    0.000000]   Normal zone: 3350591 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 9, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 10, version 33, address 0xfec20000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd832000 - 00000000bd885000
[    0.000000] PM: Registered nosave memory: 00000000bd885000 - 00000000bd890000
[    0.000000] PM: Registered nosave memory: 00000000bd890000 - 00000000bdadc000
[    0.000000] PM: Registered nosave memory: 00000000bdadc000 - 00000000bdaed000
[    0.000000] PM: Registered nosave memory: 00000000bdaed000 - 00000000bdb00000
[    0.000000] PM: Registered nosave memory: 00000000bdb00000 - 00000000bdb02000
[    0.000000] PM: Registered nosave memory: 00000000bdb02000 - 00000000bdb0b000
[    0.000000] PM: Registered nosave memory: 00000000bdb0b000 - 00000000bdb11000
[    0.000000] PM: Registered nosave memory: 00000000bdb11000 - 00000000bdb73000
[    0.000000] PM: Registered nosave memory: 00000000bdb73000 - 00000000bdd76000
[    0.000000] PM: Registered nosave memory: 00000000bdf00000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000fec20000
[    0.000000] PM: Registered nosave memory: 00000000fec20000 - 00000000fec21000
[    0.000000] PM: Registered nosave memory: 00000000fec21000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed01000
[    0.000000] PM: Registered nosave memory: 00000000fed01000 - 00000000fed61000
[    0.000000] PM: Registered nosave memory: 00000000fed61000 - 00000000fed71000
[    0.000000] PM: Registered nosave memory: 00000000fed71000 - 00000000fed80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 0000000100001000
[    0.000000] e820: [mem 0xbdf00000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88043ec00000 s78976 r8192 d23424 u262144
[    0.000000] pcpu-alloc: s78976 r8192 d23424 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4110703
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda3 video=efifb memtest=1 rootflags=ssd,discard,compress printk.time=1 init=/usr/bin/systemd rw
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ b4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ b4000000
[    0.000000] PM: Registered nosave memory: 00000000b4000000 - 00000000b8000000
[    0.000000] Memory: 16283624k/17809408k available (6054k kernel code, 1088212k absent, 437572k reserved, 4805k data, 744k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:1288 16
[    0.000000] virt_efi_get_time: get_time=0xffff8800bdb1a594

