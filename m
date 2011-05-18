Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1ERJDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:03:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab1ERJDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:03:36 -0400
Message-ID: <4DD38B57.2070904@redhat.com>
Date: Wed, 18 May 2011 12:03:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to guests
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <1305129333-7456-6-git-send-email-avi@redhat.com> <20110517194117.GA26184@elte.hu>
In-Reply-To: <20110517194117.GA26184@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 10:41 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
> >  Caveats:
> >  - counters that have PMI (interrupt) enabled stop counting after the
> >    interrupt is signalled.  This is because we need one-shot samples
> >    that keep counting, which perf doesn't support yet
>
> Hm, do you need more than perf_event::event_limit, or something special?

I do use event_limit, but it's inexact since it auto-disables the event 
after firing the callback.  I want to limit the callback to just one, 
but let the event keep counting.

> >  - some combinations of INV and CMASK are not supported
>
> Could you please describe this better, where does this limit come from?
> If perf then this needs fixing.

perf_event_attr does not support generic INV and CMASK at all.  I 
imagine you can get them through the model-specific hardware 
configuration, but that means we have to encode model specific 
information into kvm host code, which is (a) hard (b) counter to the 
spirit of perf.

(INV and CMASK allow you to increment the counter only when > N or < N 
events occur simultaneously, for example count when 2 or more 
instructions are retired in a single clock).

> >  - counters keep on counting in the host as well as the guest
>
> I suspect fixing this either needs a hw filter feature, or the ability to
> disable/enable these events across VM exits/entries.
>
> I would imagine the disable/enable to be rather expensive so hw help would be
> preferred ...

Yes, Joerg already posted support for this feature for AMD.  Intel 
supports this in a more complicated way (you can tell vmx to load 
IA32_PERF_GLOBAL_CTL atomically during entry or exit).  This can be done 
independently of this patchset.

> I didnt see anything objectionable in your patches, but i'd like to have
> Peter's Acked-by as well before we go forward. I think that in the long run
> having a virtio-perf gateway would allow us a lot more tricks than just
> arch-perfmon emulation:
>
>   - we could do things like propagate guest side traces over to the host

We support that already via 'perf kvm', no?  This is more about the 
guest profiling itself without access to the host (which is the more 
common scenario, IMO).

We're still missing tunnelling guest ftrace to the host, but a patch was 
recently posted to do that.

>   - we could control from the host which events we measure on the guest side
>
>   - etc.
>
> How would you like to handle the flow of patches - should we merge #1,#2,#3 in
> perf/core and you'd then merge #4,#5 via the KVM tree once the first bits hit
> upstream?
>
> We could also set up a separate branch for these three commits, which you could
> pull - this would allow all this to still hit .40.

You can put them in either perf/core or a different branch, and I can 
pull them as long as its fast-forward only.

But I don't think I'll target 2.6.40, this needs to be tested a lot 
more, particularly wrt guest-initiated DoS against the host.

-- 
error compiling committee.c: too many arguments to function

