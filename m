Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab2ILXl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:41:58 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab2ILXlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:41:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Babu Moger <babu.moger@netapp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 69/85] SCSI: scsi_lib: fix scsi_io_completions SG_IO error propagation
Date: Wed, 12 Sep 2012 16:36:52 -0700
Message-Id: <20120912233548.948155923@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 27c419739b67decced4650440829b8d51bef954b upstream.

The following v3.4-rc1 commit unmasked an existing bug in scsi_io_completion's
SG_IO error handling: 47ac56d [SCSI] scsi_error: classify some ILLEGAL_REQUEST
sense as a permanent TARGET_ERROR

Given that certain ILLEGAL_REQUEST are now properly categorized as
TARGET_ERROR the host_byte is being set (before host_byte wasn't ever
set for these ILLEGAL_REQUEST).

In scsi_io_completion, initialize req->errors with cmd->result _after_
the SG_IO block that calls __scsi_error_from_host_byte (which may
modify the host_byte).

Before this fix:

    cdb to send: 12 01 01 00 00 00
ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
    mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
    status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
    00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0x10,
    driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
SCSI Status: Check Condition

Sense Information:
sense buffer empty

After:

    cdb to send: 12 01 01 00 00 00
ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
    mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
    status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
    00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0,
    driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
SCSI Status: Check Condition

Sense Information:
 Fixed format, current;  Sense key: Illegal Request
 Additional sense: Invalid field in cdb
 Raw sense data (in hex):
        70 00 05 00 00 00 00 0b  00 00 00 00 24 00 00 00
        00 00 00

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Babu Moger <babu.moger@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---
 drivers/scsi/scsi_lib.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -760,7 +760,6 @@ void scsi_io_completion(struct scsi_cmnd
 	}
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
-		req->errors = result;
 		if (result) {
 			if (sense_valid && req->sense) {
 				/*
@@ -776,6 +775,10 @@ void scsi_io_completion(struct scsi_cmnd
 			if (!sense_deferred)
 				error = __scsi_error_from_host_byte(cmd, result);
 		}
+		/*
+		 * __scsi_error_from_host_byte may have reset the host_byte
+		 */
+		req->errors = cmd->result;
 
 		req->resid_len = scsi_get_resid(cmd);
 


