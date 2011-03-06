Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1CFPEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 10:04:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37320 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1CFPEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 10:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=m3q3GXHbpLLz6PJ+e9KjV9z0WVm2tDKFg1bgp2jZOtPfP3pAWqc9MsEb+8zJrlfY14
         CoFl6nU7tFpc72LWRl2uhsXgXZoWOMidutOG4Rcuiy9aerIieZbRyLooqdTz4cmpZukJ
         rvjxNjJbtWvJa3CV/2O64DBpSWkzk2dBxZy9k=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=BszM8mwQ+Ooff+8D1vOXZ1=LLOp3MwPcPQu4-@mail.gmail.com>
References: <AANLkTi=BszM8mwQ+Ooff+8D1vOXZ1=LLOp3MwPcPQu4-@mail.gmail.com>
Date: Sun, 6 Mar 2011 17:04:31 +0200
Message-ID: <AANLkTi=H8uOpqC56GCt9U89nDWChG5nQa4kUz+fxHPdc@mail.gmail.com>
Subject: x86_32 machine with 4G - possible wrong last_pfn value ?
From: "Haim D." <haimdaniel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm running  a x86_32 bit 4G machine with 2.4.33 and 2.6.34, I've
noticed the difference between max_pfn values
2.4.33 shows 0x100000
2.4.34 shows  0xdffe0

The issue seems to be in
--- 2.6.34/arch/x86/kernel/e820.c       17 Jun 2010 12:00:26 -0000      1.1.2.1
+++ 2.6.34/arch/x86/kernel/e820.c       6 Mar 2011 14:56:44 -0000
@@ -869,7 +869,7 @@ static unsigned long __init e820_end_pfn
               start_pfn = ei->addr >> PAGE_SHIFT;
               end_pfn = (ei->addr + ei->size) >> PAGE_SHIFT;

-               if (start_pfn >= limit_pfn)
+               if (start_pfn > limit_pfn)
                       continue;
               if (end_pfn > limit_pfn) {
                       last_pfn = limit_pfn;

=======2.4=======
Mar  3 09:22:32 accelerator kernel: Linux version 2.4.33
(root@haimd-ubuntu) (gcc version 3.2.3 20030502 (Red Hat Linux
3.2.3-53)) #3 Wed Mar 2 18:36:10 IST
Mar  6 13:27:17 localhost kernel: BIOS-provided physical RAM map:
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 0000000000000000 -
000000000009fc00 (usable)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 000000000009fc00 -
00000000000a0000 (reserved)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000000e0000 -
0000000000100000 (reserved)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 0000000000100000 -
00000000dffe0000 (usable)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000dffe0000 -
00000000dffee000 (ACPI data)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000dffee000 -
00000000e0000000 (ACPI NVS)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000fee00000 -
00000000fee01000 (reserved)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000ffb00000 -
0000000100000000 (reserved)
Mar  6 13:27:17 localhost kernel:  BIOS-e820: 0000000100000000 -
0000000120000000 (usable)
Mar  6 13:27:17 localhost kernel: Warning only 4GB will be used.
Mar  6 13:27:17 localhost kernel: Use a PAE enabled kernel.
Mar  6 13:27:17 localhost kernel: (find_max_low_pfn:1003) max_low_pfn to 753664
Mar  6 13:27:17 localhost kernel: 1152MB HIGHMEM available.
Mar  6 13:27:17 localhost kernel: 2944MB LOWMEM available.
Mar  6 13:27:17 localhost kernel: found SMP MP-table at 000ff780
Mar  6 13:27:17 localhost kernel: hm, page 000ff000 reserved twice.
Mar  6 13:27:17 localhost kernel: hm, page 00100000 reserved twice.
Mar  6 13:27:17 localhost kernel: hm, page 000fd000 reserved twice.
Mar  6 13:27:17 localhost kernel: hm, page 000fe000 reserved twice.
Mar  6 13:27:17 localhost kernel: On node 0 totalpages: 1048576

============2.6 ==========
Mar  6 08:19:06 localhost kernel: [    0.000000] Linux version
2.6.34.aos (root@builder) (gcc version 4.1.2 20080704 (Red Hat
4.1.2-48)) #1 Thu Mar 3 17:54:29 IST 2011
Mar  6 08:19:06 localhost kernel: [    0.000000] BIOS-provided physical RAM map:
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
0000000000000000 - 000000000009fc00 (usable)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
000000000009fc00 - 00000000000a0000 (reserved)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
00000000000e0000 - 0000000000100000 (reserved)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
0000000000100000 - 00000000dffe0000 (usable)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
00000000dffe0000 - 00000000dffee000 (ACPI data)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
00000000dffee000 - 00000000e0000000 (ACPI NVS)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
00000000fee00000 - 00000000fee01000 (reserved)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
00000000ffb00000 - 0000000100000000 (reserved)
Mar  6 08:19:06 localhost kernel: [    0.000000]  BIOS-e820:
0000000100000000 - 0000000120000000 (usable)
Mar  6 08:19:06 localhost kernel: [    0.000000] Notice: NX (Execute
Disable) protection cannot be enabled: non-PAE kernel!
Mar  6 08:19:06 localhost kernel: [    0.000000] DMI present.
Mar  6 08:19:06 localhost kernel: [    0.000000] AMI BIOS detected:
BIOS may corrupt low RAM, working around it.
Mar  6 08:19:06 localhost kernel: [    0.000000] e820 update range:
0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Mar  6 08:19:06 localhost kernel: [    0.000000] e820 update range:
0000000000000000 - 0000000000001000 (usable) ==> (reserved)
Mar  6 08:19:06 localhost kernel: [    0.000000] e820 remove range:
00000000000a0000 - 0000000000100000 (usable)
Mar  6 08:19:06 localhost kernel: [    0.000000] last_pfn = 0xdffe0
max_arch_pfn = 0x100000

please advise,
-haim
