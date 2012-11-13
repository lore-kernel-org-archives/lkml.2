Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2KMBvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:51:17 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52681 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2KMBvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:51:16 -0500
X-AuditID: 9c93016f-b7b42ae000004383-c7-50a1a79269ee
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/12] perf header: Add HEADER_GROUP_DESC feature
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
	<1352479414-2324-3-git-send-email-namhyung@kernel.org>
	<20121112174534.GF18978@ghostprotocols.net>
Date: Tue, 13 Nov 2012 10:51:14 +0900
In-Reply-To: <20121112174534.GF18978@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 12 Nov 2012 14:45:34 -0300")
Message-ID: <87lie6mfsd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 14:45:34 -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Nov 10, 2012 at 01:43:24AM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Save group relationship information so that it can be restored when
>> perf report is running.
>> 
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Stephane Eranian <eranian@google.com>
>> Acked-by: Jiri Olsa <jolsa@redhat.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> <SNIP>
>   
>> +static int process_group_desc(struct perf_file_section *section __maybe_unused,
>> +			      struct perf_header *ph, int fd,
>> +			      void *data __maybe_unused)
>> +{
>> +	size_t ret = -1;
>
> why initialize ret if the first thing you do with it is...
>
>> +	u32 i, nr, nr_groups;
>> +	struct perf_session *session;
>> +	struct perf_evsel *evsel, *leader = NULL;
>> +	struct group_desc {
>> +		char *name;
>> +		u32 leader_idx;
>> +		u32 nr_members;
>> +	} *desc;
>> +
>> +	ret = read(fd, &nr_groups, sizeof(nr_groups));
>
> assign another value?
>
> We need to use readn instead of read, and not use ret here, just do
> 	if (read(fd, &nr_groups, sizeof(nr_groups)) != sizeof(nr_groups))

Will do.

>
>> +	if (ret != sizeof(nr_groups))
>> +		return -1;
>> +
>> +	if (ph->needs_swap)
>> +		nr_groups = bswap_32(nr_groups);
>> +
>> +	ph->env.nr_groups = nr_groups;
>> +	if (!nr_groups) {
>> +		pr_debug("group desc not available\n");
>> +		return 0;
>> +	}
>> +
>> +	desc = calloc(nr_groups, sizeof(*desc));
>> +	if (!desc)
>> +		return -1;
>> +
>> +	for (i = 0; i < nr_groups; i++) {
>> +		desc[i].name = do_read_string(fd, ph);
>> +		if (!desc[i].name)
>> +			goto out_free;
>> +
>> +		ret = read(fd, &desc[i].leader_idx, sizeof(u32));
>> +		if (ret != sizeof(u32))
>> +			goto out_free;
>
> ditto
>
>> +
>> +		ret = read(fd, &desc[i].nr_members, sizeof(u32));
>> +		if (ret != sizeof(u32))
>> +			goto out_free;
>
> ditto
>
>> +
>> +		if (ph->needs_swap) {
>> +			desc[i].leader_idx = bswap_32(desc[i].leader_idx);
>> +			desc[i].nr_members = bswap_32(desc[i].nr_members);
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Rebuild group relationship based on the group_desc
>> +	 */
>> +	session = container_of(ph, struct perf_session, header);
>> +	session->evlist->nr_groups = nr_groups;
>> +
>> +	i = nr = 0;
>> +	list_for_each_entry(evsel, &session->evlist->entries, node) {
>> +		if (evsel->idx == (int) desc[i].leader_idx) {
>> +			evsel->leader = NULL;
>
> Humm, isn't it better to set evsel->leader to evsel, that way all
> members in a group have its evsel->leader pointing to the leader and for
> things like the group idx we can do just:
>
> 		evsel->idx - evsel->leader->idx
>
> avoiding the need to special case the leader, will do that.

I just followed the existing behavior.  I'm open to changing it. :)

>
>> +			/* {anon_group} is a dummy name */
>> +			if (strcmp(desc[i].name, "{anon_group}"))
>> +				evsel->group_name = desc[i].name;
>> +			evsel->nr_members = desc[i].nr_members;
>> +
>> +			BUG_ON(i >= nr_groups);
>> +			BUG_ON(nr > 0);
>
> BUG_ON here is way too extreme, we should just bail out, testing and if
> the problem is found, goto out_free

Okay, it was there to help me debugging the code. Will change.

>
>> +			leader = evsel;
>> +			nr = evsel->nr_members;
>> +			i++;
>> +		} else if (nr) {
>
> Humm, do we really need to test against nr? Or even use nr at all?

The group descriptor misses leader-only groups intentionally.  In that
case I wanted to skip those events with nr == 0.

>
>> +			/* This is a group member */
>> +			evsel->leader = leader;
>> +			/* group_idx starts from 0 */
>> +			evsel->group_idx = leader->nr_members - nr;
>> +			nr--;
>> +		}
>> +	}
>> +
>> +	BUG_ON(i != nr_groups);
>> +	BUG_ON(nr != 0);
>
> Too extreme, goto out_free.
>
> And just before out_free we need to set ret = 0, otherwise we will
> return...

Right, will do.

>
>> +out_free:
>> +	while ((int) --i >= 0)
>> +		free(desc[i].name);
>> +	free(desc);
>
> here, whatever value was in ret, in this patch it will be, if all goes
> well, sizeof(u32) :-)
>
>> +	return ret;
>> +}
>> +
>>  struct feature_ops {
>>  	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
>>  	void (*print)(struct perf_header *h, int fd, FILE *fp);
>> @@ -1986,6 +2137,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
>>  	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
>>  	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
>>  	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
>> +	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
>>  };
>>  
>>  struct header_print_data {
>> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
>> index 5f1cd6884f37..e3e7fb490310 100644
>> --- a/tools/perf/util/header.h
>> +++ b/tools/perf/util/header.h
>> @@ -29,6 +29,7 @@ enum {
>>  	HEADER_NUMA_TOPOLOGY,
>>  	HEADER_BRANCH_STACK,
>>  	HEADER_PMU_MAPPINGS,
>> +	HEADER_GROUP_DESC,
>>  	HEADER_LAST_FEATURE,
>>  	HEADER_FEAT_BITS	= 256,
>>  };
>
> Here we're adding holes to the struct:
>
>> @@ -79,6 +80,7 @@ struct perf_session_env {
>>  	char			*numa_nodes;
>>  	int			nr_pmu_mappings;
>
> 4 byte hole
>
>>  	char			*pmu_mappings;
>
> 4 byte hole

Yes, I thought it's a in-memory struct for a session, so a couple of
holes doesn't matter much.  So I just wanted to keep the struct in a
consistent and straight-forward way.

>
>> +	int			nr_groups;
>
> I'm working on a patch implementing my suggestions.

Great!

Thanks,
Namhyung
