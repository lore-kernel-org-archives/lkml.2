Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1DKHmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:42:53 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51069 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab1DKHmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:42:52 -0400
Message-ID: <4DA2B0FB.8020302@kernel.dk>
Date: Mon, 11 Apr 2011 09:42:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org
Subject: Re: block: ioc->refcount accessed twice in put_io_context()?
References: <1302442907.5366.15.camel@t41.thuisdomein> <BANLkTi=ma7WDo9=kKwZGwuhi=qUEB8EW5g@mail.gmail.com>
In-Reply-To: <BANLkTi=ma7WDo9=kKwZGwuhi=qUEB8EW5g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-11 03:54, Shaohua Li wrote:
> 2011/4/10 Paul Bolle <pebolle@tiscali.nl>:
>> 0) Looking for clues to solve a problem I ran into, I noticed something
>> odd in block/blk-ioc.c:put_io_context(). It seems it accesses the atomic
>> variable ioc->refcount twice in a way which suggests things might race.
>>
>> 1) Code is more exact than words, so this (entirely untested) patch to
>> solve this possible race might describe better what this is all about:
>>
>> @@ -33,12 +33,16 @@ static void cfq_dtor(struct io_context *ioc)
>>  */
>>  int put_io_context(struct io_context *ioc)
>>  {
>> +       int new;
>> +
>>        if (ioc == NULL)
>>                return 1;
>>
>> -       BUG_ON(atomic_long_read(&ioc->refcount) == 0);
>> +       new = atomic_long_dec_return(&ioc->refcount);
>> +
>> +       BUG_ON(new < 0);
>>
>> -       if (atomic_long_dec_and_test(&ioc->refcount)) {
>> +       if (new == 0) {
>>                rcu_read_lock();
>>                cfq_dtor(ioc);
>>                rcu_read_unlock();
>>
> so you hit this line?
> BUG_ON(atomic_long_read(&ioc->refcount) == 0);
> this suggests something else is already wrong, you should fix that.

Indeed, there is nothing wrong with having the BUG_ON() there first and
doing the decrement later. If the BUG_ON() is hit, then it's not a race
conditon - it's a plain bug in the code.

-- 
Jens Axboe

