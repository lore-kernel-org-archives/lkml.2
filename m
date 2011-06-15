Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1FOSyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:54:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:2712 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1FOSys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,370,1304319600"; 
   d="scan'208";a="13946511"
Message-ID: <4DF8FFF6.4060000@linux.intel.com>
Date: Wed, 15 Jun 2011 11:54:46 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com> <1307373819.3098.40.camel@edumazet-laptop> <1307376672.2322.167.camel@twins> <1307376989.2322.171.camel@twins> <4DF2099B.7030600@jp.fujitsu.com> <20110615185047.GA2171@BohrerMBP.rgmadvisors.com>
In-Reply-To: <20110615185047.GA2171@BohrerMBP.rgmadvisors.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/15/2011 11:50 AM, Shawn Bohrer wrote:
> On Fri, Jun 10, 2011 at 09:10:03PM +0900, KOSAKI Motohiro wrote:
>>>> Urgh,. maybe something like the below but with more conditionals that
>>>> enable the extra logic only for FUTEX_WAIT..
>>>>
>>>> The idea is to try a RO gup() when the RW gup() fails so as not to slow
>>>> down the common path of writable anonymous maps and bail when we used
>>>> the RO path on anonymous memory.
>>>>
>>>> ---
>>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>>> index fe28dc2..11f2ad1 100644
>>>> --- a/kernel/futex.c
>>>> +++ b/kernel/futex.c
>>>> @@ -234,7 +234,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>>>>  	unsigned long address = (unsigned long)uaddr;
>>>>  	struct mm_struct *mm = current->mm;
>>>>  	struct page *page, *page_head;
>>>> -	int err;
>>>> +	int err, ro = 0;
>>>>  
>>>>  	/*
>>>>  	 * The futex address must be "naturally" aligned.
>>>> @@ -262,6 +262,10 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>>>>  
>>>>  again:
>>>>  	err = get_user_pages_fast(address, 1, 1, &page);
>>>> +	if (err == -EFAULT) {
>>>> +		err = get_user_pages_fast(address, 1, 0, &page);
>>>> +		ro = 1;
>>>> +	}
>>>>  	if (err < 0)
>>>>  		return err;
>>>>  
>>>> @@ -316,6 +320,11 @@ again:
>>>>  	 * the object not the particular process.
>>>>  	 */
>>>>  	if (PageAnon(page_head)) {
>>>> +		if (ro) {
>>>> +			err = -EFAULT;
>>>> +			goto out;
>>>> +		}
>>>> +
>>>>  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
>>>>  		key->private.mm = mm;
>>>>  		key->private.address = address;
>>>> @@ -327,9 +336,10 @@ again:
>>>>  
>>>>  	get_futex_key_refs(key);
>>>>  
>>
>> Need err=0 here. (note: get_user_pages_fast() return 1) Other than that looks
>> good to me and this patch passed my test.
>> 	Reviewed-and-tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>>>> +out:
>>>>  	unlock_page(page_head);
>>>>  	put_page(page_head);
>>>> -	return 0;
>>>> +	return err;
>>>>  }
>>>>  
>>>>  static inline void put_futex_key(union futex_key *key)
>>>>
> 
> I've reviewed and tested Peter's change with KOSAKI's addition against
> 2.6.32.41 and this passes our tests using FUTEX_WAIT with read only
> shared mappings.
> 
> Reviewed-and-tested-by: Shawn Bohrer <sbohrer@rgmadvisors.com>


Would someone care to roll this all together and send a patch with
commit log clearly documenting the issues and which are addressed with
the patch?

Kosaki, do you have updated futextest patches or should I look at the
ones you send previously?

--
Darren


> 
> --
> Shawn
> 
> 
> ---------------------------------------------------------------
> This email, along with any attachments, is confidential. If you 
> believe you received this message in error, please contact the 
> sender immediately and delete all copies of the message.  
> Thank you.
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
