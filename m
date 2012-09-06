Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab2IFTbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:31:13 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:51654 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2IFTbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:31:11 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzAuK6Trk4=
X-RZG-CLASS-ID: mo00
Message-ID: <5048F9FB.9020207@hartkopp.net>
Date: Thu, 06 Sep 2012 21:31:07 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] can: rename LED trigger name on netdev renames
References: <20120904071128.GB416@vandijck-laurijssen.be> <1346750951-10451-1-git-send-email-kurt.van.dijck@eia.be> <20120906185938.GA4043@gmail.com>
In-Reply-To: <20120906185938.GA4043@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.2012 20:59, Fabio Baltieri wrote:

> Hi Kurt,
> 
> thanks for the patch!
> 
> On Tue, Sep 04, 2012 at 11:29:11AM +0200, Kurt Van Dijck wrote:
>> The LED trigger name for CAN devices is based on the initial
>> CAN device name, but does never change. The LED trigger name
>> is not guaranteed to be unique in case of hotplugging CAN devices.
>>
>> This patch tries to address this problem by modifying the
>> LED trigger name according to the CAN device name when
>> the latter changes.
> 
> That's an ideal solution, and I like the notifier implementation, but I
> see a couple of problems with it.
> 
>> This patch is meant as illustration only.
>> In case of VCAN device rename, a segmentation fault will occur.
>>
>> Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
>> ---
>>  drivers/net/can/led.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 57 insertions(+)
>>
>> diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
>> index eaa14ac..f62f908 100644
>> --- a/drivers/net/can/led.c
>> +++ b/drivers/net/can/led.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/can/dev.h>
>> +#include <linux/if_arp.h>
>>  
>>  #include <linux/can/led.h>
>>  
>> @@ -87,3 +88,59 @@ void devm_can_led_init(struct net_device *netdev)
>>  	devres_add(&netdev->dev, res);
>>  }
>>  EXPORT_SYMBOL_GPL(devm_can_led_init);
>> +
>> +/*
>> + * NETDEV rename notifier to rename the associated led triggers too
>> + */
>> +static int can_led_notifier(struct notifier_block *nb, unsigned long msg,
>> +			void *data)
>> +{
>> +	struct net_device *netdev = (struct net_device *)data;
>> +	struct can_priv *priv = netdev_priv(netdev);
>> +	int busy = 0;
>> +
>> +	if (!net_eq(dev_net(netdev), &init_net))
>> +		return NOTIFY_DONE;
>> +
>> +	if (netdev->type != ARPHRD_CAN)
>> +		return NOTIFY_DONE;
>> +
>> +	if (msg != NETDEV_CHANGENAME)
>> +		return NOTIFY_DONE;
> 
> That's the main problem, which I also got stuck into when I did my first
> can-led implementation.  As LED structures are in netdev's private data,
> you can only use it if your driver is based on the can-dev API, and
> there are no way to be sure of that if you get outside driver's code
> itself.
> 
> This would give problems with vcan, slcan, and probabily other
> non-mainlined drivers.


Do you think, this is really a problem?

If a driver decides not to use the can-dev framework it has to implement own
solutions or just adopt can-dev.

Regards,
Oliver

> 
> Is there any way to register a notifier which fires only for devices
> registered with devm_can_led_init?
> 


