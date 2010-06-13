Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0FML1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:27:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54554 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0FML1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=Ajd8kGTZIMvwOYUE4abVoo/7Ys1X6PWem81/Y4hnmIlvVGnHf+UzQ8RsDFONQqtUnH
         GTDIrIInw1mioCksFXjgWVEJkTmnREzzd5D3Ulhk1ij2m6Gbxzz3XIaEsLW92ONGO9xf
         Ldi0/vaYWX9r0+MsGwxYnBaf1amszKZMXKeKw=
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: "=?iso-8859-1?Q?Henri_H=E4kkinen?=" <henrih81@gmail.com>
In-Reply-To: <1276407050.1449.28.camel@Joe-Laptop.home>
Date: Sun, 13 Jun 2010 14:27:45 +0300
Cc: devel@driverdev.osuosl.org, gregkh@suse.de, andrea.gelmini@gelma.net,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EC683E5B-0C90-4C16-B493-7BFAEC675BDA@gmail.com>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com> <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com> <1276405626.1449.26.camel@Joe-Laptop.home> <1276407050.1449.28.camel@Joe-Laptop.home>
To: Joe Perches <joe@perches.com>, Mark Rankilor <reodge@gmail.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

There are several printk statements without the "comedi:" prefix. Such as:

printk(KERN_WARNING "BUG: dev->driver=NULL in comedi_device_detach()\n");

Do you think it is better to leave these as they are, or should they be changed to use comedi_xxx macros (which will print the "comedi:" prefix)?

Also even with logging macros, there will be few lines which go beyond the 80 character boundary.


On 13.6.2010, at 8.30, Joe Perches wrote:

> On Sat, 2010-06-12 at 22:07 -0700, Joe Perches wrote:
>> 2: Create some comedi logging functions or macros like:
>>   	comedi_<level>(fmt, arg...) (ie: comedi_info, comedi_err, etc)
>>   where "comedi:" is always prefixed and an
>>   optional #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>   could be used.
> 
> Maybe this is a start:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> drivers/staging/comedi/comedidev.h |   54 ++++++++++++++++++++++++++++++++++--
> 1 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 4eb2b77..6c2bdde 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -43,11 +43,59 @@
> 
> #include "comedi.h"
> 
> -#define DPRINTK(format, args...)	do {		\
> -	if (comedi_debug)				\
> -		printk(KERN_DEBUG "comedi: " format , ## args);	\
> +#define comedi_printk(level, fmt, args...)			\
> +	printk(level "comedi: " pr_fmt(fmt), ##args)
> +
> +#define DPRINTK(format, args...)				\
> +do {								\
> +	if (comedi_debug)					\
> +		comedi_printk(KERN_DEBUG, fmt, ##args);		\
> } while (0)
> 
> +#define comedi_emerg(fmt, ...)				\
> +	comedi_printk(KERN_EMERG, fmt, ##__VA_ARGS__)
> +#define comedi_alert(fmt, ...)				\
> +	comedi_printk(KERN_ALERT, fmt, ##__VA_ARGS__)
> +#define comedi_crit(fmt, ...)				\
> +	comedi_printk(KERN_CRIT, fmt, ##__VA_ARGS__)
> +#define comedi_err(fmt, ...)				\
> +	comedi_printk(KERN_ERR, fmt, ##__VA_ARGS__)
> +#define comedi_warn(fmt, ...)				\
> +	comedi_printk(KERN_WARNING, fmt, ##__VA_ARGS__)
> +#define comedi_notice(fmt, ...)				\
> +	comedi_printk(KERN_NOTICE, fmt, ##__VA_ARGS__)
> +#define comedi_info(fmt, ...)				\
> +	comedi_printk(KERN_INFO, fmt, ##__VA_ARGS__)
> +
> +/* comedi_devel() should produce zero code unless DEBUG is defined */
> +#ifdef DEBUG
> +#define comedi_devel(fmt, ...)				\
> +	comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__)
> +#else
> +#define comedi_devel(fmt, ...)					\
> +({								\
> +	if (0)							\
> +		comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__);	\
> +	0;							\
> +})
> +#endif
> +
> +#if defined(DEBUG)
> +#define comedi_debug(fmt, ...)				\
> +	comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__)
> +#elif defined(CONFIG_DYNAMIC_DEBUG)
> +/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
> +#define comedi_debug(fmt, ...)				\
> +	dynamic_pr_debug(fmt, ##__VA_ARGS__)
> +#else
> +#define comedi_debug(fmt, ...)					\
> +({								\
> +	if (0)							\
> +		comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__);	\
> +	0;							\
> +})
> +#endif
> +
> #define COMEDI_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
> #define COMEDI_VERSION_CODE COMEDI_VERSION(COMEDI_MAJORVERSION, \
> 	COMEDI_MINORVERSION, COMEDI_MICROVERSION)
> 
> 

