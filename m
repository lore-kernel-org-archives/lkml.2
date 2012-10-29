Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870Ab2J2Upq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:45:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38698 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760804Ab2J2Upn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:45:43 -0400
Message-ID: <508EEAF2.4090506@ursulin.net>
Date: Mon, 29 Oct 2012 20:45:38 +0000
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Milan Broz <gmazyland@gmail.com>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org, okozina@redhat.com,
        linux-rt-users@vger.kernel.org
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - RT patch set seem
 to break it
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net> <508EDD6E.7030908@gmail.com> <508EE395.9010709@ursulin.net>
In-Reply-To: <508EE395.9010709@ursulin.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/12 20:14, Tvrtko Ursulin wrote:
> On 29/10/12 19:47, Milan Broz wrote:
>> On 10/29/2012 08:31 PM, Tvrtko Ursulin wrote:
>>> Just tried 3.6.4 and it is still broken. Is there anything else I could
>>> try to debug this?
>>
>> See response from response from Ondra on dmcrypt list - your kernel
>> config
>> is perhaps broken.
>
> I don't think that reached me - perhaps I was not copied.
>
> Weird yes, I mean no one can spot anything bad with my config...
>
>> Please use fresh checkout, run make oldconfig and try again.
>> (Many people use 3.6 already and there is no other report.)
>
> ... and I just used it today to configure a fresh 3.6.4 (plus -rt10
> patches) without a problem.
>
> Unless RT patchset is the culprit. Hm.. that would be unexpected, but I
> guess it is worth a shot. I'll let you know what happens without -rt.

Ha, this is exciting, vanilla 3.6.4 works, with -rt10 patch it does not.

Copying in linux-rt-users.

To recap, 3.6 RT seems to break dm-crypt. Try it like this:

cryptsetup --debug --key-file=- luksOpen /some/luks/formatted/file any-label

And kernel will fail like this:

Kernel says this:
      device-mapper: table: 252:1: crypt: Error allocating crypto tfm
      device-mapper: ioctl: error adding target to table

I think crypto modules are not getting auto loaded for some reason, but 
even if I load them manually before hand and still breaks in the same way.

Maybe someone will have a "ah yes" moment? Here is the diff between 
working (vanilla 3.6.4) and non-working (3.6.4-rt10) configs:

--- 1	2012-10-29 20:37:49.472306922 +0000
+++ 2	2012-10-29 20:37:52.319732779 +0000
@@ -892,7 +892,6 @@
  # CONFIG_DEBUG_SECTION_MISMATCH is not set
  # CONFIG_DEBUG_SET_MODULE_RONX is not set
  # CONFIG_DEBUG_SG is not set
-# CONFIG_DEBUG_SHIRQ is not set
  # CONFIG_DEBUG_SPINLOCK is not set
  # CONFIG_DEBUG_STACKOVERFLOW is not set
  # CONFIG_DEBUG_STACK_USAGE is not set
@@ -1810,7 +1809,7 @@
  CONFIG_MTRR_SANITIZER=y
  CONFIG_MTRR=y
  # CONFIG_MULTICORE_RAID456 is not set
-CONFIG_MUTEX_SPIN_ON_OWNER=y
+# CONFIG_MUTEX_SPIN_ON_OWNER is not set
  # CONFIG_MWAVE is not set
  CONFIG_NAMESPACES=y
  CONFIG_NATIONAL_PHY=y
@@ -1842,7 +1841,6 @@
  CONFIG_NET_CLS_TCINDEX=m
  CONFIG_NET_CLS_U32=m
  CONFIG_NET_CLS=y
-# CONFIG_NETCONSOLE is not set
  CONFIG_NET_CORE=y
  CONFIG_NETDEVICES=y
  # CONFIG_NET_DSA is not set
@@ -2260,9 +2258,13 @@
  CONFIG_PPP=y
  # CONFIG_PPS is not set
  CONFIG_PREEMPT_COUNT=y
+# CONFIG_PREEMPT__LL is not set
  # CONFIG_PREEMPT_NONE is not set
  CONFIG_PREEMPT_NOTIFIERS=y
  CONFIG_PREEMPT_RCU=y
+CONFIG_PREEMPT_RT_BASE=y
+# CONFIG_PREEMPT_RTB is not set
+CONFIG_PREEMPT_RT_FULL=y
  # CONFIG_PREEMPT_VOLUNTARY is not set
  CONFIG_PREEMPT=y
  CONFIG_PREVENT_FIRMWARE_BUILD=y
@@ -2368,11 +2370,10 @@
  CONFIG_RTC_INTF_PROC=y
  CONFIG_RTC_INTF_SYSFS=y
  CONFIG_RTC_LIB=y
-# CONFIG_RT_GROUP_SCHED is not set
  CONFIG_RT_MUTEXES=y
  # CONFIG_RT_MUTEX_TESTER is not set
-# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
-CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
  # CONFIG_SAMPLES is not set
  # CONFIG_SATA_ACARD_AHCI is not set
  CONFIG_SATA_AHCI=m
@@ -2851,7 +2852,6 @@
  CONFIG_TRACE_IRQFLAGS_SUPPORT=y
  # CONFIG_TRACE_SINK is not set
  CONFIG_TRACING_SUPPORT=y
-# CONFIG_TRANSPARENT_HUGEPAGE is not set
  CONFIG_TREE_PREEMPT_RCU=y
  # CONFIG_TREE_RCU_TRACE is not set
  CONFIG_TUN=y
@@ -2867,7 +2867,6 @@
  CONFIG_UID16=y
  # CONFIG_UIO is not set
  # CONFIG_ULTRIX_PARTITION is not set
-CONFIG_UNINLINE_SPIN_UNLOCK=y
  CONFIG_UNIX98_PTYS=y
  CONFIG_UNIX_DIAG=y
  # CONFIG_UNIXWARE_DISKLABEL is not set

No crypto related differences.

Tvrtko




