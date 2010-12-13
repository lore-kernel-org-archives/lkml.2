Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0LMAj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:39:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:37217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab0LMAjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:39:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,333,1288594800"; 
   d="scan'208";a="686445909"
Subject: Re: [patch]block cfq: select new workload if priority changed
From: Shaohua Li <shaohua.li@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
In-Reply-To: <x49sjy5ad81.fsf@segfault.boston.devel.redhat.com>
References: <1291871853.2323.8.camel@sli10-conroe>
	 <x49sjy5ad81.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 08:39:52 +0800
Message-ID: <1292200792.2323.13.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 22:56 +0800, Jeff Moyer wrote:
> Shaohua Li <shaohua.li@intel.com> writes:
> 
> > If priority is changed, continue checking workload_expires and service tree
> > count of previous workload is meaningless. We should always choose the workload
> 
> I'd change that first sentence to:
> 
>   If priority is changed, continuing to check workload_expires and
>   service tree count of the previous workload does not make sense.
> 
> > with lowest key of new priority in such case.
> >
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> This makes sense to me.
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Thanks, modified the the changelog.




If priority is changed, continuing to check workload_expires and service tree
count of the previous workload does not make sense. We should always choose
the workload with lowest key of new priority in such case.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/cfq-iosched.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2010-12-08 19:39:01.000000000 +0800
+++ linux/block/cfq-iosched.c	2010-12-09 10:27:24.000000000 +0800
@@ -2116,6 +2116,7 @@ static void choose_service_tree(struct c
 	unsigned count;
 	struct cfq_rb_root *st;
 	unsigned group_slice;
+	enum wl_prio_t original_prio = cfqd->serving_prio;
 
 	if (!cfqg) {
 		cfqd->serving_prio = IDLE_WORKLOAD;
@@ -2134,6 +2135,9 @@ static void choose_service_tree(struct c
 		return;
 	}
 
+	if (original_prio != cfqd->serving_prio)
+		goto new_workload;
+
 	/*
 	 * For RT and BE, we have to choose also the type
 	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
@@ -2148,6 +2152,7 @@ static void choose_service_tree(struct c
 	if (count && !time_after(jiffies, cfqd->workload_expires))
 		return;
 
+new_workload:
 	/* otherwise select new workload type */
 	cfqd->serving_type =
 		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);



