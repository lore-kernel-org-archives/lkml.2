Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0IGOX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:23:58 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:30793 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751152Ab0IGOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:23:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Hrc_3PYVM1lW4LsQMjDQqnEbxUMf3e.A595KKJ5hn0Og6M2
 _e2ekFJjq70qHexQ7jOEn9k.4kpubAMBm.iZDv0dPC1_GInZTWliqyUlpVbf
 RgdCNTMpEeeKJbfQkvDS0H_x2HARbKTiNA6acWBvb62WqCi1124ML8E2Oont
 GzMpRjkUTSY9SmAD88.WhJEle_XGLJy_cUV9tkTxa0elpKdq5dkjKcrjn60g
 x
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Sep 2010 09:23:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Chinner <david@fromorbit.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct
 reclaim allocation fails
In-Reply-To: <20100906040243.GA7362@dastard>
Message-ID: <alpine.DEB.2.00.1009070918030.14634@router.home>
References: <20100903160026.564fdcc9.akpm@linux-foundation.org> <20100904022545.GD705@dastard> <20100903202101.f937b0bb.akpm@linux-foundation.org> <20100904075840.GE705@dastard> <20100904081414.GF705@dastard> <20100905015400.GA10714@localhost>
 <20100905021555.GG705@dastard> <20100905060539.GA17450@localhost> <20100905131447.GJ705@dastard> <20100905134554.GA7083@localhost> <20100906040243.GA7362@dastard>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010, Dave Chinner wrote:

> [  596.628086]  [<ffffffff81108a8c>] ? drain_all_pages+0x1c/0x20
> [  596.628086]  [<ffffffff81108fad>] ? __alloc_pages_nodemask+0x42d/0x700
> [  596.628086]  [<ffffffff8113d0f2>] ? kmem_getpages+0x62/0x160
> [  596.628086]  [<ffffffff8113dce6>] ? fallback_alloc+0x196/0x240

fallback_alloc() showing up here means that one page allocator call from
SLAB has already failed. SLAB then did an expensive search through all
object caches on all nodes to find some available object. There were no
objects in queues at all therefore SLAB called the page allocator again
(kmem_getpages()).

As soon as memory is available (on any node or any cpu, they are all
empty) SLAB will repopulate its queues(!).

