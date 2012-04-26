Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2DZPO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:14:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54420 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2DZPOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:14:25 -0400
MIME-Version: 1.0
In-Reply-To: <1334134889-20312-1-git-send-email-eranian@google.com>
References: <1334134889-20312-1-git-send-email-eranian@google.com>
Date: Thu, 26 Apr 2012 17:14:23 +0200
Message-ID: <CABPqkBSexGgADXKF7FMUXrATf-UcYb_p=tn+ij0Hn--kYyv2jg@mail.gmail.com>
Subject: Re: [PATCH 0/5] perf tools: add meta-data header support in pipe mode
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, dsahern@gmail.com,
        namhyung.kim@lge.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Any comment on this series?

On Wed, Apr 11, 2012 at 11:01 AM, Stephane Eranian <eranian@google.com> wrote:
> This patch series adds meta-data support to perf record/report in pipe
> mode:
>        perf record -o - foo | perf inject -b | perf report -i -
>
> We had meta-data (information about host configuration, perf tool version,...)
> in regular (file) mode but it was lacking in pipe mode. This patch series fixes
> this.
>
> In pipe mode, there is no meta-data header structures at the beginning of the
> streamed data given we cannot seek in a pipe. Instead, we need to create pseudo
> record types for each of the possible features, e.g., hostname, cpuid, event_desc,
> and so on. Those pseudo records are guaranteed to be before any actual sample
> records, therefore perf report/annotate are guaranteed to get the information
> they need before processing the first sample.
>
> The series also fixes perf inject to actually inject build-ids and buildid-list
> to work better with pipe mode, i.e., print the build-ids.
>
> With this series:
>
>  $ perf record -o - noploop 2 | perf inject -b | perf report -i -
>      # ========
>      # captured on: Fri Jan 20 18:13:55 2012
>      # ========
>      #
>      # hostname : quad
>      # os release : 3.2.0-rc7-tip
>      # perf version : 3.2.0
>      # arch : x86_64
>      # nrcpus online : 4
>      # nrcpus avail : 4
>      # cpudesc : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
>      # cpuid : GenuineIntel,6,15,11
>      # total memory : 8092884 kB
>      ...
>      # HEADER_CPU_TOPOLOGY info available, use -I to display
>      noploop for 2 seconds
>      [ perf record: Woken up 1 times to write data ]
>      [ perf record: Captured and wrote 0.084 MB - (~3677 samples) ]
>        99.80%  noploop  noploop            [.] noploop
>         0.19%  noploop  [kernel.kallsyms]  [k] radix_tree_gang_lookup
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Stephane Eranian (5):
>  perf inject: fix broken perf inject -b
>  perf tools: fix piped mode read code
>  perf tools: rename HEADER_TRACE_INFO to HEADER_TRACING_DATA
>  perf record: add meta-data support for pipe-mode
>  perf: make perf buildid-list work better with pipe mode
>
>  tools/perf/builtin-annotate.c     |    5 +
>  tools/perf/builtin-buildid-list.c |    6 +-
>  tools/perf/builtin-inject.c       |    6 +
>  tools/perf/builtin-record.c       |   11 +-
>  tools/perf/builtin-report.c       |    7 +-
>  tools/perf/util/build-id.c        |    2 +
>  tools/perf/util/event.c           |   12 +
>  tools/perf/util/event.h           |   18 ++
>  tools/perf/util/header.c          |  538 ++++++++++++++++++++++++++-----------
>  tools/perf/util/header.h          |   11 +-
>  tools/perf/util/session.c         |   52 +++-
>  tools/perf/util/tool.h            |    4 +-
>  12 files changed, 494 insertions(+), 178 deletions(-)
>
> --
> 1.7.4.1
>
