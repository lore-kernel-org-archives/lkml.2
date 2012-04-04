Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2DDRiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:38:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38051 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2DDRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:38:19 -0400
Message-ID: <4F7C870B.6020807@gmail.com>
Date: Wed, 04 Apr 2012 10:38:19 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>, kosaki.motohiro@gmail.com
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com> <20120305215602.GA1693@redhat.com> <4F5798B1.5070005@jp.fujitsu.com> <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com> <65795E11DBF1E645A09CEC7EAEE94B9C01454D13A6@USINDEVS02.corp.hds.com> <CAHGf_=p9OgVC9J-Nh78CTbuMbc9CVt-+-G+CNbYUsgz70Uc8Qg@mail.gmail.com> <4F7ADE1A.2050004@redhat.com>
In-Reply-To: <4F7ADE1A.2050004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/3/12 4:25 AM), Jerome Marchand wrote:
> On 04/02/2012 07:10 PM, KOSAKI Motohiro wrote:
>> 2012/3/30 Satoru Moriya<satoru.moriya@hds.com>:
>>> Hello Kosaki-san,
>>>
>>> On 03/07/2012 01:18 PM, Satoru Moriya wrote:
>>>> On 03/07/2012 12:19 PM, KOSAKI Motohiro wrote:
>>>>> Thank you. I brought back to memory it. Unfortunately DB folks are
>>>>> still mainly using RHEL5 generation distros. At that time,
>>>>> swapiness=0 doesn't mean disabling swap.
>>>>>
>>>>> They want, "don't swap as far as kernel has any file cache page". but
>>>>> linux don't have such feature. then they used swappiness for emulate
>>>>> it. So, I think this patch clearly make userland harm. Because of, we
>>>>> don't have an alternative way.
>>>
>>> As I wrote in the previous mail(see below), with this patch
>>> the kernel begins to swap out when the sum of free pages and
>>> filebacked pages reduces less than watermark_high.
>
> Actually, this is true only for global reclaims. Reclaims in cgroup can fail
> in this case.
>
>>>
>>> So the kernel reclaims pages like following.
>>>
>>> nr_free + nr_filebacked>= watermark_high: reclaim only filebacked pages
>>> nr_free + nr_filebacked<   watermark_high: reclaim only anonymous pages
>>
>> How?
>
> get_scan_count() checks that case explicitly:
>
> 	if (global_reclaim(sc)) {
> 		free  = zone_page_state(mz->zone, NR_FREE_PAGES);
> 		/* If we have very few page cache pages,
> 		   force-scan anon pages. */
> 		if (unlikely(file + free<= high_wmark_pages(mz->zone))) {
> 			fraction[0] = 1;
> 			fraction[1] = 0;
> 			denominator = 1;
> 			goto out;
> 		}
> 	}

Eek. This is silly. Nowaday many people enabled THP and it increase zone watermark.
so, high watermask is not good threshold anymore.





