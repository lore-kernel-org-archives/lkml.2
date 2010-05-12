Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0ELF5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:57:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58498 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0ELF5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:57:38 -0400
Message-ID: <4BEA434E.3030403@jp.fujitsu.com>
Date: Wed, 12 May 2010 14:57:34 +0900
From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com
CC: linux-kernel@vger.kernel.org, kusumi.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH] fix hard-coded disk header chunk size for persistent
 snapshot
References: <4BEA0472.1060300@jp.fujitsu.com> <20100512013909.GD2377@agk-dp.fab.redhat.com> <Pine.LNX.4.64.1005120055020.1551@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1005120055020.1551@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/05/12 13:58), Mikulas Patocka wrote:
>
>
> On Wed, 12 May 2010, Alasdair G Kergon wrote:
>
>> On Wed, May 12, 2010 at 10:29:22AM +0900, Tomohiro Kusumi wrote:
>>> This patch fixes hard-coded value for the size of a chunk that includes
>>> disk header for persistent snapshot. It should be changed to existing
>>> macro NUM_SNAPSHOT_HDR_CHUNKS instead of using hard-coded value 1.
>>
>> Any more places too?  (E.g. persistent_commit_merge)
>>
>> Alasdair
>
> I think the expression in persistent_commit_merge should be changed to:
> ps->next_free = area_location(ps, ps->current_area) +
>                  ps->current_committed + 1;
>
> It is numerically the same, but will avoid trouble if
> NUM_SNAPSHOT_HDR_CHUNKS is increased.
>
> Mikulas
>
>

agree,

a single chunk is large enough to contain 16byte disk header
which does not seem necessary to increase NUM_SNAPSHOT_HDR_CHUNKS in the future
(unless whole structure get totally changed),
but it should also get fixed to avoid trouble.

I merged it to the patch with your names signed off.

Thanks,
Tomohiro Kusumi


Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---

diff -aNur linux-2.6.34-rc7.org/drivers/md/dm-snap-persistent.c linux-2.6.34-rc7/drivers/md/dm-snap-persistent.c
--- linux-2.6.34-rc7.org/drivers/md/dm-snap-persistent.c	2010-05-10 10:36:28.000000000 +0900
+++ linux-2.6.34-rc7/drivers/md/dm-snap-persistent.c	2010-05-12 14:49:13.000000000 +0900
@@ -266,7 +266,7 @@
   */
  static chunk_t area_location(struct pstore *ps, chunk_t area)
  {
-	return 1 + ((ps->exceptions_per_area + 1) * area);
+	return NUM_SNAPSHOT_HDR_CHUNKS + ((ps->exceptions_per_area + 1) * area);
  }
  
  /*
@@ -780,8 +780,8 @@
  	 * ps->current_area does not get reduced by prepare_merge() until
  	 * after commit_merge() has removed the nr_merged previous exceptions.
  	 */
-	ps->next_free = (area_location(ps, ps->current_area) - 1) +
-			(ps->current_committed + 1) + NUM_SNAPSHOT_HDR_CHUNKS;
+	ps->next_free = area_location(ps, ps->current_area) +
+			ps->current_committed + 1;
  
  	return 0;
  }

