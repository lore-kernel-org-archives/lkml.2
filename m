Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2LMRax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:30:53 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60601 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2LMRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:30:52 -0500
Message-ID: <50CA10C8.3020509@gmail.com>
Date: Thu, 13 Dec 2012 10:30:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com> <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com> <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com> <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com> <50CA0134.2090608@gmail.com> <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com> <CA+55aFwSYyoLmdDJ5xsdwcWLThYQ7oieoeWDV2g+wV3CJk4vtg@mail.gmail.com>
In-Reply-To: <CA+55aFwSYyoLmdDJ5xsdwcWLThYQ7oieoeWDV2g+wV3CJk4vtg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/12 10:02 AM, Linus Torvalds wrote:

 From your response to Ingo I take it you looked into other cases. I'll 
summarize here to make sure we are on the same page:

1. guest only profiling from the host
perf {record|top} -e cycles:G

2. host only profiling
perf {record|top} -e cycles:H

These are 4 existing use cases that toggle exclude_guest and do work 
today for those who care. Not the lack of precise attribute on the 
commands. These are the existing use cases that break by inverting the 
logic in the kernel.

The problem child is perf record -e cycles:ppG. That command silently 
crashes running VMs. You don't get a pop up or message that says "Dave, 
you crashed your VMs running perf". You don't notice the VMs have 
crashed until you attempt to login or what have you.

So how many perf users are having weird VM crashes? I don't know. I just 
happened to:

1. not use libbvirt
2. have a running VM with console messages kicked to ttyS0
3. ttyS0 connected to stdio
4. screen session with a running VM open

at the time I ran perf.


> Btw, I do *not* think that you should necessariyl default to 'H' for
> host-only mode.

The change made to perf userspace was to set exclude_guest IF precise is 
requested AND GH have not been specified.

>
> The way it should work is that ":pp", ":ppH" and ":ppV" are all different.
>
>   - "cycles:ppH" means: I want precise cycles only for the host case
>
>   - "cycles:ppV" means: I want precise cycles, and I want the VM too
>
>     This would result in EOPNOTSUPP for the case we know is buggy (but
> presumably work on some other CPUs that don't have the problem)
>
>   - "cycles:pp" is "I want precise cycles, and I don't care about virtualization"

yes, this is the case I handled within perf userspace.

And then there is the whole 'perf kvm {top|record}' twists to the perf code.

David

