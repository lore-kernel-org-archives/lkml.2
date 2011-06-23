Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab1FWAwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:52:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47114 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab1FWAwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xEv7bQkxi1/SG165BfIBXwu7StXEJG4IByvez0J0KkTKWHx2ruPVWsyBMPS3TgYiMy
         o5GUb8sJek4l7JhG9gBlJQnGtbSsgEC60z26P8Z8pejy5iHFTG/jHS+ObuiwHUu/cpl+
         opudPrxJ1xybL2FcLfAWelrWnrW/M4ojFv5CI=
MIME-Version: 1.0
In-Reply-To: <4E027A96.3040905@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
	<201106212132.39311.nai.xia@gmail.com>
	<4E01C752.10405@redhat.com>
	<4E01CC77.10607@ravellosystems.com>
	<4E01CDAD.3070202@redhat.com>
	<4E01CFD2.6000404@ravellosystems.com>
	<4E020CBC.7070604@redhat.com>
	<BANLkTikidXPzyxySbmrXK=EUXOzqMtm-0g@mail.gmail.com>
	<4E027A96.3040905@redhat.com>
Date: Thu, 23 Jun 2011 08:52:03 +0800
Message-ID: <BANLkTimB7JBdV3=jDKA=t8Rc=8C0onYM7Q@mail.gmail.com>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
From: Nai Xia <nai.xia@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>, Avi Kivity <avi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 7:28 AM, Rik van Riel <riel@redhat.com> wrote:
> On 06/22/2011 07:13 PM, Nai Xia wrote:
>>
>> On Wed, Jun 22, 2011 at 11:39 PM, Rik van Riel<riel@redhat.com>  wrote:
>>>
>>> On 06/22/2011 07:19 AM, Izik Eidus wrote:
>>>
>>>> So what we say here is: it is better to have little junk in the unstable
>>>> tree that get flushed eventualy anyway, instead of make the guest
>>>> slower....
>>>> this race is something that does not reflect accurate of ksm anyway due
>>>> to the full memcmp that we will eventualy perform...
>>>
>>> With 2MB pages, I am not convinced they will get "flushed eventually",
>>> because there is a good chance at least one of the 4kB pages inside
>>> a 2MB page is in active use at all times.
>>>
>>> I worry that the proposed changes may end up effectively preventing
>>> KSM from scanning inside 2MB pages, when even one 4kB page inside
>>> is in active use.  This could mean increased swapping on systems
>>> that run low on memory, which can be a much larger performance penalty
>>> than ksmd CPU use.
>>>
>>> We need to scan inside 2MB pages when memory runs low, regardless
>>> of the accessed or dirty bits.
>>
>> I agree on this point. Dirty bit , young bit, is by no means accurate.
>> Even
>> on 4kB pages, there is always a chance that the pte are dirty but the
>> contents
>> are actually the same. Yeah, the whole optimization contains trade-offs
>> and
>> trades-offs always have the possibilities to annoy  someone.  Just like
>> page-bit-relying LRU approximations none of them is perfect too. But I
>> think
>> it can benefit some people. So maybe we could just provide a generic
>> balanced
>> solution but provide fine tuning interfaces to make sure tha when it
>> really gets
>> in the way of someone, he has a way to walk around.
>> Do you agree on my argument? :-)
>
> That's not an argument.
>
> That is a "if I wave my hands vigorously enough, maybe people
> will let my patch in without thinking about what I wrote"
> style argument.

Oh, NO, this is not what I meant.
Really sorry if I made myself look so evil...
I actually mean: "Skip or not, we agree on a point that will not
harm most people, and provide another interface to let someon
who _really_ want to take another way."

I am by no means pushing the idea of "skipping" huge pages.
I am just not sure about it and want to get a precise idea from
you. And now I get it.


>
> I believe your optimization makes sense for 4kB pages, but
> is going to be counter-productive for 2MB pages.
>
> Your approach of "make ksmd skip over more pages, so it uses
> less CPU" is likely to reduce the effectiveness of ksm by not
> sharing some pages.
>
> For 4kB pages that is fine, because you'll get around to them
> eventually.
>
> However, the internal use of a 2MB page is likely to be quite
> different.  Chances are most 2MB pages will have actively used,
> barely used and free pages inside.
>
> You absolutely want ksm to get at the barely used and free
> sub-pages.  Having just one actively used 4kB sub-page prevent
> ksm from merging any of the other 511 sub-pages is a problem.

No, no,  I was just not sure about it. I meant we cannot satisfy
all people but I was not sure which one is good for most of them.

Sorry, again, if I didn't make it clear.


Nai

>
> --
> All rights reversed
>
