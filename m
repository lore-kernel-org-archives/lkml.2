Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1BJSgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:36:16 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:57678 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1BJSgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:36:13 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: Rik van Riel <riel@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Thu, 10 Feb 2011 13:30:13 -0500
Subject: RE: [RFC][PATCH 0/2] Tunable watermark
Thread-Topic: [RFC][PATCH 0/2] Tunable watermark
Thread-Index: Acu5AK3GsmLTZakiSO+PDEcYSuvYvgPtnn3A
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C3BCD59E6@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com>
 <4D38D070.2050802@redhat.com>
In-Reply-To: <4D38D070.2050802@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1AIaLoG028150

On 01/20/2011 07:16 PM, Rik van Riel wrote:
> On 01/07/2011 05:03 PM, Satoru Moriya wrote:
> 
> > The result is following.
> >
> >                   | default |  case 1   |  case 2 |
> > ----------------------------------------------------------
> > wmark_min_kbytes  |  5752   |    5752   |   5752  |
> > wmark_low_kbytes  |  7190   |   16384   |  32768  | (KB)
> > wmark_high_kbytes |  8628   |   20480   |  40960  |
> > ----------------------------------------------------------
> > real              |   503   |    364    |    337  |
> > user              |     3   |      5    |      4  | (msec)
> > sys               |   153   |    149    |    146  |
> > ----------------------------------------------------------
> > page fault        |  32768  |  32768    |  32768  |
> > kswapd_wakeup     |   1809  |    335    |    228  | (times)
> > direct reclaim    |      5  |      0    |      0  |
> >
> > As you can see, direct reclaim was performed 5 times and
> > its exec time was 503 msec in the default case. On the other
> > hand, in case 1 (large delta case ) no direct reclaim was
> > performed and its exec time was 364 msec.
> 
> Saving 1.5 seconds on a one-off workload is probably not
> worth the complexity of giving a system administrator
> yet another set of tunables to mess with.

Above table shows average data but they might not be enough.
In a low-latency enterprise system, worst latency is the most
important. I recorded worst latency data per one page allocation
and here it is.

                    | default |  case 1   |  case 2 |
----------------------------------------------------------
worst latency       |   223   |    75     |    50   | (usec)  
 per one page alloc |         |           |         |

In the default case, the worst latency is 223 usec and at that time
direct reclaim occurred. OTOH our target latency is under 100 usec.
So I'd like to ensure that direct reclaim is never executed in a certain
situation.

> However, I suspect it may be a good idea if the kernel
> could adjust these watermarks automatically, since direct
> reclaim could lead to quite a big performance penalty.
> 
> I do not know which events should be used to increase and
> decrease the watermarks, but I have some ideas:
> - direct reclaim (increase)
> - kswapd has trouble freeing pages (increase)
> - kswapd frees enough memory at DEF_PRIORITY (decrease)
> - next to no direct reclaim events in the last N (1000?)
>    reclaim events (decrease)

I think it might be good idea but not enough because we can't avoid
direct reclaim completely. So what do you think of introducing a learning
mode to your idea? In the learning mode, kernel calculates appropriate
watermarks and next boot users use them.

It is useful for a enterprise system because we normally do performance/stress
tests and tune it before release. If we run stress tests under the learning mode,
we can get the appropriate watermarks for that system. By using them we can avoid
direct reclaim and keep latency low enough in a product system.

> I guess we will also need to be sure that the watermarks
> are never raised above some sane upper threshold.  Maybe
> 4x or 5x the default?
> 
> 
> --
> All rights reversed
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
