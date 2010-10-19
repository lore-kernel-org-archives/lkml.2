Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0JSOkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:40:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35157 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0JSOkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ULQIepLUqVjZ1cqxagUUexJQF6gH6R6njAXfFzEQipLkXKf7pfP2Z40320TXXvk2ay
         Uc5m8A8mGWITWiSWY7725Nitf9WPytAc1SCAnh+uU1qExbHKNh4scuX/MqlWm0GhVlmN
         NDtrx7v4+oJ598oIqYX7Lb5MmvBsqRUX5a8rI=
MIME-Version: 1.0
In-Reply-To: <4CBD5D680200005A0007492F@soto.provo.novell.com>
References: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
	<1287486167.1994.1.camel@twins>
	<4CBD5D680200005A0007492F@soto.provo.novell.com>
Date: Tue, 19 Oct 2010 20:40:00 +0600
Message-ID: <AANLkTi=-E6f3US+h9vzmZhQbzLkaoA4_OZqu8uV3wsjv@mail.gmail.com>
Subject: Re: [PATCH] sched_rt: Removes extra checking for nr_cpus_allowed when
 calling find_lowest_rq
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/10, Gregory Haskins <ghaskins@novell.com> wrote:
>>>> On 10/19/2010 at 07:02 AM, in message <1287486167.1994.1.camel@twins>,
>>>> Peter
> Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2010-10-19 at 16:57 +0600, Rakib Mullick wrote:
>
> I think the motivation here was that checking nr_cpus_allowed is far cheaper
> than taking the hit on a function call in this particularly hot path.  As
> Steven points out in a follow-up reply, the function call has additional
> overhead before the equivalent check is made again.  We could possibly
> optimize this with some of the suggestions he made, but I am not sure if it
> is worth it (alone) as the call overhead would still be present.  OTOH, the
> cases where nr_cpus_allowed <= 1 are probably rare in the grand scheme of
> things.
>
I also think that checking nr_cpus_allowed before calling
find_lowest_rq is cheaper. We can take even cheaper way by introducing
the same check in find_lock_lowest_rq(), which also calls
find_lowest_rq. Scenario in find_lock_lowest_rq is even worse, a check
for nr_cpus_allowed (maybe even before for loop) will reduce more
overhead and removing the  nr_cpus_allowed check completely from
find_lowest_rq. And it will keep find_lowest_rq simple. We can also
made a comment whenever someone is calling find_lowest_rq, should
check nr_cpus_allowed first. (I didn't propose it in patch, cause it's
duplicate check. And it looks clean).

> My opinion is the check should probably remain (if but perhaps with a
> comment to explain its existence) unless someone (Rakib, hint hint) is
> willing to do some benchmarking to demonstrate that it doesn't actually have
> any positive impact.  It probably also makes sense to take Steve's suggested
> changes to improve the places that use the function without external
> optimization.
>
If we made explicit check before calling find_lowest_rq, then I don't
think we need the change that Steve's suggesting. I think explicitly
checking is much more easier and removes extra overhead of function
calling.

Thanks,
Rakib
> Kind Regards,
> -Greg
>
>
>
