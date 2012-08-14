Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2HNQFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:05:47 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:32886 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2HNQFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:05:46 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: efi_pstore: question about how to remove create_sysfs_entry() from
 a write callback.
Thread-Topic: efi_pstore: question about how to remove create_sysfs_entry()
 from a write callback.
Thread-Index: Ac16Npmt6jTfpP4+SGO2J5V3Hs4Kkw==
Date: Tue, 14 Aug 2012 16:05:28 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FBD89@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-14_04:2012-08-14,2012-08-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=11 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208140148
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sending an email to discuss how to remove create_sysfs_entry() from a write callback.

[Problem]

Current efi_pstore creates sysfs entries ,which enable users to access to NVRAM, in a write callback.
If a kernel panic happens in interrupt contexts, pstore may fail because it could sleep due to dynamic 
memory allocations during creating sysfs entries.

To resolve the problem above, my goal here is removing create_sysfs_entry() from a write callback.

[Ideas]

 (1) Introduce a workqueue updating sysfs entries

     To remove create_sysfs_entry() from a write callback,
     It seems to be possible if efi_pstore updates its sysfs files 
     by scanning existing entries in NVRAM with a GetNextVariable()
     in a workqueue.
     

     I created a prototype patch based on an idea above but can't avoid a race 
     between SetVariable() in a write callback and GetNextVariable() in a workqueue.
     It is not guaranteed by EFI specification.

     EFI 2.3.1 specification, page 217. 
     <snip>
     Calls to SetVariable() between calls to
     GetNextVariableName() may produce unpredictable results.
     <snip>


 (2) Don't support sysfs entries in efi_pstore.

     Another idea is _not_ updating sysfs entries at all in efi_pstore.
     This can avoid a race SetVariable() and GetNextVariable().

     write callback
       - simply write a new entry with SetVariable().
         - This fits a discussion about holding multiple logs in a thread below.
           http://marc.info/?l=linux-kernel&m=134316268011854&w=2 

     erase callback
       - simply erase an existing entry with SetVariable().

     read callback
       - Scaning existing entries with GetNextVariable().
         We can avoid a race between GetNextVariable() in a read callback 
         and SetVariable() in a write/erase callback by protecting them with efi_lock.

 IMO, idea (2) is reasonable because we already have an interface, /dev/pstore, which users can access
 to NVRAM and we don't need to support multiple user interfaces.

Any comments are welcome.

Seiji
