Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936072Ab2JYVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:09:22 -0400
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:56616 "EHLO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab2JYVJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:09:20 -0400
Message-ID: <5089AA72.9010805@adobe.com>
Date: Thu, 25 Oct 2012 14:09:06 -0700
From: "Paton J. Lewis" <palewis@adobe.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <5086D27F.1000007@adobe.com> <50873DFA.5010205@adobe.com> <CAKgNAkj=52rPitKT2b4_=dwczpfub6RQojjX4rNhFZQZHecSTA@mail.gmail.com>
In-Reply-To: <CAKgNAkj=52rPitKT2b4_=dwczpfub6RQojjX4rNhFZQZHecSTA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/12 3:23 AM, Michael Kerrisk (man-pages) wrote:
> Hi Pat,
>
>
>>> I suppose that I have a concern that goes in the other direction. Is
>>> there not some other solution possible that doesn't require the use of
>>> EPOLLONESHOT? It seems overly restrictive to require that the caller
>>> must employ this flag, and imposes the burden that the caller must
>>> re-enable monitoring after each event.
>>>
>>> Does a solution like the following (with no requirement for EPOLLONESHOT)
>>> work?
>>>
>>> 0. Implement an epoll_ctl() operation EPOLL_CTL_XXX
>>>     where the name XXX might be chosen based on the decision
>>>     in 4(a).
>>> 1. EPOLL_CTL_XXX employs a private flag, EPOLLUSED, in the
>>>     per-fd events mask in the ready list. By default,
>>>     that flag is off.
>>> 2. epoll_wait() always clears the EPOLLUSED flag if a
>>>     file descriptor is found to be ready.
>>> 3. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>>>     flag is NOT set, then
>>>          a) it sets the EPOLLUSED flag
>>>          b) It disables I/O events (as per EPOLL_CTL_DISABLE)
>>>             (I'm not 100% sure if this is necesary).
>>>          c) it returns EBUSY to the caller
>>> 4. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>>>     flag IS set, then it
>>>          a) either deletes the fd or disables events for the fd
>>>             (the choice here is a matter of design taste, I think;
>>>             deletion has the virtue of simplicity; disabling provides
>>>             the option to re-enable the fd later, if desired)
>>>          b) returns 0 to the caller.
>>>
>>> All of the above with suitable locking around the user-space cache.
>>>
>>> Cheers,
>>>
>>> Michael
>>
>>
>> I don't believe that proposal will solve the problem. Consider the case
>> where a worker thread has just executed epoll_wait and is about to execute
>> the next line of code (which will access the data associated with the fd
>> receiving the event). If the deletion thread manages to call
>> epoll_ctl(EPOLL_CTL_XXX) for that fd twice in a row before the worker thread
>> is able to execute the next statement, then the deletion thread will
>> mistakenly conclude that it is safe to destroy the data that the worker
>> thread is about to access.
>
> Okay -- I had the idea there might be a hole in my proposal ;-).
>
> By the way, have you been reading the comments in the two LWN articles
> on EPOLL_CTL_DISABLE?
> https://lwn.net/Articles/520012/
> http://lwn.net/SubscriberLink/520198/fd81ba0ecb1858a2/
>
> There's some interesting proposals there--some suggesting that an
> entirely user-space solution might be possible. I haven't looked
> deeply into the ideas though.

Yes, thanks, I read through the article and comments. I believe all of 
the objections raised there were either addressed by responses there, or 
they were also voiced here on the kernel.org mailing lists and addressed 
by either my or Paul Holland's responses here. If there is another 
objection to the original proposal that you feel I have overlooked or 
which has not been properly addressed, please let me know.

Pat
