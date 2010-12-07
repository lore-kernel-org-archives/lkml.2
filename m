Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0LGRZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:25:05 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:60491 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0LGRZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:25:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=laK6fTsA5nFm/SByx4aQ0f3cBX8mOuZPsdB8w5KRz0gJhzAjz1ZslF1A3fX1s8iEXR
         +1x0up9wwJRKXIdr3bYV23CWQEKOWaxfK1J8mq8fXpq/KoWvOKyZagjyf+QycJLI7rJl
         KmqDXJztLngnGoglCC1BXvrzKJlGg9sEj8vko=
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
From: Namhyung Kim <namhyung@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1291739449.17668.9.camel@mulgrave.site>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site> <1291738348.1638.9.camel@leonhard>
	 <1291739449.17668.9.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 02:24:53 +0900
Message-ID: <1291742693.1638.22.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-07 (화), 10:30 -0600, James Bottomley:
> On Wed, 2010-12-08 at 01:12 +0900, Namhyung Kim wrote:
> > MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODULE) so
> > allyesconfig build always emits the warnings. Possible patch for this
> > would be wraping it up in #ifdefs but when I sent a same patch to Greg
> > KH he didn't want to add more #ifdefs in .c files.
> 
> I didn't mean changing any c files.  I meant fixing the module include
> to make the table used even in the !MODULE case.  That way we only alter
> one file instead of a significant proportion of the drivers.
> 

It would not be a _significant_ proportion because normal drivers may
refer the table in their driver struct. :)

Anyway the patch below looks good to me. I'll happily drop my patches if
you apply this in your tree.

Thanks.

> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 7575bbb..d49aa9c 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -90,7 +90,10 @@ extern const struct gtype##_id __mod_##gtype##_table		\
>  extern struct module __this_module;
>  #define THIS_MODULE (&__this_module)
>  #else  /* !MODULE */
> -#define MODULE_GENERIC_TABLE(gtype,name)
> +/* Flag name as used to avoid warnings about the unused device id table */
> +#define MODULE_GENERIC_TABLE(gtype,name)			\
> +static const struct gtype##_id __mod_##gtype##_table		\
> +  __attribute__ ((unused, alias(__stringify(name))))
>  #define THIS_MODULE ((struct module *)0)
>  #endif
>  


-- 
Regards,
Namhyung Kim


