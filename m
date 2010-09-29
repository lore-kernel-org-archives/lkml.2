Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0I2IRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:17:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44065 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0I2IRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NLDAfRnSMfYw1Ro8KSNZBP4nHvbFqQhdJx6cxlVECN7naDYr4FrXgW5bslz4b6cgsz
         G7dCUjtf54lj6byRaZSi4H/SE0MiwFeTEQleGKYR1aD3dzYBDa51EYpsheFQWmVKVcA/
         7LAFY2jTuGYrJ2ji0GQ/Z5v0PTa15B3QvyrVQ=
MIME-Version: 1.0
In-Reply-To: <20100928153247.GL26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	<1285549026-5008-6-git-send-email-ying.huang@intel.com>
	<20100927100901.GC32222@erda.amd.com>
	<AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
	<20100927133816.GP13563@erda.amd.com>
	<20100927152014.GY26290@redhat.com>
	<1285634172.20791.92.camel@yhuang-dev>
	<20100928153247.GL26290@redhat.com>
Date: Wed, 29 Sep 2010 16:17:30 +0800
Message-ID: <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: huang ying <huang.ying.caritas@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 11:32 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Tue, Sep 28, 2010 at 08:36:12AM +0800, Huang Ying wrote:
>> > I tend to agree with Robert here.  I don't know if there were any 'rules'
>> > to which handlers get directly called versus ones that go through the
>> > die_chain, so I was originally going to let it go.  But if they aren't
>> > any, it does look cleaner to have everything in die_chains.
>>
>> Personally, I think directly call has better readability than
>
> I am confused what type of readability you are looking for?  Can we create
> a sysfs entry to give you that info?

Sorry for my poor English. I mean code readability here. That is,
notifier_chain makes code harder to understand than direct call.

>> notifier_chain in general. Notifier_chain is for:
>>
>> - Call functions in module.
>> - Need to enable/disable (via register/unregister) at run time.
>> - Call functions from low layer to high layer.
>>
>> Otherwise, notifier_chain should be avoid if possible. So I think it is
>> better to keep direct call as much as possible.
>
> But the problem is you have to export all this platform specific stuff to
> traps.c and surround the code with #ifdef's, which start to look ugly.

There is no #ifdef in my final default_do_nmi(), so I think the code
can be cleaned up without converting everything into notifier block. I
think the rule can be: architecture specific thing should go direct
call, while device driver should be turned into notifier block.

> Is there any reason why traps.c should know about MCA/HEST/<other hardware
> errors>?  Shouldn't it be abstracted away?

Yes. The device drivers should be abstracted away, leaving
architectural logic, such as port 0x61 as direct call. We need
notifier chain, but I just suggest reduce its usage if possible.

> Honestly, I would be interested in creating a southbridge driver and
> moving the port 0x61 code there and keeping the default_do_nmi() function
> stupidly simple (just a call to the die_chain and the
> unknown_nmi_error()).

I think the southbridge drivers should go notifier block, but the port
0x61 code is architectural and should be kept in default_do_nmi().

Best Regards,
Huang Ying
