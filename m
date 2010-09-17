Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0IQTDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 15:03:46 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:33745 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0IQTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 15:03:44 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPlYk0yrR7H+/2dsb2JhbACiKXGoGJxEhUAEhEyFZ4R3
X-IronPort-AV: E=Sophos;i="4.56,384,1280707200"; 
   d="scan'208";a="362996539"
Message-ID: <4C93BB8E.2080501@cisco.com>
Date: Fri, 17 Sep 2010 12:03:42 -0700
From: Joe Eykholt <jeykholt@cisco.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct Scsi_Host->cmd_serial_number
 to atomic_t
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/10 11:21 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts struct Scsi_Host->cmd_serial_number to an atomic_t so that
> scsi_cmd_get_serial() can be safely called without struct Scsi_Host->host_lock
> in scsi_dispatch_cmd().  This patch also adds a struct Scsi_Host->use_serial_number
> to signal serial_number usage, but this is now disabled by default in
> scsi_host_alloc().
> 
> One special item in scsi_cmd_get_serial() recommended by Joe Eykholt is to
> start struct Scsi_Host->cmd_serial_number at 1, and increment each serial_number
> by 2 so that the serial is odd, and wraps to 1 instead of 0.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/hosts.c     |    4 ++++
>  drivers/scsi/scsi.c      |   13 ++++++++++---
>  include/scsi/scsi_host.h |    8 +++++---
>  3 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8a8f803..aff1c9c 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -380,6 +380,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> +	/*
> +	 * Set the default shost->cmd_serial_number to 1.
> +	 */

Comment not necessary.

> +	atomic_set(&shost->cmd_serial_number, 1);
>  
>  	if (sht->supported_mode == MODE_UNKNOWN)
>  		/* means we didn't set it ... default to INITIATOR */
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ad0ed21..4724ce7 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -636,9 +636,16 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
>   */
>  static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  {
> -	cmd->serial_number = host->cmd_serial_number++;
> -	if (cmd->serial_number == 0) 
> -		cmd->serial_number = host->cmd_serial_number++;
> +	/*
> +	 * The use of per struct scsi_cmnd->serial_number is disabled by default
> +	 */
> +	if (!(host->use_serial_number))
> +		return;
> +	/*
> +	 * Increment the host->cmd_serial_number by 2 so cmd->serial_number
> +	 * is always odd and wraps to 1 instead of 0.
> +	 */
> +	cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
>  }
>  
>  /**
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index b7bdecb..b08d0f2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -602,10 +602,9 @@ struct Scsi_Host {
>  	short unsigned int max_sectors;
>  	unsigned long dma_boundary;
>  	/* 
> -	 * Used to assign serial numbers to the cmds.
> -	 * Protected by the host lock.
> +	 * Used to assign serial numbers to the cmds in scsi_cmd_get_serial()
>  	 */
> -	unsigned long cmd_serial_number;
> +	atomic_t cmd_serial_number;
>  	
>  	unsigned active_mode:2;
>  	unsigned unchecked_isa_dma:1;
> @@ -636,6 +635,9 @@ struct Scsi_Host {
>  	/* Asynchronous scan in progress */
>  	unsigned async_scan:1;
>  
> +	/* Signal usage of per struct scsi_cmnd->serial_number */
> +	unsigned use_serial_number:1;
> +
>  	/*
>  	 * Optional work queue to be utilized by the transport
>  	 */

Simple code is so much fun to critique!   So here goes:

This patch would break any drivers that care about serial_numbers
because it never sets use_serial_number in any drivers.  So that should
be done in the same patch so it's bisect-able.

How about instead of adding use_serial_number, let's just have the
drivers that want a serial number call scsi_cmd_get_serial()
and stop calling it from scsi_dispatch_cmd()?   AFAICT, it's only
used in debug messages in some drivers.  I didn't find other usages
but didn't do an exhaustive search.  If the drivers do it themselves,
maybe they're already under a lock when they get the serial number
and then we wouldn't need the atomic.

Thanks for using my increment by 2 idea.

	Joe




