Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab2CRBk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 21:40:57 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:47656
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756732Ab2CRBk4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 21:40:56 -0400
X-SpamScore: -19
X-BigFish: VS-19(zzbb2dI9371I936eK542M1432N98dKzz1202hzz8275bh8275dhz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: "dgilbert@interlog.com" <dgilbert@interlog.com>,
        Jeff Garzik <jeff@garzik.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 2/2] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Topic: [PATCH 2/2] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Index: AQHNA7a50NyOpWfJEkyddxfm+pj8DJZulyQAgABAhgCAAHDRQA==
Date: Sun, 18 Mar 2012 01:40:51 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B767B28@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1331929448-6838-1-git-send-email-kys@microsoft.com>
 <1331929472-6877-1-git-send-email-kys@microsoft.com>
 <1331929472-6877-2-git-send-email-kys@microsoft.com>
 <4F64A80C.6040206@garzik.org> <4F64DE2C.1030809@interlog.com>
In-Reply-To: <4F64DE2C.1030809@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Douglas Gilbert [mailto:dgilbert@interlog.com]
> Sent: Saturday, March 17, 2012 2:56 PM
> To: Jeff Garzik
> Cc: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On 12-03-17 04:04 PM, Jeff Garzik wrote:
> > On 03/16/2012 04:24 PM, K. Y. Srinivasan wrote:
> >> The current Windows hosts don't handle the ATA_16 command and
> furthermore
> >> return a generic error code after filtering the command on the host side.
> >> For now filter the command on the guest side until the host is modified to
> >> properly handle unsupported commands.
> >>
> >> Signed-off-by: K. Y. Srinivasan<kys@microsoft.com>
> >> Reviewed-by: Haiyang Zhang<haiyangz@microsoft.com>
> >> ---
> >> drivers/scsi/storvsc_drv.c | 9 +++++++++
> >> 1 files changed, 9 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> >> index 8b967c9..783bab8 100644
> >> --- a/drivers/scsi/storvsc_drv.c
> >> +++ b/drivers/scsi/storvsc_drv.c
> >> @@ -1229,8 +1229,17 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd
> *scmnd)
> >> /*
> >> * smartd sends this command and the host does not handle
> >> * this. So, don't send it.
> >> + * The current Windows hosts implement a subset of scsi commands
> >> + * and for the commands that are not implemented, the host filters
> >> + * them and returns a generic failure SRB status. I have been in
> >> + * discussions with the Windows team to return the appropriate SRB
> >> + * status code for unsupported scsi commands and while they have
> >> + * agreed to implement this, it is not clear when this change will be
> >> + * available. Consequently, filtering the command before submitting it
> >> + * to the host is a resonable interim solution.
> >> */
> >> case SET_WINDOW:
> >> + case ATA_16:
> >> scmnd->result = ILLEGAL_REQUEST<< 16;
> >> allowed = false;
> >
> > It would be even nicer to fill out a nice SCSI status for this. For an illegal
> > request such as this, the libata SCSI simulator (drivers/ata/libata-scsi.c) uses
> > a more complete sense buffer setup,
> >
> > static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk,
> > u8 asc, u8 ascq)
> > {
> > cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
> >
> > scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
> > }
> >
> > and calls this function for invalid/unknown/unsupported command ops thusly,
> >
> > ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
> > /* "Invalid command operation code" */
> >
> > Supplying asc/ascq provides additional information that may be useful in
> > determining whether or not to retry, provide better error diagnostics, etc.
> >
> > The asc/ascq values are found in the SCSI standards documents.
> 
> Jeff,
> I agree with your suggestion and would point out that the
> originally proposed:
>      scmnd->result = ILLEGAL_REQUEST<<  16;
> 
> is just plain wrong. result[23:16] is a Linux invented host byte
> code (they typically start with "DID_") while ILLEGAL_REQUEST is
> a SCSI sense key.
> 
> Doug Gilbert
> 
Jeff, Doug,

Thank you. I will make the suggested changes.

Regards,

K. Y

