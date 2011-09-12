Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1ILOk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:40:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab1ILOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:40:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=pyPFXyaFazMnXvS0SwpUHXHsxW0NSrtZokNO8cARaP8zJN0boDC8f8VbvvWH6uTah
	VwwTudS18OcCUCYAaqocA==
MIME-Version: 1.0
In-Reply-To: <4E6E181E.9080506@gmail.com>
References: <20110907191045.GA13475@quad>
	<4E6E0D0B.3080306@gmail.com>
	<CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	<4E6E181E.9080506@gmail.com>
Date: Mon, 12 Sep 2011 16:40:25 +0200
Message-ID: <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 4:33 PM, David Ahern <dsahern@gmail.com> wrote:
>
> On 09/12/2011 07:54 AM, Stephane Eranian wrote:
>>> The problem with endianness handling I mentioned last week is related to
>>> the assumption that the HEADER_BUILD_ID is set. In my test case it is
>>> not (-B flag on perf-record) and that causes the aborts. A problem for
>>> another day which I can address it when I submit the patch to handle
>>> swapping for the feature mask.
>>>
>> Ok, now I understand your point better.
>>
>> The thing is that the endianess detection done by perf is currently broken.
>> It assumes that if the size of perf_event_attr saved in the file (attr_size)
>> does not match sizeof(perf_event_attr) then it must be because of endianess
>> issues. The reality is that it they can be different because the the ABI
>> has been extended (and I am sure it will), and this a perf tool may
>> have a larger struct perf_event_attr, than an old perf.data file, yet it
>> should be able to read it. We need to fix this issue now and not once
>> we hit the problem with extended ABI. I have a couple of ideas on this
>> and they revolve around using the magic prefix as the indicator of endianess
>> (and also detect older perf.data files).
>
> There is some handling of older perf data files. For example, data files
> without the adds_features mask are handled -- see
> perf_file_header__read(), if (header->size != sizeof(*header)) {}
>
Yes, that's quite possible. I am worried of attr_size vs.
sizeof(perf_event_attr).
I don't think this should be the test to detect endianess.


> The swapping of the adds_features mask is a mess because the mask was
> declared as an array of unsigned longs (util/include/linux/types.h).
>
> I do have it working now -- analyzing 32-bit PPC files on 32-bit and
> 64-bit x86 hosts.
>
> I have a patch to take a best guess on the feature mask. Your patchset
> actually helps there since the new features are on by default with no
> off switch. I guess to make it more robust I should add an endian
> feature mask and require it to be set rather than depending implicitly
> on the existence of other flags. Once Arnaldo picks up this patch I'll
> send out one for endianness handling of the features mask.
>
okay.
