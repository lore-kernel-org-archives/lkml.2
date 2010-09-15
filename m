Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0IODbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:31:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:40320 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IODbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:31:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,368,1280732400"; 
   d="scan'208";a="837724229"
Date: Wed, 15 Sep 2010 11:31:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Neil Brown <neilb@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Message-ID: <20100915033059.GA12542@localhost>
References: <20100915091118.3dbdc961@notabene>
 <4C90139A.1080809@redhat.com>
 <20100915122334.3fa7b35f@notabene>
 <20100915023735.GA9175@localhost>
 <20100915025454.GA10230@localhost>
 <20100915030640.GA11141@localhost>
 <20100915031343.GA12005@localhost>
 <1284520712.30133.1.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284520712.30133.1.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 11:18:32AM +0800, Li, Shaohua wrote:

> > +	if (!(sc->gfp_mask & __GFP_WAIT))
> > +		return 0;
> > +
> it appears __GFP_WAIT allocation doesn't go to direct reclaim.

Good point! So we are returning to its very first version ;)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1135,6 +1135,7 @@ static int too_many_isolated(struct zone *zone, int file,
 		struct scan_control *sc)
 {
 	unsigned long inactive, isolated;
+	int ratio;
 
 	if (current_is_kswapd())
 		return 0;
@@ -1150,7 +1151,9 @@ static int too_many_isolated(struct zone *zone, int file,
 		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
 	}
 
-	return isolated > inactive;
+	ratio = sc->gfp_mask & (__GFP_IO | __GFP_FS) ? 1 : 8;
+
+	return isolated > inactive * ratio;
 }
 
 /*
