Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2GKCee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 22:34:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53277 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab2GKCec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 22:34:32 -0400
X-AuditID: 9c930179-b7c19ae000007374-ab-4ffce6361a47
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] perf kvm: fix bug resolving guest kernel syms
References: <1341956894-69284-1-git-send-email-dsahern@gmail.com>
	<1341956894-69284-5-git-send-email-dsahern@gmail.com>
	<874npf86dp.fsf@sejong.aot.lge.com> <4FFCE1EF.7000602@gmail.com>
Date: Wed, 11 Jul 2012 11:30:01 +0900
In-Reply-To: <4FFCE1EF.7000602@gmail.com> (David Ahern's message of "Tue, 10
	Jul 2012 20:16:15 -0600")
Message-ID: <87zk776ndi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012 20:16:15 -0600, David Ahern wrote:
> On 7/10/12 6:54 PM, Namhyung Kim wrote:
>> On Tue, 10 Jul 2012 15:48:14 -0600, David Ahern wrote:
>>> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
>>> index 641377e..da3411b 100644
>>> --- a/tools/perf/util/map.c
>>> +++ b/tools/perf/util/map.c
>>> @@ -730,3 +730,27 @@ char *machine__mmap_name(struct machine *self, char *bf, size_t size)
>>>
>>>   	return bf;
>>>   }
>>> +
>>> +void machines__set_id_hdr_size(struct rb_root *self, u16 id_hdr_size)
>>> +{
>>> +	struct rb_node *p;
>>> +	struct machine *machine;
>>> +
>>> +    p = self->rb_node;
>>> +	while (p != NULL) {
>>> +		machine = rb_entry(p, struct machine, rb_node);
>>> +		machine->id_hdr_size = id_hdr_size;
>>> +        p = rb_next(p);
>>> +	}
>>> +
>>
>> Looks like white-space damaged. :(
>
> bleah, something on my dev server converted tabs to spaces. Will fix.
>
>>
>> The loop itself looks fine, or you might use this form:
>>
>> 	for (p = rb_first(self); p; p = rb_next(p))
>
> Doesn't work - I still see machines not updated.
>>
>>
>> Is there a something like rb_for_each_entry() ?
>
> Didn't see one.
>
>>
>>
>>> +    p = self->rb_node;
>>> +    if (p)
>>> +        p = rb_prev(p);
>>> +	while (p != NULL) {
>>> +		machine = rb_entry(p, struct machine, rb_node);
>>> +		machine->id_hdr_size = id_hdr_size;
>>> +        p = rb_prev(p);
>>> +	}
>>> +
>>
>> I don't see why this second loop is necessary?
>
> To get the left half of the tree I believe. First loop walks the root
> and all of the leaves to the right; this loop walks all of the leaves
> to the left.
>

Oh, I overlooked the initial setting. So you divided tree-traversal to
left and right part. It seems very odd to me. AFAIK a traversal from
rb_first through rb_next shouldn't miss any node in the tree.

Thanks,
Namhyung
