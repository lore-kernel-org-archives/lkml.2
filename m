Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2B2RRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:17:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab2B2RRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:17:39 -0500
Message-ID: <4F4E5D9B.9020902@redhat.com>
Date: Wed, 29 Feb 2012 14:17:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab> <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab>
In-Reply-To: <20120229144054.GH21224@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-02-2012 11:40, Borislav Petkov escreveu:
> On Wed, Feb 29, 2012 at 11:04:09AM -0300, Mauro Carvalho Chehab wrote:
>> No, you didn't. Every time i touch on this point, you just say that it
>> doesn't fit without giving any explanation why not.
> 
> Let me explain it to you one _last_ time:

Thanks! Your view is now clear.
> 
> - severity: No real need for it. If the error is severe enough, the
> kernel handles automatically, i.e. memory poisoning and recovery. In all
> the other cases it is not severe enough.

I see your point, but opone thing is to recover from severe errors; 
another thing is to properly report it.

In general, when an error occurs, what users do is to account
them, taking other measures (like replace the affected hardware) 
only if the error count is above a certain threshold.

The threshold criteria for non-severe errors is generally different from
the criteria for severe ones. That's why the severity information should
be reported.

> 
> - location: this is contained in the ->cpu field.

Assuming that the CPU field contains the location of the error is a bad
assumption. On SB, the CPU that reports a memory error is the CPU where
some code tried to access the RAM, and not the CPU where the memory 
controller is. So, the value for CPU is bogus for those error types.
This is also true, at least on Intel, for other types of errors, like
bus/interconnect ones: the CPU that reports the error is the one trying
to access the bus.

Also, on almost all memory error cases, the location of the affected
component is not the memory controller at the CPU. Instead, it is the
DRAM chip, located inside a DIMM.

So, while there are several error types where the location is cpu field,
there are also several other cases where location != cpu.

The kernel decoder knows the error location, on most cases. So, instead
of letting the userspace to guess the error location, it should report
what it was decoded.

> - silkscreen_label: <sarcasm> yeah, I'm getting a, say, a Data
> Cache error during an L1 linefill from L2, what the f*ck does the
> silkscreen label mean for such an error?! Well, nobody knows wtf it
> means!</sarcasm>

It means what component needs to be replaced, because there are too
many errors there, and it is likely damaged.

Silkscreen label for a L1 error: CPU0, CPU1, CPU2, CPU3 (the socket "name"
for the CPU socket at the motherboard, as labeled at the silkscreen).
Again, this is not the CPU field, as one CPU socket has several cores, 
and the core/socket ID order can be different than the actual CPU slots
(btw, this is explicitly noticed on a few Intel datasheets). 

Of course, for both location and silkscreen label fields, if, for any 
reason, the location of the affected component can't be identified, those
fields should be filled with an empty string (or with something like "unknown").

Silkscreen label for a memory error: DIMM1A, DIMM2B, etc.

> - error_msg: already there in my patch.
> 
> So go and read and try _understanding_ this before you come back with
> more crap, ok?

Ok, but please do the same and try to see the question from the users
perspective that needs to know what is the damn broken FRU
(Field Replaceable Unit) that needs a replacement on their
critical systems.
> 
>> Running away from this discussion won't help at all.
> 
> Not running away - trying not to waste time with bullshit.
> 

Thanks,
Mauro
