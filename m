Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1FJMK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:10:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50704 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab1FJMKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:10:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF2099B.7030600@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 21:10:03 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: peterz@infradead.org
CC: eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, sbohrer@rgmadvisors.com,
        zvonler@rgmadvisors.com, hughd@google.com, tglx@linutronix.de,
        dvhart@linux.intel.com, mingo@elte.hu
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins> <1307376989.2322.171.camel@twins>
In-Reply-To: <1307376989.2322.171.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Urgh,. maybe something like the below but with more conditionals that
>> enable the extra logic only for FUTEX_WAIT..
>>
>> The idea is to try a RO gup() when the RW gup() fails so as not to slow
>> down the common path of writable anonymous maps and bail when we used
>> the RO path on anonymous memory.
>>
>> ---
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index fe28dc2..11f2ad1 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -234,7 +234,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>>  	unsigned long address = (unsigned long)uaddr;
>>  	struct mm_struct *mm = current->mm;
>>  	struct page *page, *page_head;
>> -	int err;
>> +	int err, ro = 0;
>>  
>>  	/*
>>  	 * The futex address must be "naturally" aligned.
>> @@ -262,6 +262,10 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>>  
>>  again:
>>  	err = get_user_pages_fast(address, 1, 1, &page);
>> +	if (err == -EFAULT) {
>> +		err = get_user_pages_fast(address, 1, 0, &page);
>> +		ro = 1;
>> +	}
>>  	if (err < 0)
>>  		return err;
>>  
>> @@ -316,6 +320,11 @@ again:
>>  	 * the object not the particular process.
>>  	 */
>>  	if (PageAnon(page_head)) {
>> +		if (ro) {
>> +			err = -EFAULT;
>> +			goto out;
>> +		}
>> +
>>  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
>>  		key->private.mm = mm;
>>  		key->private.address = address;
>> @@ -327,9 +336,10 @@ again:
>>  
>>  	get_futex_key_refs(key);
>>  

Need err=0 here. (note: get_user_pages_fast() return 1) Other than that looks
good to me and this patch passed my test.
	Reviewed-and-tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

>> +out:
>>  	unlock_page(page_head);
>>  	put_page(page_head);
>> -	return 0;
>> +	return err;
>>  }
>>  
>>  static inline void put_futex_key(union futex_key *key)
>>
> 
> Hmm, wouldn't that still be susceptible to the zero-page thing if: we
> create a writable private file map of a sparse file, touch a page and
> then remap the thing RO?

After while thinking, I've conclude this is ok. Because 1) as Andrew and
Kyle described, RO mapping usage is not so sane. We need to care it for
only compatibility. 2) David Oliver's case is real compatibility issue.
but I doubt such mprotect() vs futex() race is happen on real world.
3) Anyway, overkill compatibility care might make code slower perhaps.

Off topic: current futex documentations are near terribly unclear and
many futex op are completely undocumented. They are one of root cause
that every change can make compatibility issue. (;_;


