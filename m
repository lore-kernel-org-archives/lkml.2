Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2BQFFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:05:11 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:46292 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2BQFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:05:08 -0500
Message-ID: <16a5b39e58f3e0bf112918ca032dc4c0.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9hYBs6fnmnDKwkkJCnbfji8NU06_Z6m+am=aJQDbYEJr_Q@mail.gmail.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
    <a5e0a6a86bb8a20919b9ae80fd510e46.squirrel@webmail.greenhost.nl>
    <CABqD9hYBs6fnmnDKwkkJCnbfji8NU06_Z6m+am=aJQDbYEJr_Q@mail.gmail.com>
Date: Fri, 17 Feb 2012 06:05:03 +0100
Subject: Re: [PATCH v8 1/8] sk_run_filter: add support for custom
 load_pointer
From: "Indan Zupancic" <indan@nul.nu>
To: "Will Drewry" <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.org,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, keescook@chromium.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 96329e479c93ffb0716cf569fedf443d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, February 17, 2012 05:13, Will Drewry wrote:
> On Thu, Feb 16, 2012 at 9:04 PM, Indan Zupancic <indan@nul.nu> wrote:
>>> Hello,
>>>
>>> On Thu, February 16, 2012 21:02, Will Drewry wrote:
>>>> This change allows CONFIG_SECCOMP to make use of BPF programs for
>>>> user-controlled system call filtering (as shown in this patch series).
>>>>
>>>> To minimize the impact on existing BPF evaluation, function pointer
>>>> use must be declared at sk_chk_filter-time.  This allows ancillary
>>>> load instructions to be generated that use the function pointer rather
>>>> than adding _any_ code to the existing LD_* instruction paths.
>>>>
>>>> Crude performance numbers using udpflood -l 10000000 against dummy0.
>>>> 3 trials for baseline, 3 for with tcpdump. Averaged then differenced.
>>>> Hard to believe trials were repeated at least a couple more times.
>>>>
>>>> * x86 32-bit (Atom N570 @ 1.66 GHz 2 core HT) [stackprot]:
>>>> - Without:  94.05s - 76.36s = 17.68s
>>>> - With:     86.22s - 73.30s = 12.92s
>>>> - Slowdown per call: -476 nanoseconds
>>>>
>>>> * x86 32-bit (Atom N570 @ 1.66 GHz 2 core HT) [no stackprot]:
>>>> - Without:  92.06s - 77.81s = 14.25s
>>>> - With:     91.77s - 76.91s = 14.86s
>>>> - Slowdown per call: +61 nanoseconds
>>>>
>>>> * x86 64-bit (Atom N570 @ 1.66 GHz 2 core HT) [stackprot]:
>>>> - Without: 122.58s - 99.54s = 23.04s
>>>> - With:    115.52s - 98.99s = 16.53s
>>>> - Slowdown per call:  -651 nanoseconds
>>>>
>>>> * x86 64-bit (Atom N570 @ 1.66 GHz 2 core HT) [no stackprot]:
>>>> - Without: 114.95s - 91.92s = 23.03s
>>>> - With:    110.47s - 90.79s = 19.68s
>>>> - Slowdown per call: -335 nanoseconds
>>>>
>>>> This makes the x86-32-nossp make sense.  Added register pressure always
>>>> makes x86-32 sad.
>>>
>>> Your 32-bit numbers are better than your 64-bit numbers, so I don't get
>>> this comment.
>
> They are in the absolute.  Relatively, all performance improved with
> my patch except for x86-nossp.

Why is 32-bit sad if it's faster than the 64-bit version?

I'd say the 64-bit numbers are sad considering the extra registers.

>>> Yeah, testing on Atom is a bit silly.
>
> Making things run well on Atom is important for my daily work.  And it
> usually means (barring Atom-specific weirdness) that it then runs even
> better on bigger processors :)

Fair enough!

>>>> +#define SKB(_data) ((const struct sk_buff *)(_data))
>>>
>>> Urgh!
>>>
>>> If you had done:
>>>                const struct sk_buff *skb = data;
>>>
>>> at the top, all those changed wouldn't be needed and it would look better too.
>
> That just means I need to disassemble after to make sure the compiler
> does the right thing.  I'll do that and change it if gcc is doing the
> right thing.

You're telling the compiler the same thing, so it better do the right thing!
It just looks better.

>>> These two should either return 0, be networking-only, just return 0/-1 or
>>> use a constant length.
>
> I'm changing it to constant length, but I can get rid of it
> altogether. I don't care either way, it just depends on if there is
> anyone else who will want this support.

Right now there is no one else.

>>>> +#define MAYBE_USE_LOAD_FN(CODE) \
>>>> +                     if (flags & BPF_CHK_FLAGS_NO_SKB) { \
>>>> +                             code = BPF_S_ANC_##CODE; \
>>>> +                             break; \
>>>> +                     }
>>>
>>> You can as well hide everything in the macro then, including the case,
>>> like the ANCILLARY() macro does.
>
> I'm not sure that would make it any more readable though, especially
> since I don't always break; after.

Ah, true. Because there was a break; in the macro, I assumed it would
always break, for some reason. I wish there was a way to make it look
nice though, it's so ugly.

>
>>>> +             case BPF_S_LD_W_LEN:
>>>> +                     MAYBE_USE_LOAD_FN(LD_W_LEN);
>>>> +                     break;
>>>> +             case BPF_S_LDX_W_LEN:
>>>> +                     MAYBE_USE_LOAD_FN(LDX_W_LEN);
>>>> +                     break;
>>>> +             case BPF_S_LD_W_IND:
>>>> +                     MAYBE_USE_LOAD_FN(LD_W_IND);
>>>> +                     break;
>>>> +             case BPF_S_LD_H_IND:
>>>> +                     MAYBE_USE_LOAD_FN(LD_H_IND);
>>>> +                     break;
>>>> +             case BPF_S_LD_B_IND:
>>>> +                     MAYBE_USE_LOAD_FN(LD_B_IND);
>>>> +                     break;
>>>> +             case BPF_S_LDX_B_MSH:
>>>> +                     MAYBE_USE_LOAD_FN(LDX_B_MSH);
>>>> +                     break;
>>>>               case BPF_S_LD_W_ABS:
>>>> +                     MAYBE_USE_LOAD_FN(LD_W_ABS);
>>>>               case BPF_S_LD_H_ABS:
>>>> +                     MAYBE_USE_LOAD_FN(LD_H_ABS);
>>>>               case BPF_S_LD_B_ABS:
>>>> +                     MAYBE_USE_LOAD_FN(LD_B_ABS);
>>>>  #define ANCILLARY(CODE) case SKF_AD_OFF + SKF_AD_##CODE:     \
>>>>                               code = BPF_S_ANC_##CODE;        \
>>>>                               break
>>>> @@ -572,7 +658,7 @@ int sk_chk_filter(struct sock_filter *filter, unsigned int flen)
>>>>       }
>>>>       return -EINVAL;
>>>>  }
>>>> -EXPORT_SYMBOL(sk_chk_filter);
>>>> +EXPORT_SYMBOL(bpf_chk_filter);
>>>>
>>>>  /**
>>>>   *   sk_filter_release_rcu - Release a socket filter by rcu_head
>>>> --
>>>> 1.7.5.4
>>>>
>>>
>>> Greetings,
>
> Thanks!

You're welcome!

Indan


