Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936593Ab2C3Wo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:44:59 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:38192 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab2C3Woq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:44:46 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Satoru Moriya <satoru.moriya@hds.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 30 Mar 2012 18:44:27 -0400
Subject: RE: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Acz8hm0oQRgcCvB0QPGLerP2npY00AAB+mfQBI4GKcA=
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C01454D13A6@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
 <20120305215602.GA1693@redhat.com> <4F5798B1.5070005@jp.fujitsu.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1203300268
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kosaki-san,

On 03/07/2012 01:18 PM, Satoru Moriya wrote:
> On 03/07/2012 12:19 PM, KOSAKI Motohiro wrote:
>> Thank you. I brought back to memory it. Unfortunately DB folks are 
>> still mainly using RHEL5 generation distros. At that time, 
>> swapiness=0 doesn't mean disabling swap.
>>
>> They want, "don't swap as far as kernel has any file cache page". but 
>> linux don't have such feature. then they used swappiness for emulate 
>> it. So, I think this patch clearly make userland harm. Because of, we 
>> don't have an alternative way.

As I wrote in the previous mail(see below), with this patch
the kernel begins to swap out when the sum of free pages and
filebacked pages reduces less than watermark_high.

So the kernel reclaims pages like following.

nr_free + nr_filebacked >= watermark_high: reclaim only filebacked pages
nr_free + nr_filebacked <  watermark_high: reclaim only anonymous pages

Do you think this behavior satisfies DB users' requirement?


> If they expect the behavior that "don't swap as far as kernel has any 
> file cache page", this patch definitely helps them because if we set 
> swappiness==0, kernel does not swap out
> *until* nr_free + nr_filebacked < high watermark in the zone.
> It means kernel begins to swap out when nr_free + nr_filebacked 
> becomes less than high watermark.
> 
> But, yes, this patch actually changes the behavior with swappiness==0 
> and so it may make userland harm.
> 
> How about introducing new value e.g -1 to avoid swap and maintain 
> compatibility?

Regards,
Satoru
