Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159Ab2CGSVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:21:20 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:49875 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab2CGSVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:21:19 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Wed, 7 Mar 2012 13:18:56 -0500
Subject: RE: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Acz8hm0oQRgcCvB0QPGLerP2npY00AAB+mfQ
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
 <20120305215602.GA1693@redhat.com> <4F5798B1.5070005@jp.fujitsu.com>
In-Reply-To: <4F5798B1.5070005@jp.fujitsu.com>
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
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1203070175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 12:19 PM, KOSAKI Motohiro wrote:
> On 3/5/2012 4:56 PM, Johannes Weiner wrote:
>> On Fri, Mar 02, 2012 at 12:36:40PM -0500, Satoru Moriya wrote:
>>>
>>> This patch changes the behavior with swappiness==0. If we set 
>>> swappiness==0, the kernel does not swap out completely (for global 
>>> reclaim until the amount of free pages and filebacked pages in a 
>>> zone has been reduced to something very very small (nr_free + 
>>> nr_filebacked < high watermark)).
>>>
>>> Any comments are welcome.
>>
>> Last time I tried that (getting rid of sc->may_swap, using 
>> !swappiness), it was rejected it as there were users who relied on 
>> swapping very slowly with this setting.
>>
>> KOSAKI-san, do I remember correctly?  Do you still think it's an 
>> issue?
>>
>> Personally, I still think it's illogical that !swappiness allows 
>> swapping and would love to see this patch go in.
> 
> Thank you. I brought back to memory it. Unfortunately DB folks are 
> still mainly using RHEL5 generation distros. At that time, swapiness=0 
> doesn't mean disabling swap.
> 
> They want, "don't swap as far as kernel has any file cache page". but 
> linux don't have such feature. then they used swappiness for emulate 
> it. So, I think this patch clearly make userland harm. Because of, we 
> don't have an alternative way.

If they expect the behavior that "don't swap as far as kernel
has any file cache page", this patch definitely helps them
because if we set swappiness==0, kernel does not swap out
*until* nr_free + nr_filebacked < high watermark in the zone.
It means kernel begins to swap out when nr_free + nr_filebacked
becomes less than high watermark.

But, yes, this patch actually changes the behavior with
swappiness==0 and so it may make userland harm. 

How about introducing new value e.g -1 to avoid swap and
maintain compatibility?

Regards,
Satoru
