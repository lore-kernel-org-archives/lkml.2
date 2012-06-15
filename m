Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2FOS35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:29:57 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:37773 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756336Ab2FOS34 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:29:56 -0400
From: Philip Rakity <prakity@marvell.com>
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
CC: Philip Rakity <philipspatches@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Fri, 15 Jun 2012 11:29:51 -0700
Subject: Re: [PATCH 1/2] regulator: core.c Pass voltage to notifier when
 setting voltage
Thread-Topic: [PATCH 1/2] regulator: core.c Pass voltage to notifier when
 setting voltage
Thread-Index: Ac1LJNqEFP5SRFurQwOCZlRzThvPpA==
Message-ID: <84B43340-7E4D-474B-9217-56E809FF16A9@marvell.com>
References: <1339711609-3417-1-git-send-email-prakity@marvell.com>
 <CADTbHxq5rmHJtFTp53sYhFSYWVrSqyo_Jq+0aWNOF2HQR+nhGA@mail.gmail.com>
In-Reply-To: <CADTbHxq5rmHJtFTp53sYhFSYWVrSqyo_Jq+0aWNOF2HQR+nhGA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15, 2012, at 10:58 AM, Pankaj Jangra wrote:

> Hi Philip,
> 
> Just a cosmetic comments.
> 
> On Fri, Jun 15, 2012 at 3:36 AM, Philip Rakity <philipspatches@gmail.com> wrote:
> V2
> --
> 
> Incorporate performance suggestions made by Mark Brown
> Use linux-next as base code rather than mmc-next
> 
> The voltage being set should be passed to the handler requesting
> the callback.  Currently this is not done.

thanks -- my typo when redoing the patch -- V3 has this fixed.

> 
> The callback cannot call regulator_get_voltage() to get the
> information since the mutex is held by the regulator and
> deadlock occurs.
> 
> Without this change the receiver of the notify cannot now what
>  
> You mean to say "cannot know what" ?   
> 
> action to take.  This is used, for example, to set PAD voltages
> when doing SD vccq voltage changes.


if you call in that receives the notify does not know the new voltage
then in our case we do not know if we should switch the pad from
3.3v to 1.8v for example.  vccq signaling in SD is normally 3.3V
but in UHS mode it is lowered to 1.8V

> 
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> ---
>  drivers/regulator/core.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 63507a5..5b04916 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2153,7 +2153,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
>        if (rdev->desc->ops->list_voltage)
>                best_val = rdev->desc->ops->list_voltage(rdev, selector);
>        else
> -               best_val = -1;
> +               best_val = _regulator_get_voltage(rdev);
> 
>        /* Call set_voltage_time_sel if successfully obtained old_selector */
>        if (_regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
> @@ -2176,9 +2176,9 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
>                udelay(delay);
>        }
> 
> -       if (ret == 0)
> +       if (ret == 0 && best_val >= 0)
>                _notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
> -                                    NULL);
> +                                    (void *)best_val);
> 
> 
> I am also curious to know if you pass the  voltage here to notifier call how does it make any difference, since in 
> blocking_notifier_call_chain() again passes the NULL. So does your patch should  modify the arguments to this function also?
> Please let me know if i am missing something in understanding.
> 
> Regards,
> Pankaj Jangra
> 
>        trace_regulator_set_voltage_complete(rdev_get_name(rdev), best_val);
> 
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

