Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2ARRTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:19:20 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53006 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab2ARRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:19:19 -0500
Message-ID: <4F16FF0D.1030606@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 22:49:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        "pavel@ucw.cz" <pavel@ucw.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
References: <201201172345.15010.rjw@sisk.pl>	<201201180015.56510.rjw@sisk.pl> <4F16C24A.4050007@linux.vnet.ibm.com> <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com> <4F16F94C.4020000@linux.vnet.ibm.com> <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com>
In-Reply-To: <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011807-1396-0000-0000-0000008D1FDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 01/18/2012 10:28 PM, Tejun Heo wrote:

> Hello,
> 
> On Wed, Jan 18, 2012 at 8:54 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> +       /*
>> +        * Don't use freezer_count() because we don't want the call to
>> +        * try_to_freeze() here.
>> +        *
>> +        * Reason:
>> +        * unlock_system_sleep() gets called in snapshot_read() and
>> +        * snapshot_write() when the freezing condition is still in effect.
>> +        * Which means, if we use try_to_freeze() here, it would make them
>> +        * enter the refrigerator, thus causing suspend-to-disk to lockup.
>> +        */
> 
> Yeap, much better but wouldn't it be better if the description was
> higher level?  ie. Explain why try_to_freeze() doesn't make sense for
> this operation semantically and then, optionally, give an example of
> breakage.  It usually is lack of proper rationale / reasoning that
> confuses people reading the code.
> 


I agree, but I was trying to keep the comment from growing too long ;)

In fact, before updating that patch, I wrote up the following description
but then didn't post it. I know you are asking me to update the comment
in the code, but let me post my original description as well, atleast just
because I took the effort to write it up ;)

Explanation as to why try_to_freeze() must not be used in
unlock_system_sleep():

We don't want try_to_freeze() here because of 2 reasons:

a) It is unnecessary at this point:
   Freezing always begins and ends in a piece of code which is protected by
   pm_mutex. 

   Some code piece, say "X":             PM/Freezer call path:

				         grab pm_mutex
				         start freezing tasks
   [-- lock_system_sleep() --]
				         skip freezing "X" since
				        it called freezer_do_not_count()

				         freezing succeeded.
				         Other things get done (suspend
				         or hibernate etc).

				         release pm_mutex

   lock_system_sleep()
   (it is only *now* that this
   function returned since pm_mutex
   had been grabbed all this while
   by the PM path.)

				          Let us say another PM operation
				          like suspend/hibernate begins.
					   So try to grab pm_mutex.

   /* do something */

   unlock_system_sleep()
   //Point 1

                		          It is only now that we acquire
					  pm_mutex.
					  So freezing for example, can
					  start only now.
					  //Point 2


>From the above depiction, it is clear that try_to_freeze() at Point 1 is
pointless because freezing can only begin much later, at Point 2.
When freezer_count() is called in some generic code, the try_to_freeze() is
justified because, we had asked the freezer to skip us earlier, and now we
want the freezer to consider us again. And hence, just in case the freezer
is about to give up based on its 20 second timeout, we are extra-cooperative
- we immediately call try_to_freeze() ourselves.

However, in the unlock_system_sleep() case, the freezer won't be anywhere
near its 20 second timeout, because freezing wouldn't have begun at all!
Freezing would start only after we release the pm_mutex in
unlock_system_sleep.

So, considering all this, try_to_freeze() is not needed in
unlock_system_sleep() path.

b) A more important reason why try_to_freeze() should not be used here is that
   it causes suspend-to-disk to lock up, as pointed out by Rafael.
   So its no longer "pointless/unnecessary", it is now "known to make things
   fail and hence not allowed".

//End of my description :)

I'll see how best I can summarize this in a short comment and post an updated
patch when I'm done.

Regards,
Srivatsa S. Bhat

