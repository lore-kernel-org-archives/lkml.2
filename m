Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2AWROT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:14:19 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33039 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2AWROS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:14:18 -0500
MIME-Version: 1.0
In-Reply-To: <1327321532.2446.6.camel@twins>
References: <1326127761-2723-1-git-send-email-eranian@google.com>
	<CABPqkBTYrEeSefnXr4-ezmXHjNv1XkfVZGULzY5-=FE3tr3pfg@mail.gmail.com>
	<1327321532.2446.6.camel@twins>
Date: Mon, 23 Jan 2012 18:14:16 +0100
Message-ID: <CABPqkBSqA071Yt4KcCH25P6HZ1C8OOGFfcjOQ_aLmBRc3ir=9A@mail.gmail.com>
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken
 branches (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-01-23 at 11:14 +0100, Stephane Eranian wrote:
>> Any comments on this patch set?
>>
> Queued it, thanks!

One thing that needs to happen with this branch sampling patch is that
Arnaldo needs
to apply the patch I developed with dsahern@ that changes the magic number to
something that can determine the endianess. I don't know what happened
to this patch.
It's been over 6 months since I posted it and it's still not in the
perf source tree.

The issue here is that with branch stack sampling, the size of
perf_event_attr has
now changed (an extra u64). As such if this new perf tries to read an
old perf.data
file, it is going to think it's using a different endianess, it'll
swap the attr_size and still
find it different from its own version of the struct. That leads to:
incompatible file
format.

We need to separate endianess detection from attr_size. If attr_size
in perf.data <
then sizeof(struct perf_event_attr), then just zero out the extra
(unused) fields.
With that in place, this new perf will be able to read older perf.data files.
