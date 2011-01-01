Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1AAR2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 12:28:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51747 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1AAR2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 12:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GKEUlJvIQZbZWrdwl86dEN0Y6vrjYF3OR+YJcvsYogRTkLLkgMj92cRqWQYMHUNFSy
         mAZk7wCjNIZXTyJ1WsmXCO3cGYAsGgkuJzmmk4hqw/LzLEr3LY6lI8XwdIVigzSsZGne
         /4In3Kn589JbQFDycnWgPqyzN8O1f+wiIIJac=
MIME-Version: 1.0
In-Reply-To: <20110101170854.GB32652@parisc-linux.org>
References: <4D1F5A17.4010807@gmail.com>
	<20110101170854.GB32652@parisc-linux.org>
Date: Sat, 1 Jan 2011 18:28:34 +0100
Message-ID: <AANLkTikxhKXmnmCKr_HUW3dg3=O3qxNK+ThQEr37zEnC@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: roel kluin <roel.kluin@gmail.com>, nick.cheng@areca.com.tw,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 1, 2011 at 6:08 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Jan 01, 2011 at 05:45:11PM +0100, roel kluin wrote:
>> The WRITE_{6,10,12} are defined numbers, so the branch was always taken.
>
> You're right, but even this will basically always set the write flag,
> since some bits will be set the same, even for reads.  Eg:
>
> #define READ_10               0x28
> #define WRITE_10              0x2a
>
> It should instead be:
>
>> +     if (pcmd->cmnd[0] == WRITE_6 || pcmd->cmnd[0] == WRITE_10 ||
>> +                     pcmd->cmnd[0] == WRITE_12 ){
>
> That will of course miss other commands which do writes, such as UNMAP
> and WRITE_32.  So we should do it properly:
>
>        if (pcmd->sc_data_direction == DMA_TO_DEVICE)
>                arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
>

<http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ae52e7f09ff509df11cd408eabe90132b6be1231;hp=f034260db330bb3ffc815fcb682b1c84aca09591#patch2>
@@ -1034,10 +1075,10 @@ static int arcmsr_build_ccb(struct
AdapterControlBlock *acb,
                }
                arcmsr_cdb->sgcount = (uint8_t)cdb_sgcount;
                arcmsr_cdb->DataLength = scsi_bufflen(pcmd);
+       arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
                if ( arccdbsize > 256)
                        arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-       }
-       if (pcmd->sc_data_direction == DMA_TO_DEVICE ) {
+       if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0] | WRITE_10 ||
pcmd->cmnd[0]|WRITE_12) {
                arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
                ccb->ccb_flags |= CCB_FLAG_WRITE;
        }

Until June 2010 it was that way...
