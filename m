Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1EKPlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:41:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab1EKPiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:38:17 -0400
Message-ID: <4DCA87FA.4070902@redhat.com>
Date: Wed, 11 May 2011 15:58:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        benh <benh@kernel.crashing.org>, Anton Blanchard <anton@samba.org>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH 2/3] perf, x86: Use GO/HO bits in perf-ctr
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com> <1305038132-5080-3-git-send-email-joerg.roedel@amd.com> <1305038900.2914.97.camel@laptop> <20110510150412.GB30996@amd.com>
In-Reply-To: <20110510150412.GB30996@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 06:04 PM, Roedel, Joerg wrote:
> On Tue, May 10, 2011 at 10:48:20AM -0400, Peter Zijlstra wrote:
> >  On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> >  >  The AMD perf-counters support counting in guest or host-mode
> >  >  only. Make use of that feature when user-space specified
> >  >  guest/host-mode only counting.
> >
> >  Subject mentions x86, does Intel have anything similar so you can make
> >  it work for them too?
>
> Intel does not support guest or host-only counting in the hardware (at
> least according to my documentation). If wanted it could be approximated by
> enabling/disabling the counters in the guest-entry path.

vmx has support for atomically swapping MSRs during guest entry and exit 
(you can load guest MSRs on entry, save guest MSRs on exit, and load 
host MSRs on exit, but you can't save host MSRs on entry, so host-only 
counters cannot be 100% accurate).  We'd need some kvm/perf hooks to 
program these MSR swaps, and to manually save the counters that cannot 
be done automatically.

btw, your patchset can be further improved by integrating 
exclude_guest/exclude_host into the constraints.  For example if we have 
three general purpose counters, two generic perf_events in user, one 
exclude_guest perf_event, and one exclude_host perf_event, we can 
schedule them all at all times, swapping the exclude_guest and 
exclude_host events during guest entry/exit.

-- 
error compiling committee.c: too many arguments to function

