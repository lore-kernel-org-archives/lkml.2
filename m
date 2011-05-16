Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab1EPPg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:36:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46213 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1EPPgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PMKFqFaX8JVy8HXjEIgTfjS4ll7D69wyD2mKOgjQSitYPXgBA0ck66UyFMqtVbsxLC
         Qh6a++0xMJ3ApthHg6oZW6uJuP16d1MuxvwD6Mpb6WEZjkMAcF0lcAu3qUwIuMyWXVVl
         vPPERs9BOeWB1pkeV+E07tELbz3P9W8iCxK2g=
Message-ID: <4DD14469.5030804@googlemail.com>
Date: Mon, 16 May 2011 17:36:09 +0200
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
References: <1304455330-2728-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1304455330-2728-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.05.2011 22:42, Alessio Igor Bogani wrote:
> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>
> ---
>   kernel/module.c |    6 ++----
>   1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 6a34337..a1f841e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2055,10 +2055,8 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
>   	const struct kernel_symbol *stop)
>   {
>   	const struct kernel_symbol *ks = start;
> -	for (; ks<  stop; ks++)
> -		if (strcmp(ks->name, name) == 0)
> -			return ks;
> -	return NULL;
> +	return bsearch(ks->name, start, stop - start,
> +			sizeof(struct kernel_symbol), cmp_name);
>   }

Back porting this patch to a 2.6.34.9 based ARM system fails with an 
Oops at 0x00000004. Debugging shows that both start and stop are 0 in 
this case resulting in ks->name accessing 0x00000004. The original 
code checked for this by 'ks < stop' in the for loop.

So the first idea was that the code should be

if(k < stop)
	return bsearch();
else
	return NULL;

Then, thinking again, results in the question if the first argument of 
bsearch() shouldn't be 'name' rather than 'ks->name'? Then it would be 
the job of cmp_name() to check for start == stop == 0? I.e.

return bsearch(name, ...);

?

Best regards

Dirk
