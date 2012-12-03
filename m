Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2LCBQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:16:06 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52816 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2LCBQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:16:05 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-81-50bbfd521a77
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 04/18] perf header: Add HEADER_GROUP_DESC feature
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	<1354171126-14387-6-git-send-email-namhyung@kernel.org>
	<20121129184304.GB1957@ghostprotocols.net>
Date: Mon, 03 Dec 2012 10:16:00 +0900
In-Reply-To: <20121129184304.GB1957@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 29 Nov 2012 15:43:04 -0300")
Message-ID: <87wqx0x7e7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 15:43:04 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Nov 29, 2012 at 03:38:32PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Save group relationship information so that it can be restored when
>> perf report is running.
>> 
[snip]
>> +static int write_group_desc(int fd, struct perf_header *h __maybe_unused,
>> +			    struct perf_evlist *evlist)
>> +{
>> +	u32 nr_groups = evlist->nr_groups;
>> +	struct perf_evsel *evsel;
>> +
>> +	do_write(fd, &nr_groups, sizeof(nr_groups));
>> +
>> +	list_for_each_entry(evsel, &evlist->entries, node) {
>> +		if (perf_evsel__is_group_leader(evsel) &&
>> +		    evsel->nr_members > 1) {
>> +			const char *name = evsel->group_name ?: "{anon_group}";
>> +			u32 leader_idx = evsel->idx;
>> +			u32 nr_members = evsel->nr_members;
>> +
>> +			do_write_string(fd, name);
>> +			do_write(fd, &leader_idx, sizeof(leader_idx));
>> +			do_write(fd, &nr_members, sizeof(nr_members));
>
> You need to check do_write() return, it can fail. There are some cases
> in header.c that don't check it, those should be eventually fixed, most
> cases check it tho.

Okay.

>
>> +		}
>> +	}
>> +	return 0;
>> +}
[snip]
>> +static int process_group_desc(struct perf_file_section *section __maybe_unused,
>> +			      struct perf_header *ph, int fd,
>> +			      void *data __maybe_unused)
>> +{
>> +	size_t ret = -1;
>> +	u32 i, nr, nr_groups;
>> +	struct perf_session *session;
>> +	struct perf_evsel *evsel, *leader = NULL;
>> +	struct group_desc {
>> +		char *name;
>> +		u32 leader_idx;
>> +		u32 nr_members;
>> +	} *desc;
>> +
>> +	if (read(fd, &nr_groups, sizeof(nr_groups)) != sizeof(nr_groups))
>
> Please use readn() instead in all read() cases in this function.

Will do.

Thanks,
Namhyung
