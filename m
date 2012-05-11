Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab2EKVL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:11:57 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:44032 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab2EKVLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:11:55 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Satoru Moriya <satoru.moriya@hds.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 11 May 2012 17:11:35 -0400
Subject: RE: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Ac0SibtX7j/6MI5MS9Ch6BlzO39vIQMyoA0gBBmNc9A=
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C01583B4D7C@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
 <20120305215602.GA1693@redhat.com> <4F5798B1.5070005@jp.fujitsu.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com>
 <65795E11DBF1E645A09CEC7EAEE94B9C01454D13A6@USINDEVS02.corp.hds.com>
 <CAHGf_=p9OgVC9J-Nh78CTbuMbc9CVt-+-G+CNbYUsgz70Uc8Qg@mail.gmail.com>
 <4F7ADE1A.2050004@redhat.com> <4F7C870B.6020807@gmail.com>
 <65795E11DBF1E645A09CEC7EAEE94B9C014575D8CF@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C014575D8CF@USINDEVS02.corp.hds.com>
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
 definitions=main-1205110220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 08:21 PM, Satoru Moriya wrote:
> On 04/04/2012 01:38 PM, KOSAKI Motohiro wrote:
>> (4/3/12 4:25 AM), Jerome Marchand wrote:
>>> On 04/02/2012 07:10 PM, KOSAKI Motohiro wrote:
>>>> 2012/3/30 Satoru Moriya<satoru.moriya@hds.com>:
>>>>> So the kernel reclaims pages like following.
>>>>>
>>>>> nr_free + nr_filebacked>= watermark_high: reclaim only filebacked pages
>>>>> nr_free + nr_filebacked<   watermark_high: reclaim only anonymous pages
>>>>
>>>> How?
>>>
>>> get_scan_count() checks that case explicitly:
>>>
>>>     if (global_reclaim(sc)) {
>>>         free  = zone_page_state(mz->zone, NR_FREE_PAGES);
>>>         /* If we have very few page cache pages,
>>>            force-scan anon pages. */
>>>         if (unlikely(file + free<= high_wmark_pages(mz->zone))) {
>>>             fraction[0] = 1;
>>>             fraction[1] = 0;
>>>             denominator = 1;
>>>             goto out;
>>>         }
>>>     }
>>
>> Eek. This is silly. Nowaday many people enabled THP and it increase zone watermark.
>> so, high watermask is not good threshold anymore.
> 
> Ah yes, it is not so small now.
> On 4GB server, without THP min_free_kbytes is 8113 but with THP it is 
> 67584.
> 
> How about using low watermark or min watermark?
> Are they still big?
> 
> ...or should we use other value? 

What do you think of the idea above?

By the way, I'd like to discuss this topic in other thread
because discussion about optimal threshold where the kernel
changes its reclaim policy does not affect only swappiness==0
case but also all other settings. 

So, I propose that we start with applying this patch first
and then discuss/improve the threshold.

The patch may not be perfect but, at least, we can improve
the kernel behavior in the enough filebacked memory case
with this patch. I believe it's better than nothing.

Regards,
Satoru
