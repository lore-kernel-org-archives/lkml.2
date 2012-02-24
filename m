Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2BXKM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:12:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34776 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2BXKM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:12:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.180.101.37 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <20120119174924.GA5409@quad>
References: <20120119174924.GA5409@quad>
Date: Fri, 24 Feb 2012 11:12:25 +0100
Message-ID: <CABPqkBRZu3sb3bRfruix7-HS-1qHkh2CqwXNRGjGu-y6O4ywbA@mail.gmail.com>
Subject: Re: [PATCH] perf: fix pipe mode read code
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comment on this patch?

On Thu, Jan 19, 2012 at 6:49 PM, Stephane Eranian <eranian@google.com> wrote:
>
> In __perf_session__process_pipe_events(), there is a risk
> we could read more than what a union perf_event struct can
> hold. This could happen when perf is reading a file which
> contains new and unknown record types which are larger than
> anything the tool already knows about (i.e. part of union
> perf_event).
>
> In general, perf is supposed to skip records it does not
> understand, but in pipe mode, those have to be read and
> ignored. They cannot just be skipped. In the current code,
> the backing for the read is provided by union perf_event.
> There is no check for the size limit thus there is a risk
> of buffer overrun:
>
>      union perf_event event;
>      void *p;
>
>      size = event->header.size;
>
>      p = &event;
>      p += sizeof(struct perf_event_header);
>      if (size - sizeof(struct perf_event_header)) {
>        err = readn(self->fd, p, size - sizeof(struct perf_event_header));
>
> It should be noted that the same problem may occur with known
> record types if they have a variable size body (not captured in
> union perf_event).
>
> We fix this by allocating a buffer based on the size reported in
> the header. We reuse the buffer as much as we can. We realloc in
> case it becomes too small. In the  common case, the performance
> impact is negligible.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index b5ca255..7f078a6 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -972,8 +972,9 @@ volatile int session_done;
>  static int __perf_session__process_pipe_events(struct perf_session *self,
>                                               struct perf_tool *tool)
>  {
> -       union perf_event event;
> -       uint32_t size;
> +       union perf_event *event;
> +       uint32_t size, cur_size = 0;
> +       void *buf = NULL;
>        int skip = 0;
>        u64 head;
>        int err;
> @@ -982,8 +983,14 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
>        perf_tool__fill_defaults(tool);
>
>        head = 0;
> +       cur_size = sizeof(union perf_event);
> +
> +       buf = malloc(cur_size);
> +       if (!buf)
> +               return -errno;
>  more:
> -       err = readn(self->fd, &event, sizeof(struct perf_event_header));
> +       event = buf;
> +       err = readn(self->fd, event, sizeof(struct perf_event_header));
>        if (err <= 0) {
>                if (err == 0)
>                        goto done;
> @@ -993,13 +1000,22 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
>        }
>
>        if (self->header.needs_swap)
> -               perf_event_header__bswap(&event.header);
> +               perf_event_header__bswap(&event->header);
>
> -       size = event.header.size;
> +       size = event->header.size;
>        if (size == 0)
>                size = 8;
>
> -       p = &event;
> +       if (size > cur_size) {
> +               buf = realloc(buf, size);
> +               if (!buf) {
> +                       pr_err("failed to allocate memory to read event\n");
> +                       goto out_err;
> +               }
> +               cur_size = size;
> +               event = buf;
> +       }
> +       p = event;
>        p += sizeof(struct perf_event_header);
>
>        if (size - sizeof(struct perf_event_header)) {
> @@ -1015,9 +1031,9 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
>                }
>        }
>
> -       if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
> +       if ((skip = perf_session__process_event(self, event, tool, head)) < 0) {
>                dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
> -                           head, event.header.size, event.header.type);
> +                           head, event->header.size, event->header.type);
>                /*
>                 * assume we lost track of the stream, check alignment, and
>                 * increment a single u64 in the hope to catch on again 'soon'.
> @@ -1038,6 +1054,7 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
>  done:
>        err = 0;
>  out_err:
> +       free(buf);
>        perf_session__warn_about_errors(self, tool);
>        perf_session_free_sample_buffers(self);
>        return err;
