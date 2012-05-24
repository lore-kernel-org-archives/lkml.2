Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2EXNjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:39:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:17485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab2EXNjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:39:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="144199424"
Message-ID: <4FBE39FE.4050001@linux.intel.com>
Date: Thu, 24 May 2012 06:39:10 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Lutomirski <luto@mit.edu>, Jan Beulich <JBeulich@suse.com>,
        Alex Shi <alex.shi@intel.com>, borislav.petkov@amd.com, arnd@arndb.de,
        akinobu.mita@gmail.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, hughd@google.com, jeremy@goop.org,
        len.brown@intel.com, tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, avi@redhat.com,
        dhowells@redhat.com, mingo@redhat.com, riel@redhat.com, cpw@sgi.com,
        steiner@sgi.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hpa@zytor.com
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>  <1337782555-8088-9-git-send-email-alex.shi@intel.com>  <4FBD18D20200007800085951@nat28.tlf.novell.com>  <1337792984.9783.37.camel@laptop> <1337793338.9783.38.camel@laptop>  <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>  <1337845230.9783.51.camel@laptop>  <CAObL_7FK8Pb7Ahmr0SBaPg1BvPTspr=EKG8v_QfcpdmMyuE5dA@mail.gmail.com> <1337865811.9783.152.camel@laptop>
In-Reply-To: <1337865811.9783.152.camel@laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/2012 6:23 AM, Peter Zijlstra wrote:
> On Thu, 2012-05-24 at 06:19 -0700, Andrew Lutomirski wrote:
>>
>> A decent heuristic might be to prefer idle SMT siblings for TLB
>> invalidation.  I don't know what effect that would have on power
>> consumption (it would be rather bad if idling one SMT thread while the
>> other one is busy saves much power). 

we really really shouldn't do flushing of tlb's on only one half of SMT.
SMT sibblings have their own TLB pool at least on some of Intels chips.

Also, note that on anything sane, we flush the tlb's in software before
going to an Idle state, so that we don't have to wake idle cpus up to
flush their TLBs (except for "global tlbs", but those change very very
very rarely hopefully)

> 
> Right, I've never really understood how C-states and SMT go together.
> Arjan recently implied waking a thread sibling from C-state was
> 'expensive' which on first thought seems daft, the core is running
> already.

in order to wake *anything* you need to send an IPI to it, it has to
exit the idle loop etc etc. It's not expensive-expensive, but it
certainly is not free either.
