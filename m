Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab1KWA2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:28:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1KWA2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:28:07 -0500
Message-ID: <4ECC3DF8.4090902@redhat.com>
Date: Tue, 22 Nov 2011 19:27:36 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>  <4ECB6D60.1010702@redhat.com> <1321991338.6445.70.camel@work-vm>
In-Reply-To: <1321991338.6445.70.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 02:48 PM, John Stultz wrote:
> On Tue, 2011-11-22 at 04:37 -0500, Rik van Riel wrote:
>> On 11/21/2011 10:33 PM, John Stultz wrote:

> So similarly to Robert, I don't see this approach as necessarily
> exclusive to the volatile flags. There are just some tradeoffs with the
> different approaches.

Agreed, they might be complementary.

> The upside with your approach is that applications don't have to
> remember to re-pin the cache before using it and unpin it after its done
> using it.

If using these volatile regions is going to become
common, programs will be pinning and unpinning
those cache regions all the time, even when there
is no memory pressure at all.

At that point, I wonder if userspace programmers will
not end up making an automatic choice for a method
that does not impact their fast path at all, and only
gets invoked rarely.

> The downside is that the "please shrink your caches" message is likely
> to arrive when the system is low on resources. Once applications have
> been asked to "be nice and get small!", having to wait for that action
> to occur might not be great.

The pageout code in vmscan.c can send these messages
before we actually get around to evicting any anonymous
page from memory.

I believe the code we have there today can get these
signals sent before we get in any serious trouble.

> Where as with the volatile regions, there
> are just additionally easily freeable pages available when the kernel
> needs them.

That is certainly true.  However, it is unclear how
that would translate to virtualized solutions, since
there is no way for a virtual machine to mark pages
as volatile with the host (especially since there is
no way to tell the host what pages belong together
in objects).

I'm not objecting to your idea - in fact I like it.

However, I believe it would be good to answer some of
these questions before adding another interface to the
kernel that needs to be maintained forever.
