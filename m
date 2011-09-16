Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1IPOfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:35:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1IPOfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:35:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=wJo/tp8d3l+MXyC9oZrGr6m+xON3lFXdY1KhYRbkcYMGHDqs7ddVY7CpIx+AMANNW
	XmLhNVXHD2jrpIPadFpYQ==
MIME-Version: 1.0
In-Reply-To: <1315838611.26517.51.camel@twins>
References: <20110907191045.GA13475@quad>
	<4E6E0D0B.3080306@gmail.com>
	<CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	<4E6E181E.9080506@gmail.com>
	<CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
	<1315838611.26517.51.camel@twins>
Date: Fri, 16 Sep 2011 16:35:34 +0200
Message-ID: <CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 4:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-09-12 at 16:40 +0200, Stephane Eranian wrote:
>> I don't think this should be the test to detect endianess.
>
> You should be able to tell the endianness from the PERF_MAGIC string, it
> stores the string as a u64, so depending on endianness it reads back as
> either: PERFFILE or ELIFFREP or whatever the bswap64 result is.
>

I believe in big endian, if you do od -c perf.data | head -1, you also see:

0000000   P   E   R   F   F   I   L   E   h  \0  \0  \0  \0  \0  \0  \0

static const char *__perf_magic = "PERFFILE";
#define PERF_MAGIC      (*(u64 *)__perf_magic)

u64 hm = PERF_MAGIC;

The layout in memory is the same for both little-endian and
big-endian. Thus the layout on the file is the same.

When you look at the memory as u64, then things are different:
In little-endian, hm=0x454c494646524550
in big-endian,   hm=0x5045524646494c45

In big-endian, the MSB 0x50 ('P') ends up at the lowest memory address.
In little-endian, the LSB 0x50 ('P') ends up at the lowest memory address.

Thus, I suspect we need to write in the file a different MAGIC for big vs.
little endian.

David, can you confirm this?
