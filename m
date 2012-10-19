Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab2JSTU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:20:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36740 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969Ab2JSTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <1350641040-19434-3-git-send-email-wency@cn.fujitsu.com>
References: <1350641040-19434-1-git-send-email-wency@cn.fujitsu.com> <1350641040-19434-3-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 15:20:06 -0400
X-Google-Sender-Auth: jFQVhqmcLHtf0h0liR0cpqP4bvs
Message-ID: <CAHGf_=pxLj8r99GwKO3n-Zc_drebVe5Lr4dB+xqB=TQG2B0Wtg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] acpi,memory-hotplug: introduce a mutex lock to
 protect the list in acpi_memory_device
To: wency@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, liuj97@gmail.com, len.brown@intel.com,
        akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        muneda.takahiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>, Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 6:03 AM,  <wency@cn.fujitsu.com> wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> The memory device can be removed by 2 ways:
> 1. send eject request by SCI
> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
>
> This 2 events may happen at the same time, so we may touch
> acpi_memory_device.res_list at the same time. This patch
> introduce a lock to protect this list.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 1e90e8f..8ff2976 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -83,7 +83,8 @@ struct acpi_memory_info {
>  struct acpi_memory_device {
>         struct acpi_device * device;
>         unsigned int state;     /* State of the memory device */
> -       struct list_head res_list;
> +       struct mutex lock;
> +       struct list_head res_list;      /* protected by lock */
>  };

Please avoid grep unfriendly name. "lock" is too common. res_list_lock
or list_lock
are better IMHO.
