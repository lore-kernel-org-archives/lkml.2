Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0IMTyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:54:44 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:27057 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755260Ab0IMTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:54:42 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: zs.7U5cVM1noOTRUitUmeEiUBN5ebhTguDRdDrxzI2dEBwa
 3phnzuEQNn_i6u9FTTpwSOZzmFLbUeBAufiIPrgrlbIZIsfvgMtI1x_.EeN6
 iOrBfF0Ldw1sC_Mk_nFe12ylqIOogGUi.wognOWs5IKZ8iajRftvEQY2DmH3
 RNydH7Q2h8NuiX9fpYNTGhSzODVVgE6_Gzv0R3pa_wnTaDyZ048at4.l64R2
 Iwj9__7PICVNQODaWKAH0h6_FTPKHcpxHEDwH.d4NriilWLPvF.6893U6gQn
 VvtZ445WNasXDw6M4UJO8uB4IeEr3i0VWgDCEt07bTplCEQTRbeB8NTOnKnh
 L5RyvhLEKCwTv1LrZsg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and
	crc32-intel offload
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>
In-Reply-To: <4C8DED17.6080801@suse.de>
References: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
	 <4C8DED17.6080801@suse.de>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 12:50:32 -0700
Message-Id: <1284407432.8171.41.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:21 +0200, Hannes Reinecke wrote:
> Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greetings all,
> > 
> > This patch series converts the LIO-Target fabric module from using a legacy
> > internal slicing by 1x CRC32C algorithm to the slicing by 1x CRC32C available in
> > crc32c.ko, as well as initial support for the Nehalem series crc32c-intel.ko
> > instruction offload available since v2.6.27 in late 2008.
> > 
> > So far this series has been lightly tested with a handful of Open-iSCSI client VMs
> > with the optimized crc32c-intel.ko offload case, and there appears to be some
> > HeaderDigest failures for one case with RHEL6 B2 x86_64, while Ubuntu i686 on
> > v2.6.27 and OpenSuse 11.2 x86_64 on v2.6.31 work as expected with HeaderDigest=CRC32C
> > and DataDigest=CRC32C using the offload on the LIO-Target side.
> > 
> > Currently this patch disables the new iSCSI TPG attribute crc32c_x86_offload
> > to force the crc32c.ko slicing by x1 CRC32C algorithm until these compatibility
> > issues with existing libcrc32c clients can be properly resolved with the Nehalem
> > CRC32C offload instructions running on the LIO-Target side.
> > 
> Due to a customer issue I had to revisit the CRC32 issue recently.
> And according to you the main reason for using your own CRC routines
> had been endianness issues.

Indeed, this has historically been the case for LIO-Target and
Core-iSCSI.  I noticed the issue with libcrypto while porting the latter
on a old G4 TI-book waaay back during v2.6.10-rc3 days.

> IE the in-kernel crc32c routines apparently weren't able to
> calculate the checksum in an endianness-independent manner.
> So a CRC calculated on a BE machine would fail to be validated by a
> LE machine and vice versa.
> 
> Has this been fixed / verified?
> 

>From taking a look at crypto/crc32c.c it still appears AFAICT to not be
big endian safe.  I was planning to test this patch on some powerpc/ppc
hardware with v2.6.36-rc4 in the next days, but it looks like
lio-core-2.6.git will need a seperate crypto/crc32c.c patch to function
properly on big endian arches.

Thanks for mentioning this point Hannes!

--nab

