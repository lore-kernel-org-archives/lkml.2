Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1AKVwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:52:24 -0500
Received: from smtp-out.google.com ([74.125.121.67]:63108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab1AKVwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:52:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ixrIOhEB6fxz6QI8/bImDcdUUbgkN2GutEKKPbC+JNw12A5O6rPxILpP+VD69slqRp
         7fYP+lVH9MN92d8VRzkQ==
MIME-Version: 1.0
In-Reply-To: <20110111204909.GE17619@aftab>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
 <1294700597-24239-1-git-send-email-mikew@google.com> <20110111065540.GA16036@aftab>
 <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com> <20110111204909.GE17619@aftab>
From: Mike Waychison <mikew@google.com>
Date: Tue, 11 Jan 2011 13:51:57 -0800
Message-ID: <AANLkTimQNnxnoFPWjh6cHp_x9ZayDdcXdV+qbee8XK_r@mail.gmail.com>
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
To: Borislav Petkov <bp@amd64.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Duncan Laurie <dlaurie@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:49 PM, Borislav Petkov <bp@amd64.org> wrote:
> Ok, let me preface this with an even easier suggestion: Can you simply
> not compile EDAC (which includes CONFIG_EDAC_DECODE_MCE) in your kernels
> and the whole issue with decoding disappears simply because no module
> registers as a decoder...?

The trouble here is that default_decode_mce() is still getting called
no matter what :(  It didn't really cause problems until you added
atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m) to
machine_check_poll().

> On Tue, Jan 11, 2011 at 02:56:50PM -0500, Mike Waychison wrote:
>> >> On our systems, we do not want to have any "decoders" called on machine
>> >> check events.  These decoders can easily spam our logs and cause space
>> >> problems on machines that have a lot of correctable error events.  We
>> >> _do_ however want to get the messages delivered via /dev/mcelog for
>> >> userland processing.
>> >
>> > Ok, question: how do you guys process DRAM ECCs? And more specifically,
>> > with a large number of machines, how do you do the mapping from the DRAM
>> > ECC error address reported by MCA to a DIMM that's failing in userspace
>> > on a particular machine?
>>
>> We process machine checks in userland, using carnal knowledge of the
>> memory controller and the board specific addressing of the SPDs on the
>> various i2c busses to deswizzle and make sense of the addresses and
>> symptoms.  We then expose this digested data on the network, which is
>> dealt with at the cluster level.
>
> Right, and this means that you need to know all the memory controller
> topologies of all the different architectures and also the SPD accessing
> based on a board type could be a pain. One of the main reasons for
> fleshing out MCE decoding in the kernel was to avoid needless trouble
> like that.

It's not that painful for us.  Our firmware guys own this userland
code :)  I can see it being a pain for others however.

Doing this all in userland does have it's upsides as well fwiw.  For
example, MC4 is usually kept around across a reset, which means that
the firmware can pick it up when the system goes down due to a
processor context corruption.  We rely on these libraries as well to
decode egregious uncorrectable memory errors as well as bus errors
(like hypertransport sync floods).

*snip*

> I've
> heard similar troubles reported by other big server farm people and
> what I'm currently working on is a RAS daemon that hooks into perf thus
> enabling persistent performance events. This way, you could open a
> debugfs file (this'll move to sysfs someday) and read the same decoded
> data by mmaping the perf ringbuffer.

I'll definitely keep an eye out for your developments with RAS :)

>
> I think this is also easy disabled by not configuring EDAC, as I said
> above. Basically, if you don't enable EDAC, you can drop that patch
> too and run your kernels without any modification, or am I missing
> something..?

See the comment above.  It's the spamming for the default decoder that
I wanted to disable specifically, though my approach was a knob to
disable decoders generally.
