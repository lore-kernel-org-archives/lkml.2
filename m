Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1A3Rf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 12:35:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37820 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1A3Rfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 12:35:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:x-duff:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=LIefczd/1+BEESkcQUyDpXhtoZ2tMGvOSsK3XDYv9DCj0/xw4Cc8Q1sYqbgOqnbsV/
         20yG4tcXlGtgEEVaCUk+3UMFsJDdAlr+GjCzm8QKQwTLIRhwBilqtNvspj0PmTrUAi9P
         K1907ipF5TWFXfL0uk9EH2G950g0wGfJVMHJk=
Subject: Re: [PATCH] mtd: fix memory leak
X-Duff: Duff Lite, Duff Dry, Duff Dark, Lady Duff, Raspberry Duff, Duff Zero
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Mathias Krause <minipli@googlemail.com>
In-Reply-To: <1296399153.2388.57.camel@localhost>
Date: Sun, 30 Jan 2011 18:35:48 +0100
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <168EA60D-68D1-4281-A0C2-22B2B598AFE1@googlemail.com>
References: <1296379908-10150-1-git-send-email-minipli@googlemail.com> <1296399153.2388.57.camel@localhost>
To: dedekind1@gmail.com
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.01.2011 at 15:52, Artem Bityutskiy wrote:
> Hi,
> 
> On Sun, 2011-01-30 at 10:31 +0100, Mathias Krause wrote:
>> diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
>> index 5239328..8d28fa0 100644
>> --- a/drivers/mtd/devices/phram.c
>> +++ b/drivers/mtd/devices/phram.c
>> @@ -117,6 +117,7 @@ static void unregister_devices(void)
>> 	list_for_each_entry_safe(this, safe, &phram_list, list) {
>> 		del_mtd_device(&this->mtd);
>> 		iounmap(this->mtd.priv);
>> +		kfree(this->mtd.name);
>> 		kfree(this);
>> 	}
> 
> Since register_device() did not allocate it, unregister_devices() should
> not free it.

I agree with you, the internal API is a little quirky regarding that point. register_device() should strdup() the name and not just blindly use it. But since the memory for name was already allocated via kmalloc() in phram_setup() it seems a little nitpicky to copy it once again in register_device().

> Hence, I think it is better to free(name) just after
> calling unregister_devices().

This is not possible because unregister_devices() unregisters all devices, not just a single instance. Though name must be freed for every object in the list. After unregister_devices() returns the list is empty and no pointer to the memory locations do exist any more. So my patch was the straight forward fix for the memory leak.


Regards,
Mathias