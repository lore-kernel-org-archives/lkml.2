Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0HHU3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 16:29:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59663 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab0HHU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nA9K/p9sLl9R7+/F6QAVqim3KN1bnBzIuIzWK9W8l7UoBTo7zu0WYPeBmdHen5VFy1
         EmJUNttucr0/9ex6mGUGGY4+eQm9+haPzepFAjwj06Gs8RND6Hkca0uF8R6SHHjvD8W1
         LLj1OjgM984txeIHg+0W7hVdbU9dlg4Xuix7k=
Message-ID: <4C5F1390.3040509@gmail.com>
Date: Sun, 08 Aug 2010 22:29:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] char: mxser: call disable_pci_device() if pci_probe()
 failed
References: <1281124159-12671-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1281124159-12671-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 09:49 PM, Kulikov Vasiliy wrote:
> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c
> @@ -2564,8 +2564,11 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
>  	/* vector */
>  	ioaddress = pci_resource_start(pdev, 3);
>  	retval = pci_request_region(pdev, 3, "mxser(vector)");
> -	if (retval)
> -		goto err_relio;
> +	if (retval) {
> +		pci_release_region(pdev, 2);
> +		brd->info = NULL;
> +		goto err;
> +	}
>  	brd->vector = ioaddress;
>  
>  	/* irq */
> @@ -2616,10 +2619,11 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
>  	pci_set_drvdata(pdev, brd);
>  
>  	return 0;
> -err_relio:
> -	pci_release_region(pdev, 2);
>  err_null:
>  	brd->info = NULL;
> +	pci_release_region(pdev, 2);
> +	pci_release_region(pdev, 3);
> +	pci_disable_device(pdev);

Why did you reorder this so that you cannot jump here from the fail path
above?

thanks,
-- 
js
