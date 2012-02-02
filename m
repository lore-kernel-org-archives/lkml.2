Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2BBNeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:34:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52962 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2BBNeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:34:06 -0500
Message-ID: <4F2A90B4.1050709@gmail.com>
Date: Thu, 02 Feb 2012 21:33:40 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/2] lkdtm: use atomic_t to replace count_lock
References: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com> <201202011527.35366.arnd@arndb.de>
In-Reply-To: <201202011527.35366.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 11:27 PM, Arnd Bergmann wrote:
> On Wednesday 01 February 2012, Cong Wang wrote:
>>   static void lkdtm_handler(void)
>>   {
>> -       unsigned long flags;
>> -
>> -       spin_lock_irqsave(&count_lock, flags);
>> -       count--;
>>          printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
>> -                       cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
>> +                       cp_name_to_str(cpoint), cp_type_to_str(cptype), atomic_dec_return(&count));
>>
>> -       if (count == 0) {
>> +       if (!atomic_cmpxchg(&count, 0, cpoint_count))
>>                  lkdtm_do_action(cptype);
>> -               count = cpoint_count;
>> -       }
>> -       spin_unlock_irqrestore(&count_lock, flags);
>>   }
>
> This use is not atomic, you could have two threads doing atomic_dec_return
> at the same time, and after that the value will be -1 so the atomic_cmpxchg
> does not trigger.


Yeah, simply combining two atomic operations is not atomic. :-/

>
> In order to have an atomic here, you have to use a loop around
> atomic_cmpxchg, like
>
>
> 	int old, new;
> 	old = atomic_read(&count);
> 	do {
> 		new = old ? old - 1 : cpoint_count;
> 		old = cmpxchg(&count, old, new);
> 	} while (old != new);
>
> I suppose you could also just keep the spinlock and move lkdtm_do_action()
> outside of it?

If we still need spinlock, I think we don't need to bother atomic_t at all.
