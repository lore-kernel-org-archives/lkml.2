Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0G0RHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:07:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0G0RHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:07:21 -0400
Message-ID: <4C4F123F.3010700@mvista.com>
Date: Tue, 27 Jul 2010 12:07:11 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Run a dummy command before submitting a new command
References: <1280246493-964-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1280246493-964-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this is the right way to handle the problem.  Though it's 
not going to break anything, this change is just a hack.  We need to 
figure out why these machine exhibit this behavior.  If it's a bug in 
the driver, then we need to fix the driver.  If it's a bug in the HP 
firmware, then we need to document it well as such, get HP to fix their 
firmware, and possibly tie it into the xaction handler that's already in 
start_next_msg.

The only interaction with the device that this change should cause is 
one read from the status register, since the device should be idle at 
this point.  If that's the case, and it's not a driver bug, you can try 
adding an xaction that calls smi_info->handlers->event(smi_info->si_sm, 0).

There are debugging flags in the state machines that might help debug 
this, too.

-corey

On 07/27/2010 11:01 AM, Matthew Garrett wrote:
> Newer firmware revisions on HP's ILO3 (1.05 and later) generate state
> machine errors with the current IPMI code. Running through the IPMI
> timeout handler once before submitting the command avoids this.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> Cc: Corey Minyard<cminyard@mvista.com>
> ---
>   drivers/char/ipmi/ipmi_si_intf.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index e39a744..3f06199 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -317,6 +317,7 @@ static int unload_when_empty = 1;
>   static int add_smi(struct smi_info *smi);
>   static int try_smi_init(struct smi_info *smi);
>   static void cleanup_one_si(struct smi_info *to_clean);
> +static void smi_timeout(unsigned long data);
>
>   static ATOMIC_NOTIFIER_HEAD(xaction_notifier_list);
>   static int register_xaction_notifier(struct notifier_block *nb)
> @@ -897,6 +898,7 @@ static void sender(void                *send_info,
>   #endif
>
>   	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
> +	smi_timeout((unsigned long)smi_info);
>
>   	if (smi_info->thread)
>   		wake_up_process(smi_info->thread);
>    

