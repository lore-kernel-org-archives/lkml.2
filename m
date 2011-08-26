Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1HZSDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:03:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1HZSDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:03:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=k5gaCzLjxknTWopmDjH6mFu3DBq8vt1N3gcrzo+lyvdqneczqr/o5tJN5j6Bc+sig
	eJU9QnJJ333CejDH3MPOg==
MIME-Version: 1.0
In-Reply-To: <4E57CA80.4070509@gmail.com>
References: <20110826152256.GA9421@quad>
	<4E57CA80.4070509@gmail.com>
Date: Fri, 26 Aug 2011 20:02:57 +0200
Message-ID: <CABPqkBTDG_DcJTPpB-126HyuT8yR+w_JOssN=ix0rAP3tjzpuw@mail.gmail.com>
Subject: Re: [PATCH] perf: collect multiplexing timing information in perf record
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 6:32 PM, David Ahern <dsahern@gmail.com> wrote:
>
>
> On 08/26/2011 09:22 AM, Stephane Eranian wrote:
>>
>> This patch modifies perf record to collect multiplexing timing
>> information (time_enabled, time_running) when the -R (raw) option
>> is used.
>>
>> This allows you to compare events captured on a single run and
>> compute multi-event metrics. Further it allows you to compare
>> measurements between different runs where the number of collected
>> events has changed and across different architectures where the
>> event count will surely change.
>>
>> To normalize an event (assuming a fixed period), you do:
>>  total_events = n_samples * period * time_enabled / time_running
>>
>> You need the timing information to compensate for multiplexing
>> which may have happened.
>>
>> To add timing information in each sample, it is necessary to
>> set PERF_SAMPLE_READ as per the kernel API. That has the side
>> effect of also storing the value of the sampling event in each
>> sample. This patch modifies perf report to correctly parse
>> such samples.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> ---
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index 6b0519f..c54e580 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -166,7 +166,7 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
>>                                 PERF_FORMAT_TOTAL_TIME_RUNNING |
>>                                 PERF_FORMAT_ID;
>>
>> -     attr->sample_type       |= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
>> +     attr->sample_type |= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
>>
>>       if (evlist->nr_entries > 1)
>>               attr->sample_type |= PERF_SAMPLE_ID;
>> @@ -211,6 +211,7 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
>>               attr->sample_type       |= PERF_SAMPLE_TIME;
>>               attr->sample_type       |= PERF_SAMPLE_RAW;
>>               attr->sample_type       |= PERF_SAMPLE_CPU;
>> +             attr->sample_type       |= PERF_SAMPLE_ID | PERF_SAMPLE_READ;
>>       }
>>
>>       if (nodelay) {
>> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
>> index 55f4c76..997b7d7 100644
>> --- a/tools/perf/builtin-test.c
>> +++ b/tools/perf/builtin-test.c
>> @@ -561,7 +561,7 @@ static int test__basic_mmap(void)
>>               }
>>
>>               err = perf_event__parse_sample(event, attr.sample_type, sample_size,
>> -                                            false, &sample);
>> +                                            false, 0, &sample);
>>               if (err) {
>>                       pr_err("Can't parse sample, err = %d\n", err);
>>                       goto out_munmap;
>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>> index 1d7f664..ed193eb 100644
>> --- a/tools/perf/util/event.h
>> +++ b/tools/perf/util/event.h
>> @@ -186,6 +186,6 @@ const char *perf_event__name(unsigned int id);
>>
>>  int perf_event__parse_sample(const union perf_event *event, u64 type,
>>                            int sample_size, bool sample_id_all,
>> -                          struct perf_sample *sample);
>> +                          u64 read_format, struct perf_sample *sample);
>>
>>  #endif /* __PERF_RECORD_H */
>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>> index c12bd47..be0e30c 100644
>> --- a/tools/perf/util/evlist.c
>> +++ b/tools/perf/util/evlist.c
>> @@ -477,6 +477,14 @@ int perf_evlist__set_filters(struct perf_evlist *evlist)
>>       return 0;
>>  }
>>
>> +u64 perf_evlist__read_format(const struct perf_evlist *evlist)
>> +{
>> +     struct perf_evsel *first;
>> +
>> +     first = list_entry(evlist->entries.next, struct perf_evsel, node);
>> +     return first->attr.read_format;
>> +}
>> +
>>  bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
>>  {
>>       struct perf_evsel *pos, *first;
>> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
>> index ce85ae9..0c0d0ff 100644
>> --- a/tools/perf/util/evlist.h
>> +++ b/tools/perf/util/evlist.h
>> @@ -68,6 +68,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
>>  void perf_evlist__delete_maps(struct perf_evlist *evlist);
>>  int perf_evlist__set_filters(struct perf_evlist *evlist);
>>
>> +u64 perf_evlist__read_format(const struct perf_evlist *evlist);
>>  u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
>>  bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
>>
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index a03a36b..630a7da 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -340,9 +340,32 @@ static bool sample_overlap(const union perf_event *event,
>>       return false;
>>  }
>>
>> +static int
>> +sample_read2u64(const u64 *array, u64 fmt)
>> +{
>> +     u64 nr = 1;
>> +     int ret = 1; /* nr or value */
>> +
>> +     if (fmt & PERF_FORMAT_TOTAL_TIME_ENABLED)
>> +             ret++;
>> +
>> +     if (fmt & PERF_FORMAT_TOTAL_TIME_RUNNING)
>> +             ret++;
>> +
>> +     if (fmt & PERF_FORMAT_GROUP) {
>> +             nr = *(u64 *)array;
>> +             ret += nr;
>> +     }
>> +
>> +     if (fmt & PERF_FORMAT_ID)
>> +             ret += nr;
>
> Why not add
> struct read_format {
>        u64     value;
>        u64     time_enabled;
>        u64     time_running;
>        u64     id;
> };
>
> to perf_sample and save the data there?
>
I am not following you here.
Are you talking about the kernel API or perf tool internals?

The only way to have timing saved in each sample is via
PERF_SAMPLE_READ and a read_format which includes
time_enabled + time_running.

> David
>
>> +
>> +     return ret;
>> +}
>> +
>>  int perf_event__parse_sample(const union perf_event *event, u64 type,
>>                            int sample_size, bool sample_id_all,
>> -                          struct perf_sample *data)
>> +                          u64 read_format,struct perf_sample *data)
>>  {
>>       const u64 *array;
>>
>> @@ -405,10 +428,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>>               array++;
>>       }
>>
>> -     if (type & PERF_SAMPLE_READ) {
>> -             fprintf(stderr, "PERF_SAMPLE_READ is unsuported for now\n");
>> -             return -1;
>> -     }
>> +     if (type & PERF_SAMPLE_READ)
>> +             array += sample_read2u64(array, read_format);
>>
>>       if (type & PERF_SAMPLE_CALLCHAIN) {
>>               if (sample_overlap(event, array, sizeof(data->callchain->nr)))
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 72458d9..25a4cf9 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -108,6 +108,7 @@ out:
>>  void perf_session__update_sample_type(struct perf_session *self)
>>  {
>>       self->sample_type = perf_evlist__sample_type(self->evlist);
>> +     self->read_format = perf_evlist__read_format(self->evlist);
>>       self->sample_size = __perf_evsel__sample_size(self->sample_type);
>>       self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
>>       perf_session__id_header_size(self);
>> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
>> index 170601e..903fc1a 100644
>> --- a/tools/perf/util/session.h
>> +++ b/tools/perf/util/session.h
>> @@ -42,7 +42,8 @@ struct perf_session {
>>        *        perf.data file.
>>        */
>>       struct hists            hists;
>> -     u64                     sample_type;
>> +     u64                     sample_type; /* identical for all events */
>> +     u64                     read_format; /* identical for all events */
>>       int                     sample_size;
>>       int                     fd;
>>       bool                    fd_pipe;
>> @@ -162,7 +163,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
>>  {
>>       return perf_event__parse_sample(event, session->sample_type,
>>                                       session->sample_size,
>> -                                     session->sample_id_all, sample);
>> +                                     session->sample_id_all,
>> +                                     session->read_format,
>> +                                     sample);
>>  }
>>
>>  struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
