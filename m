Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1ITAMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 20:12:14 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34287 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751478Ab1ITAMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 20:12:13 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E77DADF.6020608@am.sony.com>
Date: Mon, 19 Sep 2011 17:14:23 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: kdb - can't set breakpoint by default on x86
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently tried using KDB on a 3.0.1 kernel, on an x86 target, using
a fairly-close-to-default kernel configuration.

I found that I could not set a breakpoint.
It sets inside KDB, but then fails to apply the breakpoint when
resuming to user space:


--------------------------------
/proc # echo g >sysrq-trigger
[2689816.806249] SysRq : DEBUG

Entering kdb (current=0xc7661d40, pid 511) on processor 0 due to Keyboard Entry

[0]kdb> bp sys_sync
Instruction(i) BP #0 at 0xc111ce70 (sys_sync)
    is enabled  addr at 00000000c111ce70, hardtype=0 installed=0

[0]kdb> g
_kdb_bp_install: failed to set breakpoint at 0xc111ce70
/proc # sync
/proc #
--------------------------------

I discovered that this was due to the text segment being marked
read-only, by mark_rodata_ro() in arch/x86/mm/init_32.c

This is controlled by CONFIG_DEBUG_RODATA.  With CONFIG_DEBUG_RODATA=y,
I get the following message on startup:

Write protecting the kernel read-only data: 6245

Also, breakpoints don't work.

Turning this off solves the problem, but seems counter-intuitive.
CONFIG_DEBUG_RODATA depends on CONFIG_DEBUG_KERNEL.

Should I:
1) turn off CONFIG_DEBUG_RODATA automatically when CONFIG_KGDB_KDB is set?
or
2) make CONFIG_DEBUG_RODATA depend on !KGDB_KDB?
or
3) something else more subtle?

Thanks,
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

