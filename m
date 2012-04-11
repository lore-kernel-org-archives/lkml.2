Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2DKKR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:17:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2DKKRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:17:24 -0400
Message-ID: <4F855A2B.6070402@canonical.com>
Date: Wed, 11 Apr 2012 18:17:15 +0800
From: Alex Hung <alex.hung@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alex Hung <alex.hung@canonical.com>
CC: ibm-acpi@hmh.eng.br, mjg@redhat.com, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: added BIOS mute interfaces for volume
References: <1334139302-7152-1-git-send-email-alex.hung@canonical.com>
In-Reply-To: <1334139302-7152-1-git-send-email-alex.hung@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am modifying thinkpad_acpi so it can support the mute led, and I am 
looking for suggestions and feedbacks.

For newer BIOS, it includes three aml methods that can be used to get, 
set and enable the mute led.

In *volume_read* function, I modify it to call BIOS GSMS method when it 
is presented in AML. This is more straight-forward.

However, I had debated with myself whether it should be included inside 
the if-else statement. The reason is that the new function is not 
necessarily dependent on volume_get_status, but including it in if-else 
statement works perfectly and it has minimal impacts on the original 
behaviors and therefore I decide to put my patch there.

I implemented as it is now to demonstrate what I am intending to do; 
however, deciding where to add changes to *volume_write* is much more 
difficult to decide for the following reasons:

1. The new mute functions (calling to AML's SSMS and SHDA) are 
dependents on BIOS and they can be called when SSMS and SHDA are supported.
2. If the new functions are included in the original cmd handler (the 
while-loop), they will be blocked by the first if-statement *if 
(!volume_control_allowed && tpacpi_lifecycle != TPACPI_LIFE_INIT)*.
3. However, the changes now will changes the original behaviors (i.e. 
"up", "down" and so on) if BIOS supports new SSMS and SHDA methods.

Any feedbacks and suggestions are most appreciated.

Best Regards,
Alex Hung

On 04/11/2012 06:15 PM, Alex Hung wrote:
> Signed-off-by: Alex Hung<alex.hung@canonical.com>
> ---
>   drivers/platform/x86/thinkpad_acpi.c |  115 +++++++++++++++++++++++++++++++---
>   1 files changed, 106 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index 7b82868..dc22a4c 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -6486,12 +6486,86 @@ enum tpacpi_volume_capabilities {
>   	TPACPI_VOL_CAP_MAX
>   };
>
> +enum  {
> +	TPACPI_AML_MUTE_GET_FUNC = 0x01,
> +	TPACPI_AML_MUTE_SET_FUNC = 0x02,
> +	TPACPI_AML_MUTE_SUPPORT_FUNC = 0x04,
> +	TPACPI_AML_MUTE_READ_MASK = 0x01,
> +	TPACPI_AML_MUTE_ERROR_STATE_MASK = 0x80000000,
> +};
> +
>   static enum tpacpi_volume_access_mode volume_mode =
>   	TPACPI_VOL_MODE_MAX;
>
>   static enum tpacpi_volume_capabilities volume_capabilities;
>   static int volume_control_allowed;
>
> +
> +static bool volume_bios_support(int func)
> +{
> +	acpi_handle temp;
> +
> +	if ((func | TPACPI_AML_MUTE_GET_FUNC)&&
> +	    !ACPI_SUCCESS(acpi_get_handle(hkey_handle, "GSMS",&temp)))
> +		return false;
> +
> +	if ((func | TPACPI_AML_MUTE_SET_FUNC)&&
> +	    !ACPI_SUCCESS(acpi_get_handle(hkey_handle, "SSMS",&temp)))
> +		return false;
> +
> +	if ((func | TPACPI_AML_MUTE_SUPPORT_FUNC)&&
> +	    !ACPI_SUCCESS(acpi_get_handle(hkey_handle, "SHDA",&temp)))
> +		return false;
> +
> +	return true;
> +}
> +
> +static int hotkey_get_mute_state(int *state)
> +{
> +	if (!acpi_evalf(hkey_handle, state, "GSMS", "dd"))
> +		return -EIO;
> +
> +	if (*state&  TPACPI_AML_MUTE_ERROR_STATE_MASK)
> +		pr_warning("getting mute state failed.\n");
> +
> +	*state&= TPACPI_AML_MUTE_READ_MASK;
> +	pr_info("get mute state = %s.\n", *state ? "muted" : "unmuted");
> +
> +	return 0;
> +}
> +
> +static int hotkey_set_mute_state(int state)
> +{
> +	int output;
> +
> +	if (!acpi_evalf(hkey_handle,&output, "SSMS", "dd", state))
> +		return -EIO;
> +
> +	if (output&  TPACPI_AML_MUTE_ERROR_STATE_MASK) {
> +		pr_warning("setting mute state failed.\n");
> +		return -EIO;
> +	}
> +	pr_info("set to mute led state to %s.\n", state ? "on" : "off");
> +
> +	return 0;
> +}
> +
> +static int hotkey_set_mute_support(int support)
> +{
> +	int output;
> +
> +	if (!acpi_evalf(hkey_handle,&output, "SHDA", "dd", support))
> +		return -EIO;
> +
> +	if (output&  TPACPI_AML_MUTE_ERROR_STATE_MASK) {
> +		pr_warning("setting mute support failed.\n");
> +		return -EIO;
> +	}
> +	pr_info("%s mute led support.\n", support ? "disable" : "enable");
> +
> +	return 0;
> +}
> +
>   /*
>    * Used to syncronize writers to TP_EC_AUDIO and
>    * TP_NVRAM_ADDR_MIXER, as we need to do read-modify-write
> @@ -6982,6 +7056,7 @@ static int __init volume_init(struct ibm_init_struct *iibm)
>   static int volume_read(struct seq_file *m)
>   {
>   	u8 status;
> +	int mute;
>
>   	if (volume_get_status(&status)<  0) {
>   		seq_printf(m, "level:\t\tunreadable\n");
> @@ -6991,8 +7066,12 @@ static int volume_read(struct seq_file *m)
>   		else
>   			seq_printf(m, "level:\t\t%d\n",
>   					status&  TP_EC_AUDIO_LVL_MSK);
> -
> -		seq_printf(m, "mute:\t\t%s\n",
> +		if (volume_bios_support(TPACPI_AML_MUTE_GET_FUNC)&&
> +		    !hotkey_get_mute_state(&mute))
> +			seq_printf(m, "mute:\t\t%s\n",
> +				mute ? "muted" : "unmuted");
> +		else
> +			seq_printf(m, "mute:\t\t%s\n",
>   				onoff(status, TP_EC_AUDIO_MUTESW));
>
>   		if (volume_control_allowed) {
> @@ -7005,7 +7084,8 @@ static int volume_read(struct seq_file *m)
>   					       " (<level>  is 0-%d)\n",
>   					       TP_EC_VOLUME_MAX);
>   			}
> -		}
> +		} else if (volume_bios_support(TPACPI_AML_MUTE_SET_FUNC))
> +			seq_printf(m, "commands:\tunmute, mute\n");
>   	}
>
>   	return 0;
> @@ -7019,6 +7099,21 @@ static int volume_write(char *buf)
>   	char *cmd;
>   	int rc;
>
> +	if (volume_bios_support(
> +		TPACPI_AML_MUTE_SET_FUNC | TPACPI_AML_MUTE_SUPPORT_FUNC)) {
> +		while ((cmd = next_cmd(&buf))) {
> +			if (strlencmp(cmd, "mute") == 0)
> +				hotkey_set_mute_state(1);
> +			else if (strlencmp(cmd, "unmute") == 0)
> +				hotkey_set_mute_state(0);
> +			else if (strlencmp(cmd, "disable") == 0)
> +				hotkey_set_mute_support(1);
> +			else if (strlencmp(cmd, "enable") == 0)
> +				hotkey_set_mute_support(0);
> +		}
> +		return -EINVAL;
> +	}
> +
>   	/*
>   	 * We do allow volume control at driver startup, so that the
>   	 * user can set initial state through the volume=... parameter hack.
> @@ -7061,12 +7156,14 @@ static int volume_write(char *buf)
>   				continue;
>   			}
>   		}
> -		if (strlencmp(cmd, "mute") == 0)
> -			new_mute = TP_EC_AUDIO_MUTESW_MSK;
> -		else if (strlencmp(cmd, "unmute") == 0)
> -			new_mute = 0;
> -		else
> -			return -EINVAL;
> +		if (!volume_bios_support(TPACPI_AML_MUTE_SET_FUNC)) {
> +			if (strlencmp(cmd, "mute") == 0)
> +				new_mute = TP_EC_AUDIO_MUTESW_MSK;
> +			else if (strlencmp(cmd, "unmute") == 0)
> +				new_mute = 0;
> +			else
> +				return -EINVAL;
> +		}
>   	}
>
>   	if (tp_features.mixer_no_level_control) {

