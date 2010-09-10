Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0IJGcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 02:32:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50471 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0IJGcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 02:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MdEQr6+tMC2bf6gvD0iSiggcgkLfTSd3yo/g1fKMYX85BSX9pjxuH86NMSnwCx4ARw
         B3LgJe5DfyeHSz6Rf1/WpgheLDFbbKTVVA2FuFvD0p5pVflcmUdYjSFSFlJvyVRZxXAs
         FoaWnAqmxNq1XZwGDYl7rgq4Z8ymxkmd97ofc=
Message-ID: <4C89D0E0.4000803@gmail.com>
Date: Fri, 10 Sep 2010 08:32:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH] tcm: Convert to cpu_relax() for atomic_read() in tight
 loops
References: <1284067768-23863-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1284067768-23863-1-git-send-email-nab@linux-iscsi.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2010 11:29 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This patch converts the following functions from within shutdown and release
> path code to use cpu_relax() instead of msleep() while doing atomic_read() in
> a tight loop waiting for various PR and MIB reference count(s) to return to zero:
> 
> 	*) core_update_device_list_for_node() + struct se_dev_entry->pr_ref_count
> 	*) core_release_port() + struct se_port->sep_tg_pt_ref_cnt
> 	*) se_dev_stop() + struct se_hba->dev_mib_access_count
> 	*) __core_scsi3_free_registration() + struct t10_pr_registration->pr_res_holders
> 	*) core_tpg_wait_for_nacl_pr_ref() + struct se_node_acl->acl_pr_ref_count
> 	*) core_tpg_wait_for_mib_ref() + struct se_node_acl->mib_ref_count
> 	*) core_tpg_deregister() + struct se_portal_group->tpg_pr_ref_count
> 	*) transport_deregister_session() + struct se_session->mib_ref_count
> 
> Thanks to Konrad Rzeszutek Wilk for mentioning cpu_relax() usage!
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_device.c    |    6 +++---
>  drivers/target/target_core_pr.c        |    2 +-
>  drivers/target/target_core_tpg.c       |    6 +++---
>  drivers/target/target_core_transport.c |    2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 665b8e2..459f0f8 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -532,7 +532,7 @@ int core_update_device_list_for_node(
>  	 */
>  	spin_unlock_irq(&nacl->device_list_lock);
>  	while (atomic_read(&deve->pr_ref_count) != 0)
> -		msleep(100);
> +		cpu_relax();
>  	spin_lock_irq(&nacl->device_list_lock);
>  	/*
>  	 * Disable struct se_dev_entry LUN ACL mapping

Why would you want to convert those to busy-waiting? This should rather
be converted to wait_event/wake_up, right?

thanks,
-- 
js
