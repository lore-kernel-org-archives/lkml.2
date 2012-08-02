Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2HBKHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:07:22 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:46140 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab2HBKHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:07:21 -0400
Message-ID: <501A5151.4040207@ti.com>
Date: Thu, 02 Aug 2012 15:37:13 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Fix the error handling in probe
References: <1343813788-19165-1-git-send-email-shubhrajyoti@ti.com> <20120801150713.GB15630@roeck-us.net>
In-Reply-To: <20120801150713.GB15630@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2012 08:37 PM, Guenter Roeck wrote:
> On Wed, Aug 01, 2012 at 03:06:28PM +0530, Shubhrajyoti D wrote:
>> The kfree() is taken care of by the spi core (spi_master_release() function)
>> that is called once the last reference to the underlying struct device has
>> been released. So the driver need not call kfree.
>>
>> Also the put was missed in some of the error handling fix the same.
>> There by fixing the missing device_put in some of the error paths.
>>
>> Cc: Guenter Roeck <linux@roeck-us.net>
> Reported-by: may be better here.
My bad. I should have done.
>
>> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Acked-by: Guenter Roeck <linux@roeck-us.net>
thanks.
> I suspect that "spi_master_put(master);" may also be missing in
> omap2_mcspi_remove(), but we'll need someone to confirm that.
Looks unlikely.

spi_master_put does a 
...
  if (master)
                put_device(&master->dev);
...

In remove I call 

spi_unregister_master
...
*/
void spi_unregister_master(struct spi_master *master)
{
        int dummy;
[...]

        dummy = device_for_each_child(&master->dev, NULL, __unregister);
        device_unregister(&master->dev);
}

and 

void device_unregister(struct device *dev)
{
    [..]
        device_del(dev);
        put_device(dev);
}

Hope my understanding is correct.


> Thanks,
> Guenter
>
>> ---
>>  drivers/spi/spi-omap2-mcspi.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
>> index 7d46b15..b5035e2 100644
>> --- a/drivers/spi/spi-omap2-mcspi.c
>> +++ b/drivers/spi/spi-omap2-mcspi.c
>> @@ -1203,18 +1203,16 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
>>  
>>  	status = spi_register_master(master);
>>  	if (status < 0)
>> -		goto err_spi_register;
>> +		goto disable_pm;
>>  
>>  	return status;
>>  
>> -err_spi_register:
>> -	spi_master_put(master);
>>  disable_pm:
>>  	pm_runtime_disable(&pdev->dev);
>>  dma_chnl_free:
>>  	kfree(mcspi->dma_channels);
>>  free_master:
>> -	kfree(master);
>> +	spi_master_put(master);
>>  	platform_set_drvdata(pdev, NULL);
>>  	return status;
>>  }
>> -- 
>> 1.7.5.4
>>
>>

