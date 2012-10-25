Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131Ab2JYBtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:49:52 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:52346 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab2JYBtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:49:50 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v2 0/5] efi_pstore: multiple event logging support
Thread-Topic: [PATCH v2 0/5] efi_pstore: multiple event logging support
Thread-Index: Ac2yUeBWHNsQTs+gQdSSj3EsTjaJug==
Date: Thu, 25 Oct 2012 01:49:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41388895F@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-24_09:2012-10-24,2012-10-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=11 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210240325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog
v1 -> v2
   - Separate into 5 patches in accordance with Mike's comment
   - Erase an extra line of comment in patch 1/5

[Issue]

    Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
    So, in the following scenario, we will lose 1st panic messages.

    1. kernel panics.
    2. efi_pstore is kicked and writes panic messages to NVRAM.
    3. system reboots.
    4. kernel panics again before a user checks the 1st panic messages in NVRAM.

[Solution]

   Solutions of this problem has been discussed among Tony, Matthew, Don, Mike and me.

   http://marc.info/?l=linux-kernel&m=134273270704586&w=2

   And there are two possible solutions right now.
     - First one is introducing some policy overwriting existing logs.
     - Second one is simply holding multiple log without overwriting any entries.

   We haven't decided the overwriting policy which is reasonable to all users yet.
   But I believe we agree that just holding multiple logs is a reasonable way.

   We may need further discussions to find the possibility of introducing overwriting
   policy, especially getting critical messages in multiple oops case.
   But I would like to begin with a simple and reasonable way to everyone.
   So, this patch takes an approach just holding multiple logs.

[Patch Description]

(1/5) efi_pstore: Check remaining space with QueryVariableInfo() before writing data

(2/5) efi_pstore: Add a logic erasing entries to an erase callback

(3/5) efi_pstore: Remove a logic erasing entries from a write callback to hold multiple logs

(4/5) efi_pstore: Add ctime to argument of erase callback

(5/5) efi_pstore: Add a sequence counter to a variable name

Detailed explanations are written in each patch.

 drivers/acpi/apei/erst.c   |   16 ++++----
 drivers/firmware/efivars.c |  100 ++++++++++++++++++++++++++++---------------
 fs/pstore/inode.c          |    7 ++-
 fs/pstore/internal.h       |    2 +-
 fs/pstore/platform.c       |   11 +++--
 fs/pstore/ram.c            |    9 ++--
 include/linux/efi.h        |    1 +
 include/linux/pstore.h     |    6 ++-
 8 files changed, 94 insertions(+), 58 deletions(-)

