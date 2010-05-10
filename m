Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab0EJW4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:56:12 -0400
Received: from kroah.org ([198.145.64.141]:33447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567Ab0EJWxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:06 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:27 2010
Message-Id: <20100510223327.582023299@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [113/117] SCSI: libiscsi: regression: fix header digest errors
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 96b1f96dcab87756c0a1e7ba76bc5dc2add82b88 upstream.

This fixes a regression introduced with this commit:

commit d3305f3407fa3e9452079ec6cc8379067456e4aa
Author: Mike Christie <michaelc@cs.wisc.edu>
Date:   Thu Aug 20 15:10:58 2009 -0500

    [SCSI] libiscsi: don't increment cmdsn if cmd is not sent

in 2.6.32.

When I moved the hdr->cmdsn after init_task, I added
a bug when header digests are used. The problem is
that the LLD may calculate the header digest in init_task,
so if we then set the cmdsn after the init_task call we
change what the digest will be calculated by the target.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libiscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -470,12 +470,12 @@ static int iscsi_prep_scsi_cmd_pdu(struc
 
 	WARN_ON(hdrlength >= 256);
 	hdr->hlength = hdrlength & 0xFF;
+	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 
 	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
 	task->state = ISCSI_TASK_RUNNING;
-	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;


