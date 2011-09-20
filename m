Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1ITTXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:23:22 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46187 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1ITTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:23:21 -0400
Message-ID: <4E78E824.4080209@gmail.com>
Date: Tue, 20 Sep 2011 13:23:16 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, acme@redhat.com,
        mingo@elte.hu
Subject: Re: [PATCH] perf: fix perf.data endianness detection
References: <20110919095620.GA9607@quad> <4E78E2A9.6060706@gmail.com> <CABPqkBRDhKUZf0FvShGbQWoPPAWAHA+XbUUqxDY+M1J9_gDiuQ@mail.gmail.com>
In-Reply-To: <CABPqkBRDhKUZf0FvShGbQWoPPAWAHA+XbUUqxDY+M1J9_gDiuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 01:02 PM, Stephane Eranian wrote:
>>> +static int check_magic_endian(u64 *magic, struct perf_file_header *header,
>>> +                           struct perf_header *ph)
>>> +{
>>> +     int ret;
>>> +
>>> +     /* check for legacy format */
>>> +     ret = memcmp(magic, __perf_magic1, sizeof(*magic));
>>> +     if (ret == 0) {
>>> +             pr_debug("legacy perf.data format\n");
>>> +             if (!header)
>>> +                     return -1;
>>> +
>>> +             if (header->attr_size != sizeof(struct perf_file_attr)) {
>>> +                     u64 attr_size = bswap_64(header->attr_size);
>>> +
>>> +                     if (attr_size != sizeof(struct perf_file_attr))
>>> +                             return -1;
>>> +
>>> +                     mem_bswap_64(header, offsetof(struct perf_file_header,
>>> +                                             adds_features));
>>> +                     ph->needs_swap = true;
>>> +             }
>>> +             return 0;
>>> +     }
>>> +
>>> +     /* check for our magic (same endianness) */
>>> +     if (*magic == __perf_magic2)
>>> +             return 0;
>>> +
>>> +     /* check for our magic (opposite endianness) */
>>> +     if (*magic != __perf_magic2_sw)
>>> +             return -1;
>>> +
>>> +     ph->needs_swap = true;

-->  goes here too
|
|

>>> +
>>> +     return 0;
>>> +}
>>> +
>>>  int perf_file_header__read(struct perf_file_header *header,
>>>                          struct perf_header *ph, int fd)
>>>  {
>>> +     int ret;
>>> +
>>>       lseek(fd, 0, SEEK_SET);
>>>
>>> -     if (readn(fd, header, sizeof(*header)) <= 0 ||
>>> -         memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
>>> +     ret = readn(fd, header, sizeof(*header));
>>> +     if (ret <= 0)
>>>               return -1;
>>>
>>> -     if (header->attr_size != sizeof(struct perf_file_attr)) {
>>> -             u64 attr_size = bswap_64(header->attr_size);
>>> -
>>> -             if (attr_size != sizeof(struct perf_file_attr))
>>> -                     return -1;
>>> -
>>> -             mem_bswap_64(header, offsetof(struct perf_file_header,
>>> -                                         adds_features));

|
|---- the mem_bswap_64()


