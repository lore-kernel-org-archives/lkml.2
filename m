Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab2AMWvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:51:52 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:50853 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMWvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:51:50 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>
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
Date: Fri, 13 Jan 2012 17:50:54 -0500
Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC)
 below smp_send_stop()
Thread-Index: AQHMy9CqWb3Eal+luUidUg+JrwynPJX+IWHAgAAOOECAAJk+gIAGFpuAgACYuICAASNngIAAuA6AgACm9AD//5HLQIADWlqQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C58394A08@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
 <20120105210123.GI5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
 <4F0BAB33.2090201@linux.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
 <4F0D3A0B.4090709@linux.intel.com> <20120111172544.GS5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>
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
 definitions=main-1201130258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0DMq3kl031992

Tony, 

I understand you are seriously concerned about reliability of pstore.
And I'm in the same position.

But I still suggest to move kmsg_dump() below smp_send_stop().

>The 20% of me that isn't buying this
>still has worries that smp_send_stop() might fail in one of several ways:
>1) Fails to actually stop one or more other cpus (this is similar to our
>current situation where other cpus may interfere with us saving kmsg in
>pstore).

I don't understand this case. Have you ever experienced some specific cases 
failing to stop cpus?

As for x86, this case will never happen if not cpus are broken.

>2) Causes another fault, thus recursively entering the panic path.
>3) Hangs - causing us to miss saving to pstore.

These concerns are not just smp_send_stop().

In panic(), there are some function calls above kmsg_dump(). 
 Ex. dump_stack(), printk(), crash_kexec()....
If they panic/hang, same issues will happen.

So, 2) and 3) are not reasonable reasons for rejecting to move kmsg_dump() below smp_send_stop().

>
>I don't know what can be done to resolve this - it is hard to make a
>100% convincing argument about the execution of any code in the panic
>path.

One of the ways we have confidence is doing more testing.
As for kdump, LKDTM is used for checking regressions of kdump.

If pstore works with LKDTM, we can prove that pstore has minimal reliabliy.
(I don't know if we need additional testing at this time.)

Seiji

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
