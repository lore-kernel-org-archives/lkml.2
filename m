Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0I2INT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:13:19 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:25176 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754317Ab0I2INQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:13:16 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: O4JUwfQVM1k0utUgKNNJgKLMe.ltXH2CT94N9GEmAB0_3yh
 gvHrICn.aJywyCbnN77CQu.MSeIX5a0v2IqoU4sun5mYeVEj3llzGRmv4oGf
 N2yQGXGute1W7fu5K7l2VHZ6yZWzQP4BXoYLpHLMu_0y6mnuz1_QFotBPw8p
 ZJIrKUexFtCYMMO_5lrhL5PYlfAu5Kdl9kdsoXEvea4i9RbSJLjN_ptjVke5
 W3Wkl_ooZ3_xsPOKZwDzAWeK9JaHy3GD9CXBOWwXy1smahsHxhArLD5Z2CA7
 Jt686RcH7RHXJ8CfCvvSdc8Hjd.en3MRsF6mnNYu4O_QlFbtX6HcMUNqtgGo
 0vYCSUDdmKt3f03zj1w--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 3/3] tcm/fileio: Add UNMAP / Block DISCARD support
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Richard Sharpe <realrichardsharpe@gmail.com>
In-Reply-To: <4CA18F28.3070608@panasas.com>
References: <1285627910-6492-1-git-send-email-nab@linux-iscsi.org>
	 <4CA18F28.3070608@panasas.com>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 01:08:59 -0700
Message-Id: <1285747739.18417.49.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 08:46 +0200, Boaz Harrosh wrote:
> On 09/28/2010 12:51 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds UNMAP emulation support using Block layer DISCARD in fd_emulate_scsi_cdb()
> > -> transport_generic_unmap().  This includes the use of blk_queue_discard() in
> > fd_create_virtdevice() to determine when to set DEV_ATTRIB(dev)->emulate_tpe=1 to
> > signal to TCM Core to perform the necessary control CDB emulation for TPE=1 / UNMAP.
> > 
> > Note this patch igrab() + iput() when accessing struct block_device via
> > I_BDEV(file->f_mapping->host) that is required for transport_generic_unmap()
> > within fd_emulate_scsi_cdb().
> > 
> > Also note that when (S_ISBLK(inode->i_mode) is NULL, the TPE=1 and UNMAP emulation
> > are disabled for non BD struct file I/O.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_file.c |   53 ++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 52 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> > index 93d3f63..3b91556 100644
> > --- a/drivers/target/target_core_file.c
> > +++ b/drivers/target/target_core_file.c
> > @@ -235,6 +235,17 @@ static struct se_device *fd_create_virtdevice(
> >  
> >  	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
> >  	fd_dev->fd_queue_depth = dev->queue_depth;
> > +	/*
> > +	 * Check for QUEUE_FLAG_DISCARD and enable TCM TPE emulation
> > +	 * if present for struct block_device backend
> > +	 */
> > +	if (S_ISBLK(inode->i_mode)) {
> > +		if (blk_queue_discard(bdev_get_queue(inode->i_bdev))) {
> > +			DEV_ATTRIB(dev)->emulate_tpe = 1;
> > +			printk(KERN_INFO "FILEIO: Enabling BLOCK Discard"
> > +				" and TPE=1 emulation\n");
> > +		}
> > +	}
> >  
> >  	printk(KERN_INFO "CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
> >  		" %llu total bytes\n", fd_host->fd_host_id, fd_dev->fd_dev_id,
> > @@ -388,9 +399,13 @@ static int fd_emulate_read_cap16(struct se_task *task)
> >   */
> >  static int fd_emulate_scsi_cdb(struct se_task *task)
> >  {
> > -	int ret;
> >  	struct se_cmd *cmd = TASK_CMD(task);
> > +	struct fd_dev *fd_dev = (struct fd_dev *) task->se_dev->dev_ptr;
> 
> No need to typecast a void pointer

Whoops, this was a cut and paste but these unnecessary typecasts for
'struct sub_dev' and 'struct sub_task' have been around forever and can
go.  Removing these in target_core_file.c, target_core_iblock,
target_core_pscsi.c target_core_rd.c, and target_core_stgt.c now.

> 
> >  	struct fd_request *fd_req = (struct fd_request *) task->transport_req;
> > +	struct file *f = fd_dev->fd_file;
> > +	struct inode *i;
> > +	struct block_device *bd;
> > +	int ret;
> >  
> >  	switch (fd_req->fd_scsi_cdb[0]) {
> >  	case INQUIRY:
> > @@ -433,6 +448,42 @@ static int fd_emulate_scsi_cdb(struct se_task *task)
> >  		if (ret < 0)
> >  			return ret;
> >  		break;
> > +	case UNMAP:
> > +		i = igrab(f->f_mapping->host);
> > +		if (!(i)) {
> 
> You must have a reference on your fileio backend file, right?
> This could be a BUG_ON()

Yes, this was an extra bit of paranoia as we always expect to have a
valid struct file here.

> 
> > +			printk(KERN_ERR "FILEIO: Unable to locate inode for"
> > +					" backend for UNMAP\n");
> > +			return PYX_TRANSPORT_LU_COMM_FAILURE;
> > +		}
> > +		/*
> > +		 * Currently for struct file w/o a struct block_device
> > +		 * backend we return a success..
> > +		 */	
> > +		if (!(S_ISBLK(i->i_mode))) {
> 
> I did not see in the first patch that you do this check when actually sending
> the VPD page. I only saw that it is enabled if set from configfs. (Sorry for
> the noise if I missed it). So you might want to call a target specific function
> when sending the VPD page. This way this will never happen right?

That is correct, once we determine that fd_create_virtdevice() -> 
blk_queue_discard() is going to set DEV_ATTRIB(dev)->emulate_tpe=1, this
is what will signal TPE=1 in SA READ_CAPACITY_16 and other locations in
Patch 1 for the emulated case with TCM/IBLOCK and TCM/FILEIO.

> 
> > +			printk(KERN_WARNING "Ignoring UNMAP for non BD"
> > +					" backend for struct file\n");
> 
> TODO: Lots of extent based filesystems could enjoy if you punch an hole
>       in the file. (Which will also send a proper discard).
>       So how to punch an hole in a file via vfs?

Good question, as all of the current block discard support assumes a
struct block_device * pointer currently.

I know that hch has mentioned that accesing a struct block_device from
struct file is very dangerous, but I am assuming for the TCM/FILEIO case
that this code will be protected by igrab() and iput().

hch and jaxboe, any comments here..?

Thanks!

--nab

> 
> > +			iput(i);
> > +			return PYX_TRANSPORT_LU_COMM_FAILURE;
> > +		}
> > +		bd = I_BDEV(f->f_mapping->host);
> > +		if (!(bd)) {
> > +			printk(KERN_ERR "FILEIO: Unable to locate struct"
> > +					" block_device for UNMAP\n");
> > +			iput(i);
> > +			return PYX_TRANSPORT_LU_COMM_FAILURE;
> > +		}
> > +		/*
> > +		 * Now call the transport_generic_unmap() -> blkdev_issue_discard()
> > +		 * wrapper to translate SCSI UNMAP into Linux/BLOCK discards on
> > +		 * LBA+Range descriptors in the UNMAP write paylaod.
> > +		 */
> > +		ret = transport_generic_unmap(cmd, bd);
> > +		if (ret < 0) {
> > +			iput(i);
> > +			return ret;
> > +		}
> > +		iput(i);
> > +		break;
> >  	case ALLOW_MEDIUM_REMOVAL:
> >  	case ERASE:
> >  	case REZERO_UNIT:
> 
> Boaz
> 

