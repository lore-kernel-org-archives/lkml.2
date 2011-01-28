Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1A1JFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 04:05:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62605 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1A1JFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 04:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ac/af6/BKRnF1AhQdRJcdm2exg9ihfyDmEvs6eK/lRqmVjhT0VZfSEixG8sQvK+Y7x
         RHlJEkfDulAaC0R/pg9S+XxeNkwOENmexL4S1GbSyDEspprunwbwKyyC1mxon+LQKFT4
         5JCC6i0hInsGcac5aA2A51kDmwtAxAb9u0wQY=
MIME-Version: 1.0
In-Reply-To: <20110127232252.GA3493@ime.usp.br>
References: <20110127232252.GA3493@ime.usp.br>
Date: Fri, 28 Jan 2011 10:05:07 +0100
Message-ID: <AANLkTingnEndZa2ZdTdbo7P=ePo1iRfTNBTjyBOM10n1@mail.gmail.com>
Subject: Re: [PATCH 01/02] ath3k: Avoid duplication of code
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org, Alexander Holler <holler@ahsoftware.de>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/1/28 Rogério Brito <rbrito@ime.usp.br>:
> Hi.
>
> In commit 86e09287e4f8c81831b4d4118a48597565f0d21b, to reduce memory
> usage, the functions of the ath3k module were rewritten to release the
> firmware blob after it has been loaded (successfully or not).
>
> The resuting code has some redundancy and the compiler can potentially
> produce better code if we omit a function call that is unconditionally
> executed in
>
> ,----
> |       if (ath3k_load_firmware(udev, firmware)) {
> |               release_firmware(firmware);
> |               return -EIO;
> |       }
> |       release_firmware(firmware);
> |
> |       return 0;
> | }
> `----
>
> It may also be argued that the rewritten code becomes easier to read,
> and also to see the code coverage of the snippet in question.
>
>
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
>
> ---
>
> I am sending here two proposals for rewriting the code.  This is the
> first one. The second uses the ternary operator and seems to have more
> usage in the kernel (or, at least, under mm).
>
> ---
>
> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index a126e61..0043781 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -116,13 +116,13 @@ static int ath3k_probe(struct usb_interface *intf,
>                return -EIO;
>        }
>
> -       if (ath3k_load_firmware(udev, firmware)) {
> -               release_firmware(firmware);
> -               return -EIO;
> -       }
> +       ret = ath3k_load_firmware(udev, firmware);
>        release_firmware(firmware);
>
> -       return 0;
> +       if (ret)
> +               return -EIO;
> +       else
> +               return 0;

We don't need "else" after a return statement, in order to avoid a
indentation level.

>  }
>
>  static void ath3k_disconnect(struct usb_interface *intf)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
