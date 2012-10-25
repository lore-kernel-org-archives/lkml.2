Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992604Ab2JYUEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:04:09 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:51749 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992551Ab2JYUEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:04:06 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from
 a write callback to hold multiple logs
Thread-Topic: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from
 a write callback to hold multiple logs
Thread-Index: Ac2yU45Umwbisi8ERWqdMazeX7tkNwAs24eAAAdb8lA=
Date: Thu, 25 Oct 2012 20:03:49 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413889851@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
 <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com>
In-Reply-To: <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-25_02:2012-10-25,2012-10-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210250253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -               list_del(&found->list);
> > +       sprintf(name, "dump-type%u-%u-%lu", type, part,
> > +               get_seconds());
> 
> Actually, nothing seems to be ensuring that the value used here ends up being the same as the ctime :\  Consider what happens if the
> get_seconds() call here happens at second N, and the i_ctime is collected at time N+1. The object wouldn't be able to be deleted after
> patch 4/5 is applied.  How can we better ensure that the i_ctime is the same value as serialized into the efi var name here?

 i_ctime of pstore file system is different from normal file systems.
As I said in patch v1, i_ctime of pstore means the date that the record was "originally" stored.
 
I_ctime is always set to N.
Here is the scenario.

1.  writing time
    - get_seconds() call here happens at second N
    - "N" is stored to a variable name

2. System reboots...
3. System boots up...

4. reading time
   - pstore calls a read callback, efi_pstore_read()
   -  efi_pstore_read extracts ctime, "N", from the virable name
   -  efi_pstore passes "N" to pstore file system
    - pstore create a file, /dev/pstore/dmesg* and set "N" to i_ctime

Pstore file system doesn't set i_ctime by itself but set ctime passed by platform drivers.

Seiji
