Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2FZQDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:03:04 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:20981 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2FZQDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:03:02 -0400
X-Loopcount0: from 10.175.216.251
From: <Srinivas_G_Gowda@Dell.com>
To: <minyard@acm.org>
CC: <tcminyard@gmail.com>, <linux-kernel@vger.kernel.org>,
        <openipmi@mvista.com>
Date: Tue, 26 Jun 2012 21:32:37 +0530
Subject: Re: [PATCH] ipmi: setting OS name as Linux in BMC
Thread-Topic: [PATCH] ipmi: setting OS name as Linux in BMC
Thread-Index: Ac1TtSb8hhSjARgkTFSfXDXQC6sUNg==
Message-ID: <4FE9DD1D.9020803@dell.com>
References: <4FE9A3EB.50505@dell.com> <4FE9B827.80300@dell.com>
 <4FE9BBA4.8070407@acm.org>
In-Reply-To: <4FE9BBA4.8070407@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 07:09 PM, Corey Minyard wrote:
> The idea here is fine, but it's probably more appropriate to do this in 
> ipmi_msghandler.c, not ipmi_si_intf.c, since the latter only handles 
> some interface types.
> 
> -corey
> 
> On 06/26/2012 08:24 AM, Srinivas_G_Gowda@Dell.com wrote:
>> There is an option in IPMI Spec using which BMC can be made aware
>> of the OS name that it is talking to.
>> IPMI_Spec-IPMI2_0E4_061209  -  ref - 22.14a ,  [Set System Info]
>>
>> This patch will update the OS name as "Linux" in BMC during
>> IPMI Driver initialization. In the current patch, declaration of
>> the OS name is done only for the Volatile param.
>>
>> Signed-off-by: Srinivas Gowda G<Srinivas_G_Gowda@dell.com>
>> ---
>>   drivers/char/ipmi/ipmi_si_intf.c |   72 ++++++++++++++++++++++++++++++++++++++
>>   include/linux/ipmi_msgdefs.h     |    1 +
>>   2 files changed, 73 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
>> index 1e638ff..df995b4 100644
>> --- a/drivers/char/ipmi/ipmi_si_intf.c
>> +++ b/drivers/char/ipmi/ipmi_si_intf.c
>> @@ -2709,6 +2709,71 @@ static int try_get_dev_id(struct smi_info *smi_info)
>>   	return rv;
>>   }
>>
>> +/*
>> + * Set the Operating System Name as "Linux" using "Set System Info" command.
>> + * Only setting Volatile variable - Parameter 4
>> + */
>> +static int try_set_system_info_os_name(struct smi_info *smi_info)
>> +{
>> +	unsigned char         msg[11];
>> +	unsigned char         *resp;
>> +	unsigned char         param_select;
>> +	unsigned char	      set_selector;		
>> +	unsigned char         string_encode;
>> +	unsigned char         str_len;
>> +	unsigned long         resp_len;
>> +	int                   rv = 0;
>> +
>> +	resp = kmalloc(IPMI_MAX_MSG_LENGTH, GFP_KERNEL);
>> +	if (!resp)
>> +		return -ENOMEM;
>> +
>> +	param_select = 4;	/* parameter number for volatile OS name */
>> +	set_selector = 0;	/* set selector, block 0 */
>> +	string_encode = 0;	/* ASCII Encoding */
>> +	str_len = 5;		/* length of ASCII string - "Linux" */
>> +
>> +	msg[0] = IPMI_NETFN_APP_REQUEST<<  2;
>> +	msg[1] = IPMI_SET_SYSTEM_INFO;
>> +	msg[2] = param_select;
>> +	msg[3] = set_selector;
>> +	msg[4] = string_encode;	
>> +	msg[5] = str_len;
>> +	msg[6] =  'L';	
>> +	msg[7] =  'i';	
>> +	msg[8] =  'n';	
>> +	msg[9] =  'u';	
>> +	msg[10] = 'x';	
>> +
>> +	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 11);
>> +
>> +	rv = wait_for_msg_done(smi_info);
>> +	if (rv)
>> +		goto out;
>> +
>> +	resp_len = smi_info->handlers->get_result(smi_info->si_sm,
>> +						  resp, IPMI_MAX_MSG_LENGTH);
>> +
>> +	if (resp_len<  3 ||
>> +			resp[0] != (IPMI_NETFN_APP_REQUEST | 1)<<  2 ||
>> +			resp[1] != IPMI_SET_SYSTEM_INFO   ||
>> +			resp[2] != 0) {
>> +		if (resp_len == 3 )
>> +			 rv = resp[2];
>> +		printk(KERN_WARNING PFX "Failed to set OS name as Linux: 0x%X\n", rv);
>> +
>> +		rv = -EINVAL;
>> +		goto out;
>> +	}
>> +	else
>> +		/* Volatile Opertaing System name */
>> +		printk(KERN_INFO PFX "OS Name successfully set as Linux\n");
>> +
>> + out:
>> +	kfree(resp);
>> +	return rv;
>> +}
>> +
>>   static int try_enable_event_buffer(struct smi_info *smi_info)
>>   {
>>   	unsigned char         msg[3];
>> @@ -3216,6 +3281,13 @@ static int try_smi_init(struct smi_info *new_smi)
>>   	new_smi->intf_num = smi_num;
>>   	smi_num++;
>>
>> +	/*
>> + 	 * Set the OS in BMC as "Linux" using "Set System Info" Command
>> + 	 */
>> +	rv = try_set_system_info_os_name(new_smi);
>> +	if(rv)
>> +		printk(KERN_WARNING PFX "Could not set OS Name in BMC\n");
>> +		
>>   	rv = try_enable_event_buffer(new_smi);
>>   	if (rv == 0)
>>   		new_smi->has_event_buffer = 1;
>> diff --git a/include/linux/ipmi_msgdefs.h b/include/linux/ipmi_msgdefs.h
>> index df97e6e..b5ea664 100644
>> --- a/include/linux/ipmi_msgdefs.h
>> +++ b/include/linux/ipmi_msgdefs.h
>> @@ -57,6 +57,7 @@
>>   #define IPMI_GET_BMC_GLOBAL_ENABLES_CMD	0x2f
>>   #define IPMI_READ_EVENT_MSG_BUFFER_CMD	0x35
>>   #define IPMI_GET_CHANNEL_INFO_CMD	0x42
>> +#define IPMI_SET_SYSTEM_INFO		0x58
>>
>>   /* Bit for BMC global enables. */
>>   #define IPMI_BMC_RCV_MSG_INTR     0x01
> 

Corey,
Thanks for the comments.

I was looking at the way BMC presence is detected. 
Thought it would be appropriate that BMC is told about the OS information 
 -- Soon after ipmi_si driver detects BMC(Get_Device_ID) and before the driver starts doing anything useful. Looked like a quick clean getaway..!    

Looking at the ipmi_msghandler, I don't see how we will be able to do this during the driver initialization process. I could probably do it inside ipmi_register_smi in ipmi_msghandler. But I still prefer doing this in ipmi_si itself. Please let me know your thoughts on this.  


Thanks,
G 