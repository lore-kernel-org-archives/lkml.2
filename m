Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0H1BbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:31:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0H1BbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R+bIc5v4uIR64K2XqsfxwaTJyoem6HHm7SbDr3qwhMrJQ5BsMg3mKOpcKgmFnOGhUA
         GFFUBr64vKN9oQUTPtEg==
MIME-Version: 1.0
In-Reply-To: <AANLkTin6+nHOowdptW2jaxg9urn3OLf9ArgGzKjWnQLM@mail.gmail.com>
References: <1282867897-31201-1-git-send-email-yinghan@google.com>
	<AANLkTimaLBJa9hmufqQy3jk7GD-mJDbg=Dqkaja0nOMk@mail.gmail.com>
	<AANLkTi=xUMSZ7wX-2BtJ0-+2BYLCTW=VPTAErinb5Zd2@mail.gmail.com>
	<AANLkTinP_q7S4_O921hdBoedmTp-7gw0+=4DPHZGmysi@mail.gmail.com>
	<AANLkTin6+nHOowdptW2jaxg9urn3OLf9ArgGzKjWnQLM@mail.gmail.com>
Date: Fri, 27 Aug 2010 18:30:58 -0700
Message-ID: <AANLkTin92hywGThE=Z7=ZJOJrmw4yA-d-sFCnUYxS2hd@mail.gmail.com>
Subject: Re: [PATCH] vmscan: fix missing place to check nr_swap_pages.
From: Venkatesh Pallipadi <venki@google.com>
To: Ying Han <yinghan@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 9:35 AM, Ying Han <yinghan@google.com> wrote:
> On Thu, Aug 26, 2010 at 10:00 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>>
>> On Fri, Aug 27, 2010 at 12:31 PM, Ying Han <yinghan@google.com> wrote:
>> > On Thu, Aug 26, 2010 at 6:03 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> >>
>> >> Hello.
>> >>
>> >> On Fri, Aug 27, 2010 at 9:11 AM, Ying Han <yinghan@google.com> wrote:
>> >> > Fix a missed place where checks nr_swap_pages to do shrink_active_list. Make the
>> >> > change that moves the check to common function inactive_anon_is_low.
>> >> >
>> >>
>> >> Hmm.. AFAIR, we discussed it at that time but we concluded it's not good.
>> >> That's because nr_swap_pages < 0 means both "NO SWAP" and "NOT enough
>> >> swap space now". If we have a swap device or file but not enough space
>> >> now, we need to aging anon pages to make inactive list enough size.
>> >> Otherwise, working set pages would be swapped out more fast before
>> >> promotion.
>> >
>> > We found the problem on one of our workloads where more TLB flush
>> > happens without the change. Kswapd seems to be calling
>> > shrink_active_list() which eventually clears access bit of those ptes
>> > and does TLB flush
>> > with ptep_clear_flush_young(). This system does not have swap
>> > configured, and why aging the anon lru in that
>> > case?
>>
>> True. I also wanted it but we have to care swap configured but
>> non-enabling still yet system as well as non-swap configured system at
>> that time.
>
> Agree.  In our case, we cares about the case where swap is not enabled
> but is configured .
>>
>> If your system is no swap configured, how about this?
>> (It's a not formal proper patch but just quick patch to show the concept).
>
> In our system, we do have swap configured. In vmscan.c, there are
> couple of places where we skip scanning
> and shrinking anon lru while the condition if(nr_swap_pages <= 0)  is
> true. It still make sense to me to add it
> to the shrink_active() condition as the initial patch.
>
> Also, we found it is quite often to hit the condition
> inactive_anon_is_low on machine with small numa node size, since the
> zone->inactive_ratio is set based on the zone->present_pages.
>

Does "total_swap_pages" help?

Thanks,
Venki
