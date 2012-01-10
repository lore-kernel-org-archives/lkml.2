Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2AJUa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:30:28 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:33575 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2AJUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:30:26 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Chen Gong <gong.chen@linux.intel.com>, "Luck, Tony" <tony.luck@intel.com>
CC: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Date: Tue, 10 Jan 2012 15:29:25 -0500
Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC)
 below smp_send_stop()
Thread-Index: AczPRN5VysxyAxzpS/qNaweMc6C1TQAkToUQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
 <20120105210123.GI5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
 <4F0BAB33.2090201@linux.intel.com>
In-Reply-To: <4F0BAB33.2090201@linux.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1201100214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0AKUfer012733


>I agree with you. How about adding macros or something like WARN_ON(XX_ARCH) or
>Kconfig to limit its scope?

Thank you for giving me your idea.
Your suggestions above will work for me because I'm a x86 user.
If Tony agrees to it, I can update my patch.

But, I'm hesitating to add WARN_ON() or change Kconfig only for specific arch 
because pstore aims for generic interface and this is related to its design.
Also, ramoops is going to use pstore now. It doesn't depend on x86.
I'm worried that ramoops users will complain about this change.

So, I think a reasonable solution at this time is just adding some explanations 
about smp_send_stop() to documentation as follows.

Users can use pstore with their own responsibility and ask developers 
if smp_send_stop() is reliable enough in panic situation on architecture they want to run.

What do you think?

---
 Documentation/ABI/testing/pstore |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing/pstore
index ff1df4e..5583729 100644
--- a/Documentation/ABI/testing/pstore
+++ b/Documentation/ABI/testing/pstore
@@ -11,6 +11,14 @@ Description:	Generic interface to platform dependent persistent storage.
 		of the console log is captured, but other interesting
 		data can also be saved.
 
+		In case of panic, pstore is invoked after smp_send_stop()
+		,a function call stopping other cpus, so that we can get
+		logs simpler and cleaner with just one running cpu.
+
+		As for x86, smp_send_stop() is reliable enough to work in
+		panic situation. But we are not guaranteed that it works
+		reliably on other architectures.
+
 		# mount -t pstore -o kmsg_bytes=8000 - /dev/pstore
 
 		$ ls -l /dev/pstore
-- 

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
