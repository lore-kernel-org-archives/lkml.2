Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab2HQTln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:41:43 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:39388 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2HQTle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:41:34 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH 0/2] make efivars/efi_pstore interrupt-safe 
Thread-Topic: [RFC][PATCH 0/2] make efivars/efi_pstore interrupt-safe 
Thread-Index: Ac18r7JT3FmFCP/MRiWrhcKDoctFSw==
Date: Fri, 17 Aug 2012 19:41:18 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413800066@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-17_03:2012-08-17,2012-08-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=7 spamscore=7
 ipscore=0 suspectscore=1 phishscore=1 bulkscore=65 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208170207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 Patch 1/2 efivars: Disable external interrupt while holding efivars->lock
   This patch replaces spin_lock/spin_unlock with spin_lock_irqsave/spin_lock_irqrestore to make efivars interrupt safe

 Patch 2/2 efi_pstore: Introducing workqueue updating sysfs entries
   This patch removes sysfs operations from write callback by introducing a workqueue updating sysfs entries

 drivers/firmware/efivars.c |  193 +++++++++++++++++++++++++++++++++++---------
 include/linux/efi.h        |    6 +-
 2 files changed, 161 insertions(+), 38 deletions(-)

