Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab0HQWDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:03:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32982 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0HQWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pxNPEwV9Bd/w+hjnirVlMpSZwQiJfgOohTbchPp6VdLC6UxjQwx95s66BKIdr2zkrX
         Wb2FaZ6Z3axzZdhhVzrEi9QBGj2OXUyijYoczbJ7Con8Z7kb1Nlc2ZpIejDghAqS5y8W
         YAVVEWNNrHeBPiIYvcIRcPlwiQnEpRxqLEPrs=
Message-ID: <4C6B0717.6030602@garzik.org>
Date: Tue, 17 Aug 2010 18:03:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Saeed Bishara <saeed@marvell.com>, Mark Lord <liml@rtr.ca>,
        Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2/2 #upstream] libata: always use ata_qc_complete_multiple()
 for NCQ command completions
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C247B54.2050900@garzik.org> <4C247C36.6040007@kernel.org> <4C24A903.4060908@kernel.org> <4C24A926.10104@kernel.org>
In-Reply-To: <4C24A926.10104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 09:03 AM, Tejun Heo wrote:
> Currently, sata_fsl, mv and nv call ata_qc_complete() multiple times
> from their interrupt handlers to indicate completion of NCQ commands.
> This limits the visibility the libata core layer has into how commands
> are being executed and completed, which is necessary to support IRQ
> expecting in generic way.  libata already has an interface to complete
> multiple commands at once - ata_qc_complete_multiple() which ahci and
> sata_sil24 already use.
>
> This patch updates the three drivers to use ata_qc_complete_multiple()
> too and updates comments on ata_qc_complete[_multiple]() regarding
> their usages with NCQ completions.  This change not only provides
> better visibility into command execution to the core layer but also
> simplifies low level drivers.
>
> * sata_fsl: It already builds done_mask.  Conversion is straight
>    forward.
>
> * sata_mv: mv_process_crpb_response() no longer checks for illegal
>    completions, it just returns whether the tag is completed or not.
>    mv_process_crpb_entries() builds done_mask from it and passes it to
>    ata_qc_complete_multiple() which will check for illegal completions.
>
> * sata_nv adma: Similar to sata_mv.  nv_adma_check_cpb() now just
>    returns the tag status and nv_adma_interrupt() builds done_mask from
>    it and passes it to ata_qc_complete_multiple().
>
> * sata_nv swncq: It already builds done_mask.  Drop unnecessary
>    illegal transition checks and call ata_qc_complete_multiple().
>
> In the long run, it might be a good idea to make ata_qc_complete()
> whine if called when multiple NCQ commands are in flight.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Ashish Kalra<ashish.kalra@freescale.com>
> Cc: Saeed Bishara<saeed@marvell.com>
> Cc: Mark Lord<liml@rtr.ca>
> Cc: Robert Hancock<hancockr@shaw.ca>
> ---
>   drivers/ata/libata-core.c |   13 ++++++++--
>   drivers/ata/sata_fsl.c    |    8 +-----
>   drivers/ata/sata_mv.c     |   25 +++++++++-----------
>   drivers/ata/sata_nv.c     |   57 ++++++++++------------------------------------
>   4 files changed, 38 insertions(+), 65 deletions(-)

I was getting really inconsistent results on sata_mv 6081 last week. 
Just booted it up again, to try and resolve this, and it started 
spitting out a bunch of PCI errors.  That sounds like the root cause to 
me...  pushing this into #upstream.

