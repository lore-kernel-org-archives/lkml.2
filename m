Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0L0OE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:04:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41810 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0L0OE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xOprLDbKrQSfZB0JJvasn96KMDLyHzD8urb+ZkrA43rhd/GXmI46z7MxAq+O40/DBQ
         e8Pte1ulfv1BtFRd7Tx3v3BHEpX/fkttjv9BZqDBQRNqP+5QFr76EnngfVzmB5RbHmfN
         Aj+TuZaHJdqrXM4BucljJ8QIpvuwLgHOMu+x8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=cDqAz_9+0358uZ2F0W8==+hCHVJxUsWhcNaVC@mail.gmail.com>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<AANLkTi==ahwQXGK-hPq+2KVRRwQiL9j7vVakAwi=NTiq@mail.gmail.com>
	<AANLkTinye4NY6D=pHWRKTW=smhS3qg1kfBW7wncQgXSU@mail.gmail.com>
	<AANLkTinNhupY59gYJNi_za8UvgGkjFA9mbdkKfwfKWeQ@mail.gmail.com>
	<AANLkTi=FOz1UZw8pbYA7Tb7b1q4O1=WRL3fzOuN0E0wX@mail.gmail.com>
	<AANLkTi=cDqAz_9+0358uZ2F0W8==+hCHVJxUsWhcNaVC@mail.gmail.com>
Date: Mon, 27 Dec 2010 22:04:25 +0800
Message-ID: <AANLkTinibgwPHq5h1hi-wBN3_OG=XAnZ8Ahqo515pfez@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 8:56 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Sun, Dec 26, 2010 at 6:05 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Sun, Dec 26, 2010 at 5:08 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>> On Sun, Dec 26, 2010 at 1:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
>>>> On Sun, Dec 26, 2010 at 2:46 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>>>> On Sun, Dec 26, 2010 at 11:13 AM, Hillf Danton <dhillf@gmail.com> wrote:
>>>>> Above description tells how its done, what it is but its not clear why
>>>>> we should use it. Can I know why should we use it or its benefits?
>>>>>
>>>>
>>>> The outstanding benefit looks that nano semaphore could be used in
>>>> cases where callers want to wait not only more than one jiffy, but far
>>>> less than one jiffy also.
>>>>
>>> But, how do we know that resources are going to be available within
>>> one jiffy or far less than one jiffy? We we be deterministic?
>>>
>> This is a really hard question.
>>
>> Though I could not answer as fine as Ingo Molnar could, the
>> deterministic has to be faced by most contentions for resources in
>> kernel, simply because deadlock could occur in spin lock for instance.
>>
> Yes, if its not handled carefully.
>
>> On the other hand, this question explores a byproduct advantage, not
>> seriously considered before,  of nano semaphore, that the caller could
>> learn that there is something out of track if she waited over 100
>> microseconds in 5 consequent steps, 20 microseconds a step, if she
>> think the resource should be available in 60 microseconds.
>>
> Why should caller think such a way, that resource will be available in
> 60 microseconds?
>

There are methods in kernel, say watchdog, to detect cases that are out
of track. The estimation about the availability of resource is utilized also
in dispatching commands to scsi disk by registering timer.

In nano semaphore, though the methods not implemented,
the waiter is able to work out which task is holding it over 60us in
out-of-track case.

>> And in nano semaphore method is available for callers to select
>> waiting over one second, one millisecond, one microsecond, one
>> nanosecond, depending on what the underlying system could offer. After
>> waiting, the caller is free to determine what to do next if the
>> resource is not available.
>>
> How do we know that, what the underlying system will offer? Its an

This is another hard question. And Ingo could say a few words about
the accuracy of hrtimer.

> NP-type problem. We cannot determine what will happen on a systems
> context. When a caller need resource, without that resource is it

This is not hard. When kmallocing 4k, if NULL returned, I will try half,
if still not available, simply return -ENOMEM.

> possible to accomplish its job? If its not, then the ultimate way to
> deal with it, is simply waiting until it gets the resource.
>

Another way looks to return -EBUSY directly, like aborting what is
dispatched and reset the bus then in scsi.

>> Here is another sample, if taxi will not come in two minutes, I could
>> either give up shopping downtown, or wait another three minutes,
>> depending on what will happen two minutes later.
>
> But what, if your mother told you not to come home until you done shopping? :)
>

I will info her every two minutes that taxi still not available, and
go home after 15 infos.


And lets return to nano semaphore, it is designed, unlike semaphore, not to loop
until released by its holder. Another difference is that the caller is free to
select the time period in nano seconds to wait.

Should anything else be added?

thanks,
Hillf
