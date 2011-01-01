Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1AARMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 12:12:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56495 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1AARMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 12:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k3ccAV2e2HxxvvQ1NQmh6Vu8XPlgOIg2/lpBOWlKAr97XN4ZrHMAY3exJGzm8sqPLo
         7rJ3Miio20OiIi1nAh9SRXC4OimixSIz7YE5Ww5NATpHFRCHbbKqp2T5ZEE9sM2zMud4
         n4MLw8vPBnKcb9RQii1ta9f6w+ZoXog8AgWOc=
MIME-Version: 1.0
In-Reply-To: <4D1F5A17.4010807@gmail.com>
References: <4D1F5A17.4010807@gmail.com>
Date: Sat, 1 Jan 2011 18:12:00 +0100
Message-ID: <AANLkTikD-E5-XzvgWSJOY518A7ERpuYNwNcYCgKKn91K@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: roel kluin <roel.kluin@gmail.com>
Cc: nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 1, 2011 at 5:45 PM, roel kluin <roel.kluin@gmail.com> wrote:
> The WRITE_{6,10,12} are defined numbers, so the branch was always taken.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> See include/scsi/scsi.h:58-123 for
> #define WRITE_6               0x0a
> #define WRITE_10              0x2a
> #define WRITE_12              0xaa
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 17e3df4..a6e5222 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1171,7 +1171,8 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
>        arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
>        if ( arccdbsize > 256)
>                arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
> -       if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0]|WRITE_12 ){
> +       if (pcmd->cmnd[0] & WRITE_6 || pcmd->cmnd[0] & WRITE_10 ||
> +                       pcmd->cmnd[0] & WRITE_12 ){

I'm not sure, if the compiler will optimize this anyway, but would it
look better this way:
if (pcmd->cmnd[0] & (WRITE_6 | WRITE_10 | WRITE_12)){

And that would open the question what really was meant, as that will
be equal to:
if (pcmd->cmnd[0] & WRITE_12){

(if you look at the constants, you can skip WRITE_6 and _10 as there
bits are already included in WRITE_12)


>                arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
>        }
>        ccb->arc_cdb_size = arccdbsize;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
