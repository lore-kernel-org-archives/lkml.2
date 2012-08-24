Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088Ab2HXTTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:19:25 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:32823 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2HXTTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:19:20 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mikew@google.com" <mikew@google.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: efi_pstore: question about how to remove spinlock from a whole
 process of open/read/close of efi_pstore
Thread-Topic: efi_pstore: question about how to remove spinlock from a whole
 process of open/read/close of efi_pstore
Thread-Index: Ac2CLUKexzVGhpi8TDCVKTYrp25kCA==
Date: Fri, 24 Aug 2012 19:19:04 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413809ABE@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-24_06:2012-08-24,2012-08-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208240180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sending an email to discuss how to remove spinlock from a whole process of open/read/close of efi_pstore.

[Problem]

Current efi_pstore calls kmalloc() in a read callback while holding a spinlock, efivar->lock, in an open callback.
This means efi_pstore may deadlock if it sleeps in kmalloc().

Also, there is a comment that an efivar->lock shouldn't be held when calling kmalloc().

[Idea]

In a process of open/read/close, pstore creates some files in the directory of /dev/pstore.
So, memory allocations like kmalloc() are not avoidable.
 
My idea fixing this issue is removing spinlock from a whole process of open/read/close of efi_pstore.

Currently, efivar->lock protects two things, efivar->list and ops.[gs]et_variable().
But if we can revise locks of efivar as follows, we can fix this issue.

  - Introduce a new efivar->list_lock to protect efivar->list and RCU is used while searching it.

  - An existing efivar>lock protects just ops.[gs]et_variable() calls.

Any comments are welcome.

Seiji
