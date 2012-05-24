Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2EXNTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:19:43 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65459 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2EXNTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:19:42 -0400
MIME-Version: 1.0
In-Reply-To: <1337845230.9783.51.camel@laptop>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
 <1337782555-8088-9-git-send-email-alex.shi@intel.com> <4FBD18D20200007800085951@nat28.tlf.novell.com>
 <1337792984.9783.37.camel@laptop> <1337793338.9783.38.camel@laptop>
 <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com> <1337845230.9783.51.camel@laptop>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 24 May 2012 06:19:21 -0700
X-Google-Sender-Auth: dr_nHSARDS6yafWPAdmgY6R-MMI
Message-ID: <CAObL_7FK8Pb7Ahmr0SBaPg1BvPTspr=EKG8v_QfcpdmMyuE5dA@mail.gmail.com>
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings of SMT
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Beulich <JBeulich@suse.com>, Alex Shi <alex.shi@intel.com>,
        borislav.petkov@amd.com, arnd@arndb.de, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, avi@redhat.com,
        dhowells@redhat.com, mingo@redhat.com, riel@redhat.com, cpw@sgi.com,
        steiner@sgi.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-05-23 at 18:46 -0700, Andrew Lutomirski wrote:
>> On Wed, May 23, 2012 at 10:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2012-05-23 at 19:09 +0200, Peter Zijlstra wrote:
>> >> > There is no comment or anything else indicating that this is
>> >> > suitable for dual-thread CPUs only - when there are more than
>> >> > 2 threads per core, the intended effect won't be achieved.
>> >>
>> >> Why would that be? Won't higher thread count still share the same
>> >> resources just more so?
>> >
>> > Ah, I see, you're saying his code is buggy for >2 threads. Agreed.
>> >
>>
>> An evil knob to statically choose which SMT sibling gets the interrupt
>> would be nice.  Then my compute-intensive thread could be (mostly)
>> unaffected by the other thread on a different core that calls munmap
>> frequently.
>
> Just make sure the two workloads never share a core and this should
> already happen since TLB invalidates are only broadcast to the mm
> cpumask.
>

I already do that.  But these two workloads share the same mm (they're
threads in the same process), so I'd gain performance if the
invalidations were sent from the core that called munmap to the SMT
sibling of the other thread.

A decent heuristic might be to prefer idle SMT siblings for TLB
invalidation.  I don't know what effect that would have on power
consumption (it would be rather bad if idling one SMT thread while the
other one is busy saves much power).

--Andy
