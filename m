Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2JJS0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:26:47 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:33894 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab2JJS0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:26:42 -0400
Message-ID: <5075BDCD.4020604@halfdog.net>
Date: Wed, 10 Oct 2012 18:26:21 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/18.0 Firefox/18.0 SeaMonkey/2.15a1
MIME-Version: 1.0
To: pageexec@freemail.hu
CC: Ard Biesheuvel <ard.biesheuvel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>,
        spender@grsecurity.net
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
References: <E1T1N2q-0001xm-5X@morero.ard.nu>, <50702DF0.32447.D66E777@pageexec.freemail.hu>, <CAKFga-erNuJ8_aLtd1b0JS1YwX1LrsCEJjEeOT67V0AqLHj_SQ@mail.gmail.com> <50721D16.9006.14F512C3@pageexec.freemail.hu>
In-Reply-To: <50721D16.9006.14F512C3@pageexec.freemail.hu>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PaX Team wrote:
> On 7 Oct 2012 at 9:43, Ard Biesheuvel wrote:
> 
>> 2012/10/6 PaX Team <pageexec@freemail.hu>:
>>> sadly, this is not true at all, for multiple reasons:
>>>
>> .. snip ...
>>>
>>> cheers,
>>>   PaX Team
>>>
>>
>> So can I summarize your position as that there is no merit at all in
>> the ability to inhibit future permissions of existing mappings?
> 
> i believe i answered this in the previous mail already:
> 
>> there's certainly a point (i've been doing it for 12 years now), but to
>> make an mprotect flag into an actual security feature, it had better pass
>> simple tests, such as non-circumventability. any method relying on
>> userland playing nice is already suspect of being the wrong way and right
>> now i don't see how PROT_FINAL could be used for actual security.
> 
> so if PROT_FINAL wants to be useful, you'd have to present a case of
> how it does something useful *while* an exploited userland cannot get
> around it. in fact i think i already told you that presenting your own
> use case in more detail (read: source code, policy, etc) would be a
> great step in 'selling the idea'.

I like the idea of final memory protection, but I guess it is quite
tricky to make it non-circumventable for reading or non-modification. To
block code execution, this feature makes it harder but does not prevent
anyway: if you can execute already (e.g. ROP), one still has ways to
exec more of anything, e.g. load more stack data and stay ROPed, map new
segments, write to file and map it r-x or exec the new file, .... but
per-application policies to prevent that could be simpler than without
PROT_FINAL.

>From my point of view, when protecting against reading/modifiction, it
would make only sense when current vm and all clones stay protected,
e.g. against proc/$$/mem-reading, ptrace attaching of process to self or
clones, not core-dumpable. Otherwise, except for the latest issue, it
should be possible, that the process forks, parent modify child via
ptrace or proc/mem, then parent just waits or commits suicide. If the
content in memory or modification of running process is that important
for success of attack, efforts might be taken to do that.

But if PROT_FINAL could be made that solid, it might be quite
interesting, especially with some proc-fs settings like
final-modification-action: ignore (do not check final, e.g. for
debugging), log (log and fail), kill (get rid of process immediately).
With kernel-wide default and e.g. uid-0 modification of policy per
process, that would still allow all debugging also.

-- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
