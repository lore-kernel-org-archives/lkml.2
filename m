Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0FGJhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:37:33 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:35605 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752245Ab0FGJha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:37:30 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: PlreNUcVM1mJM1EMN2R3tXji992n4fICK9s3uv96fCH.Gd1NmCW3KmqqLNU5iR3PZFwUBW84Xx2jvh5XBfsdzwMwmgKr6EFC5ZVhKANjhgUBg5InskRPVsA7nuJdsjmfZSL3w_EwpMrtCp2ee6srR7ZE2EPRunAHIwguhOocyikEoFqbJWcDyIkHDah7pcKZ598W51_XM_dhvLzO9trsZDlPCNhv4G9KXV6fpawlVHrpiILjqsHHdJ9W.7u3UCDr6Z0uPsSZxpx2v91H.S96yGgYDml6b.btUftvlIN95_67exp90zeBt2heSxeCS1Q4rwNk80tny8Q6.XVuy4wUsZ26NePUR0ygTbuKH6814l0.rg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 3/3] [tgt]: Add BSG v4 backstore support to usr/bs_sg.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>,
       Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <4C0CBB89.9000209@panasas.com>
References: <1275882640-5418-1-git-send-email-nab@linux-iscsi.org>
	 <4C0CB071.8040805@panasas.com>
	 <1275901324.26888.56.camel@haakon2.linux-iscsi.org>
	 <4C0CBB89.9000209@panasas.com>
Content-Type: text/plain
Date: Mon, 07 Jun 2010 02:37:29 -0700
Message-Id: <1275903449.26888.69.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 12:27 +0300, Boaz Harrosh wrote:
> On 06/07/2010 12:02 PM, Nicholas A. Bellinger wrote:
> > On Mon, 2010-06-07 at 11:40 +0300, Boaz Harrosh wrote:
> >> On 06/07/2010 06:50 AM, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>>
> >>> This patch adds initial support for the block layer implementation of the sg v4 interface
> >>> (BSG) -> STGT with a new struct backingstore_template bsg_bst sharing code with the
> >>> original sg_bst.  It adds for new function bs_bsg_cmd_submit() for incoming write I/O
> >>> and bs_bsg_cmd_complete() for polling read I/O using include/linux/bsg.h:struct sg_io_v4.
> >>>
> >>> This patch also splits up bs_sg_open() to support both BSG and SG looking for the
> >>> path "/dev/bsg" in bs_sg_open(), and getting max_queue using SG_GET_COMMAND_Q and
> >>> calling SG_SET_RESERVED_SIZE (following the original bs_sg code in init_sg_device)
> >>>
> >>> Also chk_bsg_device() currently using a hardcoded 254 major as def for BSG does not
> >>> appear in include/linux/major.h just yet..
> >>>
> >>> So far this has been tested with STGT/iSCSI <-> BSG <-> TCM_Loop SPC-4 iSCSI Target
> >>> Port emulation and is able to mkfs, fsck and mount a filesystem from a TCM/IBLOCK
> >>> Linux LVM kernel level backstore
> >>>
> >>> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> >>> ---
> >>>  usr/bs_sg.c     |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++---
> >>>  usr/scsi_cmnd.h |    7 ++
> >>>  2 files changed, 175 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/usr/bs_sg.c b/usr/bs_sg.c
> >>> index 23676ef..d071714 100644
> >>> --- a/usr/bs_sg.c
> >>> +++ b/usr/bs_sg.c
> > 
> > <SNIP>
> > 
> >>> +
> >>> +static int bs_bsg_cmd_submit(struct scsi_cmd *cmd)
> >>> +{
> >>> +	struct scsi_lu *dev = cmd->dev;
> >>> +	int fd = dev->fd;
> >>> +	struct sg_io_v4 *io_hdr = &cmd->cmd_bsg_hdr;
> >>> +	int err = 0;
> >>> +	/*
> >>> +	 * Following linux/include/linux/bsg.h
> >>> +	 */
> >>> +	/* [i] 'Q' to differentiate from v3 */
> >>> +	io_hdr->guard = 'Q';
> >>> +	io_hdr->protocol = BSG_PROTOCOL_SCSI;
> >>> +	io_hdr->subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD;
> >>> +	io_hdr->request_len = cmd->scb_len;
> >>> +	io_hdr->request = (unsigned long )cmd->scb;
> >>> +
> >>> +	if (scsi_get_data_dir(cmd) == DATA_WRITE) {
> >>
> >> Why the if? both sides are fully bidi just remove the ifs
> >> and: OUT <= OUT, IN <= IN
> >>
> > 
> > Whoops, thanks for pointing this one out (again).  Tested with
> > unidirection commands and included into my local tgt.git/pass that I
> > will send along to Tomo-san..
> > 
> > Btw, I still need to sort out BIDI support for TCM_Loop at some point in
> > the not too distant future.  What would be a good way to generate BIDI
> > traffic into STGT or a local SCSI LLD..?
> 
> scsi_debug has some emulation for XOR commands, does that help?
> 

Great, thanks for the pointer on the LLD side.  Is there any userspace
code around that will generate XDWRITEREAD_* CDBs for bulk I/O or do I
need to code this part myself..?

Best,

--nab

