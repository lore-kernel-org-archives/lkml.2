Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab2BIWrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:47:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43821 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab2BIWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:46:59 -0500
Message-ID: <4F344CDF.8060206@gmail.com>
Date: Thu, 09 Feb 2012 15:46:55 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v6 16/18] perf: enable reading of perf.data files from
 different ABI rev
References: <1328826068-11713-1-git-send-email-eranian@google.com> <1328826068-11713-17-git-send-email-eranian@google.com> <4F344B0C.8060203@gmail.com> <CABPqkBQZFT=GHNg8nNagrAtf+dy4vFzCzp1t1nmpv6HWBEEoLg@mail.gmail.com>
In-Reply-To: <CABPqkBQZFT=GHNg8nNagrAtf+dy4vFzCzp1t1nmpv6HWBEEoLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/2012 03:41 PM, Stephane Eranian wrote:
>>> +     /* read perf_file_section, ids are read in caller */
>>> +     ret = readn(fd, &f_attr->ids, sizeof(f_attr->ids));
>>
>> I thought the above 2 lines were to be removed.
>>
> 
> No, They are needed to get the offsets of the ids[] table.
> The field name are confusing. This is not reading the ids[],
> but just the offset of where the table is. Without that you
> get bogus offsets. I ran into that bug during testing...

Hmm.... ok, so the perf_file_attr is now read in back to back reads --
attr then ids -- versus today where it gets both in one readn.


> 
> 
>> David
>>
>>
>>> +
>>> +     return ret <= 0 ? -1 : 0;
>>> +}
>>> +
>>>  int perf_session__read_header(struct perf_session *session, int fd)
>>>  {
>>>       struct perf_header *header = &session->header;
>>> @@ -1974,19 +2019,17 @@ int perf_session__read_header(struct perf_session *session, int fd)
>>>       if (session->fd_pipe)
>>>               return perf_header__read_pipe(session, fd);
>>>
>>> -     if (perf_file_header__read(&f_header, header, fd) < 0) {
>>> -             pr_debug("incompatible file format\n");
>>> +     if (perf_file_header__read(&f_header, header, fd) < 0)
>>>               return -EINVAL;
>>> -     }
>>>
>>> -     nr_attrs = f_header.attrs.size / sizeof(f_attr);
>>> +     nr_attrs = f_header.attrs.size / f_header.attr_size;
>>>       lseek(fd, f_header.attrs.offset, SEEK_SET);
>>>
>>>       for (i = 0; i < nr_attrs; i++) {
>>>               struct perf_evsel *evsel;
>>>               off_t tmp;
>>>
>>> -             if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
>>> +             if (read_attr(fd, header, &f_attr) < 0)
>>>                       goto out_errno;
>>>
>>>               if (header->needs_swap)
>>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>>> index 3f3afed..5476320 100644
>>> --- a/tools/perf/util/session.c
>>> +++ b/tools/perf/util/session.c
>>> @@ -24,7 +24,7 @@ static int perf_session__open(struct perf_session *self, bool force)
>>>               self->fd = STDIN_FILENO;
>>>
>>>               if (perf_session__read_header(self, self->fd) < 0)
>>> -                     pr_err("incompatible file format");
>>> +                     pr_err("incompatible file format (rerun with -v to learn more)");
>>>
>>>               return 0;
>>>       }
>>> @@ -56,7 +56,7 @@ static int perf_session__open(struct perf_session *self, bool force)
>>>       }
>>>
>>>       if (perf_session__read_header(self, self->fd) < 0) {
>>> -             pr_err("incompatible file format");
>>> +             pr_err("incompatible file format (rerun with -v to learn more)");
>>>               goto out_close;
>>>       }
>>>
