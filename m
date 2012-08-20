Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2HTTNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:13:54 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:57720 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2HTTNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:13:51 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        Mike Waychison <mikew@google.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH v2 0/3] make efivars/efi_pstore interrupt-safe
Thread-Topic: [RFC][PATCH v2 0/3] make efivars/efi_pstore interrupt-safe
Thread-Index: Ac1/BzifQj+EBOmdQMa+fIK8DRfpaA==
Date: Mon, 20 Aug 2012 19:13:36 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C1C@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-20_04:2012-08-20,2012-08-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=60 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208200220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog
 - Patch 1/3
    Add spin_lock_irq/spin_unlock_irq to open/close callbacks of efi_pstore 
    instead of moving spin_locks to a read callback.    

 - Patch 2/3
    Replace a periodical timer with schedule_work().

 - Patch 3/3
    freshly create to kick a workqueue in oops case only.

[Problem]
 There are following problems related to an interrupt context in efivar/efi_pstore.

 Currently, efivars enables interrupt while taking efivars->lock.
 So, there is a risk to be deadlocking in a write callback of efi_pstore if kernel panics 
 in interrupt context while taking efi_lock.

 Also, efi_pstore creates sysfs entries ,which enable users to access to NVRAM, in a write callback.
 If a kernel panic happens in interrupt contexts, pstore may fail because it could sleep due to dynamic 
 memory allocations during creating sysfs entries.

To resolve the problems above, a goal of this patchset is making efivars/efi_pstore interrupt-safe.

[Patch Description]
 Patch 1/3 efivars: Disable external interrupt while holding efivars->lock
   This patch replaces spin_lock/spin_unlock with spin_lock_irqsave/spin_lock_irqrestore to make efivars interrupt safe

 Patch 2/3 efi_pstore: Introducing workqueue updating sysfs entries
   This patch removes sysfs operations from write callback by introducing a workqueue updating sysfs entries

 Patch 3/3 efi_pstore: Skip scheduling a workqueue in cases other than oops
   This patch restricts a schedule of a workqueue in just oops case which is truly needed for users.
   Also, a logic of erase callback is freshly created instead of sharing with a write callback so that
   its sysfs update operation works correctly.

 drivers/firmware/efivars.c |  209 +++++++++++++++++++++++++++++++++++++-------
 include/linux/efi.h        |    3 +-
 2 files changed, 179 insertions(+), 33 deletions(-)

