Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1K2Sf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:35:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37937 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab1K2Sf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:35:26 -0500
MIME-Version: 1.0
In-Reply-To: <20111129182231.GZ15738@erda.amd.com>
References: <20110930134040.GA5575@quad>
	<20111129182231.GZ15738@erda.amd.com>
Date: Tue, 29 Nov 2011 10:35:24 -0800
Message-ID: <CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "acme@redhat.com" <acme@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

On Tue, Nov 29, 2011 at 10:22 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 30.09.11 09:40:40, Stephane Eranian wrote:
>> @@ -385,36 +1433,69 @@ static int perf_header__adds_write(struct perf_header *header,
>>         sec_start = header->data_offset + header->data_size;
>>         lseek(fd, sec_start + sec_size, SEEK_SET);
>>
>> -       if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
>> -               struct perf_file_section *trace_sec;
>> -
>> -               trace_sec = &feat_sec[idx++];
>> +       err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
>> +       if (err)
>> +               goto out_free;
>>
>> -               /* Write trace info */
>> -               trace_sec->offset = lseek(fd, 0, SEEK_CUR);
>> -               read_tracing_data(fd, &evlist->entries);
>> -               trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
>> +       err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
>> +       if (err) {
>> +               perf_header__clear_feat(header, HEADER_BUILD_ID);
>> +               goto out_free;
>>         }
>
> Stephane,
>
> I am just looking at the code and got a question:
>
> Is there a reason for the different error handling for
> HEADER_TRACE_INFO and HEADER_BUILD_ID? All other types simply disable
> the feature and go on without returning an error (goto out_free).
>
You're looking at an old version of that code. I fixed that later on.
If you look in tip
you'll see that TRACE_INFO  follows the same logic.

        sec_start = header->data_offset + header->data_size;
        lseek(fd, sec_start + sec_size, SEEK_SET);

        err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
        if (err)
                goto out_free;

        err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
        if (err) {
                perf_header__clear_feat(header, HEADER_BUILD_ID);
                goto out_free;
        }

The 'clear_feat' is missing for TRACE_INFO, that's all. The question is:
is case do_write_feat(trace_info) fails, is there still a way to parse the file
correctly? If not, then perf should bail out, if yes, then we need to add the
clear_feat(TRACE_INFO) in case of error.
