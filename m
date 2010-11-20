Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0KTVNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 16:13:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47529 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752383Ab0KTVNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 16:13:48 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+2ZLFk8Yi26JcxQOt2eQ69+MHNpaaFZQcID/OAqf
	eyh6MWdQqnocu9
Message-ID: <4CE83A09.5020000@gmx.de>
Date: Sat, 20 Nov 2010 22:13:45 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jesper Juhl <jj@chaosbits.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH RFC] serio HIL MLC: don't deref null, don't leak and return
 proper error
References: <alpine.LNX.2.00.1011072024100.26247@swampdragon.chaosbits.net> <20101109063520.GA10502@core.coreip.homeip.net>
In-Reply-To: <20101109063520.GA10502@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 07:35 AM, Dmitry Torokhov wrote:
> On Sun, Nov 07, 2010 at 08:36:33PM +0100, Jesper Juhl wrote:
>> Hi,
>>
>> While reviewing various users of kernel memory allocation functions I came
>> across drivers/input/serio/hil_mlc.c::hil_mlc_register() and noticed that
>>   - it calls kzalloc() buf fails to check for a NULL return before use.
>>   - it makes several allocations and if one fails it doesn't free the
>>     previous ones.
>>   - It doesn't return -ENOMEM in the failed memory allocation case (it just
>>     crashes).
>> This patch corrects all of the above and also reworks the only caller of
>> this function that I could find
>> (drivers/input/serio/hp_sdc_mlc.c::hp_sdc_mlc_out()) so that it now checks
>> the return value of hil_mlc_register() and properly propagate it on
>> failure and I also restructured the code to remove some labels and goto's
>> to make it, IMHO nicer to read.
>>
>> I have no hardware to test, so please review carefully and let me know if
>> I've done something completely stupid. Please don't merge this RFC patch
>> unless at least one or more people who know this code and can actually
>> test it have ACK'ed it.
> I think Helge Deller (CCed) used to have access to such hardware...

Yes, and I tested the patch successfully.

Tested-by: Helge Deller <deller@gmx.de>
Acked-by: Helge Deller <deller@gmx.de>


>> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
>> ---
>>   hil_mlc.c    |    5 +++++
>>   hp_sdc_mlc.c |   18 +++++++++---------
>>   2 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
>> index e5624d8..bfd3865 100644
>> --- a/drivers/input/serio/hil_mlc.c
>> +++ b/drivers/input/serio/hil_mlc.c
>> @@ -932,6 +932,11 @@ int hil_mlc_register(hil_mlc *mlc)
>>   		hil_mlc_copy_di_scratch(mlc, i);
>>   		mlc_serio = kzalloc(sizeof(*mlc_serio), GFP_KERNEL);
>>   		mlc->serio[i] = mlc_serio;
>> +		if (!mlc->serio[i]) {
>> +			for (; i>= 0; i--)
>> +				kfree(mlc->serio[i]);
>> +			return -ENOMEM;
>> +		}
>>   		snprintf(mlc_serio->name, sizeof(mlc_serio->name)-1, "HIL_SERIO%d", i);
>>   		snprintf(mlc_serio->phys, sizeof(mlc_serio->phys)-1, "HIL%d", i);
>>   		mlc_serio->id			= hil_mlc_serio_id;
>> diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
>> index 7d2b820..d50f067 100644
>> --- a/drivers/input/serio/hp_sdc_mlc.c
>> +++ b/drivers/input/serio/hp_sdc_mlc.c
>> @@ -305,6 +305,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
>>   static int __init hp_sdc_mlc_init(void)
>>   {
>>   	hil_mlc *mlc =&hp_sdc_mlc;
>> +	int err;
>>
>>   #ifdef __mc68000__
>>   	if (!MACH_IS_HP300)
>> @@ -323,22 +324,21 @@ static int __init hp_sdc_mlc_init(void)
>>   	mlc->out =&hp_sdc_mlc_out;
>>   	mlc->priv =&hp_sdc_mlc_priv;
>>
>> -	if (hil_mlc_register(mlc)) {
>> +	err = hil_mlc_register(mlc);
>> +	if (err) {
>>   		printk(KERN_WARNING PREFIX "Failed to register MLC structure with hil_mlc\n");
>> -		goto err0;
>> +		return err;
>>   	}
>>
>>   	if (hp_sdc_request_hil_irq(&hp_sdc_mlc_isr)) {
>>   		printk(KERN_WARNING PREFIX "Request for raw HIL ISR hook denied\n");
>> -		goto err1;
>> +		if (hil_mlc_unregister(mlc))
>> +			printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
>> +				"This is bad.  Could cause an oops.\n");
>> +		return -EBUSY;
>>   	}
>> +
>>   	return 0;
>> - err1:
>> -	if (hil_mlc_unregister(mlc))
>> -		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
>> -			"This is bad.  Could cause an oops.\n");
>> - err0:
>> -	return -EBUSY;
>>   }
>>
>>   static void __exit hp_sdc_mlc_exit(void)
>>
>>
>>

