Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2DODBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 23:01:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30576 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab2DODBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 23:01:41 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: USB storage SCSI EH oops
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>
Date: Sat, 14 Apr 2012 23:01:28 -0400
In-Reply-To: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 14 Apr 2012 15:18:18 -0700")
Message-ID: <yq1aa2daebb.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F8A3A10.0062,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus,

Linus> So I got the appended NULL pointer dereference with current -git
Linus> (plus the RCU patches I'm testing, but they seem unrelated)..

I sent out the following patch earlier in the week but James hasn't
picked it up yet...


SCSI: Fix error handling when no ULD is attached

Commit 18a4d0a2 introduced a bug in which we would attempt to
dereference the scsi driver even when the device had no ULD attached.

Ensure that a driver is registered and make the driver accessor function
more resilient to errors during device discovery.

Reported-by: Elric Fu <elricfu1@gmail.com>
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2cfcbff..386f0c5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -835,7 +835,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-	if (sdrv->eh_action)
+	if (sdrv && sdrv->eh_action)
 		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
 
 	return rtn;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 377df4a..1e11985 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -134,6 +134,9 @@ struct scsi_cmnd {
 
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
+	if (!cmd->request->rq_disk)
+		return NULL;
+
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
