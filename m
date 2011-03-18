Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab1CRXwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:52:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55074 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab1CRXwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=CtfJj/6+x8LsBfReA3CinmMZy4wHezhKBVKF7ze1Su1OkvmKeiAfYkOphT1BnQWIQ/
         YKP6fneZy1P3AtkxEeQFx52uwnBegvc9ZWijnpBy3wXigyAB6fDBQMQUjnj6ewBY4Plk
         fykD4iBeMu1vGL3dQxC0HP71mbN7+FKfFghJc=
MIME-Version: 1.0
In-Reply-To: <m3y64ct47j.fsf@pullcord.laptop.org>
References: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
 <1300486320-23607-2-git-send-email-lrodriguez@atheros.com> <m3y64ct47j.fsf@pullcord.laptop.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 16:52:08 -0700
X-Google-Sender-Auth: gGDV1jJWRlE-H1mBMsgKF4PsN-A
Message-ID: <AANLkTik=G-FzcUy+x0yK0DY1YKoRA58qhCN95hxOnizO@mail.gmail.com>
Subject: Re: [RFC 1/4] sdhci: allow for multiple delays when sending commands
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        vmehta@atheros.com, naveen.singh@atheros.com, kvalo@adurom.com,
        j@w1.fi, Naveen Singh <nsingh@atheros.com>,
        Vipin Mehta <Vipin.Mehta@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 4:10 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi Luis,
>
> On Fri, Mar 18 2011, Luis R. Rodriguez wrote:
>> This is at least known to be required for the ENE 714.
>>
>> Cc: Chris Ball <cjb@laptop.org>
>> Cc: Kalle Valo <kvalo@adurom.com>
>> Cc: Naveen Singh <nsingh@atheros.com>
>> Cc: Vipin Mehta <Vipin.Mehta@atheros.com>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> I think this wins cjb's "I've never been so confused about what a patch
> author thought they were doing before" award.

I warned you :)

>> ---
>>  drivers/mmc/host/sdhci.c |    7 ++++---
>>  1 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index 9e15f41..c95dfc2 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -891,8 +891,8 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
>>
>>       WARN_ON(host->cmd);
>>
>> -     /* Wait max 10 ms */
>> -     timeout = 10;
>> +     /* Wait max this amount of ms */
>> +     timeout = (10*256) + 255;
>>
>>       mask = SDHCI_CMD_INHIBIT;
>>       if ((cmd->data != NULL) || (cmd->flags & MMC_RSP_BUSY))
>
> Okay, so our original plan is to go through the while loop ten times,
> which equals ten mdelay(1)s == 10ms, waiting for the inhibit bit to
> become unset.
>
> After this hunk of your patch, we're set to go through the loop 2815
> times, which would make for 2.8 seconds.  That seems excessive.
>
>> @@ -913,7 +913,8 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
>>                       return;
>>               }
>>               timeout--;
>> -             mdelay(1);
>> +             if (!(timeout & 0xFF))
>> +                     mdelay(1);
>>       }
>>
>>       mod_timer(&host->timer, jiffies + 10 * HZ);
>
> But wait, here you decide *not* to call mdelay(1) every time through the
> loop, and instead call it only on iterations where the bottom eight bits
> are unset.  This disqualifies most of the 2815 values that timeout will
> be set to, and leaves the following values triggering the mdelay(1):
>
> 0x100 0x200 0x300 0x400 0x500 0x600 0x700 0x800 0x900 0xa00
>  256   512   768  1024  1280  1536  1792  2048  2304  2560
>
> The astute observer will notice that there are ten such values.
> So you're calling mdelay(1) ten times.  But that's what we were
> doing before!  The only difference is that now we spin through
> the while loop 2815 times instead of 10, and don't perform any
> explicit delay on 2805 of them.  Or am I missing something?
>
> I think you should try:
>
> (a) Reverting the patch and checking that it's actually needed
> (b) Leaving the while loop body alone, but increasing the max
>    timeout until you bisect to the amount of ms that your controller
>    actually takes to release the inhibit bit.
> (c) Yelling loudly in the direction that this code came from.  :)

Heh thanks for the review, once I even get ath6kl to even load
properly on x86_64 I'll try reverting this POS hunk and see if it
still works without it. Who knows where the hell this patch came from,
as I noted I was given the entire blob as a huge patch and if you look
at it, the original patch even removes some quirk for tegra.

 Luis
