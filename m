Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1LWA1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 19:27:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:50183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab1LWA1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 19:27:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88765633"
Subject: Re: [patch 1/2]scsi: scsi_run_queue() doesn't use local list to
 handle starved sdev
From: Shaohua Li <shaohua.li@intel.com>
To: James Bottomley <jbottomley@parallels.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <1324578449.9709.15.camel@dabdike.int.hansenpartnership.com>
References: <1324523412.22361.471.camel@sli10-conroe>
	 <1324578449.9709.15.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 08:40:51 +0800
Message-ID: <1324600851.22361.475.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 18:27 +0000, James Bottomley wrote:
> On Thu, 2011-12-22 at 11:10 +0800, Shaohua Li wrote:
> > scsi_run_queue() picks off all sdev from host starved_list to a local list,
> > then handle them. If there are multiple threads running scsi_run_queue(),
> > the starved_list will get messed. This is quite common, because request
> > rq_affinity is on by default.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> >  drivers/scsi/scsi_lib.c |   21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> > 
> > Index: linux/drivers/scsi/scsi_lib.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/scsi_lib.c	2011-12-21 16:56:23.000000000 +0800
> > +++ linux/drivers/scsi/scsi_lib.c	2011-12-22 09:33:09.000000000 +0800
> > @@ -401,9 +401,8 @@ static inline int scsi_host_is_busy(stru
> >   */
> >  static void scsi_run_queue(struct request_queue *q)
> >  {
> > -	struct scsi_device *sdev = q->queuedata;
> > +	struct scsi_device *sdev = q->queuedata, *head_sdev = NULL;
> >  	struct Scsi_Host *shost;
> > -	LIST_HEAD(starved_list);
> >  	unsigned long flags;
> >  
> >  	/* if the device is dead, sdev will be NULL, so no queue to run */
> > @@ -415,9 +414,8 @@ static void scsi_run_queue(struct reques
> >  		scsi_single_lun_run(sdev);
> >  
> >  	spin_lock_irqsave(shost->host_lock, flags);
> > -	list_splice_init(&shost->starved_list, &starved_list);
> >  
> > -	while (!list_empty(&starved_list)) {
> > +	while (!list_empty(&shost->starved_list)) {
> 
> The original reason for working from a copy instead of the original list
> was that the device can end up back on the starved list because of a
> variety of conditions in the HBA and so this would cause the loop not to
> exit, so this piece of the patch doesn't look right to me.
+               /*
+                * the head sdev is no longer starved and removed from the
+                * starved list, select a new sdev as head.
+                */
+               if (head_sdev == sdev && list_empty(&sdev->starved_entry))
+                       head_sdev = NULL;
I had this in the loop, which is to guarantee the loop will exit if a
device is removed from the starved list.

Thanks,
Shaohua

