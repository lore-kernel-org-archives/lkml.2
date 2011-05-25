Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1EYTw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:52:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58445 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1EYTwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=J41N227r9Nek90fuuDRG9t9+n9OfQLkWXvZlRrRcz59wYH3KdpasZ8obrR2j/8O7gB
         88kPtUBQ3N9lMRQ8TnyQFFU0TxHRJmwUqGyk3rJBK7NZSsN5qPs9zHCspZO0e9MkZWbV
         Z+vfBFHpYszQGAWyUHKA9w4dRRk8hN1bBEW+4=
Date: Wed, 25 May 2011 15:52:16 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu-natty
To: Jens Axboe <jaxboe@fusionio.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Parag Warudkar <parag.lkml@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re: 
 __elv_add_request OOPS]
In-Reply-To: <4DDD55D6.1080909@fusionio.com>
Message-ID: <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com> <4DDD55D6.1080909@fusionio.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 May 2011, Jens Axboe wrote:

> I don't think we can move it earlier, we essentially have to do the
> check at both ends. The "normal" IO path would see that the queue is
> dead and error the IO, but this is an internal setup that sets up the
> request and then adds it to the stored queue pointer. So it needs to
> check this state one way or the other. I think the above fix with the
> sdev_alive() will be good enough.
> 

If I understood it right we need checks in both places (kind of makes 
sense as the device could be gone *after* we checked in ioctl function and 
before the request queue was dereferenced). So here is the ioctl check 
with a helper function for state check that Linus asked for.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index d9564fb..8615e63 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -30,6 +30,13 @@
 
 #define MAX_BUF PAGE_SIZE
 
+static inline int sdev_early_check(struct scsi_device *sdev)
+{
+	if (!sdev || sdev->sdev_state == SDEV_DEL
+		|| sdev->sdev_state > SDEV_QUIESCE)
+		return -ENXIO;
+	return 0;
+}
 /**
  * ioctl_probe  --  return host identification
  * @host:	host to identify
@@ -91,6 +98,10 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	int result;
 	struct scsi_sense_hdr sshdr;
 
+	result = sdev_early_check(sdev);
+	if (result)
+		return result;
+
 	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
 	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
@@ -194,10 +205,11 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
 int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
+	int result;
 
-	/* No idea how this happens.... */
-	if (!sdev)
-		return -ENXIO;
+	result = sdev_early_check(sdev);
+	if (result)
+		return result;
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
@@ -288,6 +300,10 @@ int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 {
 	int val, result;
 
+	result = sdev_early_check(sdev);
+	if (result)
+		return result;
+
 	/* The first set of iocts may be executed even if we're doing
 	 * error processing, as long as the device was opened
 	 * non-blocking */
