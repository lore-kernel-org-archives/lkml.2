Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0JEOkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:40:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0JEOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b4LBFT4fkEBjEy3ormhqBchrQyzhtfW0Eo3sCXWB8YlZKQFcGiRqWieZRsz7IPd4iT
         hLtxLvIT4CBz4ucaRNeietRbj18zyv8ShGW3YEkGDZvMTbkDDJJJkAKxLFMugRBUCX/m
         QzSzf25lWOK89dg/yNP+GtrHHPjNNn+VzAHGI=
Message-ID: <4CAB38CC.3060001@gmail.com>
Date: Tue, 05 Oct 2010 07:40:12 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Potential kobject functionality (two stage delete, single
 delete)
References: <4CAB26C7.2020109@gmail.com> <20101005135750.GA4414@kroah.com>
In-Reply-To: <20101005135750.GA4414@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 06:57 AM, Greg KH wrote:
> On Tue, Oct 05, 2010 at 06:23:19AM -0700, Kent Overstreet wrote:
>> I've been working on reference counting in my own code, and it
>> seemed to me that some of this stuff would be best added to the
>> generic code - I can't be the only one who's needed to solve these
>> particular problems. But kobjects aren't new, maybe someone knows if
>> any of this has been tried before?
>
> Oh yeah, it's come up lots of times before, see the lkml archives :)

Figures :)

>> void kobject_delete(struct kobject *k)
>> {
>> 	if (!test_and_set_bit(deleted)) {
>> 		if (delete_fn)
>> 			delete_fn(k);
>> 		kobject_put(k);
>> 	}
>> }
>
> Every time we have tried to do something like this, it ends up not being
> correct, and missused, so we don't.

Well, past experience is hard to argue with. I'd be curious what 
previous implementations looked like, hopefully my google-fu is stronger 
this time... I just have a hard time seeing a good reason not do it once 
correctly, if previous interfaces were prone to misuse it still ought to 
be possible to do it right.

>> The more annoying one is two stage delete. Unless my google-fu has
>> failed me, I don't see a reasonable way of using kobject refcounting
>> if you need to drop a refcount from atomic context.
>
> You can't call kfree from atomic context?

Well, kobject_cleanup() does more than kfree() - thus I don't see how 
you'd use kobject_put() in atomic context; it seems to me it wouldn't be 
entirely unreasonable to replace kobject_put with a kref_put wrapper 
specific to your code, then you could queue up the object somewhere and 
run kobject_cleanup() yourself - except kobject_cleanup() is static.

So unless I've completely missed something, you have to use 
kobject_put() to free a kobject, but kobject_put() can't be called from 
atomic context - at least if the kobject was present in sysfs... perhaps 
that's where the confusion comes from? Going over the code again it 
looks like kobject_cleanup() doesn't do anything but kfree() if the 
kobject wasn't in sysfs.

Anyways, in that case the end result is I need my own refcount so when 
it goes to 0 I can do the right thing - the kobject's refcount then 
serves no purpose, it's just pointless duplication. Am I making any more 
sense now?

> Anyway, code does handle this properly, look at the scsi code for
> example, we have a waitqueue-like infrastructure to do this somewhere,
> perhaps it's within the driver core, I can't remember it this early in
> the morning.

I'm not arguing it can't be done, just would like something cleaner than 
what I've got now :)

Grepping around for kobject in drivers/scsi and elsewhere isn't getting 
me anything, will see where googling gets me...

> thanks,
>
> greg k-h

Sorry to have to impose upon your time :) Thanks!
