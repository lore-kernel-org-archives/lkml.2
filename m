Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1JQOLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:11:18 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:55252 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1JQOLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:11:16 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 17 Oct 2011 10:10:26 -0400
Subject: RE: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Topic: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Index: AcyMlRE8F5tlsuxeR9C2VaoDoFlzmgAPWYKw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5747E157@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <4E9BC972.8010909@linux.intel.com>
In-Reply-To: <4E9BC972.8010909@linux.intel.com>
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
 definitions=main-1110170134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9HEBQRN000798

Hi,

Thank you for giving me a comment.

>I have a stupid question: since you have serialized the process procedure via
>smp_send_stop, why still using spin_lock_xxx? Maybe preempt_disable/enable is
>enough?


I added spin_lock_init() in panic path for sharing code with other triggers 
such as oops/reboot/emergency_restart because they still need spin_locks.

Do you suggest following code?

<snip>
If(!panic)
	spin_lock_irqsave();

     .
     .
If(!panic)
	spin_unlock_restore();
<snip>

I don't stick to current patch.
So I will resend a patch above if you request.

Regarding as preempt_disable/enable, we don't need to call them in panic path because they are
called at the beginning of panic().

	<snip>
	60 NORET_TYPE void panic(const char * fmt, ...)  
	61 {  
	62         static char buf[1024];  
	63         va_list args;  
	64         long i, i_next = 0;  
	65         int state = 0;  
	66   
	67         /*  
	68          * It's possible to come here directly from a panic-assertion and  
	69          * not have preempt disabled. Some functions called from here want  
	70          * preempt to be disabled. No point enabling it later though...  
	71          */  
	72         preempt_disable();
	<snip>

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
