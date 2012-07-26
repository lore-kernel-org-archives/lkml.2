Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab2GZFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:16:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55484 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2GZFQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:16:25 -0400
Message-ID: <5010D2B1.3000206@gmail.com>
Date: Wed, 25 Jul 2012 23:16:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-9-git-send-email-dsahern@gmail.com> <20120723181358.GC6717@infradead.org> <500EAF23.8060909@gmail.com> <20120724161507.GG3732@erda.amd.com> <500EDB50.3070704@gmail.com> <20120724180312.GJ6717@infradead.org>
In-Reply-To: <20120724180312.GJ6717@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/12 12:03 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jul 24, 2012 at 11:28:48AM -0600, David Ahern escreveu:
>> On 7/24/12 10:15 AM, Robert Richter wrote:
>>> On AMD cpus precise_ip maps to IBS, which does not support hardware
>>> options as perfctrs do. Thus, following attr flags are not supported:
>
>>>   exclude_user, exclude_kernel, exclude_host, exclude_guest
>
>>> Counting in guest mode is possible with IBS, but not the exclusion of
>>> a certain mode. If precise_ip counting is enabled on AMD we may not
>>> set the exclude_guest flag.
>
>> Ok, so with AMD precise_ip requires exclude_guest to be unset; for
>> Intel we need it set.
>
>> So then we look at vendor_id in /proc/cpuinfo?
>
> Does it return EOPNOTSUPP or something similar if something not
> supported is asked for?
>
> Fallbacking, or capability querying if you will, may be the way to do it
> without having to maintain an userland table for what is possible,
> leaving it to the kernel drivers for each arch.

Peter's patch (see https://lkml.org/lkml/2012/7/9/298) changes kernel 
side to require the use of exclude_guest if the precise modifier is 
used, returning -EOPNOTSUPP if exclude_guest is not set. This patch goes 
after the user experience: Today if a user specifies -e <event>:p all 
other modifiers are reset - including exclude_guest. Going forward we 
need :p to imply :pH if a user has not specified a GH modifer.

We could do nothing and handle the unsupported error and try setting the 
exclude_guest option - like perf handles other new parameters. But 
EOPNOTSUPP is not uniquely tied to this error -- e.g., it could be the 
BTS is not supported (:pp). Also, we have no easy way to discriminate :p 
from :pG or :pGH. It seems to me perf should not silently undo a user 
request on the modifier, but inform the user the request is wrong. For 
example if a user request -e cycles:pG it should not be silently turned 
into :pH.

And then yesterday, Robert stated that none of the exclude_xxxx 
modifiers can be set for the AMD if the precise modifier is used, so we 
cannot blindly set exclude_guest if precise_ip is set.

So, seems to me perf need's one action for Intel processors and another 
for AMD.

David

>
> We do it now for sample_id_all and some other newer stuff, maybe we can
> do it for this as well.
>
> - Arnaldo
>

