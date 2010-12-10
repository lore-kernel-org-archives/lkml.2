Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0LJC1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:27:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47271 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0LJC1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kfCkNFz4yhaAgkgFGAXMnz/zccOu/6xrvGB0M+yAA//KJfaVzjvQ9Vv9EQE9JWLUEZ
         pvA+NVz9xQjJJDRQdttW+naGitTHlqjUhvy/hnz0vv/g2V3JsOooU2cCWFLgmvC/ylij
         8vqCnArcNceYimslnPNxNoCN793gUJk4eYeiI=
MIME-Version: 1.0
In-Reply-To: <1291915077.6803.1.camel@twins>
References: <1291432752-2466-1-git-send-email-bookjovi@gmail.com>
	<AANLkTimnSPSEx+B+wgxJaaAO8-HxcnLW+Nob4O3mjxBn@mail.gmail.com>
	<AANLkTimFjH6JZjOhPBrHmfpRycs4gDJuCpa+koxEyNgY@mail.gmail.com>
	<AANLkTi=HGdGs++FKY6=icEs3FTwSggXTu42JQ+1MCxBc@mail.gmail.com>
	<4D010C9D.6020005@linux.vnet.ibm.com>
	<1291915077.6803.1.camel@twins>
Date: Fri, 10 Dec 2010 10:27:49 +0800
Message-ID: <AANLkTinAd968gPUKHiLTxDwR=xXiPg3=ySBOnLqatGRb@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix error handling path
From: jovi zhang <bookjovi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Thiago Farina <tfransosi@gmail.com>, paulus@samba.org, mingo@elte.hu,
        acme@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 1:17 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-12-09 at 09:06 -0800, Corey Ashford wrote:
>> On 12/07/2010 05:51 PM, jovi zhang wrote:
>> > On Mon, Dec 6, 2010 at 9:59 AM, jovi zhang<bookjovi@gmail.com>  wrote:
>> >> On Sun, Dec 5, 2010 at 8:29 PM, Thiago Farina<tfransosi@gmail.com>  wrote:
>> >>>
>> >>> On Sat, Dec 4, 2010 at 1:19 AM,<bookjovi@gmail.com>  wrote:
>> >>>> fix error handling path
>> >>>>
>> >>>> Signed-off-by: Jovi Zhang<bookjovi@gmail.com>
>> >>>>   kernel/perf_event.c |    2 --
>> >>>>   1 files changed, 0 insertions(+), 2 deletions(-)
>> >>>>
>> >>>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> >>>> index cb6c0d2..62f9e9d 100644
>> >>>> --- a/kernel/perf_event.c
>> >>>> +++ b/kernel/perf_event.c
>> >>>> @@ -1918,8 +1918,6 @@ static int get_callchain_buffers(void)
>> >>>>         }
>> >>>>
>> >>>>         err = alloc_callchain_buffers();
>> >>>> -       if (err)
>> >>>> -               release_callchain_buffers();
>> >>>
>> >>> Care to explain in the change log message? As I reader, is not clear
>> >>> to me what is wrong with this.
>> >>
>> >> Sorry, the description should be as:
>> >> fix error handling path. alloc_callchain_buffers() can return -ENOMEM,
>> >> in this time callchain_cpus_entries maybe is NULL, It will oops if
>> >> invoke release_callchain_buffers() when callchain_cpus_entries is
>> >> NULL.
>> >>
>> > I hope my understanding is right, is it?
>>
>> One possible problem here is what if it returns an error other than
>> -ENOMEM, and the buffers do need to be released?  Maybe you could change
>> the code to
>>
>> err = alloc_callchain_buffers();
>> if (err != -ENOMEM)
>>       release_callchain_buffers();
>>

Thanks for you suggestion. I also thought it, but I think it should
release the buffers in alloc_callchain_buffers if there have some
error(like many other part of kernel code).

It's not a good way to trace return error code outside of
alloc_callchain_buffer, if there have many return error code in
future, maybe need to write code like this:
if(err && err != -ENOMEM && err != -EXXX ) ...

It's very ugly. is right?

>>
>> Currently, alloc_callchain_buffers cannot return any error code other
>> than -ENOMEM, but that might change in the future.
>
> The kernel convention is to fully clean up after yourself if you return
> an error. So in that sense the patch seems right.
>
> Anyway, anybody care to post a new patch with slightly extended
> changelog?
>
