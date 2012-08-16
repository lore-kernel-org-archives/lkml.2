Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2HPJ0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab2HPJ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:26:39 -0400
Message-ID: <502CBCC4.6010603@redhat.com>
Date: Thu, 16 Aug 2012 06:26:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] [media] ddbridge: fix error handling in module_init_ddbridge()
References: <1345063345-31131-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1345063345-31131-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-08-2012 17:42, Alexey Khoroshilov escreveu:
> If pci_register_driver() failed, resources allocated in
> ddb_class_create() are leaked. The patch fixes it.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/media/dvb/ddbridge/ddbridge-core.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
> index ebf3f05..36aa4e4 100644
> --- a/drivers/media/dvb/ddbridge/ddbridge-core.c
> +++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
> @@ -1705,7 +1705,11 @@ static __init int module_init_ddbridge(void)
>  	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
>  	if (ddb_class_create())
>  		return -1;

This is not right. It should be returning a proper error code.

Could you please patch ddb_class_create() in order to make it to
return the retuned value from IS_ERR() as the error code, and return
it back to the init code?

Ok, I noticed that other parts of the driver are also returning wrong
error codes, but let's fix at least module_init_ddbridge() while you're
looking into this.

> -	return pci_register_driver(&ddb_pci_driver);
> +	if (pci_register_driver(&ddb_pci_driver) < 0) {
> +		ddb_class_destroy();
> +		return -1;

The correct here would be to store the error on a temp register
and return it, instead of returning -1.

> +	}
> +	return 0;
>  }
>  
>  static __exit void module_exit_ddbridge(void)
> 

Thank you!
Mauro
