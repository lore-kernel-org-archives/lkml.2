Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1JUVTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:19:51 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:38501 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1JUVTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:19:50 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Don Zickus <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 21 Oct 2011 17:19:04 -0400
Subject: [RFC][PATCH v2 -next 0/2] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Topic: [RFC][PATCH v2 -next 0/2] make pstore/kmsg_dump run after
 stopping other cpus in panic path
Thread-Index: AcyQNw89n12xggQmR/WpacFE5kCaEQ==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A6@USINDEVS01.corp.hds.com>
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
 definitions=main-1110210252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 As Don mentioned in following thread, it would be nice for pstore/kmsg_dump to serialize 
 panic path and have one cpu running  because they can log messages reliably. 
 
 https://lkml.org/lkml/2011/10/13/427
 
 For realizing this idea, we have to move kmsg_dump below smp_send_stop() and bust some locks of 
 kmsg_dump/pstore in panic path. Also, we have to care about NMI interrupt.

Changelog:
 v2
  - Adding trylocks to kmsg_dump()/pstore_dump() so that they can work in NMI context.  
  - Dividing a patch into two. 
     First one is just moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop().
     Second one is changing lock operations in kmsg_dump()/pstore_dump().
 v1
  - moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop.
  - busting logbuf_lock of kmsg_dump() in panic path for avoiding deadlock.
  - busting psinfo->buf_lock of pstore_dump() in panic path for avoiding deadlock.

Patch Descriptions:
[RFC][PATCH -next v2 1/2] Moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()
  - moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop for serializing logging 
    process via smp_send_stop.

[RFC][PATCH v2 -next 2/2] Adding lock operations to kmsg_dump()/pstore_dump()
  Adding a lock operation below in pstore_dump()
  - busting psinfo->buf_lock of pstore_dump() in panic path for avoiding deadlock.

  Adding lock operations below in kmsg_dump()
  - busting logbuf_lock of kmsg_dump() in panic path for avoiding deadlock.
  - Adding trylock for taking logbuf_lock of kmsg_dump() in NMI context. 

Seiji
