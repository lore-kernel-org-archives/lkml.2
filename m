Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2EPCYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:24:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53748 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808Ab2EPCYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:24:47 -0400
Message-ID: <4FB30FEA.2080105@gmail.com>
Date: Tue, 15 May 2012 20:24:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com
Subject: Re: [PATCH v2 2/5] perf tools: fix piped mode read code
References: <1337081295-10303-1-git-send-email-eranian@google.com> <1337081295-10303-3-git-send-email-eranian@google.com>
In-Reply-To: <1337081295-10303-3-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/12 5:28 AM, Stephane Eranian wrote:
> In __perf_session__process_pipe_events(), there was a risk
> we would read more than what a union perf_event struct can
> hold. this could happen in case, perf is reading a file which
> contains new record types it does not know about and which are
> larger than anything it knows about.
>
> In general, perf is supposed to skip records it does not
> understand, but in pipe mode, those have to be read and ignored.
> The fixed size header contains the size of the record, but that
> size may be larger than union perf_event, yet it was used as
> the backing to the read in:
>
>    union perf_event event;
>    void *p;
>
>    size = event->header.size;
>
>    p =&event;
>    p += sizeof(struct perf_event_header);
>    if (size - sizeof(struct perf_event_header)) {
>      err = readn(self->fd, p, size - sizeof(struct perf_event_header));
>
> We fix this by allocating a buffer based on the size reported in
> the header. We reuse the buffer as much as we can. We realloc in
> case it becomes too small. In the  common case, the performance
> impact is negligible.
>
> Signed-off-by: Stephane Eranian<eranian@google.com>
> ---
>   tools/perf/util/session.c |   34 ++++++++++++++++++++++++++--------
>   1 files changed, 26 insertions(+), 8 deletions(-)
>

I don't have a file/perf with different sized events, but the change 
makes sense.

Reviewed-and-tested-by: David Ahern <dsahern@gmail.com>

