Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1AKT5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:57:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab1AKT5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:57:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jVAHGBVlQxGwHtSkWIvJ+OvRxcZLk5i4fdZF+GKw1XCTR7nVBwnco1QTq4QDaSnpRK
         pZHRUnA0aC93Q2GVtmkQ==
MIME-Version: 1.0
In-Reply-To: <20110111065540.GA16036@aftab>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
 <1294700597-24239-1-git-send-email-mikew@google.com> <20110111065540.GA16036@aftab>
From: Mike Waychison <mikew@google.com>
Date: Tue, 11 Jan 2011 11:56:50 -0800
Message-ID: <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
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

On Mon, Jan 10, 2011 at 10:55 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Mon, Jan 10, 2011 at 06:03:17PM -0500, Mike Waychison wrote:
>> This patch applies to v2.6.37.
>>
>> Updated with documentation of the new option.
>> ---
>>
>> On our systems, we do not want to have any "decoders" called on machine
>> check events.  These decoders can easily spam our logs and cause space
>> problems on machines that have a lot of correctable error events.  We
>> _do_ however want to get the messages delivered via /dev/mcelog for
>> userland processing.
>
> Ok, question: how do you guys process DRAM ECCs? And more specifically,
> with a large number of machines, how do you do the mapping from the DRAM
> ECC error address reported by MCA to a DIMM that's failing in userspace
> on a particular machine?

We process machine checks in userland, using carnal knowledge of the
memory controller and the board specific addressing of the SPDs on the
various i2c busses to deswizzle and make sense of the addresses and
symptoms.  We then expose this digested data on the network, which is
dealt with at the cluster level.

>
> Also, I've worked on trimming down all that decoding output to 3-5
> lines. Now it looks like this:
>
> [  521.677316] [Hardware Error]: MC4_STATUS[Over|UE|MiscV|PCC|AddrV|UECC]: 0xfe00200000080a0f
> [  521.686467] [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
> [  521.686498] EDAC MC0: UE page 0x0, offset 0x0, grain 0, row 0, labels ":": amd64_edac
> [  521.686501] EDAC MC0: UE - no information available: UE bit is set
> [  521.686503] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, mem-tx: GEN, part-proc: RES (no timeout)
>
> and the two lines starting with "EDAC MC0" will get trimmed even
> more with time. I'm assuming this is not a lot but if you get a lot
> of correctable error events, then output like that accumulates over
> time.

This decoded information is great, but it's only really consumable by
a human.  We'd _much_ rather have structured data that we know isn't
as volatile (in terms of regexes that break with development churn)
nor susceptible to corruption (as the logs are not transactional and
are shared by all CPUs concurrently).   For the most part, we rarely
rely on the anything automated consuming kernel printk logs, and the
bits that do are there only for historical reasons (read: we haven't
figured out how to replace them yet).  With almost every single kernel
version bump we've had, we've found numerous places where strings in
the logs have subtly changed, breaking our infrastructure :(  Finding
these is a painful process and often shows up late in the deployment
process.  This is disastrous to our deployment schedules as rebooting
our number of machines, well, it takes a while...

I'm sorry if this is tangential to your comment above, but I feel the
need to have folks recognize that printk() is _not_ a good foundation
on which to build automation.

As for using EDAC, I know we tried using it a few years ago, but have
since reverted to processing MCE ourselves.  I don't know all the
details as to why, however Duncan Laurie might be able to share more
(CCed).

> How about an error thresholding scheme in software then which
> accumulates the error events and reports only when some configurable
> thresholds per DRAM device in error have been reached?

This is pretty much the opposite of what we'd want.   We have no use
for anything printed in the logs, though emitting these messages
wouldn't be a problem except for those machines which very frequently
have MCA events to report.  On those machines, the chatter in the logs
can potentially wedge our root filesystem (which is tiny) and has the
downside that it forces logs to rotate quickly (which means there is
less useful data for a human to consume when analyzing what happened
on the host).  Our policy has been to neuter bits of the kernel that
don't know when to stfu :)


>>
>> +static void call_decoders(struct mce *m)
>
> Yeah, let's call this decode_mce().

OK.

>
>> +{
>> +     if (mce_dont_decode)
>> +             return;
>> +     /*
>> +      * Print out human-readable details about the MCE error,
>> +      * (if the CPU has an implementation for that)
>> +      */
>> +     atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
>> +}
>> +
>>  static void print_mce(struct mce *m)
>>  {
>>       pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
>> @@ -234,11 +246,7 @@ static void print_mce(struct mce *m)
>>       pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
>>               m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
>>
>> -     /*
>> -      * Print out human-readable details about the MCE error,
>> -      * (if the CPU has an implementation for that)
>> -      */
>> -     atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
>> +     call_decoders(m);
>>  }
>>
>>  #define PANIC_TIMEOUT 5 /* 5 seconds */
>> @@ -588,7 +596,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>>                */
>>               if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
>>                       mce_log(&m);
>
> Also, there's another hook in the function above that does
> edac_mce_parse(mce) (which shouldnt've been there actually) which is
> used by the Nehalem driver i7core_edac which does also decode DRAM ECCs.

What should we do with this guy?  I'd be happy to send a patch in, but
as I mentioned above, we don't use EDAC at all (which is probably why
I didn't notice this guy).

>
> @Mauro: how about dropping the whole <drivers/edac/edac_mce.c> and using
> a simple notifier which is much smaller in code and does the same thing?
