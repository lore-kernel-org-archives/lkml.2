Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab2CJBwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 20:52:15 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30130
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755868Ab2CJBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 20:52:12 -0500
X-SpamScore: -6
X-BigFish: VPS-6(z21eNzzz1202hzzz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F5AB3B6.2040705@am.sony.com>
Date: Fri, 9 Mar 2012 17:51:50 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: <tglx@linutronix.de>, <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: 3.0.23-rt39 BUG: scheduling while atomic, _cpu_down()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
(and Steve, since you've been mucking about in the hotplug code,)

Yet another bit of fallout related to hotplug.

This appears to affect 3.0-rt1, 3.0.23-rt29, and 3.2.9-rt17.
(Thus probably all 3.x versions, but I haven't been masochistic
enough to check.)

If not defined CONFIG_PREEMPT_RT_FULL then

  - hotplug_lock() is a mutex_lock()
  - cpu_hotplug_begin() calls hotplug_lock()
  - _cpu_down() calls cpu_hotplug_begin() with preemption
    disabled (disabled by the migrate_disable())

The call to cpu_hotplug_begin() is not in a preempt disabled
region until hotplug-use-migrate-disable.patch.  This patch
moves the preempt_enable() (aka migrate_enable()) from just
before calling cpu_hotplug_begin() to after "out_cancel:".

The BUG can be triggered by:

   echo 0 > /sys/devices/system/cpu/cpu1/online 


-Frank

