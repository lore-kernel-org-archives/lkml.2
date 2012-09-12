Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab2IMAVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:21:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2ILXgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matthias Prager <linux@matthiasprager.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 089/108] SCSI: Fix Device not ready issue on mpt2sas
Date: Wed, 12 Sep 2012 16:29:27 -0700
Message-Id: <20120912232459.834272678@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 14216561e164671ce147458653b1fea06a4ada1e upstream.

This is a particularly nasty SCSI ATA Translation Layer (SATL) problem.

SAT-2 says (section 8.12.2)

        if the device is in the stopped state as the result of
        processing a START STOP UNIT command (see 9.11), then the SATL
        shall terminate the TEST UNIT READY command with CHECK CONDITION
        status with the sense key set to NOT READY and the additional
        sense code of LOGICAL UNIT NOT READY, INITIALIZING COMMAND
        REQUIRED;

mpt2sas internal SATL seems to implement this.  The result is very confusing
standby behaviour (using hdparm -y).  If you suspend a drive and then send
another command, usually it wakes up.  However, if the next command is a TEST
UNIT READY, the SATL sees that the drive is suspended and proceeds to follow
the SATL rules for this, returning NOT READY to all subsequent commands.  This
means that the ordering of TEST UNIT READY is crucial: if you send TUR and
then a command, you get a NOT READY to both back.  If you send a command and
then a TUR, you get GOOD status because the preceeding command woke the drive.

This bit us badly because

commit 85ef06d1d252f6a2e73b678591ab71caad4667bb
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Jul 1 16:17:47 2011 +0200

    block: flush MEDIA_CHANGE from drivers on close(2)

Changed our ordering on TEST UNIT READY commands meaning that SATA drives
connected to an mpt2sas now suspend and refuse to wake (because the mpt2sas
SATL sees the suspend *before* the drives get awoken by the next ATA command)
resulting in lots of failed commands.

The standard is completely nuts forcing this inconsistent behaviour, but we
have to work around it.

The fix for this is twofold:

   1. Set the allow_restart flag so we wake the drive when we see it has been
      suspended

   2. Return all TEST UNIT READY status directly to the mid layer without any
      further error handling which prevents us causing error handling which
      may offline the device just because of a media check TUR.

Reported-by: Matthias Prager <linux@matthiasprager.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_error.c |   10 ++++++++++
 drivers/scsi/scsi_scan.c  |   10 ++++++++++
 2 files changed, 20 insertions(+)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -42,6 +42,8 @@
 
 #include <trace/events/scsi.h>
 
+static void scsi_eh_done(struct scsi_cmnd *scmd);
+
 #define SENSE_TIMEOUT		(10*HZ)
 
 /*
@@ -241,6 +243,14 @@ static int scsi_check_sense(struct scsi_
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+		/*
+		 * nasty: for mid-layer issued TURs, we need to return the
+		 * actual sense data without any recovery attempt.  For eh
+		 * issued ones, we need to try to recover and interpret
+		 */
+		return SUCCESS;
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -779,6 +779,16 @@ static int scsi_add_lun(struct scsi_devi
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);
 
+	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
+		/*
+		 * sata emulation layer device.  This is a hack to work around
+		 * the SATL power management specifications which state that
+		 * when the SATL detects the device has gone into standby
+		 * mode, it shall respond with NOT READY.
+		 */
+		sdev->allow_restart = 1;
+	}
+
 	if (*bflags & BLIST_ISROM) {
 		sdev->type = TYPE_ROM;
 		sdev->removable = 1;


