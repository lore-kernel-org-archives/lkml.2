Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0LWKKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:10:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44635 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0LWKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:10:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c0ino4cjqcqovFjvx7qLWIiwqk4Okbvr5LDJQznUlxxfv1E497Cy80ZsTXT+W7/qPR
         L7xnNHt9pIgld1EgC2dXqdab4Yw/Y4L3YHAPmCGH6eTr1FPvMe2Ik0gr0Upk+7PSUQTG
         dwmrnWMdST/2m0bLZ/EDXtFv0umSkIu4yQXdA=
Date: Thu, 23 Dec 2010 11:09:56 +0100
From: Tejun Heo <htejun@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Boot failure with block/for-next
Message-ID: <20101223100956.GA15625@htj.dyndns.org>
References: <1293038823.3019.89.camel@mulgrave.site>
 <1293078673.3019.765.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293078673.3019.765.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On Wed, Dec 22, 2010 at 10:31:13PM -0600, James Bottomley wrote:
 > Actually, surprisingly, bisection confirms it's this patch:
 > 
 > Author: Tejun Heo <tj@kernel.org>
 > Date:   Wed Dec 8 20:57:42 2010 +0100
 > 
 >     sd: implement sd_check_events()
 > 
 > I can't quite see how yet.

Does the following patch fix the problem?  Thanks.

Subject: sd: don't clear media presence unless it's removable

set_media_not_present() can be called for a non-removable device if it
raises UA for whatever reason; however, block layer calls into
sd_check_events() only if the device is removable.  As the function is
responsible for setting media presence, sd continues to think that
media is missing on the non-removable device making it inaccessible.

This patch makes set_media_not_present() clear media presence iff the
device is removable.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/sd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: work/drivers/scsi/sd.c
===================================================================
--- work.orig/drivers/scsi/sd.c
+++ work/drivers/scsi/sd.c
@@ -993,8 +993,11 @@ static void set_media_not_present(struct
 {
 	if (sdkp->media_present)
 		sdkp->device->changed = 1;
-	sdkp->media_present = 0;
-	sdkp->capacity = 0;
+
+	if (sdkp->device->removable) {
+		sdkp->media_present = 0;
+		sdkp->capacity = 0;
+	}
 }
 
 static int media_not_present(struct scsi_disk *sdkp,
