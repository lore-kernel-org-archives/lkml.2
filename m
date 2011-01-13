Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab1AMWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:09:27 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:59956 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1AMWJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:09:16 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Thu, 13 Jan 2011 17:05:20 -0500
Subject: RE: [RFC][PATCH 0/2] Tunable watermark
Thread-Topic: [RFC][PATCH 0/2] Tunable watermark
Thread-Index: Acuuu82/VOb/4ZEzRnC46n2ULWlfCQEsepZA
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C3B8DF647@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com>
 <alpine.DEB.2.00.1101071416450.23577@chino.kir.corp.google.com>
 <AANLkTikQPXWkEJwN5fV2vnUS37Fs+GNzFXuFkKXcnzmu@mail.gmail.com>
 <alpine.DEB.2.00.1101071436220.23858@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1101071436220.23858@chino.kir.corp.google.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 05:39 PM, David Rientjes wrote:

> The semantics of any watermark is to trigger events to happen at a 
> specific level, so they should be static with respect to a frame of 
> reference (which in the VM case is the min watermark with respect to the 
> size of the zone).  If you're going to adjust the min watermark, it's then 
> _mandatory_ to adjust the others to that frame of reference, you shouldn't 
> need to tune them independently.

Currently watermark[low,high] are set by following calculation (lowmem case).

watermark[low]  = watermark[min] * 1.25
watermark[high] = watermark[min] * 1.5

So the difference between watermarks are following:

min <-- min/4 --> low <-- min/4 --> high

I think the differences, "min/4", are too small in my case.
Of course I can make them bigger if I set min_free_kbytes to bigger value. 
But it means kernel keeps more free memory for PF_MEMALLOC case unnecessarily.

So I suggest changing coefficients(1.25, 1.5). Also it's better
to make them accessible from user space to tune in response to application
requirements.

> The problem that Satoru is reporting probably has nothing to do with the 
> watermarks themselves but probably requires more aggressive action by 
> kswapd and/or memory compaction.

More aggressive action may reduce the possibility of the problem reported.
But we can't avoid the problem completely because applications may
allocate/access faster than reclaiming/compaction.

