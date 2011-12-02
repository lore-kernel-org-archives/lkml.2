Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1LBWJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:09:18 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:48849 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1LBWJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:09:16 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 2 Dec 2011 17:08:32 -0500
Subject: [RFC][PATCH v3 0/3] Make pstore/kmsg_dump run after stopping other
 cpus in panic path
Thread-Topic: [RFC][PATCH v3 0/3] Make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Index: AcyxPu4fSl+qdT7oRSamPJnbrxOQww==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D0E@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112020255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Discussion:
 As Don mentioned in following thread, it would be nice for pstore/kmsg_dump to serialize 
 panic path because they can log messages reliably.

 https://lkml.org/lkml/2011/10/13/427

 This patchset is based on his proposal switching smp_send_stop() from REBOOT_VECTOR to NMI.

Change Log:

 v2 -> v3
   - Skip spin_locks in panic case in both kmsg_dump() and pstore_dump() instead of calling spin_lock_init()
     to avoid potential issues due to spin_lock_init()
   - Add WARN_ON() in "in_nmi() and !panic" case into kmsg_dump() so that we trap when someone adds 
     new kmsg_dump() in NMI path in the future
   - Skip subsequent kmsg_dump() function calls to avoid deadlock.

 v1 -> v2
  - Add trylocks to kmsg_dump()/pstore_dump() so that they can work in NMI context.  
  - Divide a patch into two
     First one is just moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()
     Second one is changing lock operations in kmsg_dump()/pstore_dump()
 v1
  - Move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop
  - Bust logbuf_lock of kmsg_dump() in panic path for avoiding deadlock
  - Bust psinfo->buf_lock of pstore_dump() in panic path for avoiding deadlock

Patch Description:
   [RFC][PATCH v3 1/3] Move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()
     - Just move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()

   [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add WARN_ON()
     - Skip spin_locks in panic case in both kmsg_dump() and pstore_dump()
     - Add WARN_ON() in "in_nmi() and !panic" case into kmsg_dump()

   [RFC][PATCH v3 3/3] Skip subsequent kmsg_dump()
     - Skip subsequent kmsg_dump() function calls

TODO:
 This patchset focuses on only kmsg_dump()/pstore_dump().
 So, we have to check whether backend drivers work.

Any comments are welcome.

Seiji Aguchi (3):
 Move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()
 Skip spin_locks in panic case and add WARN_ON()
 Skip subsequent kmsg_dump()

 fs/pstore/platform.c |   16 ++++++----------
 kernel/panic.c       |    4 ++--
 kernel/printk.c      |   23 +++++++++++++++++++++--
 3 files changed, 29 insertions(+), 14 deletions(-)
