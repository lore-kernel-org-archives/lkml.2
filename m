Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1H3TqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:46:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38605 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab1H3TqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:46:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110830191937.GA8689@suse.de>
References: <1314731192-1960-1-git-send-email-rajan.aggarwal85@gmail.com>
	<20110830191937.GA8689@suse.de>
Date: Wed, 31 Aug 2011 01:16:24 +0530
Message-ID: <CALN+fr1Nke3kgEpJbb8fbzAd=dB_KhKP71rZRpm7TjOmkE5Jwg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Free fw_priv in fw_create_instance
From: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Aug 31, 2011 at 12:49 AM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Aug 31, 2011 at 12:36:32AM +0530, Rajan Aggarwal wrote:
>> fw_priv is not being freed in some of the error scenarios in
>> fw_create_instance.
>
> Not true.
>
>> This patch makes sure that this is kfreed properly in all error
>> situations in the fw_create_instance logic where it is required.
>
> Nope, this will cause a double-free to happen.

>From what you say, the only suspicious line seems to be the following
assignment:
f_dev = &fw_priv->dev;
However, I cannot make out how this can be freed by device_del or
put_device as I
don't see the logic anywhere where f_dev is decremented to get the
address of fw_priv.

>
>> Signed-off-by: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
>> ---
>>  drivers/base/firmware_class.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> index 06ed6b4..3ddbc48 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -497,6 +497,7 @@ err_del_dev:
>>       device_del(f_dev);
>>  err_put_dev:
>>       put_device(f_dev);
>> +     kfree(fw_priv);
>
> Did you test this patch out?  What happened when you tested it?
>
> How did you find this "problem"?
>
> Care to look a bit closer at the code?
>
> I'd give you a hint, but it's more sporting this way :)
>

I was looking at some bluetooth code and went into the request_firmware API
and saw this.
I was browsing through this code and this looked like a problem.
I have just started using git and decided to post this email.

But I still don't see how the fw_priv can be freed. :)
There might be some place in kobject where this decrementation is
happening but I
must be missing something.

> thanks,
>
> greg k-h
>
