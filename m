Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0HSRiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:38:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28173 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0HSRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:38:49 -0400
Message-ID: <4C6D6BCB.2090307@oracle.com>
Date: Thu, 19 Aug 2010 10:37:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Savoy, Pavan" <pavan_savoy@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Jain, Naveen" <naveen_jain@ti.com>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
References: <1282241331-5178-1-git-send-email-pavan_savoy@ti.com> <4C6D6A9A.3010409@oracle.com> <19F8576C6E063C45BE387C64729E7394044F124F7B@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044F124F7B@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/10 10:35, Savoy, Pavan wrote:
> Randy,
>  
> 
>> -----Original Message-----
>> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
>> Sent: Thursday, August 19, 2010 12:32 PM
>> To: Savoy, Pavan
>> Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; linux-kernel@vger.kernel.org;
>> devel@driverdev.osuosl.org; Jain, Naveen
>> Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
>>
>> On 08/19/10 11:08, pavan_savoy@ti.com wrote:
>>> From: Pavan Savoy <pavan_savoy@ti.com>
>>>
>>> In order to support multiple ST platform devices, a new symbol
>>> 'st_get_plat_device' earlier needed to be exported by the arch/XX/brd-XX.c
>>> file which intends to add the ST platform device.
>>>
>>> On removing this dependency, now inside ST driver maintain the array of
>>> ST platform devices that would be registered.
>>> As of now let id=0, as and when we end up having such platforms
>>> where mutliple ST devices can exist, id would come from
>>> protocol drivers (BT, FM and GPS) as to on which platform device
>>> they want to register to.
>>>
>>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
>>
>> Thanks, that builds cleanly.  I'm OK with it if you are comfortable with a
>> hard limit on the fixed number of devices that can be supported:
> 
> Yep, Thanks for pointing out, sort of cleaned up the code.
> 
>> +#define MAX_ST_DEVICES	3	/* Imagine 1 on each UART for now */
>> +struct platform_device *st_kim_devices[MAX_ST_DEVICES];
>>
>> We usually try not to have such limits nor use arrays like that,
>> but if the nature of the device and its platform/environment is like
>> that, so be it.
>>
> 
> Actually on all platforms that I have seen there's only 1 such device.
> The device is basically a connectivity chip (with Bluetooth, FM and GPS working
> on a single UART)
> 
> The number which I mentioned was out of imagination.
> I don't think we are ever going to have multiple of them either...

OK, thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> 
>>> ---
>>>  drivers/staging/ti-st/st.h      |    1 -
>>>  drivers/staging/ti-st/st_core.c |    9 ++++-----
>>>  drivers/staging/ti-st/st_core.h |    2 +-
>>>  drivers/staging/ti-st/st_kim.c  |   22 +++++++++++++++++++---
>>>  4 files changed, 24 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/staging/ti-st/st.h b/drivers/staging/ti-st/st.h
>>> index 9952579..1b3060e 100644
>>> --- a/drivers/staging/ti-st/st.h
>>> +++ b/drivers/staging/ti-st/st.h
>>> @@ -80,5 +80,4 @@ struct st_proto_s {
>>>  extern long st_register(struct st_proto_s *);
>>>  extern long st_unregister(enum proto_type);
>>>
>>> -extern struct platform_device *st_get_plat_device(void);
>>>  #endif /* ST_H */
>>> diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-
>> st/st_core.c
>>> index 063c9b1..b85d8bf 100644
>>> --- a/drivers/staging/ti-st/st_core.c
>>> +++ b/drivers/staging/ti-st/st_core.c
>>> @@ -38,7 +38,6 @@
>>>  #include "st_ll.h"
>>>  #include "st.h"
>>>
>>> -#define VERBOSE
>>>  /* strings to be used for rfkill entries and by
>>>   * ST Core to be used for sysfs debug entry
>>>   */
>>> @@ -581,7 +580,7 @@ long st_register(struct st_proto_s *new_proto)
>>>  	long err = 0;
>>>  	unsigned long flags = 0;
>>>
>>> -	st_kim_ref(&st_gdata);
>>> +	st_kim_ref(&st_gdata, 0);
>>>  	pr_info("%s(%d) ", __func__, new_proto->type);
>>>  	if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
>>>  	    || new_proto->reg_complete_cb == NULL) {
>>> @@ -713,7 +712,7 @@ long st_unregister(enum proto_type type)
>>>
>>>  	pr_debug("%s: %d ", __func__, type);
>>>
>>> -	st_kim_ref(&st_gdata);
>>> +	st_kim_ref(&st_gdata, 0);
>>>  	if (type < ST_BT || type >= ST_MAX) {
>>>  		pr_err(" protocol %d not supported", type);
>>>  		return -EPROTONOSUPPORT;
>>> @@ -767,7 +766,7 @@ long st_write(struct sk_buff *skb)
>>>  #endif
>>>  	long len;
>>>
>>> -	st_kim_ref(&st_gdata);
>>> +	st_kim_ref(&st_gdata, 0);
>>>  	if (unlikely(skb == NULL || st_gdata == NULL
>>>  		|| st_gdata->tty == NULL)) {
>>>  		pr_err("data/tty unavailable to perform write");
>>> @@ -818,7 +817,7 @@ static int st_tty_open(struct tty_struct *tty)
>>>  	struct st_data_s *st_gdata;
>>>  	pr_info("%s ", __func__);
>>>
>>> -	st_kim_ref(&st_gdata);
>>> +	st_kim_ref(&st_gdata, 0);
>>>  	st_gdata->tty = tty;
>>>  	tty->disc_data = st_gdata;
>>>
>>> diff --git a/drivers/staging/ti-st/st_core.h b/drivers/staging/ti-
>> st/st_core.h
>>> index e0c32d1..8601320 100644
>>> --- a/drivers/staging/ti-st/st_core.h
>>> +++ b/drivers/staging/ti-st/st_core.h
>>> @@ -117,7 +117,7 @@ int st_core_init(struct st_data_s **);
>>>  void st_core_exit(struct st_data_s *);
>>>
>>>  /* ask for reference from KIM */
>>> -void st_kim_ref(struct st_data_s **);
>>> +void st_kim_ref(struct st_data_s **, int);
>>>
>>>  #define GPS_STUB_TEST
>>>  #ifdef GPS_STUB_TEST
>>> diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
>>> index b4a6c7f..9e99463 100644
>>> --- a/drivers/staging/ti-st/st_kim.c
>>> +++ b/drivers/staging/ti-st/st_kim.c
>>> @@ -72,11 +72,26 @@ const unsigned char *protocol_names[] = {
>>>  	PROTO_ENTRY(ST_GPS, "GPS"),
>>>  };
>>>
>>> +#define MAX_ST_DEVICES	3	/* Imagine 1 on each UART for now */
>>> +struct platform_device *st_kim_devices[MAX_ST_DEVICES];
>>>
>>>  /**********************************************************************/
>>>  /* internal functions */
>>>
>>>  /**
>>> + * st_get_plat_device -
>>> + *	function which returns the reference to the platform device
>>> + *	requested by id. As of now only 1 such device exists (id=0)
>>> + *	the context requesting for reference can get the id to be
>>> + *	requested by a. The protocol driver which is registering or
>>> + *	b. the tty device which is opened.
>>> + */
>>> +static struct platform_device *st_get_plat_device(int id)
>>> +{
>>> +	return st_kim_devices[id];
>>> +}
>>> +
>>> +/**
>>>   * validate_firmware_response -
>>>   *	function to return whether the firmware response was proper
>>>   *	in case of error don't complete so that waiting for proper
>>> @@ -353,7 +368,7 @@ void st_kim_chip_toggle(enum proto_type type, enum
>> kim_gpio_state state)
>>>  	struct kim_data_s	*kim_gdata;
>>>  	pr_info(" %s ", __func__);
>>>
>>> -	kim_pdev = st_get_plat_device();
>>> +	kim_pdev = st_get_plat_device(0);
>>>  	kim_gdata = dev_get_drvdata(&kim_pdev->dev);
>>>
>>>  	if (kim_gdata->gpios[type] == -1) {
>>> @@ -574,12 +589,12 @@ static int kim_toggle_radio(void *data, bool blocked)
>>>   *	This would enable multiple such platform devices to exist
>>>   *	on a given platform
>>>   */
>>> -void st_kim_ref(struct st_data_s **core_data)
>>> +void st_kim_ref(struct st_data_s **core_data, int id)
>>>  {
>>>  	struct platform_device	*pdev;
>>>  	struct kim_data_s	*kim_gdata;
>>>  	/* get kim_gdata reference from platform device */
>>> -	pdev = st_get_plat_device();
>>> +	pdev = st_get_plat_device(id);
>>>  	kim_gdata = dev_get_drvdata(&pdev->dev);
>>>  	*core_data = kim_gdata->core_data;
>>>  }
>>> @@ -623,6 +638,7 @@ static int kim_probe(struct platform_device *pdev)
>>>  	long *gpios = pdev->dev.platform_data;
>>>  	struct kim_data_s	*kim_gdata;
>>>
>>> +	st_kim_devices[pdev->id] = pdev;
>>>  	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
>>>  	if (!kim_gdata) {
>>>  		pr_err("no mem to allocate");
>>
>>
>> --
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
