Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1IPOu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:50:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54395 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1IPOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:50:25 -0400
Message-ID: <4E73622D.5010506@gmail.com>
Date: Fri, 16 Sep 2011 08:50:21 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
References: <20110907191045.GA13475@quad> <4E6E0D0B.3080306@gmail.com> <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com> <4E6E181E.9080506@gmail.com> <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com> <1315838611.26517.51.camel@twins> <CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
In-Reply-To: <CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 08:35 AM, Stephane Eranian wrote:
> On Mon, Sep 12, 2011 at 4:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Mon, 2011-09-12 at 16:40 +0200, Stephane Eranian wrote:
>>> I don't think this should be the test to detect endianess.
>>
>> You should be able to tell the endianness from the PERF_MAGIC string, it
>> stores the string as a u64, so depending on endianness it reads back as
>> either: PERFFILE or ELIFFREP or whatever the bswap64 result is.
>>
> 
> I believe in big endian, if you do od -c perf.data | head -1, you also see:
> 
> 0000000   P   E   R   F   F   I   L   E   h  \0  \0  \0  \0  \0  \0  \0
> 
> static const char *__perf_magic = "PERFFILE";
> #define PERF_MAGIC      (*(u64 *)__perf_magic)
> 
> u64 hm = PERF_MAGIC;
> 
> The layout in memory is the same for both little-endian and
> big-endian. Thus the layout on the file is the same.
> 
> When you look at the memory as u64, then things are different:
> In little-endian, hm=0x454c494646524550
> in big-endian,   hm=0x5045524646494c45
> 
> In big-endian, the MSB 0x50 ('P') ends up at the lowest memory address.
> In little-endian, the LSB 0x50 ('P') ends up at the lowest memory address.
> 
> Thus, I suspect we need to write in the file a different MAGIC for big vs.
> little endian.
> 
> David, can you confirm this?

on x86:
$  od -c perf.data | head -1
0000000   P   E   R   F   F   I   L   E   h  \0  \0  \0  \0  \0  \0  \0

on PPC:
# od -c perf.data | head -1
0000000   P   E   R   F   F   I   L   E  \0  \0  \0  \0  \0  \0  \0   h

And then PPC file on x86:
$ od -c perf-ppc.data | head -1
0000000   P   E   R   F   F   I   L   E  \0  \0  \0  \0  \0  \0  \0   h

So it is the same and that explains why the current code is:

    if (readn(fd, header, sizeof(*header)) <= 0 ||
        memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
        return -1;

versus a u64 comparison. Printing magic as a PRIx64 running the command
on x86:

ppc data file: header->magic 454c494646524550
x86 data file: header->magic 454c494646524550

Which is expected given the od -c output above.

David
