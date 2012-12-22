Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LVT2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:28:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51996 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2LVT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:28:07 -0500
Message-ID: <50D6086E.4000402@gmail.com>
Date: Sat, 22 Dec 2012 12:22:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com> <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com> <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com> <50CA0134.2090608@gmail.com> <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com> <20121213165904.GA18574@gmail.com> <CA+55aFwfxRgLqSsa1=4KvhR6E5GdvfGGxTM_0++YepLv5A_U_w@mail.gmail.com> <20121213173101.GA19444@gmail.com> <50CEA2F7.7020908@gmail.com>
In-Reply-To: <50CEA2F7.7020908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any opinions on whether the approach is reasonable?

On 12/16/12 9:43 PM, David Ahern wrote:
> On 12/13/12 10:31 AM, Ingo Molnar wrote:
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> So the default shouldn't necessarily be "include guest". The default
>>> should presumably be "the user didn't say", and then the kernel does
>>> whatever works best.
>>>
>>> If the user actually explicitly says one or the other, we should try
>>> to honor that (and then EOPNOTSUPP may be a "sorry, I really cannot do
>>> that particular combination that you explicitly asked for").
>>>
>>> That should make everybody happy. Doing a non-PEBS virtualized perf
>>> run should still work with the old binary.
>>>
>>> So there should be two bits: "include guest" (V in the event specifier
>>> unless you already used that for something else) and "host only" (H),
>>> and they should both default to off. Then the kernel can see the three
>>> actual cases.
>>>
>>> (Or four cases, if you really want to: you may or may not want to make
>>> the "both V and H set means both, and _only_ V set means 'no host at
>>> all, _only_ virtual environment'. So then ":ppV" would mean
>>> "cycle-accurate for virtual box _only_", while ":ppVH" would mean
>>> "cycle-accurate for both the host and the virtual box". Of course,
>>> considering the PEBS interface, right now neither of those can
>>> actually work, but plain ":V" and ":HV" could work).
>>>
>>> The important thing, I think, is that if the user doesn't know
>>> or care about the VM case (because he's not running any!) and
>>> doesn't specify, then the kernel should not say EOPNOTSUPP,
>>> and should do whatever works for that cpu.
>>
>> Agreed.
>>
>> David, wanna send a patch for this?
>
> As I mentioned in a prior email exclude_{guest,host} work currently work
> fine without PEBS. The current matrix for the flags:
>
>                     profiling
>                    guest    host
> -e <event>         y        y
> -e <event>:G       y        n    - G means enable guest, turn off host
> -e <event>:H       n        y    - H means enable host, turn off guest
> -e <event>:GH      y        y    - G followed by H means enable both
> -e <event>:HG      y        y    - same as GH
>
> There is no reason to change how these work. It's the variants with :p
> that need to be handled:
>
> -e <event>:p       n        y    - guest off is required
> -e <event>:pG      y        n    - needs to fail - not supported
> -e <event>:pH      n        y
> -e <event>:pGH     y        y    - needs to fail - not supported
>
> This is the logic that was implemented in the original patchset which
> was pulled into v3.7 and the cause of this email thread.
>
> One suggestion was to switch exclude_guest to include_guest. I take that
> to mean deprecate the current exclude_guest and add a new include_guest
> flag. Given that there are a number of exclude_XXXX flags (XXXX = user,
> kernel, host, guest, hv, etc) that would make the perf code inconsistent.
>
> All that is needed is for the current exclude_guest flag to be
> deprecated such that for older binaries on newer kernels it is ignored
> (perhaps a warn on once), and then a new flag -- exclude_guest2 -- is
> then used for the new logic.
>
> e.g.,
>
> diff --git a/include/uapi/linux/perf_event.h
> b/include/uapi/linux/perf_event.h
> index 4f63c05..19900df 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -266,12 +266,14 @@ struct perf_event_attr {
>                  sample_id_all  :  1, /* sample_type all events */
>
>                  exclude_host   :  1, /* don't count in host   */
> -               exclude_guest  :  1, /* don't count in guest  */
> +               exclude_guest  :  1, /* don't count in guest -
> DEPRECATED */
>
>                  exclude_callchain_kernel : 1, /* exclude kernel
> callchains */
>                  exclude_callchain_user   : 1, /* exclude user
> callchains */
>
> -               __reserved_1   : 41;
> +               exclude_guest2  :  1, /* don't count in guest  */
> +
> +               __reserved_1   : 40;
>
>      union {
>          __u32       wakeup_events;    /* wakeup every n events */
>
>
> Do you agree with that?
>
> David

