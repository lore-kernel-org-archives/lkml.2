Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1LSXiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:38:01 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:48614 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1LSXh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:37:59 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, "Luck, Tony" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 19 Dec 2011 18:37:03 -0500
Subject: RE: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Topic: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Index: Acy+kVWuU2fL5F7bQFi25L8QZU5ixwABq3bg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57FFA38E@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
 <20111212155827.GR1669@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE46F2@USINDEVS01.corp.hds.com>
 <0207C53569FE594381A4F2EB66570B2A018EFB83C4@orsmsx508.amr.corp.intel.com>
 <20111219210046.GG5650@redhat.com>
In-Reply-To: <20111219210046.GG5650@redhat.com>
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
 definitions=main-1112190275
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for coordinating discussion.

>Hitachi's whole goal behind
>kmsg_dump is to record every possible reason for rebooting the machine for
>inspection on reboot, I think if I understood Seiji privately.

Exactly.

>Now we have a scenario (though rare), where kmsg_dump can fail to save a
>dump because someone already has the lock.
>Seiji, has does this failure impact kmsg_dump's goal?

When we use EFI-enabled system, we can avoid this failure because
,as you can see below(spec of EFI 2.3), kernel in NMI can call set_variable 
runtime service even if previous call is busy.

<snip>
  7.1 Runtime Services Rules and Restrictions
  7.1.1 Exception for Machine Check, INIT, and NMI.
   .
   .
   .
  If the OS determines that the Machine Check is non-recoverable, the OS level handler may 
  ignore the normal restrictions and may invoke the runtime services described in Table 31 even 
  in the case where a previous call was busy. The system firmware will honor the new runtime 
  service call(s) and the operation of the previous interrupted call is not guaranteed. 
  Any interrupted runtime functions will not be restarted.
  The INIT and NMI events follow the same restrictions.
<snip>

So, next steps we should take are as follows.

 - Fix efi_pstore so "efivars->lock" in efi_pstore_write() skips in panic path.

 - Fix smp_send_stop() (or introduce new function call) 
   so that kmsg_dump(KMSG_DUMP_PANIC) is always called in NMI.

   Currently, panicked cpu sends NMI to all cpus other than itself in smp_send_stop() (with Don's patch).
   My suggestion is that panicked cpu sends NMI to itself and then it calls kmsg_dump(KMSG_DUMP_PANIC) in NMI.

Seiji
