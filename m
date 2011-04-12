Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1DLRli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:41:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56150 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259Ab1DLRle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:41:34 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302627097.2661.25.camel@dolmen>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>  <1302617212.2661.14.camel@dolmen>
	 <1302621261.2604.18.camel@mulgrave.site>  <1302624266.2661.21.camel@dolmen>
	 <1302625621.2604.24.camel@mulgrave.site>  <1302627097.2661.25.camel@dolmen>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 12:41:30 -0500
Message-ID: <1302630090.2604.30.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 17:51 +0100, Steven Whitehouse wrote:
> Still not quite there, but looking more hopeful now,

Not sure I share your optimism; but this one

> scsi 0:2:1:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
> scsi: killing requests for dead queue
> ------------[ cut here ]------------
> WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
> Hardware name: PowerEdge R710
> Modules linked in:
> Pid: 386, comm: kworker/6:1 Not tainted 2.6.39-rc2+ #193
> Call Trace:
>  [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff813c984d>] kref_get+0x2d/0x30
>  [<ffffffff813c824a>] kobject_get+0x1a/0x30
>  [<ffffffff81460874>] get_device+0x14/0x20
>  [<ffffffff81478bd7>] scsi_request_fn+0x37/0x4a0

Is definitely a race between the last put of the SCSI device and the
block delayed work.  The signal that mediates that race is supposed to
be the q->queuedata being null, but that doesn't get set until some time
into the release function (by which time the ref is already zero).

Closing the window completely involves setting this to NULL before we do
the final put when we know everything else is gone.  So, here's the next
incremental.

James

---

Index: linux-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6/drivers/scsi/scsi_sysfs.c
@@ -323,7 +323,6 @@ static void scsi_device_dev_release_user
 	}
 
 	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
 		scsi_free_queue(sdev->request_queue);
 		/* temporary expedient, try to catch use of queue lock
@@ -937,6 +936,7 @@ void __scsi_remove_device(struct scsi_de
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+	sdev->request_queue->queuedata = NULL;
 	put_device(dev);
 }
 


