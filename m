Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2AGJAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 04:00:42 -0500
Received: from claw.goop.org ([74.207.240.146]:57293 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2AGJAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 04:00:40 -0500
Message-ID: <4F0809B5.9000105@goop.org>
Date: Sat, 07 Jan 2012 20:00:37 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the battery tree
References: <20120105144042.4e03850089cce56a7e9312e4@canb.auug.org.au> <20120105152536.GB28629@oksana.dev.rtsoft.ru>
In-Reply-To: <20120105152536.GB28629@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 02:25 AM, Anton Vorontsov wrote:
> On Thu, Jan 05, 2012 at 02:40:42PM +1100, Stephen Rothwell wrote:
>> Hi Anton,
>>
>> After merging the battery tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> ERROR: "sysfs_create_link_nowarn" [drivers/power/power_supply.ko] undefined!
>>
>> Caused by commit 8351665195ce ("power_supply: allow a power supply to
>> explicitly point to powered device").  That symbol is not exported to
>> modules.
>>
>> I have used the battery tree from next-20120104 for today.
> Thanks for catching this, Stephen!
>
> I wonder why do we need to use _nowarn variant?..
>
> Something tells me that we actually want a warning.
>
> Jeremy, are you OK with the patch down below?

Yep, that's fine.

    J

>
> - - - -
> From: Anton Vorontsov <cbouatmailru@gmail.com>
> Subject: power_supply: Drop usage of nowarn variant of sysfs_create_link()
>
> The function is not exported to modules, plus we do want to catch anyone
> who tries to create complex hierarchy (in that case we'd need to change
> 'powers' symlink to a directory, probably under a different name to not
> break ABI).
>
> This patch fixes the following build error:
>
>  ERROR: "sysfs_create_link_nowarn" [drivers/power/power_supply.ko] undefined!
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  drivers/power/power_supply_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index b10c121..47f4e11 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -149,7 +149,7 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
>  
>  int power_supply_powers(struct power_supply *psy, struct device *dev)
>  {
> -	return sysfs_create_link_nowarn(&psy->dev->kobj, &dev->kobj, "powers");
> +	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
>  }
>  EXPORT_SYMBOL_GPL(power_supply_powers);
>  

