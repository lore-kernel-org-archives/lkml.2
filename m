Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2BGPuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:50:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64922 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2BGPue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <4F3051E3.5050402@gmail.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
	<1328187288-24395-17-git-send-email-eranian@google.com>
	<4F3051E3.5050402@gmail.com>
Date: Tue, 7 Feb 2012 16:50:32 +0100
Message-ID: <CABPqkBSYwwQpfxj3daHF_YHfJWLUT-Pfd03_7_jtrBkO4kM2ag@mail.gmail.com>
Subject: Re: [PATCH v5 16/18] perf: enable reading of perf.data files from
 different ABI rev
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 11:19 PM, David Ahern <dsahern@gmail.com> wrote:
>
>
> On 02/02/2012 05:54 AM, Stephane Eranian wrote:
>> This patch allows perf to process perf.data files generated
>> using an ABI that has a different perf_event_attr struct size, i.e.,
>> a different ABI version.
>>
>> The perf_event_attr can be extended, yet perf needs to cope with
>> older perf.data files. Similarly, perf must be able to cope with
>> a perf.data file which is using a newer version of the ABI than
>> what it knows about.
>>
>> This patch adds read_attr(), a routine that reads a perf_event_attr
>> struct from a file incrementally based on its advertised size. If
>> the on-file struct is smaller than what perf knows, then the extra
>> fields are zeroed. If the on-file struct is bigger, then perf only
>> uses what it knows about, the rest is skipped.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  tools/perf/util/header.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 47 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
>> index 6f4187d..8d6c18d 100644
>> --- a/tools/perf/util/header.c
>> +++ b/tools/perf/util/header.c
>> @@ -1959,6 +1959,51 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
>>       return 0;
>>  }
>>
>> +static int read_attr(int fd, struct perf_header *ph,
>> +                  struct perf_file_attr *f_attr)
>> +{
>> +     struct perf_event_attr *attr = &f_attr->attr;
>> +     size_t sz, left;
>> +     size_t our_sz = sizeof(f_attr->attr);
>> +     int ret;
>> +
>> +     memset(f_attr, 0, sizeof(*f_attr));
>> +
>> +     /* read minimal guaranteed structure */
>> +     ret = readn(fd, attr, PERF_ATTR_SIZE_VER0);
>> +     if (ret <= 0)
>> +             return -1;
>
> As I recall the first bump in that structure happened in 2.6.32. Why add
> backward compatibility for it now? ie., why not just expect VER1
>
>> +
>> +     /* on file perf_event_attr size */
>> +     sz = attr->size;
>> +     if (ph->needs_swap)
>> +             sz = bswap_32(sz);
>> +
>> +     if (sz == 0) {
>> +             /* assume ABI0 */
>> +             sz =  PERF_ATTR_SIZE_VER0;
>
> Shouldn't this be a failure? ie., problem with the file (or the
> swapping) since size can't be 0
>
size can be zero. In which case, it means ABI0 version.
See kernel/event/core.c:perf_copy_attr().


> And then for the following why not restrict sz to known, expected sizes
> -- using the PERF_ATTR_SIZE_VER defines introduced in patch 15?
>
Well, the current code solves the problem once and for all. Old tools
can still read new files and vice-versa. If you think that's a problem I
can simply bail out if sz > our_sz.

>> +     } else if (sz > our_sz) {
>> +             /* bigger than what we know about */
>> +             sz = our_sz;
>> +
>> +             /* skip what we do not know about */
>> +             lseek(fd, SEEK_CUR, attr->size - our_sz);
>> +     }
>> +     /* what we have not yet read and that we know about */
>> +     left = sz - PERF_ATTR_SIZE_VER0;
>> +     if (left) {
>> +             void *ptr = attr;
>> +             ptr += PERF_ATTR_SIZE_VER0;
>> +
>> +             ret = readn(fd, ptr, left);
>> +             if (ret <= 0)
>> +                     return -1;
>> +     }
>> +     /* read the ids */
>> +     ret = readn(fd, &f_attr->ids, sizeof(struct perf_file_section));
>
> Confused by the above? It is not done in the old code, so why read the
> ids here? I scanned the other patches, but don't see other code movement
> on this file.
>
Good catch. It is leftover code from debugging most likely. The ids are read
later on in perf_session__read_header().

> David
>
>> +     return ret <= 0 ? -1 : 0;
>> +}
>> +
>>  int perf_session__read_header(struct perf_session *session, int fd)
>>  {
>>       struct perf_header *header = &session->header;
>> @@ -1979,14 +2024,14 @@ int perf_session__read_header(struct perf_session *session, int fd)
>>               return -EINVAL;
>>       }
>>
>> -     nr_attrs = f_header.attrs.size / sizeof(f_attr);
>> +     nr_attrs = f_header.attrs.size / f_header.attr_size;
>>       lseek(fd, f_header.attrs.offset, SEEK_SET);
>>
>>       for (i = 0; i < nr_attrs; i++) {
>>               struct perf_evsel *evsel;
>>               off_t tmp;
>>
>> -             if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
>> +             if (read_attr(fd, header, &f_attr) < 0)
>>                       goto out_errno;
>>
>>               if (header->needs_swap)
