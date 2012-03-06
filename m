Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030710Ab2CFNcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:32:05 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49132 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030275Ab2CFNcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:32:02 -0500
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC -v3 PATCH 0/3] RAS: Use MCE tracepoint for decoded MCEs
Date: Tue,  6 Mar 2012 14:31:30 +0100
Message-Id: <1331040694-12558-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Third version of the patchset, with the latest addition of
"hijacking" EDAC printk output when a RAS agent is running, i.e.
/sys/devices/system/ras/agent is 1. Btw, I'm open for better suggestions
on how to do the logic of having a RAS agent running - currently, it is
a bool which is visible through sysfs and userspace can turn it on and
off.

Changelog:

* V2:

Here's a second version of the patchset with the buffer enlarging ripped
out. 1/4 in the series could go in independently since it is a cleanup,
I'll add it to a for-next testing branch if there are no objections.

* V1:

this is an initial, more or less serious attempt to collect decoded
MCE info into a buffer and jettison it into userspace using the MCE
tracepoint trace_mce_record(). This initial approach needs userspace to
do

$ echo 1 > /sys/devices/system/ras/agent

and decoded MCE info gets collected into a buffer. Then, when decoding
is finished, the tracepoint is called and the MCE info along with the
decoded information lands in the ring buffer and at possible userspace
consumers.

Also, the commit messages of the single patches contain additional info.

For example, the data looks like this:

mcegen.py-2318  [001] .N..   580.902409: mce_record: [Hardware Error]: CPU:0 MC4_STATUS[Over|CE|-|PCC|AddrV|CECC]: 0xd604c00006080a41 MC4_ADDR: 0x0000000000000016
[Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
[Hardware Error]: ERR_ADDR: 0x16 row: 0, channel: 0
[Hardware Error]: cache level: L1, mem/io: MEM, mem-tx: DWR, part-proc: RES (no timeout)
[Hardware Error]: CPU: 0, MCGc/s: 0/0, MC4: d604c00006080a41, ADDR/MISC: 0000000000000016/dead57ac1ba0babe, RIP: 00:<0000000000000000>, TSC: 0, TIME: 0)

       mcegen.py-2326  [001] .N..   598.795494: mce_record: [Hardware Error]: CPU:0 MC4_STATUS[Over|UE|MiscV|PCC|-|UECC]: 0xfa002000001c011b
[Hardware Error]: Northbridge Error (node 0): L3 ECC data cache error.
[Hardware Error]: cache level: L3/GEN, tx: GEN, mem-tx: RD
[Hardware Error]: CPU: 0, MCGc/s: 0/0, MC4: fa002000001c011b, ADDR/MISC: 0000000000000016/dead57ac1ba0babe, RIP: 00:<0000000000000000>, TSC: 0, TIME: 0)

mcegen.py-2343  [013] .N..   619.620698: mce_record: [Hardware Error]: CPU:0 MC4_STATUS[-|UE|MiscV|PCC|-|UECC]: 0xba002100000f001b[HardwareError]: Northbridge Error (node 0): GART Table Walk data error.
[Hardware Error]: cache level: L3/GEN, tx: GEN
[Hardware Error]: CPU: 0, MCGc/s: 0/0, MC4: ba002100000f001b, ADDR/MISC: 0000000000000016/dead57ac1ba0babe, RIP: 00:<0000000000000000>, TSC: 0, TIME: 0)

As always, reviews and comments are welcome.

Thanks.
