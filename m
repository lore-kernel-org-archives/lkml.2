Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0KIKBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:01:19 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:33087 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KIKBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:01:16 -0500
Subject: Re: [RFC v2 16/21] tcm: Add PSCSI subsystem plugin
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4CD91172.4010007@panasas.com>
References: <1285195867-11728-1-git-send-email-nab@linux-iscsi.org>
	 <4CD01EE2.20705@panasas.com>
	 <1289279587.19946.69.camel@haakon2.linux-iscsi.org>
	 <4CD91172.4010007@panasas.com>
Content-Type: text/plain
Date: Tue, 09 Nov 2010 01:56:02 -0800
Message-Id: <1289296562.19946.88.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 11:16 +0200, Boaz Harrosh wrote:
> On 11/09/2010 07:13 AM, Nicholas A. Bellinger wrote:
> > <More follow up on Boaz comments from last week>
> > 
> 
> <snip>
> 
> >>> +static inline void pscsi_blk_init_request(
> >>> +	struct se_task *task,
> >>> +	struct pscsi_plugin_task *pt,
> >>> +	struct request *req,
> >>> +	int bidi_read)
> >>> +{
> >>> +	/*
> >>> +	 * Defined as "scsi command" in include/linux/blkdev.h.
> >>> +	 */
> >>> +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> >>> +	/*
> >>> +	 * For the extra BIDI-COMMAND READ struct request we do not
> >>> +	 * need to setup the remaining structure members
> >>> +	 */
> >>> +	if (bidi_read)
> >>> +		return;
> >>> +	/*
> >>> +	 * Setup the done function pointer for struct request,
> >>> +	 * also set the end_io_data pointer.to struct se_task.
> >>> +	 */
> >>> +	req->end_io = pscsi_req_done;
> >>> +	req->end_io_data = (void *)task;
> >>> +	/*
> >>> +	 * Load the referenced struct se_task's SCSI CDB into
> >>> +	 * include/linux/blkdev.h:struct request->cmd
> >>> +	 */
> >>> +	req->cmd_len = scsi_command_size(pt->pscsi_cdb);
> >>> +	req->cmd = &pt->pscsi_cdb[0];
> >>
> >> Here!   req->cmd = TASK_CMD(task)->t_task_cdb;
> >>
> >> I don't see in this patch the actual memcpy of TASK_CMD(task)->t_task_cdb into
> >> pt->pscsi_cdb, which I suspect is done in Generic code through the use of
> >> ->get_cdb(struct se_task *);?
> >>
> >> If so then it means all the plugins have their own copy of the CDB? Now I finally
> >> understand the get_max_cdb_len().
> >>
> >> All that could be totally clean. All plugins use the TASK_CMD(task)->t_task_cdb
> >> directly. Then get_max_cdb_len(), get_cdb(), the memcpy() and all these extra buffers
> >> just magically go away.
> > 
> > As described in the last response, the T_TASK(cmd)->t_task_cdb is used
> > as a base for all CDBs, and is the primary storage for all *non*
> > SCF_SCSI_DATA_SG_IO_CDB type ops.
> > 
> > For all bulk SCF_SCSI_DATA_SG_IO_CDB, we will memcpy
> > T_TASK(cmd)->t_task_cdb into the backend specific location (for
> > TCM/pSCSI this is pt->pscsi_cdb[])  and then update the LBA+length when
> > splitting the single received struct se_cmd across multiple struct
> > se_task w/ backend descriptors due to backend struct
> > se_dev_limits->limits.max_sectors limitations for underlying backend HW.
> > 
> 
> OK Thanks I was missing this part. Sorry I only looked at the patches and
> not the complete code.
> 
> So for pSCSI could you use the cmnd buffer at struct request? Maybe
> postpone a little bit the patching of the cdb to after the request allocation.

<nod>  Again, this would only be for the non SCF_SCSI_DATA_SG_IO_CDB
cases for TCM/pSCSI, so I am not sure if the complexity is worth the
benefit for the non SCF_SCSI_DATA_SG_IO_CDB descriptors..

> Than anything bigger then 16 bytes (max cmnd at struct request) you allocate
> and free on request completion.

Hmm yeah, that adds a bit of extra complexity for TCM/pSCSI considering
the default TCM_MAX_COMMAND_SIZE=32

> But all that could be cleaned up later. You are currently busy with bigger
> stuff, just as a future note.
> 

<nod> point taken.

> The rest look good. I have some holes in my knowledge of how you did bidi.
> I promise to one of these days actually clone the tree and look at the real
> code.
> My goal is to have Lio-iscsi => lio-pSCSI => iscsi-initiator as a passthrough
> of OSD commands. That will prove things are done right.
> 

Excellent, please let me know if you have any questions getting setup.

> Also a Lio-iscsi => lio-tgt_if => tgtd-user-mode should also be very useful
> and OSD-able
> 

Indeed, I am still planning to spend a day or two before the end of the
year to get the basic pieces running for target_core_stgt.c and the main
I/O path for a userspace passthrough backend module function.

As usual, I am happy to test and accept patches before then..  ;)

> Thanks, Nic. Hope you feeling better now
> Boaz

Most certainly.  Thanks again for your detailed review!

--nab


