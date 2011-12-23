Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1LWLUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:20:10 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:1705
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720Ab1LWLUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:20:07 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LWNM5C-02-0GD-02
X-M-MSG: 
Date: Fri, 23 Dec 2011 12:19:58 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111223111958.GE16765@erda.amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <20111223103329.GC4749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111223103329.GC4749@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.11 11:33:29, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > This patch adds a script to collect and display IBS samples.
> > There are the following options:
> > 
> >  perf script ibs [ibs_op|ibs_fetch] [-c period] <command>
> > 
> > Examples for usage:
> > 
> >  perf script ibs ibs_op <command>
> >  perf script ibs ibs_fetch <command>
> >  perf script record ibs ibs_op -c 500000 <command>
> >  perf script report ibs
> >  perf script record ibs ibs_op -c 500000 <command> | perf script report ibs
> 
> So, cannot we just integrate this into regular perf record and 
> perf report?

As stated in the cover letter, perf record is already there:

 perf record -e ibs_op:r0 -c 100000 -R -a <command>
 perf record -e ibs_fetch:r0 -c 100000 -R -a <command>

For perf report I was looking at parsing perf.data to output a dump
for ibs samples, but it turned out to be more useful to implement this
with perf script.

What we might do later to integrate ibs more into HW event sampling is
to redirect perfctr event requests for clk_unhalted/ops_count in
conjunction with the precise bit to ibs_op (clk_unhalted/ops). We
would then have e.g. a precise perf top. But this is clearly out of
the scope of this patch series.

> 
> Also, could you quote example output of "perf script report ibs"?

IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x0000000000444780 IBS2:0x000000041af26780
IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x00007f5efb44e3b2 IBS2:0x000000042fcff3b2
IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065273 IBS2:0x0000000001065273
IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff811a6320 IBS2:0x00000000011a6320
IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065255 IBS2:0x0000000001065255
IBS_FETCH sample on cpu7	IBS0: 0x00170004186a186a IBS1: 0x00007fbf0c687ca0 IBS2:0x000000041d345ca0
IBS_FETCH sample on cpu7	IBS0: 0x00170003186a186a IBS1: 0x000000000043bb80 IBS2:0x000000041c351b80
IBS_FETCH sample on cpu7	IBS0: 0x01370003186a186a IBS1: 0xffffffff813d5790 IBS2:0x00000000013d5790
IBS_FETCH sample on cpu7	IBS0: 0x00030001186a186a IBS1: 0xffffffff8102bd00 IBS2:0x00000000013d5d00


IBS_OP sample on cpu0            IBS0: 0x000000000006186a IBS1: 0xffffffff811a8297 IBS2: 0x0000000000490047
        IBS3: 0x0000000000000000 IBS4: 0x0000070300000000 IBS5: 0x0000000000000000 IBS6: 0x0000000000000000
IBS_OP sample on cpu4            IBS0: 0x000000000006186a IBS1: 0xffffffff8100840d IBS2: 0x0000000000040004
        IBS3: 0x0000000000000000 IBS4: 0x0000000000000000 IBS5: 0x0000000000000000 IBS6: 0x0000000000000000
IBS_OP sample on cpu0            IBS0: 0x000000000006186a IBS1: 0xffffffff811a8297 IBS2: 0x0000000000120008
        IBS3: 0x0000000000000000 IBS4: 0x0000000700060012 IBS5: 0xffff88041df23918 IBS6: 0x000000041df23918
IBS_OP sample on cpu0            IBS0: 0x000000000006186a IBS1: 0xffffffff811a8297 IBS2: 0x0000000000270002
        IBS3: 0x0000000000000000 IBS4: 0x0000064b00070092 IBS5: 0xffff88041dd93198 IBS6: 0x000000041dd93198
IBS_OP sample on cpu0            IBS0: 0x000000000006186a IBS1: 0xffffffff811a8297 IBS2: 0x00000000002d0002
        IBS3: 0x0000000000000000 IBS4: 0x0000064a00070092 IBS5: 0xffff88041e3acd18 IBS6: 0x000000041e3acd18
IBS_OP sample on cpu0            IBS0: 0x000000000006186a IBS1: 0xffffffff811a8297 IBS2: 0x0000000000160006
        IBS3: 0x0000000000000000 IBS4: 0x000008a000070092 IBS5: 0xffff88041e217990 IBS6: 0x000000041e217990
IBS_OP sample on cpu1            IBS0: 0x000000000006186a IBS1: 0xffffffff8100840d IBS2: 0x0000000000040004
        IBS3: 0x0000000000000000 IBS4: 0x0000000000000000 IBS5: 0x0000000000000000 IBS6: 0x0000000000000000
IBS_OP sample on cpu3            IBS0: 0x000000000006186a IBS1: 0xffffffff8100840d IBS2: 0x0000000000040004
        IBS3: 0x0000000000000000 IBS4: 0x0000000000000000 IBS5: 0x0000000000000000 IBS6: 0x0000000000000000
IBS_OP sample on cpu0            IBS0: 0x000000000006186a IBS1: 0xffffffff811a8297 IBS2: 0x000000000012000e
        IBS3: 0x0000000000000000 IBS4: 0x0000000300060012 IBS5: 0xffff88041effa8d0 IBS6: 0x000000041effa8d0

Esp. IBS_OP is not that good looking, but it shows how to use it and
can also be beautified and extended later. It gives the user a
direction about how to access ibs.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

