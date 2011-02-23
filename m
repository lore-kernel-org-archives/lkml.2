Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1BWIbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:31:14 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34484 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1BWIbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jjKaHKjw0nxlQfAxqwvVVn9vFLbqH8p1Dg80iZuX4SUwQUMe+16BPeP80ItoBwaG/f
         RYMwXUGo7m8HfIfRu/53BO0q9bfc7/2ucwGowvQLBDly1fVRfJ+WPW7YZ9azUakj09Ft
         FEhOI2bdyEUa0qEwAyvriQvo8r+gwoLu63A1A=
MIME-Version: 1.0
In-Reply-To: <20110223092619.4dfa7480@schatten.dmk.lab>
References: <1297117771-12392-1-git-send-email-florian@mickler.org>
	<20110223092619.4dfa7480@schatten.dmk.lab>
Date: Wed, 23 Feb 2011 18:28:21 +1000
Message-ID: <AANLkTinyEo62CurDuWnt-Mq0bbQyS+-Fe06_=izNbzGA@mail.gmail.com>
Subject: Re: [PATCH] amd64-agp: fix crash at second module load
From: Dave Airlie <airlied@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: akpm@linux-foundation.org, airlied@linux.ie, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 6:26 PM, Florian Mickler <florian@mickler.org> wrote:
> Hi Andrew,
> I sent this to Dave Airlie because that is what MAINTAINERS says, but
> that is probably the wrong receipient?
>

No I just get agp blindspots, esp for the 64-bit ones since they
interact with x86.

I'll push it to Linus tomorrow.

Dave.

> Regards,
> Flo
>
> On Mon,  7 Feb 2011 23:29:31 +0100
> Florian Mickler <florian@mickler.org> wrote:
>
>> The module forgot to sometimes unregister some resources.
>>
>> This fixes Bug #22882.
>>
>> [Patch updated to 2.6.38-rc3 by Randy Dunlap.]
>> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Signed-off-by: Florian Mickler <florian@mickler.org>
>> ---
>>  drivers/char/agp/amd64-agp.c |    9 +++++++--
>>  1 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
>> index 9252e85..780498d 100644
>> --- a/drivers/char/agp/amd64-agp.c
>> +++ b/drivers/char/agp/amd64-agp.c
>> @@ -773,18 +773,23 @@ int __init agp_amd64_init(void)
>>  #else
>>                       printk(KERN_INFO PFX "You can boot with agp=try_unsupported\n");
>>  #endif
>> +                     pci_unregister_driver(&agp_amd64_pci_driver);
>>                       return -ENODEV;
>>               }
>>
>>               /* First check that we have at least one AMD64 NB */
>> -             if (!pci_dev_present(amd_nb_misc_ids))
>> +             if (!pci_dev_present(amd_nb_misc_ids)) {
>> +                     pci_unregister_driver(&agp_amd64_pci_driver);
>>                       return -ENODEV;
>> +             }
>>
>>               /* Look for any AGP bridge */
>>               agp_amd64_pci_driver.id_table = agp_amd64_pci_promisc_table;
>>               err = driver_attach(&agp_amd64_pci_driver.driver);
>> -             if (err == 0 && agp_bridges_found == 0)
>> +             if (err == 0 && agp_bridges_found == 0) {
>> +                     pci_unregister_driver(&agp_amd64_pci_driver);
>>                       err = -ENODEV;
>> +             }
>>       }
>>       return err;
>>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
