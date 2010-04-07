Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0DGAGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:06:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213Ab0DGAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:06:23 -0400
Date: Tue, 6 Apr 2010 17:05:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 09/14] Add /proc trigger for memory compaction
Message-Id: <20100406170555.1efe35b0.akpm@linux-foundation.org>
In-Reply-To: <1270224168-14775-10-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-10-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 17:02:43 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
> value is written to the file,

Might be better if "when the number 1 is written...".  That permits you
to add 2, 3 and 4 later on.

> all zones are compacted. The expected user
> of such a trigger is a job scheduler that prepares the system before the
> target application runs.
> 

Ick.  The days of multi-user computers seems to have passed.

> ...
>
> +/* Compact all zones within a node */
> +static int compact_node(int nid)
> +{
> +	int zoneid;
> +	pg_data_t *pgdat;
> +	struct zone *zone;
> +
> +	if (nid < 0 || nid >= nr_node_ids || !node_online(nid))
> +		return -EINVAL;
> +	pgdat = NODE_DATA(nid);
> +
> +	/* Flush pending updates to the LRU lists */
> +	lru_add_drain_all();
> +
> +	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
> +		struct compact_control cc;
> +
> +		zone = &pgdat->node_zones[zoneid];
> +		if (!populated_zone(zone))
> +			continue;
> +
> +		cc.nr_freepages = 0;
> +		cc.nr_migratepages = 0;
> +		cc.zone = zone;

It would be better to do

	struct compact_control cc = {
		.nr_freepages = 0,
		etc

because if you later add more fields to compact_control, everything
else works by magick.  That's served us pretty well with
writeback_control, scan_control, etc.
	
> +		INIT_LIST_HEAD(&cc.freepages);
> +		INIT_LIST_HEAD(&cc.migratepages);
> +
> +		compact_zone(zone, &cc);
> +
> +		VM_BUG_ON(!list_empty(&cc.freepages));
> +		VM_BUG_ON(!list_empty(&cc.migratepages));
> +	}
> +
> +	return 0;
> +}
> +
> +/* Compact all nodes in the system */
> +static int compact_nodes(void)
> +{
> +	int nid;
> +
> +	for_each_online_node(nid)
> +		compact_node(nid);

What if a node goes offline?

> +	return COMPACT_COMPLETE;
> +}
> +
>
> ...
