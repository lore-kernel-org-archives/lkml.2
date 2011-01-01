Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1AASk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 13:40:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42030 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1AASk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 13:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QYOMtIdK8iJRIRJJY+8aEn5WIkbdPUHXOhTYcw2NeAr6deNv+JL4ife2mrK+q212U1
         KHBgkRbaGA+dtmDabkxXN1+GcYXkZU/9eFl/r5eAG+1OEAeUig/0lSBsUCtBNNT4ERN7
         huqPVZpb5u6wkX92PbPeX09SHX3Sxt27XUmpo=
Message-ID: <4D1F7517.7080803@gmail.com>
Date: Sat, 01 Jan 2011 19:40:23 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, just.for.lkml@googlemail.com
CC: nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
References: <4D1F5A17.4010807@gmail.com> <20110101170854.GB32652@parisc-linux.org>
In-Reply-To: <20110101170854.GB32652@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure no other command which does a write, such as UNMAP and WRITE_32, is missed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

If you agree this is the right fix, please ack.

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 17e3df4..a5acedc 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1171,7 +1171,7 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
 	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
 	if ( arccdbsize > 256)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0]|WRITE_12 ){
+	if (pcmd->sc_data_direction == DMA_TO_DEVICE)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 	}
 	ccb->arc_cdb_size = arccdbsize;
