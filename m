Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2HOXOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:14:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2HOXOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:14:11 -0400
Message-ID: <502C2D35.4040102@redhat.com>
Date: Wed, 15 Aug 2012 20:13:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Lars Hanisch <dvb@cinnamon-sage.de>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] [media] ddbridge: fix error handling in module_init_ddbridge()
References: <1345063345-31131-1-git-send-email-khoroshilov@ispras.ru> <502C0DEC.3010104@cinnamon-sage.de>
In-Reply-To: <502C0DEC.3010104@cinnamon-sage.de>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-08-2012 18:00, Lars Hanisch escreveu:
> Hi,
> 
> Am 15.08.2012 22:42, schrieb Alexey Khoroshilov:
>> If pci_register_driver() failed, resources allocated in
>> ddb_class_create() are leaked. The patch fixes it.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>>  drivers/media/dvb/ddbridge/ddbridge-core.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
>> index ebf3f05..36aa4e4 100644
>> --- a/drivers/media/dvb/ddbridge/ddbridge-core.c
>> +++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
>> @@ -1705,7 +1705,11 @@ static __init int module_init_ddbridge(void)
>>  	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
>>  	if (ddb_class_create())
>>  		return -1;

This is not right. It should be returning a proper error code.

Could you please patch ddb_class_create() in order to make it to
return the retuned value from IS_ERR() as the error code, and return
it back to the init code?

Ok, I noticed that other parts of the driver are also returning wrong
error codes, but let's fix at least module_init_ddbridge() while you're
looking into this.

>> -	return pci_register_driver(&ddb_pci_driver);
>> +	if (pci_register_driver(&ddb_pci_driver) < 0) {
>> +		ddb_class_destroy();
>> +		return -1;

Again, the correct here would be to store the error on a temp register
and return it, instead of returning -1.
> 
>  Difference to before: the return value of pci_register_driver is not passed through.
>  Is this a problem? I'm just an interested application developer, not a driver developer.

On userspace, ioctl() always return -1 on errors. The error code at "errno"
is wrong, though. Instead of "1", it should be the ones described at the
API spec[1].

[1] http://linuxtv.org/downloads/v4l-dvb-apis/gen_errors.html

> 
> Regards,
> Lars.
> 
>> +	}
>> +	return 0;
>>  }
>>  
>>  static __exit void module_exit_ddbridge(void)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

