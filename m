Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1ACFWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:22:51 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55078 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1ACFWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mazhRmVphkDOIc0NXLQmVhmp+5QZuGlEiWwTmw5C3zpYwxV9ZwD/+OhEgbYlCPZREx
         ptpBCw74lye0DVCmVKCKSdOjZS19f1AiLqul9vopi9JRkvM8hsOlKfcDAqr8XclvUOOW
         X0iUdaw4LyqnnProCeB/YR8zSXwyMs1aH//nE=
MIME-Version: 1.0
In-Reply-To: <4D1F7517.7080803@gmail.com>
References: <4D1F5A17.4010807@gmail.com>
	<20110101170854.GB32652@parisc-linux.org>
	<4D1F7517.7080803@gmail.com>
Date: Mon, 3 Jan 2011 06:22:49 +0100
Message-ID: <AANLkTingw6peu9g1bN53L9Jtd9XkM-GzrJoNEF-x9Zcu@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: roel kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, nick.cheng@areca.com.tw,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 1, 2011 at 7:40 PM, roel kluin <roel.kluin@gmail.com> wrote:
> Make sure no other command which does a write, such as UNMAP and WRITE_32, is missed.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> If you agree this is the right fix, please ack.
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 17e3df4..a5acedc 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1171,7 +1171,7 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
>        arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
>        if ( arccdbsize > 256)
>                arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
> -       if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0]|WRITE_12 ){
> +       if (pcmd->sc_data_direction == DMA_TO_DEVICE)

If you remove the { from the if, then ...

>                arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
>        }

... you also need to remove this }. ;-)

>        ccb->arc_cdb_size = arccdbsize;
>
