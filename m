Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2BJBdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 20:33:40 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51530 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2BJBdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 20:33:39 -0500
Subject: Re: linux-next: build failure after merge of the target-updates
 tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20120210115005.b828eca7065d1fbed82c80c6@canb.auug.org.au>
References: <20120210115005.b828eca7065d1fbed82c80c6@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Feb 2012 17:33:36 -0800
Message-ID: <1328837616.9333.71.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 11:50 +1100, Stephen Rothwell wrote:
> Hi Nicholas,
> 
> After merging the target-updates tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_abort_cmd':
> drivers/infiniband/ulp/srpt/ib_srpt.c:1381:25: error: 'struct se_cmd' has no member named 'transport_lun_stop'
> drivers/infiniband/ulp/srpt/ib_srpt.c:1390:25: error: 'struct se_cmd' has no member named 'transport_lun_stop'
> drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_handle_rdma_err_comp':
> drivers/infiniband/ulp/srpt/ib_srpt.c:1516:25: error: 'struct se_cmd' has no member named 'transport_lun_stop'
> 
> Caused by commit 3f1d120476c5 ("target: replace various cmd flags with a
> transport state").
> 
> I have used the target-updates tree from next-20120209 for today.

Whoops, I managed to drop the piece below from hch's original patch in
target-pending/for-next.  Sorry about that..

Rolling the missing ib_srpt.c bit into the patch now..

Thanks Stephen!

--nab

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2b73d43..e1e6b5b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1378,7 +1378,9 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
                break;
        case SRPT_STATE_NEED_DATA:
                /* DMA_TO_DEVICE (write) - RDMA read error. */
-               atomic_set(&ioctx->cmd.transport_lun_stop, 1);
+               spin_lock_irqsave(&ioctx->cmd.t_state_lock, flags);
+               ioctx->cmd.transport_state |= CMD_T_LUN_STOP;
+               spin_unlock_irqrestore(&ioctx->cmd.t_state_lock, flags);
                transport_generic_handle_data(&ioctx->cmd);
                break;
        case SRPT_STATE_CMD_RSP_SENT:
@@ -1387,7 +1389,9 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
                 * not been received in time.
                 */
                srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
-               atomic_set(&ioctx->cmd.transport_lun_stop, 1);
+               spin_lock_irqsave(&ioctx->cmd.t_state_lock, flags);
+               ioctx->cmd.transport_state |= CMD_T_LUN_STOP;
+               spin_unlock_irqrestore(&ioctx->cmd.t_state_lock, flags);
                kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
                break;
        case SRPT_STATE_MGMT_RSP_SENT:
@@ -1494,6 +1498,7 @@ static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
 {
        struct se_cmd *cmd;
        enum srpt_command_state state;
+       unsigned long flags;
 
        cmd = &ioctx->cmd;
        state = srpt_get_cmd_state(ioctx);
@@ -1513,7 +1518,9 @@ static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
                               __func__, __LINE__, state);
                break;
        case SRPT_RDMA_WRITE_LAST:
-               atomic_set(&ioctx->cmd.transport_lun_stop, 1);
+               spin_lock_irqsave(&ioctx->cmd.t_state_lock, flags);
+               ioctx->cmd.transport_state |= CMD_T_LUN_STOP;
+               spin_unlock_irqrestore(&ioctx->cmd.t_state_lock, flags);
                break;
        default:
                printk(KERN_ERR "%s[%d]: opcode = %u\n", __func__,


