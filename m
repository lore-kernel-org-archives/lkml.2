Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0IIOlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0IIOl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:41:29 -0400
Date: Thu, 9 Sep 2010 11:41:06 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf events over (net) console?
Message-ID: <20100909144106.GC4155@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909132057.GA5259@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 09, 2010 at 03:21:00PM +0200, Frederic Weisbecker escreveu:
> In the beginning this could wrap into perf record - | perf pipe | netcat
> and so, until we get the splice support.

Isn't this what Tom Zanussi's live mode, that we have already special
casing 'perf record -' does?

Look at these tools/perf/builtin-record.c excerpts:

static int __cmd_record(int argc, const char **argv)
{
<SNIP>
        if (!strcmp(output_name, "-"))
                pipe_output = 1;
<SNIP>
        if (pipe_output)
                output = STDOUT_FILENO;
        else
                output = open(output_name, flags, S_IRUSR | S_IWUSR);
<SNIP>
	if (pipe_output) {
                err = perf_header__write_pipe(output);
<SNIP>
        if (pipe_output) {
                err = event__synthesize_attrs(&session->header,
                                              process_synthesized_event,
                                              session)
<SNIP>
}

Harald, can you please take a look at the comment for these commits:

commit 454c407ec17a0c63e4023ac0877d687945a7df4a
Author: Tom Zanussi <tzanussi@gmail.com>
Date:   Sat May 1 01:41:20 2010 -0500

    perf: add perf-inject builtin

commit 529870e37473a9fc609078f03cc5b4148cf06a87
Author: Tom Zanussi <tzanussi@gmail.com>
Date:   Thu Apr 1 23:59:16 2010 -0500

    perf record: Introduce special handling for pipe output

commit 8dc58101f2c838355d44402aa77646649d10dbec
Author: Tom Zanussi <tzanussi@gmail.com>
Date:   Thu Apr 1 23:59:15 2010 -0500

    perf: Add pipe-specific header read/write and event processing code

Using live mode you can stream to a perf.data for later analisys or do
it live, piping it to trace scripts, etc.

Doing it using splice, talking directly to an in kernel mini-server, etc
are all optimizations that we should think about, but if you can try
using the live mode and see if it is ok, that would be good.

A mini binary with just record can come in handy if you like and should
be rather easy to build, please let me know if you think it is a good
idea and if you need help, lemme know.

- Arnaldo
