Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0JQU6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:58:36 -0400
Received: from nm4-vm0.bullet.mail.ne1.yahoo.com ([98.138.90.253]:43578 "HELO
	nm4-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932785Ab0JQU6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:58:34 -0400
X-Yahoo-Newman-Id: 494230.39732.bm@omp1055.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ty97g2wVM1m2OpWuFqYPCOokK8lvB6pO8MbkswCHd.l2CcB
 abJ96V2hX.4UVsF38w5nP2cDxY2p1yc6WPplM95HmxozXsbIo9e5J4zzMX8u
 KRkYQNmeCs9rImRqZp2CY8CZKoDy5kPo75qVJTww6StSY5C27.LFeVo6IDKu
 eFFWvHW3.Cgpt19BlQQLUULW.LcqsF2Vzs5rSRxkQcHZjInr5Mf6Hzj_SsCZ
 uECZ_A3N2z4DEiCG.a8sCwo0eZ990G_JLkDH02jnT9P374DCo0XU_9gxsv_g
 -
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 4/5] tcm: Unify UNMAP and WRITE_SAME w/ UNMAP=1
	subsystem plugin handling
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
In-Reply-To: <4CBB1BD2.9080702@panasas.com>
References: <1286959700-3489-1-git-send-email-nab@linux-iscsi.org>
	 <20101013111920.GB26366@lst.de>
	 <1287003368.7334.64.camel@haakon2.linux-iscsi.org>
	 <20101014000341.GA15583@lst.de>  <4CBB1BD2.9080702@panasas.com>
Content-Type: text/plain
Date: Sun, 17 Oct 2010 13:53:45 -0700
Message-Id: <1287348825.14039.10.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 17:52 +0200, Boaz Harrosh wrote:
> On 10/13/2010 08:03 PM, Christoph Hellwig wrote:
> > On Wed, Oct 13, 2010 at 01:56:08PM -0700, Nicholas A. Bellinger wrote:
> >>> The parsing of the WRITE SAME and UNMAP CDBs is something the generic
> >>> CDB parsing code should do,
> >>
> >> Ok, so you are thinking about a seperate transport_emulate_write_same()
> >> and transport_emulate_unmap() called from
> >> transport_emulate_control_cdb(), right..?
> > 
> > More or less yes.
> > 
> >>>  and just give a range of lists of lba/len
> >>> pairs to the ->discard method in the backed.
> >>
> >> Yes, these are already available from the passed struct
> >> se_task->task_lba and ->task_size values.
> > 
> > Not for UNMAP.  WRITE SAME in it's various incarnations uses the
> > standard LBA/LEN encoding and you seem to parse it nicely.  But for
> > UNMAP the lba/len pairs are in the command payload.  To support things
> > genericly you'd need a standard way to pass them.  If you want to
> > limit yourself to one lba/len pair for one the scheme could work,
> > though.
> > 
> >> Yes, so the problem of trying to make this code generic (eg: outside of
> >> TCM subsystem plugins) is that blk_issue_discard() takes struct
> >> block_device, which means we the subsystem plugin has to locate struct
> >> block_device inside of non generic cide.
> > 
> > blk_issue_discard is in no way generic.  It's 100% iblock code and
> > really doesn't belong into any other backend.  And btw,
> > blk_issue_discard is rather suboptimal even in iblock - it's a
> > synchronous function that will stall progress of the thread handling it.
> > If you want better performance you'll need to opencode the content of
> > it to allow an asynchronous completion handler.  But given that discard
> > isn't really a critical feature at this point this could easily be
> > left for later with a comment.
> > 
> >> So, then the main issue becomes FILEIO + block level discard and how to
> >> issue an blk_issue_discard() from struct fileio in the most sane way.
> >> If there is no sane way then I will just drop this bit, or just do the
> >> file level 'hole punch' that you are speaking about.
> > 
> > Right now there is no good way to do a block device discard or file
> > hole punch at the level where the file backend operates.
> > 
> 
> Nick why don't you let User-mode (With configfs everything is user mode
> right?)

Correct, everything is driven by user-mode code -> syscalls and
translated into kernel level operations using Linux/VFS to represent
struct config_group dependencies between parent/child directory layout
and inter module symlinks.

> look into the file set for FILEIO and if found to be a block
> device then set iblock instead. Then you can surly assume in FILEIO that
> you only have FS files at hand.
> 

Yes, I don't think we ever want to do that type of auto-configuration at
the kernel level because using interpreted userspace code to drive
configfs is oh so much easier to develop and maintain for the long run.

> Christoph.
> has xfs an IOCTL to punch holes in files? would it be desirable to make
> that generic with a ->punch() vectror FS(s) can implement. It's the 3rd
> project that's looking for a generic punch().
> 

This sounds really interesting, any thoughts hch..?

--nab

