Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1EIPGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:06:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1EIPGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RpIDVfUgmDjzJFETzB3rxaUZnFz7LIK9Lj2ZmTSjul94OFN8hMONfaXjxByvc4W0/n
         71zhXXjygyRLW4toMbnWllHLc6DKggCYNdnsxD+b1fdsIcPBpUfFDogWgBFM21HTeQCd
         Zg8IiuT7qtHl3ux1YZrQo5plzhoAPNTt7V4HU=
Message-ID: <4DC802C0.9040302@gmail.com>
Date: Mon, 09 May 2011 17:05:36 +0200
From: Vladimir Motyka <vladimir.motyka@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: cjb@laptop.org, kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mmc/card/block.c: fix potential null dereference
 'idata'
References: <4DC7F4AB.90607@gmail.com> <Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 04:32 PM, Julia Lawall wrote:
> On Mon, 9 May 2011, Vladimir Motyka wrote:
> 
>> When allocation of idata fails there was a null dereferece.
> 
> Why not have a different label for the two cases?  That would make the 
> code easier to statically analyze, and perhaps be more understandable as 
> well.
> 
> julia
>
I think You are right. So it could be better like this?

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 3dec493..a03cdc6 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -237,7 +237,7 @@ static struct mmc_blk_ioc_data
*mmc_blk_ioctl_copy_from_user(
 	idata = kzalloc(sizeof(*idata), GFP_KERNEL);
 	if (!idata) {
 		err = -ENOMEM;
-		goto copy_err;
+		goto alloc_err;
 	}

 	if (copy_from_user(&idata->ic, user, sizeof(idata->ic))) {
@@ -266,9 +266,9 @@ static struct mmc_blk_ioc_data
*mmc_blk_ioctl_copy_from_user(
 	return idata;

 copy_err:
-	if(idata)
-		kfree(idata->buf);
+	kfree(idata->buf);
 	kfree(idata);
+alloc_err:
 	return ERR_PTR(err);
 }

Or it could return right after allocation fails so there needn't be
goto. It is simplier, but maybe worse looking and to read. What is your
opinion?

Vladimir Motyka

> 
>> Signed-off-by: Vladimir Motyka <vladimir.motyka@gmail.com>
>>
>> ---
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 407836d..3dec493 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -266,10 +266,10 @@ static struct mmc_blk_ioc_data
>> *mmc_blk_ioctl_copy_from_user(
>>  	return idata;
>>
>>  copy_err:
>> -	kfree(idata->buf);
>> +	if(idata)
>> +		kfree(idata->buf);
>>  	kfree(idata);
>>  	return ERR_PTR(err);
>> -
>>  }
>>
>>  static int mmc_blk_ioctl_cmd(struct block_device *bdev,
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

