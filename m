Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2FHEuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:50:24 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52469 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2FHEuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:50:22 -0400
Message-ID: <4FD1848B.7040102@gmail.com>
Date: Fri, 08 Jun 2012 00:50:19 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com>	<4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com>	<4FC937AD.8040201@linaro.org> <4FC9438B.1000403@gmail.com>	<4FC94F61.20305@linaro.org> <4FCFB4F6.6070308@gmail.com>	<4FCFEE36.3010902@linaro.org> <CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com> <4FD13C30.2030401@linux.vnet.ibm.com> <4FD16B6E.8000307@linaro.org>
In-Reply-To: <4FD16B6E.8000307@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/7/12 11:03 PM), John Stultz wrote:
> On 06/07/2012 04:41 PM, Dave Hansen wrote:
>> On 06/07/2012 03:55 AM, Dmitry Adamushko wrote:
>>> but maybe we should also purge them before we swap out some non-tmpfs
>>> pages or drop some file-backed pages?
>>
>> Sure... I guess we could kick that from either direct reclaim or from
>> kswapd. But, then we're basically back to the places where
>> shrink_slab() is called.
>>
>> I think that means that we think it's preferable to integrate this more
>> directly in the VM instead of sticking it off in the corner of tmpfs
>> only, or pretending it's a slab.
>>
>> Dunno... The slab shrinker one isn't looking _so_ bad at the moment.
>
> Dave also pointed out to me on irc that on a system without swap,
>shmem_writepage doesn't even get called, which kills the utility of
>triggering volatile purging from writepage.

Ah, right you are. swap-less system never try to reclaim anon pages. So,
volatile pages is no longer swap backed. swap backed lru is no longer suitable
place.

  
> So I'm falling back to using a shrinker for now, but I think Dmitry's
>point is an interesting one, and am interested in finding a better
>place to trigger purging volatile ranges from the mm code. If anyone has any
>suggestions, let me know, otherwise I'll go back to trying to better grok the mm code.

I hate vm feature to abuse shrink_slab(). because of, it was not designed generic callback.
it was designed for shrinking filesystem metadata. Therefore, vm keeping a balance between
page scanning and slab scanning. then, a lot of shrink_slab misuse may lead to break balancing
logic. i.e. drop icache/dcache too many and makes perfomance impact.

As far as a code impact is small, I'm prefer to connect w/ vm reclaim code directly.
