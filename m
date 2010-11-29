Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0K2KW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:22:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0K2KWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:22:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s604PGs+jUUsGN1Yr5EGsdNSDe5iIrVOV8n/9dCd7xAQQ3JWtuX0tSRJh/EBcX3qgS
         IPNBzy/p5/tkGPe4luyA==
MIME-Version: 1.0
In-Reply-To: <tip-baa2f6cedbfae962f04281a31f08ec29667d31a0@git.kernel.org>
References: <tip-baa2f6cedbfae962f04281a31f08ec29667d31a0@git.kernel.org>
Date: Mon, 29 Nov 2010 11:22:50 +0100
Message-ID: <AANLkTik5oXxxSKcLq2j_9OAVqSzPxqtqqkSrQhqeB2it@mail.gmail.com>
Subject: Re: [tip:perf/core] perf record: Add option to disable collecting build-ids
From: Stephane Eranian <eranian@google.com>
To: acme@redhat.com
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Indeed, collecting buildids at the end of a perf record session
is a very time AND memory consuming phase. I have seen
system oom because of this when running inside cgroup with
low memory.

This is easy to reproduce running: perf record -a -- ./Run shell.
With this, you see perf record reaching a RSS first plateau during
the active collection of the samples, i.e., dumping the kernel
buffer on disk. But then, when it calls process_buildids(), it shoots
way up in memory consumption. For instance, I have seen a
perf record running at 10MB RSS shooting all the way to 250MB
RSS during that phase. At first, I thought there was a memory
leak somewhere. But after instrumenting for a while, nothing
really showed up.

I think the problem for RSS is not so much reloading the entire
buffer, but rather that you are recreating the entire addresses spaces
of all processes captured. The reason: you only want to save the
buildids of the DSO for which you had at least one sample. Thus,
you have to allocate/de-allocate tons of threads and map structures.
I wonder if simply looking for MMAP samples and storing the buildids
(even if they have no samples) wouldn't be more efficient in some
cases. I believe it would be faster and less memory greedy.


On Sun, Nov 28, 2010 at 9:33 AM, tip-bot for Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Commit-ID:  baa2f6cedbfae962f04281a31f08ec29667d31a0
> Gitweb:     http://git.kernel.org/tip/baa2f6cedbfae962f04281a31f08ec29667d31a0
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Fri, 26 Nov 2010 19:39:15 -0200
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Fri, 26 Nov 2010 19:39:15 -0200
>
> perf record: Add option to disable collecting build-ids
>
> Collecting build-ids for long running sessions may take a long time
> because it needs to traverse the whole just collected perf.data stream
> of events, marking the DSOs that had hits and then looking for the
> .note.gnu.build-id ELF section.
>
> For things like the 'trace' tool that records and right away consumes
> the data on systems where its unlikely that the DSOs being monitored
> will change while 'trace' runs, it is desirable to remove build id
> collection, so add a -B/--no-buildid option to perf record to allow such
> use case.
>
> Longer term we'll avoid all this if we, at DSO load time, in the kernel,
> take advantage of this slow code path to collect the build-id and stash
> it somewhere, so that we can insert it in the PERF_RECORD_MMAP event.
>
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-record.c            |   14 +++++++++++---
>  tools/perf/util/header.c               |   11 +++++++++--
>  tools/perf/util/header.h               |    1 +
>  tools/perf/util/include/linux/bitops.h |    5 +++++
>  4 files changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 3d2cb48..024e144 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -61,6 +61,7 @@ static bool                   inherit_stat                    =  false;
>  static bool                    no_samples                      =  false;
>  static bool                    sample_address                  =  false;
>  static bool                    no_buildid                      =  false;
> +static bool                    no_buildid_cache                =  false;
>
>  static long                    samples                         =      0;
>  static u64                     bytes_written                   =      0;
> @@ -437,7 +438,8 @@ static void atexit_header(void)
>        if (!pipe_output) {
>                session->header.data_size += bytes_written;
>
> -               process_buildids();
> +               if (!no_buildid)
> +                       process_buildids();
>                perf_header__write(&session->header, output, true);
>                perf_session__delete(session);
>                symbol__exit();
> @@ -557,6 +559,9 @@ static int __cmd_record(int argc, const char **argv)
>                return -1;
>        }
>
> +       if (!no_buildid)
> +               perf_header__set_feat(&session->header, HEADER_BUILD_ID);
> +
>        if (!file_new) {
>                err = perf_header__read(session, output);
>                if (err < 0)
> @@ -831,8 +836,10 @@ const struct option record_options[] = {
>                    "Sample addresses"),
>        OPT_BOOLEAN('n', "no-samples", &no_samples,
>                    "don't sample"),
> -       OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid,
> +       OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
>                    "do not update the buildid cache"),
> +       OPT_BOOLEAN('B', "no-buildid", &no_buildid,
> +                   "do not collect buildids in perf.data"),
>        OPT_END()
>  };
>
> @@ -857,7 +864,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>        }
>
>        symbol__init();
> -       if (no_buildid)
> +
> +       if (no_buildid_cache || no_buildid)
>                disable_buildid_cache();
>
>        if (!nr_counters) {
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index d7e67b1..f65d7dc 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -152,6 +152,11 @@ void perf_header__set_feat(struct perf_header *self, int feat)
>        set_bit(feat, self->adds_features);
>  }
>
> +void perf_header__clear_feat(struct perf_header *self, int feat)
> +{
> +       clear_bit(feat, self->adds_features);
> +}
> +
>  bool perf_header__has_feat(const struct perf_header *self, int feat)
>  {
>        return test_bit(feat, self->adds_features);
> @@ -431,8 +436,10 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
>        int idx = 0, err;
>
>        session = container_of(self, struct perf_session, header);
> -       if (perf_session__read_build_ids(session, true))
> -               perf_header__set_feat(self, HEADER_BUILD_ID);
> +
> +       if (perf_header__has_feat(self, HEADER_BUILD_ID &&
> +           !perf_session__read_build_ids(session, true)))
> +               perf_header__clear_feat(self, HEADER_BUILD_ID);
>
>        nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
>        if (!nr_sections)
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index 402ac24..ed550bf 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -84,6 +84,7 @@ u64 perf_header__sample_type(struct perf_header *header);
>  struct perf_event_attr *
>  perf_header__find_attr(u64 id, struct perf_header *header);
>  void perf_header__set_feat(struct perf_header *self, int feat);
> +void perf_header__clear_feat(struct perf_header *self, int feat);
>  bool perf_header__has_feat(const struct perf_header *self, int feat);
>
>  int perf_header__process_sections(struct perf_header *self, int fd,
> diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
> index bb4ac2e..8be0b96 100644
> --- a/tools/perf/util/include/linux/bitops.h
> +++ b/tools/perf/util/include/linux/bitops.h
> @@ -13,6 +13,11 @@ static inline void set_bit(int nr, unsigned long *addr)
>        addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
>  }
>
> +static inline void clear_bit(int nr, unsigned long *addr)
> +{
> +       addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
> +}
> +
>  static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
>  {
>        return ((1UL << (nr % BITS_PER_LONG)) &
>
