Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1IBRQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:16:05 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:46446 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1IBRQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:16:01 -0400
X-Greylist: delayed 2629 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Sep 2011 13:16:01 EDT
From: Satoru Moriya <satoru.moriya@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Fri, 2 Sep 2011 12:31:14 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: Acxo8lfuHB0gMHZ2TYComoolH0i7LQAmvWxw
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CAFB42677@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
 <20110901145819.4031ef7c.akpm@linux-foundation.org>
In-Reply-To: <20110901145819.4031ef7c.akpm@linux-foundation.org>
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
 definitions=main-1109020166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 05:58 PM, Andrew Morton wrote:
> On Thu, 1 Sep 2011 15:26:50 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
>> Add a userspace visible knob
> 
> argh.  Fear and hostility at new knobs which need to be maintained for 
> ever, even if the underlying implementation changes.
> 
> Unfortunately, this one makes sense.
> 
>> to tell the VM to keep an extra amount of memory free, by increasing 
>> the gap between each zone's min and low watermarks.
>>
>> This is useful for realtime applications that call system calls and 
>> have a bound on the number of allocations that happen in any short 
>> time period.  In this application, extra_free_kbytes would be left at 
>> an amount equal to or larger than the maximum number of 
>> allocations that happen in any burst.
> 
> _is_ it useful?  Proof?
> 
> Who is requesting this?  Have they tested it?  Results?

This is interesting for me.

Some of our customers have realtime applications and they are concerned 
the fact that Linux uses free memory as pagecache. It means that
when their application allocate memory, Linux kernel tries to reclaim
memory at first and then allocate it. This may make memory allocation
latency bigger.

In many cases this is not a big issue because Linux has kswapd for
background reclaim and it is fast enough not to enter direct reclaim
path if there are a lot of clean cache. But under some situations -
e.g. Application allocates a lot of memory which is larger than delta
between watermark_low and watermark_min in a short time and kswapd
can't reclaim fast enough due to dirty page reclaim, direct reclaim
is executed and causes big latency.

We can avoid the issue above by using preallocation and mlock.
But it can't cover kmalloc used in systemcall. So I'd like to use
this patch with mlock to avoid memory allocation latency issue as
low as possible. It may not be a perfect solution but it is important
for customers in enterprise area to configure the amount of free
memory at their own risk.

Anyway, now I'm testing this patch and will report a test result later.

Thanks,
Satoru
