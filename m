Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2LTPLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:11:41 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:53307 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2LTPLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:11:35 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in non-blocking
 paths
Thread-Topic: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Index: Ac3ewyNm+rP2IEnER5GHHHxmid334A==
Date: Thu, 20 Dec 2012 15:11:14 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A03B@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-20_05:2012-12-20,2012-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212200121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog 
v2 -> v3
 - Merge modifications of pstore part in 2/2 to 1/2.
 - Rename pstore_is_non_blocking_path() to pstore_cannot_block_path().

v1 -> v2
 - Erase a logic checking the number of online cpus.
 - Create a patchset to fix deadlocking issue in both pstore filesystem and
   efi_pstore driver.
   - Introduce a function, is_non_blocking_path(), to check if pstore 
     is in panic and emergency-restart paths (PATCH 1/2)
   - Avoid efi_pstore_driver is blocked in non-blocking paths
     such as nmi, panic and emergency-restart paths (PATCH 2/2)

[Issue]

There are some paths in kernel which shouldn't be blocked, 
like NMI, panic case after stopping cpus, emergency-restart.

On the other hand, current pstore avoids blocking in a NMI path 
but it may be blocked in other paths.
Also, an efi_pstore driver may be blocked in all of those paths 
because it simply takes a spin lock at writing time.

If they are blocked in those paths, the system will hang up and
it has a big impact for users.

Here is an example scenario which pstore is blocked in panic path.

 - cpuA grabs psinfo->buf_lock
 - cpuB panics and calls smp_send_stop
 - smp_send_stop sends IRQ to cpuA
   after 1 second, cpuB gives up on cpuA and sends an NMI instead
 - cpuA is now in an NMI handler while still holding buf_lock.
   And then, cpuB is deadlocked by taking efi_pstore->lock again.

This case may happen if a firmware has a bug and cpuA is stuck in it.

[Solution]

This patchset avoids that pstore and efi_pstore driver are blocked 
in the non-blocking paths like NMI, panic, and emrgency-restart
by introducing a function checking if they are in those paths.
Please see each patch for detailed explanations.

Seiji Aguchi (2):
  [PATCH v3 1/2] pstore: Avoid deadlock in panic and emergency-restart path
  [PATCH v3 2/2] efi_pstore: Avoid deadlock in non-blocking paths

 drivers/firmware/efivars.c |   11 ++++++++++-
 fs/pstore/platform.c       |   34 ++++++++++++++++++++++++++++------
 include/linux/pstore.h     |    6 ++++++
 3 files changed, 44 insertions(+), 7 deletions(-)


