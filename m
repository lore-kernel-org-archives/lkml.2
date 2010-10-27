Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab0J0O0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:26:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46783 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab0J0O0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=P/rIiHGKUfBYALnmdtLRvAkJYel9Q5zQc8pKbxnAv8EBCBhiE862C9cWIVqOv33eN/
         amCM5yYHM/cmPpp4HWhwkPbCpYrmQIUls9+8fMrr3J0ndCXJiCqbDMQQqSBAWUMF2r5U
         sMIrijWx5ctLVT43j3QqddCZIGJj86B77tyFc=
MIME-Version: 1.0
In-Reply-To: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
References: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 27 Oct 2010 16:26:09 +0200
X-Google-Sender-Auth: TElvavkm1XuIh34wkFcXTGk84l8
Message-ID: <AANLkTi=juKAP9gZ4hhRCPwovWRn8px=FEWCCUfuJbUQM@mail.gmail.com>
Subject: Re: [PATCH] scsi: Add SHT->unlocked_qcmd for host_lock less
 SHT->queuecommand() dispatch
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 2:32 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> [ ... ]
>
> Finally, this patch also converts the remaining struct Scsi_Host->cmd_serial_number
> to atomic_t following a recommedation by Joe Eykholt to start struct Scsi_Host->
> cmd_serial_number at 1, and increment each serial_number by 2 so that the
> serial is odd, and wraps to 1 instead of 0.  struct Scsi_Host->cmd_serial_number
> is initialized to '1' in drivers/scsi/hosts.c:scsi_host_alloc().
>
> [ ... ]
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 4f7a582..0c87c4f 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -381,6 +381,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>        shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>        shost->use_clustering = sht->use_clustering;
>        shost->ordered_tag = sht->ordered_tag;
> +       shost->unlocked_qcmd = sht->unlocked_qcmd;
> +       /*
> +        * Set the default shost->cmd_serial_number to 1.
> +        */
> +       atomic_set(&shost->cmd_serial_number, 1);
>
>        if (sht->supported_mode == MODE_UNKNOWN)
>                /* means we didn't set it ... default to INITIATOR */
> [ ... ]
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 348fba0..7c93384 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -628,17 +628,69 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
>
>  /**
>  * scsi_cmd_get_serial - Assign a serial number to a command
> - * @host: the scsi host
>  * @cmd: command to assign serial number to
>  *
>  * Description: a serial number identifies a request for error recovery
> - * and debugging purposes.  Protected by the Host_Lock of host.
> + * and debugging purposes.  Called directly by SCSI LLDs that have a
> + * legacy requirement for struct scsi_cmnd->serial_number.
>  */
> -static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
> +void scsi_cmd_get_serial(struct scsi_cmnd *cmd)
>  {
> -       cmd->serial_number = host->cmd_serial_number++;
> -       if (cmd->serial_number == 0)
> -               cmd->serial_number = host->cmd_serial_number++;
> +       struct Scsi_Host *host = cmd->device->host;
> +       /*
> +        * Increment the host->cmd_serial_number by 2 so cmd->serial_number
> +        * is always odd and wraps to 1 instead of 0.
> +        */
> +       cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
> +}
> +EXPORT_SYMBOL(scsi_cmd_get_serial);
> +
> [ ... ]

There is a mismatch between the patch description and the patch
itself. The patch description says that the serial number starts at
one while the patch itself makes the serial number start at three.

Bart.
