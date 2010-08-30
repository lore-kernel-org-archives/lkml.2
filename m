Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0H3Sq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:46:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46917 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0H3Sq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kHleQq4j+wX+lMiipLGfQoGkTff77Qr+X96qliYzMUvlTSnIpaOnJ9j9ilmEZqctBc
         HwePle2+0Bv5ENfQwp/YOKFf+FyPkc9qlZUNEirFZUJXMnZOwTMY1pWjIh9+ctPywCW/
         zViZE5mUjDldUd6PEONaZuVKnaAKK9kLhKiIU=
Date: Mon, 30 Aug 2010 21:46:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.36-rc3: EIP is at scsi_init_io+...
Message-ID: <20100830184620.GA4818@core2.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not much of a calltrace, it scrolled away because of hardlockup detector.
On the bright side, radeon KMS worked correctly and actually showed it.

$ addr2line -e vmlinux ffffffff812d207b 
drivers/scsi/scsi_lib.c:1015 


   969	int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
   970	{
   971		int error = scsi_init_sgtable(cmd->request, &cmd->sdb, gfp_mask);
   972		if (error)
   973			goto err_exit;
   974	
   975		if (blk_bidi_rq(cmd->request)) {
   976			struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
   977				scsi_sdb_cache, GFP_ATOMIC);
   978			if (!bidi_sdb) {
   979				error = BLKPREP_DEFER;
   980				goto err_exit;
   981			}
   982	
   983			cmd->request->next_rq->special = bidi_sdb;
   984			error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
   985									    GFP_ATOMIC);
   986			if (error)
   987				goto err_exit;
   988		}
   989	
   990		if (blk_integrity_rq(cmd->request)) {
   991			struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
   992			int ivecs, count;
   993	
   994			BUG_ON(prot_sdb == NULL);
   995			ivecs = blk_rq_count_integrity_sg(cmd->request);
   996	
   997			if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask)) {
   998				error = BLKPREP_DEFER;
   999				goto err_exit;
  1000			}
  1001	
  1002			count = blk_rq_map_integrity_sg(cmd->request,
  1003							prot_sdb->table.sgl);
  1004			BUG_ON(unlikely(count > ivecs));
  1005	
  1006			cmd->prot_sdb = prot_sdb;
  1007			cmd->prot_sdb->table.nents = count;
  1008		}
  1009	
  1010		return BLKPREP_OK ;
  1011	
  1012	err_exit:
  1013		scsi_release_buffers(cmd);
  1014		scsi_put_command(cmd);
  1015	===>	cmd->request->special = NULL; <===
  1016		return error;
  1017	}
  1018	EXPORT_SYMBOL(scsi_init_io);
