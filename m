Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1GENx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:53:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42199 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1GENxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:53:25 -0400
Message-ID: <4E13174B.30403@gmail.com>
Date: Tue, 05 Jul 2011 21:53:15 +0800
From: Gong Chen <clumsycg@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Thomas Renninger <trenn@novell.com>
Subject: Re: [RFC 1/2] ACPI, APEI, Add apei_exec_run_optional
References: <1309846023-16459-1-git-send-email-ying.huang@intel.com>
In-Reply-To: <1309846023-16459-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/7/5 14:07, Huang Ying 写道:
> Some actions in APEI ERST and EINJ tables are optional, for example,
> ACPI_EINJ_BEGIN_OPERATION action is used to do some preparation for
> error injection, and firmware may choose to do nothing here.  While
> some other actions are mandatory, for example, firmware must provide
> ACPI_EINJ_GET_ERROR_TYPE implementation.
>
> Original implementation treats all actions as optional (that is, can
> have no instructions), that may cause issue if firmware does not
> provide some mandatory actions.  To fix this, this patch adds
> apei_exec_run_optional, which should be used for optional actions.
> The original apei_exec_run should be used for mandatory actions.
>
> Cc: Thomas Renninger<trenn@novell.com>
> Signed-off-by: Huang Ying<ying.huang@intel.com>
> ---
>   drivers/acpi/apei/apei-base.c     |    9 +++++----
>   drivers/acpi/apei/apei-internal.h |   13 ++++++++++++-
>   2 files changed, 17 insertions(+), 5 deletions(-)
>
> --- a/drivers/acpi/apei/apei-base.c
> +++ b/drivers/acpi/apei/apei-base.c
> @@ -157,9 +157,10 @@ EXPORT_SYMBOL_GPL(apei_exec_noop);
>    * Interpret the specified action. Go through whole action table,
>    * execute all instructions belong to the action.
>    */
> -int apei_exec_run(struct apei_exec_context *ctx, u8 action)
> +int __apei_exec_run(struct apei_exec_context *ctx, u8 action,
> +		    bool optional)
>   {
> -	int rc;
> +	int rc = -ENOENT;
>   	u32 i, ip;
>   	struct acpi_whea_header *entry;
>   	apei_exec_ins_func_t run;
> @@ -198,9 +199,9 @@ rewind:
>   			goto rewind;
>   	}
>
> -	return 0;
> +	return !optional&&  rc<  0 ? rc : 0;

if one operation is optional but running into errors when executing this 
kind of command,
here just ignoring it. Is it reasonable ?

