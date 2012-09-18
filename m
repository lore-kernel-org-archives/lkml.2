Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2IRA5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:57:37 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:51703 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2IRA5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:57:35 -0400
Subject: Re: linux-next: build failure after merge of the target-updates
 tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Dreier <roland@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <20120917134142.c7948ae04bdeabe1a863e464@canb.auug.org.au>
References: <20120917134142.c7948ae04bdeabe1a863e464@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 17:57:24 -0700
Message-ID: <1347929844.10711.136.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 13:41 +1000, Stephen Rothwell wrote:
> Hi Nicholas,
> 
> After merging the target-updates tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/target/target_core_transport.c: In function 'transport_get_sense_buffer':
> drivers/target/target_core_transport.c:582:22: error: 'struct target_core_fabric_ops' has no member named 'set_fabric_sense_len'
> 
> I can only assume that this has been caused by the (largish) changes that
> went into Linus' tree recently conflicting with changes in the
> target-updates tree.
> 
> I have dropped the target-updates tree for today.  Please sort the mess out.

Hi Stephen,

Whoops, sorry about that..

So target-pending/for-next has been rebased + now includes the following
change to Roland's original patch that drops TFO->set_fabric_sense_len
core+fabric usage for v3.7-rc1.  As reported, this ended up conflicting
with Paolo's recent pSCSI backend sense data handling bug-fixes that
went in for v3.6-rc6.

So with the following, for-next should be looking as expected now.

Thanks!

--nab

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fd0d0f0..d6d4844 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -567,9 +567,7 @@ static void target_complete_failure_work(struct work_struct *work)
  */
 static unsigned char *transport_get_sense_buffer(struct se_cmd *cmd)
 {
-       unsigned char *buffer = cmd->sense_buffer;
        struct se_device *dev = cmd->se_dev;
-       u32 offset = 0;
 
        WARN_ON(!cmd->se_lun);
 
@@ -579,14 +577,11 @@ static unsigned char *transport_get_sense_buffer(struct se_cmd *cmd)
        if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION)
                return NULL;
 
-       offset = cmd->se_tfo->set_fabric_sense_len(cmd, TRANSPORT_SENSE_BUFFER);
-
-       /* Automatically padded */
-       cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER + offset;
+       cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
 
        pr_debug("HBA_[%u]_PLUG[%s]: Requesting sense for SAM STATUS: 0x%02x\n",
                dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
-       return &buffer[offset];
+       return cmd->sense_buffer;
 }
 
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)

