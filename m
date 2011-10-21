Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1JUOm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 10:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab1JUOm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 10:42:26 -0400
Date: Fri, 21 Oct 2011 16:42:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: "Xu, Anhua" <anhua.xu@intel.com>, "acme@redhat.com" <acme@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Message-ID: <20111021144208.GF2033@jolsa.brq.redhat.com>
References: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
 <1A42CE6F5F474C41B63392A5F80372B212DCA02CB2@shsmsx501.ccr.corp.intel.com>
 <20111021081024.GA2033@jolsa.brq.redhat.com>
 <4EA17EAE.8040905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA17EAE.8040905@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 08:16:14AM -0600, David Ahern wrote:
> 
> 
> On 10/21/2011 02:10 AM, Jiri Olsa wrote:
> > On Fri, Oct 21, 2011 at 03:18:31PM +0800, Xu, Anhua wrote:
> >> I installed the latest kernel and found without such patch( not sure if other patches were added besides this one). That following command works fine.
> >> perf record -o perf.data -e ext3:ext3_request_inode -e LLC-loads -- date '+%F'
> > hi,
> > was there any ext3 event stored? The issue should be hit when
> > processing stored events.. either in the atexit code or during
> > report.
> > 
> > Following command freezes for me on 3.1.0-rc10-tip+:
> > ./perf record -o perf.data -e ext4:ext4_request_inode -e LLC-loads -- date '+%F'
> > 
> 
> With -B and it doesn't for me. Without the -B argument the backtrace
> shows it stuck here:

yep, it get's stuck in processig build ids.

All the events are traversed and processing fails with event which does
not support configured sample_type.. the event is skipped, but with no
idea about the actual event length (not sure about the details right now),
thus screwing processing of following events.. ending up in infinite loop ;)

jirka

> 
> #0  0x0000000000460d91 in fetch_mmaped_event (session=0x13dd510,
> head=3464, mmap_size=21112,
>     buf=0x7fbd1d016000 "") at util/session.c:988
> #1  0x0000000000461074 in __perf_session__process_events
> (session=0x13dd510, data_offset=456,
>     data_size=20656, file_size=21112, ops=0x77ad40) at util/session.c:1063
> #2  0x000000000041dcc4 in process_buildids () at builtin-record.c:377
> #3  0x000000000041dd2e in atexit_header () at builtin-record.c:388
> #4  0x0000003e96e38991 in __run_exit_handlers () from /lib64/libc.so.6
> #5  0x0000003e96e38a15 in exit () from /lib64/libc.so.6
> #6  0x00000000004126f8 in handle_internal_command (argc=11,
> argv=0x7fffade3f3d0) at perf.c:358
> #7  0x000000000041283d in run_argv (argcp=0x7fffade3f2bc,
> argv=0x7fffade3f2b0) at perf.c:402
> #8  0x0000000000412b24 in main (argc=11, argv=0x7fffade3f3d0) at perf.c:512
> 
> 
> It's stuck in a loop on this:
> remap:
> 	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, session->fd,
> 		   file_offset);
> 	if (buf == MAP_FAILED) {
> 		pr_err("failed to mmap file\n");
> 		err = -errno;
> 		goto out_err;
> 	}
> 	mmaps[map_idx] = buf;
> 	map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
> 	file_pos = file_offset + head;
> 
> more:
> 	event = fetch_mmaped_event(session, head, mmap_size, buf);
> 	if (!event) {
> 		if (mmaps[map_idx]) {
> 			munmap(mmaps[map_idx], mmap_size);
> 			mmaps[map_idx] = NULL;
> 		}
> 
> 		page_offset = page_size * (head / page_size);
> 		file_offset += page_offset;
> 		head -= page_offset;
> 		goto remap;
> 	}
> 
> head < page_size, page_offset stays 0.
> 
> David
> 
> 
> > 
> > wbr,
> > jirka
> > 
> >>
> >> -----Original Message-----
> >> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jiri Olsa
> >> Sent: Friday, September 30, 2011 12:01 AM
> >> To: acme@redhat.com; a.p.zijlstra@chello.nl; mingo@elte.hu; paulus@samba.org
> >> Cc: linux-kernel@vger.kernel.org; Jiri Olsa
> >> Subject: [PATCH] perf tools: Exit recording if events have non matching sample type
> >>
> >> The event processing relies on all events having the same sample_type.
> >>
> >> This is being checked when the session is being opened read only.
> >> It also needs to be checked when we do record, since events could be
> >> read during processing build IDs at the end of the record command.
> >>
> >> If we process events with different sample_type the processing might
> >> skip some events or hang.
> >>
> >> Following command hangs on my setup:
> >>   ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
> >>    -e LLC-loads -- date '+%F'
> >>
> >> because hardware and tracepoint events have different sample type.
> >>
> >> With the patch applied the record command displays
> >> "Non matching sample_type" message and exits.
> >>
> >> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> >> ---
> >>  tools/perf/builtin-record.c |    6 ++++++
> >>  1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> >> index f4c3fbe..71e2c4e 100644
> >> --- a/tools/perf/builtin-record.c
> >> +++ b/tools/perf/builtin-record.c
> >> @@ -832,6 +832,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
> >>  		goto out_symbol_exit;
> >>  	}
> >>  
> >> +	if (!perf_evlist__valid_sample_type(evsel_list)) {
> >> +		pr_err("Non matching sample_type\n");
> >> +		err = -EINVAL;
> >> +		goto out_symbol_exit;
> >> +	}
> >> +
> >>  	if (target_pid != -1)
> >>  		target_tid = target_pid;
> >>  
> >> -- 
> >> 1.7.4
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
