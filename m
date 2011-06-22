Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab1FVKp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:45:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44902 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1FVKp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:45:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01C7D5.3060603@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 19:45:41 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com, oleg@redhat.com
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH v3 0/6]  Fix oom killer doesn't work at all if system have
 > gigabytes memory  (aka CAI founded issue)
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAI Qian reported current oom logic doesn't work at all on his 16GB RAM
machine. oom killer killed all system daemon at first and his system
stopped responding.

The brief log is below.

> > Out of memory: Kill process 1175 (dhclient) score 1 or sacrifice child
> > Out of memory: Kill process 1247 (rsyslogd) score 1 or sacrifice child
> > Out of memory: Kill process 1284 (irqbalance) score 1 or sacrifice child
> > Out of memory: Kill process 1303 (rpcbind) score 1 or sacrifice child
> > Out of memory: Kill process 1321 (rpc.statd) score 1 or sacrifice child
> > Out of memory: Kill process 1333 (mdadm) score 1 or sacrifice child
> > Out of memory: Kill process 1365 (rpc.idmapd) score 1 or sacrifice child
> > Out of memory: Kill process 1403 (dbus-daemon) score 1 or sacrifice child
> > Out of memory: Kill process 1438 (acpid) score 1 or sacrifice child
> > Out of memory: Kill process 1447 (hald) score 1 or sacrifice child
> > Out of memory: Kill process 1447 (hald) score 1 or sacrifice child
> > Out of memory: Kill process 1487 (hald-addon-inpu) score 1 or sacrifice child
> > Out of memory: Kill process 1488 (hald-addon-acpi) score 1 or sacrifice child
> > Out of memory: Kill process 1507 (automount) score 1 or sacrifice child

The problems are three.

1) if two processes have the same oom score, we should kill younger process.
but current logic kill older. Typically oldest processes are system daemons.
2) Current logic use 'unsigned int' for internal score calculation. (exactly says,
it only use 0-1000 value). its very low precision calculation makes a lot of
same oom score and kill an ineligible process.
3) Current logic give 3% of SystemRAM to root processes. It obviously too big
if you have plenty memory. Now, your fork-bomb processes have 500MB OOM immune
bonus. then your fork-bomb never ever be killed.

Changes from v2
 o added [patch 1/5] use euid instead of CAP_SYS_ADMIN


KOSAKI Motohiro (6):
  oom: use euid instead of CAP_SYS_ADMIN for protection root process
  oom: improve dump_tasks() show items
  oom: kill younger process first
  oom: oom-killer don't use proportion of system-ram internally
  oom: don't kill random process
  oom: merge oom_kill_process() with oom_kill_task()

 fs/proc/base.c        |   13 ++-
 include/linux/oom.h   |    5 +-
 include/linux/sched.h |   11 +++
 mm/oom_kill.c         |  201 ++++++++++++++++++++++++++----------------------
 4 files changed, 131 insertions(+), 99 deletions(-)

-- 
1.7.3.1


