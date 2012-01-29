Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2A2SFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 13:05:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52287 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2A2SFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 13:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAB6DaTMKiePraRLJK=BdguFVriiEHJ2UgB0qSce50FW1R7bVSA@mail.gmail.com>
References: <1326400778-24131-1-git-send-email-dumitru.sorin87@gmail.com>
 <20120113122547.GA8161@infradead.org> <CAB6DaTMKiePraRLJK=BdguFVriiEHJ2UgB0qSce50FW1R7bVSA@mail.gmail.com>
From: Sorin Dumitru <dumitru.sorin87@gmail.com>
Date: Sun, 29 Jan 2012 20:04:49 +0200
Message-ID: <CAB6DaTOC6GNFxQun=-TTLVAz_WbReEj4xfd9hZ8BqxxefdvGLg@mail.gmail.com>
Subject: Re: [PATCH] perf: check if address is in range
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        Daniel Baluta <daniel.baluta@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 6:35 PM, Sorin Dumitru
<dumitru.sorin87@gmail.com> wrote:
> On Fri, Jan 13, 2012 at 2:25 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
>> Em Thu, Jan 12, 2012 at 10:39:38PM +0200, Sorin Dumitru escreveu:
>>> When addr isn't in the [sym->start,sym->end] range offset
>>> will be a very big value, giving us a segfault when we do:
>>>       h->addr[offset]++
>>> Fix this by checking that addr is in the correct range.
>>
>> Is this against what tree? Can you please provide a backtrace of when
>> this happens?
>
> This is against mainline from kernel.org. I'm using 3.1.8 under arch linux.
> Backtrace of crash:
>
> #0  symbol__inc_addr_samples (sym=0x8b863e0, map=0x8299930, evidx=0,
> addr=1376452) at util/annotate.c:73
> #1  0x08066593 in record_precise_ip (ip=<optimized out>, counter=0,
> he=<optimized out>) at builtin-top.c:223
> #2  perf_event__process_sample (session=0x824db88, sample=0xbffff9d4,
> evsel=<optimized out>, event=<optimized out>) at builtin-top.c:801
> #3  perf_session__mmap_read_idx (self=0x824db88, idx=1) at
> builtin-top.c:825
> #4  0x08068489 in perf_session__mmap_read (self=0x824db88) at
> builtin-top.c:839
> #5  __cmd_top () at builtin-top.c:1003
> #6  cmd_top (argc=<optimized out>, argv=0xbffffd18, prefix=0x0) at
> builtin-top.c:1274
> #7  0x08055e90 in run_builtin (p=0x80f2624, argc=1, argv=0xbffffd18)
> at perf.c:286
> #8  0x08055651 in handle_internal_command (argv=0xbffffd18, argc=1) at
> perf.c:358
> #9  run_argv (argv=0xbffffbb8, argcp=0xbffffbbc) at perf.c:402
> #10 main (argc=1, argv=0xbffffd18) at perf.c:512
>
>> I ask this because this is a kind of BUG_ON() situation, one shouldn't
>> get to this point if the address is not within that symbol.
>
> That's what i thought too at first. But i'm not very familiar with the perf code
> so i thought that since we have this check for sym->end, which seems
> like a similar situation, a check for sym->start might be needed.
>
>> - Arnaldo
>>
>>> Signed-off-by: Sorin Dumitru <dumitru.sorin87@gmail.com>
>>> ---
>>>  tools/perf/util/annotate.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
>>> index 011ed26..4ddc55f 100644
>>> --- a/tools/perf/util/annotate.c
>>> +++ b/tools/perf/util/annotate.c
>>> @@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>>>
>>>       pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
>>>
>>> -     if (addr >= sym->end)
>>> +     if (addr <= sym->start || addr >= sym->end)
>>>               return 0;
>>>
>>>       offset = addr - sym->start;
>>> --
>>> 1.7.8.3

The problem seems to be that the symbol is found using al.addr but we
pass event->ip.ip to perf_top__record_precise_ip. al.addr comes from
event->ip.ip but can be modified by map_ip function pointer before we
find the symbol.

If this isn't the right approch, can you give me some pointers where
something might go wrong, because this bug is really bugging me.


diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e8b033c..3946dcb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -660,7 +660,6 @@ static void perf_event__process_sample(struct
perf_tool *tool,
 {
        struct perf_top *top = container_of(tool, struct perf_top, tool);
        struct symbol *parent = NULL;
-       u64 ip = event->ip.ip;
        struct addr_location al;
        int err;

@@ -747,7 +746,7 @@ static void perf_event__process_sample(struct
perf_tool *tool,
                }

                if (top->sort_has_symbols)
-                       perf_top__record_precise_ip(top, he, evsel->idx, ip);
+                       perf_top__record_precise_ip(top, he,
evsel->idx, al.addr);
        }

        return;
