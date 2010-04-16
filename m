Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab0DPRYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:24:34 -0400
Received: from nat.nue.novell.com ([195.135.221.3]:49954 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751710Ab0DPRYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:24:33 -0400
Message-ID: <4BC89D4F.8060509@suse.de>
Date: Fri, 16 Apr 2010 21:24:31 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100415 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Rauth <alexander.rauth@promotion-ie.de>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: EC: limit multibyte access to EC to 8 byte
References: <1271434066-7292-1-git-send-email-alexander.rauth@promotion-ie.de>
In-Reply-To: <1271434066-7292-1-git-send-email-alexander.rauth@promotion-ie.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Thanks, but we already have patch to do just that.
See https://bugzilla.kernel.org/show_bug.cgi?id=15749

Regards,
Alex.

16.04.2010 20:07, Alexander Rauth пишет:
> commit dadf28a10c3eb29421837a2e413ab869ebd9e168 enabled multibyte
> access to EC, but ignored that the consuming function expects the
> bitfields to be in chunks of maximal 64 bit. So limit multibyte
> access to 8 byte to prevent error in the ACPI layer.
>
> Signed-off-by: Alexander Rauth<alexander.rauth@promotion-ie.de>
> ---
>   drivers/acpi/acpica/exprep.c |   17 +++++++++++------
>   1 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
> index a610ebe..58659af 100644
> --- a/drivers/acpi/acpica/exprep.c
> +++ b/drivers/acpi/acpica/exprep.c
> @@ -471,13 +471,18 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
>   		/* allow full data read from EC address space */
>   		if (obj_desc->field.region_obj->region.space_id ==
>   			ACPI_ADR_SPACE_EC) {
> -			if (obj_desc->common_field.bit_length>  8)
> -				obj_desc->common_field.access_bit_width =
> -				ACPI_ROUND_UP(obj_desc->common_field.
> -							bit_length, 8);
> +			if (obj_desc->common_field.bit_length>  8) {
> +				if (obj_desc->common_field.bit_length<= 64) {
> +					obj_desc->common_field.access_bit_width =
> +						ACPI_ROUND_UP(obj_desc->common_field.
> +						bit_length, 8);
> +				} else {
> +					obj_desc->common_field.access_bit_width = 64;
> +				}	
>   				obj_desc->common_field.access_byte_width =
> -				ACPI_DIV_8(obj_desc->common_field.
> -							access_bit_width);
> +					ACPI_DIV_8(obj_desc->common_field.
> +					access_bit_width);
> +			}
>   		}
>
>   		ACPI_DEBUG_PRINT((ACPI_DB_BFIELD,

