Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab2GRSx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:53:27 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:39804 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755592Ab2GRSxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:53:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Rny8aJ8VM1nhcBPGR4JjwiYWJXJb.a6fVCh5aB1jGgk9xrF
 xdDOt6xIcBmC9pa.wJxId7BOArgvhlF0Jr4ZSlIS2ASN5RBS8QlUJqpQFXis
 4_SX6qQrnZMEpk7Mr0oY.18sWp.YvlJr.P2QvV9OETkwTjuizw4GNkPAVEzi
 6q8QW63DazrwchKpHYEXCXZ0E7S62h35ed6e.zX0sNY8rvscBIwnAVe40cZJ
 8k1xOcnF24yCgT.MrW7w7EoPL6Ewlgd_9V_OybNs5vunNruMi9oM1ebCck4i
 KK0mG3i_dU4rsINAi1e5hjnUDI_q5qVRrjlkbTO23ULIC.7C_.VYBUWZ_59w
 yen02xPF.3yJvVUAlxBx8kU92gg2UBDzxtBqEic3DNTvvA3SmuzONBR0Lstf
 mMEmgF.EolXvHNms5RKUrdHd2M8bA6fyfym.k
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 18 Jul 2012 13:53:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <liuj97@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Jianguo Wu <wujianguo@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: fix a BUG_ON() when offlining a memory node
 and CONFIG_SLUB_DEBUG is on
In-Reply-To: <5006E9E6.2030004@gmail.com>
Message-ID: <alpine.DEB.2.00.1207181349370.22907@router.home>
References: <1342543816-10853-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207171237320.15177@router.home> <5006E9E6.2030004@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2012, Jiang Liu wrote:

> 	I found the previous analysis of the BUG_ON() issue is incorrect after
> another round of code review.
> 	The really issue is that function early_kmem_cache_node_alloc() calls
> inc_slabs_node(kmem_cache_node, node, page->objects) to increase the object
> count on local node no matter whether page is allocated from local or remote
> node. With current implementation it's OK because every memory node has normal
> memory so page is allocated from local node. Now we are working on a patch set
> to improve memory hotplug. The basic idea is to to let some memory nodes only
> host ZONE_MOVABLE zone, so we could easily remove the whole memory node when
> needed. That means some memory nodes have no ZONE_NORMAL/ZONE_DMA, and the page
> will be allocated from remote node in function early_kmem_cache_node_alloc().
> But early_kmem_cache_node_alloc() still increases object count on local node,
> which triggers the BUG_ON eventually when removing the affected memory node.

That does not work. If the node does only have ZONE_MOVABLE then no slab
object can be allocated from the zone. You need to modify the slab
allocators to not allocate a per node structure for those zones and forbit
all allocations from such a node. Actually that should already work
because only ZONE_NORMAL nodes should get a per node structure because
slab objects can only be allocated from ZONE_NORMAL.


