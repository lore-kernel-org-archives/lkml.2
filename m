Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2JWK0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:26:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab2JWK03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:26:29 -0400
Date: Tue, 23 Oct 2012 12:26:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: mmotm 2012-10-22-17-08 uploaded (memory_hotplug.c)
Message-ID: <20121023102625.GA24265@dhcp22.suse.cz>
References: <20121023000924.C56EF5C0050@hpza9.eem.corp.google.com>
 <50861FA9.2030506@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50861FA9.2030506@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-10-12 21:40:09, Randy Dunlap wrote:
> On 10/22/2012 05:09 PM, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2012-10-22-17-08 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> 
> 
> 
> on x86_64, when CONFIG_MEMORY_HOTREMOVE is not enabled:
> 
> mm/built-in.o: In function `online_pages':
> (.ref.text+0x10e7): undefined reference to `zone_pcp_reset'

Caused by memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch.
And fixed by. Andrew either fold this one in to the above one or keep it
separate what works better with you.
---
>From e8d79e446b00e57c195c59570df0f2ec435ca39d Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 23 Oct 2012 11:07:11 +0200
Subject: [PATCH] mm: make zone_pcp_reset independ on MEMORY_HOTREMOVE

340175b7 (mm/hotplug: free zone->pageset when a zone becomes empty)
introduced zone_pcp_reset and hided it inside CONFIG_MEMORY_HOTREMOVE.
Since "memory-hotplug: allocate zone's pcp before onlining pages" the
function is also called from online_pages which is defined outside
CONFIG_MEMORY_HOTREMOVE which causes a linkage error.

The function, although not used outside of MEMORY_{HOTPLUT,HOTREMOVE},
seems like universal enough so let's keep it at its current location
and only remove the HOTREMOVE guard.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e29912e..30e359c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5981,7 +5981,6 @@ void __meminit zone_pcp_update(struct zone *zone)
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
@@ -6001,6 +6000,7 @@ void zone_pcp_reset(struct zone *zone)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
  */
-- 
1.7.10.4


-- 
Michal Hocko
SUSE Labs
