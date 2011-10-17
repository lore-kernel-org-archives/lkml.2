Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1JQUOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:14:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:60149 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab1JQUOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:14:48 -0400
MIME-Version: 1.0
Message-ID: <7f94da39-4855-46b6-96d3-ab5ddbaed039@default>
Date: Mon, 17 Oct 2011 13:14:23 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de
Cc: cascardo@holoscopio.com, rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        rcj@linux.vnet.ibm.com, brking@linux.vnet.ibm.com
Subject: RE: [PATCH] staging: zcache: remove zcache_direct_reclaim_lock
References: <1318448460-5930-1-git-send-email-sjenning@linux.vnet.ibm.com
 3e84809b-a45d-4980-b342-c2d671f87f79@default>
In-Reply-To: <3e84809b-a45d-4980-b342-c2d671f87f79@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E9C8CAF.00C8:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dan Magenheimer
> Sent: Wednesday, October 12, 2011 2:39 PM
> To: Seth Jennings; gregkh@suse.de
> Cc: cascardo@holoscopio.com; rdunlap@xenotime.net; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org; linux-mm@kvack.org; rcj@linux.vnet.ibm.com; brking@linux.vnet.ibm.com
> Subject: RE: [PATCH] staging: zcache: remove zcache_direct_reclaim_lock
> 
> > From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> > Subject: [PATCH] staging: zcache: remove zcache_direct_reclaim_lock
> >
> > zcache_do_preload() currently does a spin_trylock() on the
> > zcache_direct_reclaim_lock. Holding this lock intends to prevent
> > shrink_zcache_memory() from evicting zbud pages as a result
> > of a preload.
> >
> > However, it also prevents two threads from
> > executing zcache_do_preload() at the same time.  The first
> > thread will obtain the lock and the second thread's spin_trylock()
> > will fail (an aborted preload) causing the page to be either lost
> > (cleancache) or pushed out to the swap device (frontswap). It
> > also doesn't ensure that the call to shrink_zcache_memory() is
> > on the same thread as the call to zcache_do_preload().
> 
> Yes, this looks to be leftover code from early in kztmem/zcache
> development.  Good analysis.
> 
> > Additional, there is no need for this mechanism because all
> > zcache_do_preload() calls that come down from cleancache already
> > have PF_MEMALLOC set in the process flags which prevents
> > direct reclaim in the memory manager. If the zcache_do_preload()
> 
> Might it be worthwhile to add a BUG/ASSERT for the presence
> of PF_MEMALLOC, or at least a comment in the code?
> 
> > call is done from the frontswap path, we _want_ reclaim to be
> > done (which it isn't right now).
> >
> > This patch removes the zcache_direct_reclaim_lock and related
> > statistics in zcache.
> >
> > Based on v3.1-rc8
> >
> > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> With added code/comment per above...
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

After Seth's further analysis, ignore my conditional and
consider v1 of this patch:

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
