Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab0EWE6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 00:58:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38184 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0EWE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 00:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LxBFkiJE2QiAoB4aqaQfe4/D99uojlaz6VK9pQcpmGgQ07XiWHV5ELYXeTumUQCoKw
         nfY4TK6sEPJqypqbwpw1usdrsmDa8OOl636Uy5lFA70bNtKWYG9FfJZr/Mekxx91fZ5Q
         5mFm/0wWgHuADTTZbQ2AmbxULbRFDBODDxdsY=
MIME-Version: 1.0
Date: Sun, 23 May 2010 12:58:14 +0800
Message-ID: <AANLkTikg6BEFCC-vwn3K96ZI-uiErg4SO8V701SWNkn0@mail.gmail.com>
Subject: Wireless IBSS on Linux-2.6.34 broken by commit 3bbb9ec946428b96657126768f65487a48dd090c
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>, johnstul@us.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>, Johannes Berg <johannes.berg@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wireless IBSS on Linux-2.6.34 is broken. Reverting commit
3bbb9ec946428b96657126768f65487a48dd090c makes it work again. This was
tested by bisecting the kernel.

I'm using 6200 AGN ...

cfg80211: Calling CRDA to update world regulatory domain
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
iwlagn 0000:02:00.0: setting latency timer to 64
iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:02:00.0: irq 46 for MSI/MSI-X
iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build 19710



So, where should the fix be?


Here's the commit ...

3bbb9ec946428b96657126768f65487a48dd090c is the first bad commit
commit 3bbb9ec946428b96657126768f65487a48dd090c
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Thu Mar 11 14:04:36 2010 -0800

    timers: Introduce the concept of timer slack for legacy timers

    While HR timers have had the concept of timer slack for quite some time
    now, the legacy timers lacked this concept, and had to make do with
    round_jiffies() and friends.

    Timer slack is important for power management; grouping timers reduces the
    number of wakeups which in turn reduces power consumption.

    This patch introduces timer slack to the legacy timers using the following
    pieces:
    * A slack field in the timer struct
    * An api (set_timer_slack) that callers can use to set explicit timer slack
    * A default slack of 0.4% of the requested delay for callers that do not set
      any explicit slack
    * Rounding code that is part of mod_timer() that tries to
      group timers around jiffies values every 'power of two'
      (so quick timers will group around every 2, but longer timers
      will group around every 4, 8, 16, 32 etc)

    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Cc: johnstul@us.ibm.com
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>




Thanks,
Jeff.
