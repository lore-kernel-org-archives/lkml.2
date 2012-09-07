Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2IGSXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:23:09 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39278 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2IGSXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:23:05 -0400
Subject: Re: [PATCH 06/11] target: go through normal processing for
 zero-length REQUEST_SENSE
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, hch@lst.de,
        roland@kernel.org
In-Reply-To: <1347031842-2531-7-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
	 <1347031842-2531-7-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 11:23:02 -0700
Message-ID: <1347042182.4162.634.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 17:30 +0200, Paolo Bonzini wrote:
> Now that spc_emulate_request_sense has been taught to process zero-length
> REQUEST SENSE correctly, drop the special handling of unit attention
> conditions from transport_generic_new_cmd.  However, for now REQUEST SENSE
> will be the only command that goes through emulation for zero lengths.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

and also applied to master for-3.6.  Nice work Paolo!

So given the nature of these changes I'll likely wait end up waiting
until -rc6 to push these pending for-3.6 bugfixes.

Roland & hch, please let us know if you have any concerns.

Thank you!

--nab

>  drivers/target/target_core_transport.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 8facb74..09d9279 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2301,6 +2301,7 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>  	 * away.
>  	 */
>  	if (!cmd->data_length &&
> +	    cmd->t_task_cdb[0] != REQUEST_SENSE &&
>  	    (cmd->se_dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV ||
>  	     cmd->t_task_cdb[0] == REPORT_LUNS) {
>  		spin_lock_irq(&cmd->t_state_lock);
> @@ -2308,13 +2309,6 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>  		cmd->transport_state |= CMD_T_ACTIVE;
>  		spin_unlock_irq(&cmd->t_state_lock);
>  
> -		if (cmd->t_task_cdb[0] == REQUEST_SENSE) {
> -			u8 ua_asc = 0, ua_ascq = 0;
> -
> -			core_scsi3_ua_clear_for_request_sense(cmd,
> -					&ua_asc, &ua_ascq);
> -		}
> -
>  		INIT_WORK(&cmd->work, target_complete_ok_work);
>  		queue_work(target_completion_wq, &cmd->work);
>  		return 0;


