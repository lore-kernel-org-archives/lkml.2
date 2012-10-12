Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2JLKLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:11:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59972 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JLKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:11:27 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5077ECA6.4010302@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 19:10:46 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <bhelgaas@google.com>, <lenb@kernel.org>, <yinghai@kernel.org>,
        <izumi.taku@jp.fujitsu.com>, <jiang.liu@huawei.com>,
        <linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix a hard coding style when determining if a device
 is a container.
References: <1350024916-3628-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1350024916-3628-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tang,

2012/10/12 15:55, Tang Chen wrote:
> "ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
> container_device_ids[], so use it, but not the hard coding style.

The idea is good.

> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>   drivers/acpi/container.c |   10 +++++++---
>   1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 1f9f7d7..448c0e2 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -217,6 +217,7 @@ container_walk_namespace_cb(acpi_handle handle,
>   {
>   	char *hid = NULL;
>   	struct acpi_device_info *info;
> +	struct acpi_device_id *container_id;
>   	acpi_status status;
>   	int *action = context;
>   
> @@ -232,10 +233,13 @@ container_walk_namespace_cb(acpi_handle handle,
>   		goto end;
>   	}
>   
> -	if (strcmp(hid, "ACPI0004") && strcmp(hid, "PNP0A05") &&
> -	    strcmp(hid, "PNP0A06")) {
> -		goto end;
> +	for (container_id = container_device_ids;
> +	     container_id->id[0]; container_id++) {
> +		if (!strcmp((char *)container_id->id, hid))
> +			break;
>   	}
> +	if (!container_id->id[0])
> +		goto end;

How about prepare is_container_device() function and check whether
the device is the container device or not as below?

	if (is_container_device())
		goto end;

Thanks,
Yasuaki Ishimatsu

>   
>   	switch (*action) {
>   	case INSTALL_NOTIFY_HANDLER:
> 


