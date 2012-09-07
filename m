Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2IGSGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:06:52 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:41231 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2IGSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:06:48 -0400
Subject: Re: [PATCH 01/11] target: go through normal processing for
 zero-length PSCSI commands
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, hch@lst.de,
        roland@kernel.org
In-Reply-To: <1347031842-2531-2-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
	 <1347031842-2531-2-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 11:06:45 -0700
Message-ID: <1347041205.4162.624.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 17:30 +0200, Paolo Bonzini wrote:
> Right now, commands with a zero-size payload are skipped completely.
> This is wrong; such commands should be passed down to the device and
> processed normally.
> 
> For physical backends, this ignores completely things such as START
> STOP UNIT.  For virtual backends, we have a hack in place to clear a
> unit attention state on a zero-size REQUEST SENSE, but we still do
> not report errors properly on zero-length commands---out-of-bounds
> 0-block reads and writes, too small parameter list lengths, etc.
> 
> This patch fixes this for PSCSI.  Uses of transport_kmap_data_sg are
> guarded with a check for non-zero cmd->data_length; for all other
> commands a zero length is handled properly in pscsi_execute_cmd.
> The sole exception will be for now REPORT LUNS, which is handled
> through the normal SPC emulation.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Applied to target-pending/master for-3.6.

Thanks Paolo!

> ---
>  drivers/target/target_core_pscsi.c     |    8 ++++----
>  drivers/target/target_core_transport.c |    4 +++-
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index c026ee3..682a581 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -688,11 +688,11 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
>  	 * Hack to make sure that Write-Protect modepage is set if R/O mode is
>  	 * forced.
>  	 */
> +	if (!cmd->se_deve || !cmd->data_length)
> +		goto after_mode_sense;
> +
>  	if (((cdb[0] == MODE_SENSE) || (cdb[0] == MODE_SENSE_10)) &&
>  	     (status_byte(result) << 1) == SAM_STAT_GOOD) {
> -		if (!cmd->se_deve)
> -			goto after_mode_sense;
> -
>  		if (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
>  			unsigned char *buf = transport_kmap_data_sg(cmd);
>  
> @@ -709,7 +709,7 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
>  	}
>  after_mode_sense:
>  
> -	if (sd->type != TYPE_TAPE)
> +	if (sd->type != TYPE_TAPE || !cmd->data_length)
>  		goto after_mode_select;
>  
>  	/*
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 09028af..2e55aa9 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2295,7 +2295,9 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>  	 * into the fabric for data transfers, go ahead and complete it right
>  	 * away.
>  	 */
> -	if (!cmd->data_length) {
> +	if (!cmd->data_length &&
> +	    (cmd->se_dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV ||
> +	     cmd->t_task_cdb[0] == REPORT_LUNS) {
>  		spin_lock_irq(&cmd->t_state_lock);
>  		cmd->t_state = TRANSPORT_COMPLETE;
>  		cmd->transport_state |= CMD_T_ACTIVE;


