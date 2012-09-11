Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2IKOCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:02:13 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:8849
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289Ab2IKOCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:02:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202h1d1ahzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MA6UZ8-01-JWN-02
X-M-MSG: 
Date: Tue, 11 Sep 2012 16:01:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] perf tool: give user better message if precise is
 not supported
Message-ID: <20120911140148.GV8285@erda.amd.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
 <1347295216-1202-4-git-send-email-dsahern@gmail.com>
 <20120911092026.GU8285@erda.amd.com>
 <504F3B18.90403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <504F3B18.90403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.09.12 07:22:32, David Ahern wrote:
> On 9/11/12 3:20 AM, Robert Richter wrote:
> > On 10.09.12 10:40:16, David Ahern wrote:
> >> --- a/tools/perf/builtin-record.c
> >> +++ b/tools/perf/builtin-record.c
> >> @@ -294,6 +294,11 @@ try_again:
> >>   					  perf_evsel__name(pos));
> >>   				rc = -err;
> >>   				goto out;
> >> +			} else if ((err == ENOTSUP) && (attr->precise_ip)) {
> >
> > It is EOPNOTSUPP, did you test this?

Ok, wrong question. Better would have been: Did you run it on a
non-pebs Intel machine of an non-ibs AMD machine?

> I do not post patches without testing them. This particular patch was 
> verified in a Virtual Machine (no PEBS) and using :pG modifier.
> 
> 'egrep -r ENOTSUP tools/perf' shows hits in 3 other files, so I am not 
> the only one using the shortcut. I'll change it in the follow up with 
> better commit messages to make it consistent with patch 2.

For VM this might be valid. Don't know where ENOTSUP comes from. It is
neither in kernel/events/ nor arch/x86/kernel/cpu/perf.

If you run this bare-metal on older machines which do not support pebs
or ibs, the syscall returns EOPNOTSUPP. You can trigger the same
behaviour on newer systems with:

 # perf record -e cycles:ppp -c 2097120 -R -a sleep 1
 
   Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.
 ...

It should work in this case too.

> > To avoid adding more duplicate code, maybe we should start to unify
> > the code by implementing this in a shared helper function.
> 
> Doing that requires additional modifications to not break perl and 
> python scripts. Adding it in both commands here is consistent with all 
> other open counter failures. Consolidation of those loops into a common 
> base is known to do item.

I am fine with that too.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

