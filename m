Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2HCNvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:51:31 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:44006
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab2HCNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:51:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI1432Izz1202hzz8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M86MHI-02-09E-02
X-M-MSG: 
Date: Fri, 3 Aug 2012 15:51:17 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120803135117.GC3732@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120723181358.GC6717@infradead.org>
 <500EAF23.8060909@gmail.com>
 <20120724161507.GG3732@erda.amd.com>
 <500EDB50.3070704@gmail.com>
 <20120724180312.GJ6717@infradead.org>
 <5010D2B1.3000206@gmail.com>
 <1343290109.26034.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343290109.26034.82.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.12 10:08:29, Peter Zijlstra wrote:
> On Wed, 2012-07-25 at 23:16 -0600, David Ahern wrote:
> 
> > Peter's patch (see https://lkml.org/lkml/2012/7/9/298) changes kernel 
> > side to require the use of exclude_guest if the precise modifier is 
> > used, returning -EOPNOTSUPP if exclude_guest is not set. This patch goes 
> > after the user experience: Today if a user specifies -e <event>:p all 
> > other modifiers are reset - including exclude_guest. Going forward we 
> > need :p to imply :pH if a user has not specified a GH modifer.
> > 
> > We could do nothing and handle the unsupported error and try setting the 
> > exclude_guest option - like perf handles other new parameters. But 
> > EOPNOTSUPP is not uniquely tied to this error -- e.g., it could be the 
> > BTS is not supported (:pp). Also, we have no easy way to discriminate :p 
> > from :pG or :pGH. It seems to me perf should not silently undo a user 
> > request on the modifier, but inform the user the request is wrong. For 
> > example if a user request -e cycles:pG it should not be silently turned 
> > into :pH.
> > 
> > And then yesterday, Robert stated that none of the exclude_xxxx 
> > modifiers can be set for the AMD if the precise modifier is used, so we 
> > cannot blindly set exclude_guest if precise_ip is set.
> > 
> > So, seems to me perf need's one action for Intel processors and another 
> > for AMD.
> 
> No, we just need to teach the IBS code about SVM enter/exit.

I aggree that this could be emulated in software by enabling/disabling
the event with a guest/host switch. And, even better, we add this for
every pmu in a generic way. E.g. northbridge counter and I guess also
Intel uncore events do not support G/H counting in hardware. Same to
other pmus that could be imaginable in the future like counters for
IOMMUs or other hardware devices.

But, as some pmus are not related to virtualization or other features
they simply do not need to support those attributes, or we want other
defaults, e.g. enable it system wide. Detecting features with syscall
error checking and then falling back to other defaults does not seem
the right approach to me, because it may require several syscalls to
check *combinations* of supported attributes, makes error logging and
detection more difficult due to noisy log messages and because there
is no strict attribute flag checking in current and older kernels.

I better would like to see a pmu feature flag in the same style as
with /proc/cpuinfo, e.g.:

 $ cat /sys/bus/event_source/devices/cpu/flags
 exclude_host exclude_guest

We also need stricter attribute flag checking, esp. of reseved flags
and for unsupported features in some pmus (I already work on some
patches for this). Userland then checks flags and sets up syscalls
according to the reported flags. The goal should be to avoid syscall
errors at all. Thus, we are able to improve dmesg logging in case of
errors, currently we do not see any message if a syscall fails.

And finally, if a feature could be emulated, we could provide this
emulation of an attr flag to all pmus.

Does this make sense?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

