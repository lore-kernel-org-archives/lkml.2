Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1ACQnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:43:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab1ACQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:43:39 -0500
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
From: James Bottomley <James.Bottomley@suse.de>
To: roel kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, just.for.lkml@googlemail.com,
        nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <4D1F7517.7080803@gmail.com>
References: <4D1F5A17.4010807@gmail.com>
	 <20110101170854.GB32652@parisc-linux.org>  <4D1F7517.7080803@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 10:43:30 -0600
Message-ID: <1294073011.4721.7.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-01 at 19:40 +0100, roel kluin wrote:
> Make sure no other command which does a write, such as UNMAP and WRITE_32, is missed.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> If you agree this is the right fix, please ack.
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 17e3df4..a5acedc 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1171,7 +1171,7 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
>  	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
>  	if ( arccdbsize > 256)
>  		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
> -	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0]|WRITE_12 ){
> +	if (pcmd->sc_data_direction == DMA_TO_DEVICE)
>  		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
>  	}
>  	ccb->arc_cdb_size = arccdbsize;

Compile checking patches you send in next time would be most welcome:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c:1177:5: error: expected ‘=’, ‘,’, ‘;’,
‘asm’ or ‘__attribute__’ before ‘->’ token
drivers/scsi/arcmsr/arcmsr_hba.c:1178:2: error: expected identifier or
‘(’ before ‘return’
drivers/scsi/arcmsr/arcmsr_hba.c:1179:1: error: expected identifier or
‘(’ before ‘}’ token
drivers/scsi/arcmsr/arcmsr_hba.c: In function ‘arcmsr_build_ccb’:
drivers/scsi/arcmsr/arcmsr_hba.c:1176:2: warning: control reaches end of
non-void function

James


