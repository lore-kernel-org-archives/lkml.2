Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab1DMRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:25:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab1DMRZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=SvYv2X3+2CkS7oltvNAcUC0sJK/ZmSKQ2tESzUn7JBqwliT8o3uwn3rpiCYkDCCoUk
         HaAP1w8N9457n4L8UPng==
MIME-Version: 1.0
Date: Wed, 13 Apr 2011 10:25:39 -0700
Message-ID: <BANLkTin5kWej_pThqBvL7dypVB_JGYU7=A@mail.gmail.com>
Subject: System crash, bisect points to "connector: convert to synchronous
 netlink message processing"
From: Venkatesh Pallipadi <venki@google.com>
To: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I started seeing crashes with linus git recently. The failure
signature is something like:

System boots up fine. But, almost immediately crashes. If I am lucky
enough to  connect to system at right time (after boot and before
crash) I get something like this before system panic reboots. (I am
sorry, but, I don't have a console onto this system)

[  214.400107] Oops: 0000 [#2] SMP
[  214.400107] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/device
[  214.400107] Stack:
[  214.400107] Call Trace:
[  214.400107]  <IRQ>
[  214.400107]  <EOI>
[  214.400107] Code: 48 8b 7d a0 4c 89 f6 e8 0a dc ff ff 4c 89 f0 48
83 c4 48 5b 41 5c 41 5d 41 5e 41 5f c9 c3 49 63 44 24 20 48 8d 4a 01
49 8b 34 24
[  214.400107] CR2: 000000000120037f
[  216.271824] Kernel panic - not syncing: Fatal exception in interrupt


git bisect points to commit
04f482faf50535229a5a5c8d629cf963899f857c is the first bad commit
commit 04f482faf50535229a5a5c8d629cf963899f857c
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Mar 28 08:39:36 2011 +0000

   connector: convert to synchronous netlink message processing

   Commits 01a16b21 (netlink: kill eff_cap from struct netlink_skb_parms)
   and c53fa1ed (netlink: kill loginuid/sessionid/sid members from struct
   netlink_skb_parms) removed some members from struct netlink_skb_parms
   that depend on the current context, all netlink users are now required
   to do synchronous message processing.

   connector however queues received messages and processes them in a work
   queue, which is not valid anymore. This patch converts connector to do
   synchronous message processing by invoking the registered callback handler
   directly from the netlink receive function.

   In order to avoid invoking the callback with connector locks held, a
   reference count is added to struct cn_callback_entry, the reference
   is taken when finding a matching callback entry on the device's queue_list
   and released after the callback handler has been invoked.

   Signed-off-by: Patrick McHardy <kaber@trash.net>
   Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
   Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 5f891d2efb30069112c60e7d3e36afac59422ca5
28600c66bb70062cc850e9a4caa3417ae8260cb8 M      drivers
:040000 040000 48634035b2c0a3ee40868a9686de284680ee3f43
7cb9bbe8b0daa08e1a1263ac746255fd3fa25e6e M      include


Full bisect log
# bad: [b2a8b4b81966094703088a7bc76a313af841924d] Merge branch
'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect bad b2a8b4b81966094703088a7bc76a313af841924d
# good: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
git bisect good 521cb40b0c44418a4fd36dc633f575813d59a43d
# good: [c55d267de274d308927b60c3e740c1a826832317] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git bisect good c55d267de274d308927b60c3e740c1a826832317
# good: [2f284c846331fa44be1300a3c2c3e85800268a00] Merge branch
'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
git bisect good 2f284c846331fa44be1300a3c2c3e85800268a00
# good: [2a20b02c055a14eb60ac8da737d79dc940bb9ee0] Merge branch
'perf-fixes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 2a20b02c055a14eb60ac8da737d79dc940bb9ee0
# good: [baaca1a61497d97cec595fedce03b0a23b983e64] Merge branch
'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86
git bisect good baaca1a61497d97cec595fedce03b0a23b983e64
# good: [eefbab599531240adaffa1d23900afbc8b0342bd] Merge branch 'frv'
of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-frv
git bisect good eefbab599531240adaffa1d23900afbc8b0342bd
# good: [50f3515828024582402044bcced6804c070c491c] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
git bisect good 50f3515828024582402044bcced6804c070c491c
# bad: [720e87efe21b43c89093c1f04ec9ecba2f0213b8] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad 720e87efe21b43c89093c1f04ec9ecba2f0213b8
# bad: [afdef69c7ff7d0bf59e3cafc187aefb12878dbe3] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6
git bisect bad afdef69c7ff7d0bf59e3cafc187aefb12878dbe3
# bad: [5e8996e72899847269ca36061ea33ea24bf6cb90] bonding:typo in comment
git bisect bad 5e8996e72899847269ca36061ea33ea24bf6cb90
# good: [7a635ea989991d7f12d57a12f2ba7cb6d211e083] net/usb: Ethernet
quirks for the LG-VL600 4G modem
git bisect good 7a635ea989991d7f12d57a12f2ba7cb6d211e083
# good: [18b429e74eeafe42e947b1b0f9a760c7153a0b5c] atm/solos-pci:
Don't include frame pseudo-header on transmit hex-dump
git bisect good 18b429e74eeafe42e947b1b0f9a760c7153a0b5c
# good: [e2666f84958adb3a034b98e99699b55705117e01] fib: add rtnl
locking in ip_fib_net_exit
git bisect good e2666f84958adb3a034b98e99699b55705117e01
# bad: [a84b50ceb7d640437d0dc28a2bef0d0de054de89] sctp: Pass
__GFP_NOWARN to hash table allocation attempts.
git bisect bad a84b50ceb7d640437d0dc28a2bef0d0de054de89
# bad: [04f482faf50535229a5a5c8d629cf963899f857c] connector: convert
to synchronous netlink message processing
git bisect bad 04f482faf50535229a5a5c8d629cf963899f857c


I did a double check with today's git
(aaa119a3d4e0b7421c82ae3fbe288e65d0f3485f) which fails and a revert of
the above patch makes the system boot fine.

Let me know if you need any more info like dmesg on good boot, config etc.

Thanks,
Venki
