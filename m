Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1KRExI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:53:08 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:29827 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab1KRExG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:53:06 -0500
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHMnj6gZ2NVqeJYKEyKywEkfms/G5Wx9nyA///jaKA=
Date: Fri, 18 Nov 2011 04:53:03 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA6D232@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1320776028-29568-1-git-send-email-kys@microsoft.com>
 <1321554393.3041.77.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1321554393.3041.77.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAI4rG1l008363



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, November 17, 2011 1:27 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; linux-
> scsi@vger.kernel.org; ohering@suse.com; hch@infradead.org
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> On Tue, 2011-11-08 at 10:13 -0800, K. Y. Srinivasan wrote:
> > The storage driver (storvsc_drv.c) handles all block storage devices
> > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > staging tree for a while and this patch moves it out of the staging area.
> > As per Greg's recommendation, this patch makes no changes to the staging/hv
> > directory. Once the driver moves out of staging, we will cleanup the
> > staging/hv directory.
> >
> > This patch includes all the patches that I have sent against the staging/hv
> > tree to address the comments I have gotten to date on this storage driver.
> 
> First comment is that it would have been easier to see the individual
> patches for comment before you committed them.

I am not sure if the patches have been committed yet. All patches were sent
to various mailing lists and you were copied as well. In the future, I will include
the scsi mailing list in the set of lists I include for the staging patches. 
 
> 
> The way you did mempool isn't entirely right: the problem is that to
> prevent a memory to I/O deadlock we need to ensure forward progress on
> the drain device.  Just having 64 commands available to the host doesn't
> necessarily achieve this because LUN1 could consume them all and starve
> LUN0 which is the drain device leading to the deadlock, so the mempool
> really needs to be per device using slave_alloc.

I will do this per LUN.

> 
> +static int storvsc_device_alloc(struct scsi_device *sdevice)
> +{
> +	/*
> +	 * This enables luns to be located sparsely. Otherwise, we may not
> +	 * discovered them.
> +	 */
> +	sdevice->sdev_bflags |= BLIST_SPARSELUN | BLIST_LARGELUN;
> +	return 0;
> +}
> 
> Looks bogus ... this should happen automatically for SCSI-3 devices ...
> unless your hypervisor has some strange (and wrong) identification?  I
> really think you want to use SCSI-3 because it will do report LUN
> scanning, which consumes far fewer resources.

I will see if I can clean this up.

> 
> I still think you need to disable clustering and junk the bvec merge
> function.  Your object seems to be to accumulate in page size multiples
> (and not aggregate over this) ... that's what clustering is designed to
> do.

As part of addressing your first round of comments, I experimented with your
suggestions and I could not get rid of the code that does the bounce buffer handling.
I could generate I/O patterns that would require bounce buffer handling with your
suggestions in place.

Regards,

K. Y  

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
