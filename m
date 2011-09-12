Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1ILOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:39:41 -0400
Received: from mail-gw0-f51.google.com ([74.125.83.51]:62838 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab1ILOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:39:40 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Sep 2011 10:39:40 EDT
Message-ID: <4E6E181E.9080506@gmail.com>
Date: Mon, 12 Sep 2011 08:33:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
References: <20110907191045.GA13475@quad> <4E6E0D0B.3080306@gmail.com> <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
In-Reply-To: <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/12/2011 07:54 AM, Stephane Eranian wrote:
>> The problem with endianness handling I mentioned last week is related to
>> the assumption that the HEADER_BUILD_ID is set. In my test case it is
>> not (-B flag on perf-record) and that causes the aborts. A problem for
>> another day which I can address it when I submit the patch to handle
>> swapping for the feature mask.
>>
> Ok, now I understand your point better.
> 
> The thing is that the endianess detection done by perf is currently broken.
> It assumes that if the size of perf_event_attr saved in the file (attr_size)
> does not match sizeof(perf_event_attr) then it must be because of endianess
> issues. The reality is that it they can be different because the the ABI
> has been extended (and I am sure it will), and this a perf tool may
> have a larger struct perf_event_attr, than an old perf.data file, yet it
> should be able to read it. We need to fix this issue now and not once
> we hit the problem with extended ABI. I have a couple of ideas on this
> and they revolve around using the magic prefix as the indicator of endianess
> (and also detect older perf.data files).

There is some handling of older perf data files. For example, data files
without the adds_features mask are handled -- see
perf_file_header__read(), if (header->size != sizeof(*header)) {}

The swapping of the adds_features mask is a mess because the mask was
declared as an array of unsigned longs (util/include/linux/types.h).

I do have it working now -- analyzing 32-bit PPC files on 32-bit and
64-bit x86 hosts.

I have a patch to take a best guess on the feature mask. Your patchset
actually helps there since the new features are on by default with no
off switch. I guess to make it more robust I should add an endian
feature mask and require it to be set rather than depending implicitly
on the existence of other flags. Once Arnaldo picks up this patch I'll
send out one for endianness handling of the features mask.

David
