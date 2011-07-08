Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1GHKa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:30:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52746 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1GHKa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <201107071927.16237.richard@nod.at>
References: <1310056562.3528.49.camel@vivanov>
	<201107071927.16237.richard@nod.at>
Date: Fri, 8 Jul 2011 13:30:56 +0300
Message-ID: <CAGTPOqfe8JxMsOru=pydy6ofEi0Ax-N=W_2UZwq5y=grrTemhQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] uml: drivers/net_user.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 8:27 PM, Richard Weinberger <richard@nod.at> wrote:
> Am Donnerstag 07 Juli 2011, 18:36:02 schrieb Vitaliy Ivanov:
>> >From 9b9f36f46aa708c3245f5ded83f96421966b2edf Mon Sep 17 00:00:00 2001
>>
>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>> Date: Thu, 7 Jul 2011 19:23:13 +0300
>> Subject: [PATCH 1/3] uml: drivers/net_user.c memory leak fix
>>
>> Perform memory cleanup on exit.
>> On receiving invalid 'pid' we still should clean 'output' variable.
>>
>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>> ---
>>  arch/um/drivers/net_user.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
>> index 9415dd9..989b653 100644
>> --- a/arch/um/drivers/net_user.c
>> +++ b/arch/um/drivers/net_user.c
>> @@ -228,10 +228,11 @@ static void change(char *dev, char *what, unsigned
>> char *addr, "buffer\n");
>>
>>       pid = change_tramp(argv, output, output_len);
>> -     if (pid < 0) return;
>>
>>       if (output != NULL) {
>> -             printk("%s", output);
>> +             if (pid >= 0) {
>> +                     printk("%s", output);
>> +             }
>>               kfree(output);
>>       }
>>  }
>
> This control logic is a bit strange.
> When change_tramp() fails we should not printk() the output variable.
>
> if (pid < 0){
>  free(output);
>  return;
> }
>
> Would be much cleaner.

I just didn't want to clone this free-return stuff. So, what you
proposing is like this:
------------
...
        output = uml_kmalloc(output_len, UM_GFP_KERNEL);
        if (output == NULL)
                printk(UM_KERN_ERR "change : failed to allocate output "
                       "buffer\n");

        pid = change_tramp(argv, output, output_len);
        if (pid < 0) {
                free(output);               <---------- I'm not sure
but 'output' can be NULL here.
                return;
        }

        if (output != NULL) {
                printk("%s", output);
                kfree(output);
        }
}
------------

I was trying to print 'output' only in case change_tramp is
successful. That's the old logic. And at the same time perform free
only in case output is not NULL.


Vitaliy
