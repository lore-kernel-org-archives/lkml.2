Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2JETAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:00:33 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:44959 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2JETAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:00:30 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mikew@google.com" <mikew@google.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH 0/2] efi_pstore: multiple event logging support
Thread-Topic: [RFC][PATCH 0/2] efi_pstore: multiple event logging support
Thread-Index: Ac2jKpCp3+bzWWFlQQmDJhOmv+C9Sw==
Date: Fri, 5 Oct 2012 19:00:14 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41386D0F8@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-05_06:2012-10-05,2012-10-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=11 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210050203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]

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

(1/2) efi_pstore: hold multiple logs
  This patch makes efi_pstore hold multiple logs.
  Once a critical message is logged, users can see it via /dev/pstore 
  without being influenced by subsequent events.

(2/2) efi_pstore: add a sequence counter to a variable name
  This patch fix an issue in case where multiple events happens in a short time  

Detailed explanations are written in each patch.

 drivers/acpi/apei/erst.c   |   16 +++---
 drivers/firmware/efivars.c |  106 ++++++++++++++++++++++++++++---------------
 fs/pstore/inode.c          |    7 ++-
 fs/pstore/internal.h       |    2 +-
 fs/pstore/platform.c       |   11 +++--
 fs/pstore/ram.c            |    9 ++--
 include/linux/efi.h        |    1 +
 include/linux/pstore.h     |    6 ++-
 8 files changed, 98 insertions(+), 60 deletions(-)

