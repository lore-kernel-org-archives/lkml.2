Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1FMUuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:50:09 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:41232 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1FMUuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:50:06 -0400
Date: Mon, 13 Jun 2011 22:50:03 +0200
From: Tobias Diedrich <ranma+xen@tdiedrich.de>
To: xen-users@lists.xensource.com
Cc: linux-kernel@vger.kernel.org
Subject: [Xen-users] 3.0.0-rc2: Xen: High amount of kernel "reserved"
 memory, about 33% in 256MB DOMU
Message-ID: <20110613205003.GD20616@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+xen@tdiedrich.de>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

another issue I'm seeing with 3.0-rc2 and Xen is that there is an
unexpectedly high amount of kernel reserved memory.

I suspect that Linux allocates page table entries and corresponding
data structures for the whole 6GB areas of the provided 'physical
RAM map' even though it has rather big unusable holes in it.

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  Xen: 000000000009f000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000010000000 (usable)
[    0.000000]  Xen: 0000000010000000 - 000000007fef0000 (unusable)
[    0.000000]  Xen: 000000007fef0000 - 000000007fef3000 (ACPI NVS)
[    0.000000]  Xen: 000000007fef3000 - 000000007ff00000 (ACPI data)
[    0.000000]  Xen: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  Xen: 0000000100000000 - 000000016fef0000 (usable)


On DOMUs I can 'fix' this by adding 'memmap=0x800000$0x100000000' to
the kernel command line, which changes 

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000010000000 (usable)
[    0.000000]  Xen: 0000000100000000 - 0000000100800000 (usable)
[...]
[    0.000000] Memory: 176356k/4202496k available (6096k kernel code, 3932608k absent, 93532k reserved, 4785k data, 572k init)

to

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000010000000 (usable)
[    0.000000]  Xen: 0000000100000000 - 0000000100800000 (usable)
[...]
[    0.000000] user-defined physical RAM map:
[    0.000000]  user: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  user: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  user: 0000000000100000 - 0000000010000000 (usable)
[...]
[    0.000000]  user: 0000000100000000 - 0000000100800000 (reserved)
[    0.000000] Memory: 244212k/262144k available (6096k kernel code, 448k absent, 17484k reserved, 4785k data, 572k init)

With 66MB of usable memory out of 256MB recovered and a reasonable
93% of memory usable for userspace instead of just 67%.


I also see this on my 256MB DOM0:
Memory: 146536k/6028224k available (6122k kernel code, 3932612k absent, 1949076k reserved, 4761k data, 576k init)
Only 143MB out of 256MB allocated for DOM0 is usable for userspace.

Regards,

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
