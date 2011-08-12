Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1HLNtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:49:23 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52714 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1HLNtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:49:20 -0400
Message-Id: <20110812134849.748973593@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 12 Aug 2011 15:48:49 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v3 0/8] kdump: Patch series for s390 support (version 3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

I updated the patch series according to our last discussions. As you requested,
I removed the "#if !defined(CONFIG_S390)" in the panic function.

The semantics is now as follows:

If kdump is loaded, kdump is always triggered for panic and PSW restart
(s390 NMI). If kdump is not loaded, the s390 shutdown actions defined
under /sys/firmware are executed as we are doing it already today.

I also added again patches for stand-alone dump integration:

For s390 we add a parameter to the purgatory entry point. When "0" is passed,
purgatory only returns the result of the checksum test. When "1" is passed,
purgatory triggers kdump. So we call purgatory twice. First for checking and
second time for execution. You can argue that it would be better to call
purgatory only once and it returns only, if checksums are invalid.
Unfortunately this would be very hard to implement for us, because we
switch to the boot CPU before kdump is finally triggered and after that
currently it is not possible to return from the called function.

panic --------+
              +--- crash_kexec()
              |    call_s390_shutdown_actions() -> stand-alone dump
PSW restart --+

crash_kexec +--> kdump loaded? --> machine_kexec()
            |
            +--> kdump not loaded --> return

machine_kexec +-> purgatory(0)==0 -> switch to IPL cpu -> purgatory(1) -> kdump
              |
              +-> purgatory(0)!=0 -> return

See patches [6] and [8] for details.

Does that sound ok for you?

Michael

Patch overview:
---------------
[1-3] common code changes (could you please ACC patches [1] and [3]?)
[4]   s390 kdump preparation patch
[5]   s390 kdump backend
[6]   s390 stand-alone dump/shutdown actions integration
[7]   kexec-tools: s390 kdump backend for kexec-tools
[8]   kexec-tools: s390 stand-alone dump/shutdown actions integration

History: v1->v2:
----------------
Main changes compared to version 1:
1. We use purgatory code
2. We use pre-allocated ELF core header
3. Registers are saved in old kernel
4. Removed meminfo
