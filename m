Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2IGSMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:12:38 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:43419 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGSMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:12:35 -0400
Subject: Re: [PATCH 04/11] target: support zero-size allocation lengths in
 transport_kmap_data_sg
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, hch@lst.de,
        roland@kernel.org
In-Reply-To: <1347031842-2531-5-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
	 <1347031842-2531-5-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 11:12:33 -0700
Message-ID: <1347041553.4162.628.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 17:30 +0200, Paolo Bonzini wrote:
> In order to support zero-size allocation lengths, do not assert
> that we have a scatterlist until after checking cmd->data_length.
> 
> But once we do this, we can have two cases of transport_kmap_data_sg
> returning NULL: a zero-size allocation length, or an out-of-memory
> condition.  Report the latter using sense codes, so that the SCSI
> command that triggered it will fail.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Applied to master for-3.6.

Nice work Paolo!

>  drivers/target/target_core_transport.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 2e55aa9..8facb74 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2185,7 +2185,6 @@ void *transport_kmap_data_sg(struct se_cmd *cmd)
>  	struct page **pages;
>  	int i;
>  
> -	BUG_ON(!sg);
>  	/*
>  	 * We need to take into account a possible offset here for fabrics like
>  	 * tcm_loop who may be using a contig buffer from the SCSI midlayer for
> @@ -2193,13 +2192,17 @@ void *transport_kmap_data_sg(struct se_cmd *cmd)
>  	 */
>  	if (!cmd->t_data_nents)
>  		return NULL;
> -	else if (cmd->t_data_nents == 1)
> +
> +	BUG_ON(!sg);
> +	if (cmd->t_data_nents == 1)
>  		return kmap(sg_page(sg)) + sg->offset;
>  
>  	/* >1 page. use vmap */
>  	pages = kmalloc(sizeof(*pages) * cmd->t_data_nents, GFP_KERNEL);
> -	if (!pages)
> +	if (!pages) {
> +		cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  		return NULL;
> +	}
>  
>  	/* convert sg[] to pages[] */
>  	for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, i) {
> @@ -2208,8 +2211,10 @@ void *transport_kmap_data_sg(struct se_cmd *cmd)
>  
>  	cmd->t_data_vmap = vmap(pages, cmd->t_data_nents,  VM_MAP, PAGE_KERNEL);
>  	kfree(pages);
> -	if (!cmd->t_data_vmap)
> +	if (!cmd->t_data_vmap) {
> +		cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  		return NULL;
> +	}
>  
>  	return cmd->t_data_vmap + cmd->t_data_sg[0].offset;
>  }


