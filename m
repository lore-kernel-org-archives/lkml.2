Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab1GSSYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:24:44 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:37878 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GSSYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:24:43 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 19 Jul 2011 14:23:26 -0400
Subject: [RFC][PATCH -mmotm 0/4] Improvement of pstore/kmsg_dump in
 kexec/panic path
Thread-Topic: [RFC][PATCH -mmotm 0/4] Improvement of pstore/kmsg_dump in
 kexec/panic path
Thread-Index: AcxGQPNfkgYolSqJQyKgeplzzN4MfQ==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C2@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Upstream status]
   Discussion about kmsg_dump() in kdump path: 
    - Eric and Vivek are worried about reliability of existing kmsg_dump().
    - Especially, Vivek would like to remove a RCU  function call chain in kdump path
　　　 which kernel modules can register their function calls freely. 

   Discussion about pstore in nmi_hander.
    - Don Zickus found an issue of pstore in nmi_handler due to its mutex_lock.
    

[Build Status]
  Built this patch on 3.0.0-rc6-mm1 in x86_64.

[Patch Description]

 For meeting Eric/Vivek's requirements and solving an issue of pstore in nmi_hander due to mutex_lock,
 I propose following patches.

  [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to kexec path

        Some people who are not familiar with kexec may add function calls getting 
        spin_lock/mutex_lock in kexec path. These function calls causes failure of kexec. 
        So, I suggest replace a call chain with static function calls so that we can keep 
        reliability of kexec.

        APEI storage backend will work well in kexec path by applying this patch.

        Summary of this patch:
        - Call pstore_kmsg_dump_in_interrupt() directly in kexec path
        - Remove mutex_lock in pstore_dump() of kexec path

  [RFC][PATCH -mmotm 2/4] Remove mutex_lock from pstore in panic path

        Pstore must not take mutex_lock in panic path as well as kexec path 
        because panic() is called in interrupt context like nmi_handler.
        APEI storage backend will work well in panic path with this patch.

        Summary of this patch:
        - Remove kmsg_dump(KMSG_DUMP_PANIC)
        - Call pstore_kmsg_dump_in_interrupt() directly in panic path
        - Remove mutex_lock in pstore_dump() of panic path

  [RFC][PATCH -mmotm 3/4] pstore: mtdoops support

        - Pstore can support mtdoops with this patch.

  [RFC][PATCH -mmotm 4/4] pstore: ramoops support

        - Pstore can support ramoops with this patch.
