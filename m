Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1G0Ucy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:32:54 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43123 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1G0Ucv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <1311747048.72460.YahooMailNeo@web31810.mail.mud.yahoo.com>
References: <1311747048.72460.YahooMailNeo@web31810.mail.mud.yahoo.com>
Date: Wed, 27 Jul 2011 13:32:50 -0700
X-Google-Sender-Auth: O0FPb5bHXYeKSfFk9vX_MCiDWFY
Message-ID: <CAA9_cmc3RWUFsWkyO4qnTLbVTmcGv51Ab8LyJqJUbNHbnx0kCg@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
From: Dan Williams <dan.j.williams@intel.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@parallels.com>,
        Jack Wang <jack_wang@usish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:10 PM, Luben Tuikov <ltuikov@yahoo.com> wrote:
> If expander discovery fails (sas_discover_expander()),
> remove the expander from the port device list
> (sas_ex_discover_expander()), before freeing it. Else
> the list is corrupted and, e.g., when we attempt to send
> SMP commands to other devices, the kernel oopses.
>
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> Reviewed-by: Jack Wang <jack_wang@usish.com>
> ---
>  drivers/scsi/libsas/sas_expander.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 874e29d..f84084b 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expander(
>
>         res = sas_discover_expander(child);
>         if (res) {
> +               spin_lock_irq(&parent->port->dev_list_lock);
> +               list_del(&child->dev_list_node);
> +               spin_unlock_irq(&parent->port->dev_list_lock);
>                 kfree(child);
>                 return NULL;

Acked-by: Dan Williams <dan.j.williams@intel.com>

...but it raises a couple questions for potential follow on patches:

1/ Do we need to add the device to port->dev_list prior to the
discovery?  Seems cleaner to defer the list_add until after the
discovery has succeeded.

2/ We have unlocked list manipulations in sas_ex_discover_end_dev(),
sas_unregister_common_dev(), and sas_ex_discover_end_dev()

--
Dan
