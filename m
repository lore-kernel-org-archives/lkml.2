Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0DOEtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:49:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54242 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab0DOEtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:49:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=MmV/ZPwr3zuIOHmDCCbOJlb9dc0seq7b989mtHw2pPQp5BSkSftAiBfOOzUqCuKRb
	ZSAVYD8b8I/c2nwSstwgQ==
MIME-Version: 1.0
In-Reply-To: <20100415114022.ef01b704.nishimura@mxp.nes.nec.co.jp>
References: <1268609202-15581-2-git-send-email-arighi@develer.com> 
	<20100318133527.420b2f25.kamezawa.hiroyu@jp.fujitsu.com> <20100318162855.GG18054@balbir.in.ibm.com> 
	<20100319102332.f1d81c8d.kamezawa.hiroyu@jp.fujitsu.com> <20100319024039.GH18054@balbir.in.ibm.com> 
	<20100319120049.3dbf8440.kamezawa.hiroyu@jp.fujitsu.com> <xr931veiplpr.fsf@ninji.mtv.corp.google.com> 
	<20100414140523.GC13535@redhat.com> <xr9339yxyepc.fsf@ninji.mtv.corp.google.com> 
	<20100415114022.ef01b704.nishimura@mxp.nes.nec.co.jp>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 14 Apr 2010 21:48:25 -0700
Message-ID: <g2u49b004811004142148i3db9fefaje1f20760426e0c7e@mail.gmail.com>
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Andrea Righi <arighi@develer.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 7:40 PM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> On Wed, 14 Apr 2010 13:14:07 -0700, Greg Thelen <gthelen@google.com> wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>
>> > On Tue, Apr 13, 2010 at 11:55:12PM -0700, Greg Thelen wrote:
>> >> On Thu, Mar 18, 2010 at 8:00 PM, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >> > On Fri, 19 Mar 2010 08:10:39 +0530
>> >> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> >> >
>> >> >> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-19 10:23:32]:
>> >> >>
>> >> >> > On Thu, 18 Mar 2010 21:58:55 +0530
>> >> >> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> >> >> >
>> >> >> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-18 13:35:27]:
>> >> >> >
>> >> >> > > > Then, no probelm. It's ok to add mem_cgroup_udpate_stat() indpendent from
>> >> >> > > > mem_cgroup_update_file_mapped(). The look may be messy but it's not your
>> >> >> > > > fault. But please write "why add new function" to patch description.
>> >> >> > > >
>> >> >> > > > I'm sorry for wasting your time.
>> >> >> > >
>> >> >> > > Do we need to go down this route? We could check the stat and do the
>> >> >> > > correct thing. In case of FILE_MAPPED, always grab page_cgroup_lock
>> >> >> > > and for others potentially look at trylock. It is OK for different
>> >> >> > > stats to be protected via different locks.
>> >> >> > >
>> >> >> >
>> >> >> > I _don't_ want to see a mixture of spinlock and trylock in a function.
>> >> >> >
>> >> >>
>> >> >> A well documented well written function can help. The other thing is to
>> >> >> of-course solve this correctly by introducing different locking around
>> >> >> the statistics. Are you suggesting the later?
>> >> >>
>> >> >
>> >> > No. As I wrote.
>> >> >        - don't modify codes around FILE_MAPPED in this series.
>> >> >        - add a new functions for new statistics
>> >> > Then,
>> >> >        - think about clean up later, after we confirm all things work as expected.
>> >>
>> >> I have ported Andrea Righi's memcg dirty page accounting patches to latest
>> >> mmtom-2010-04-05-16-09.  In doing so I have to address this locking issue.  Does
>> >> the following look good?  I will (of course) submit the entire patch for review,
>> >> but I wanted make sure I was aiming in the right direction.
>> >>
>> >> void mem_cgroup_update_page_stat(struct page *page,
>> >>                    enum mem_cgroup_write_page_stat_item idx, bool charge)
>> >> {
>> >>    static int seq;
>> >>    struct page_cgroup *pc;
>> >>
>> >>    if (mem_cgroup_disabled())
>> >>            return;
>> >>    pc = lookup_page_cgroup(page);
>> >>    if (!pc || mem_cgroup_is_root(pc->mem_cgroup))
>> >>            return;
>> >>
>> >>    /*
>> >>     * This routine does not disable irq when updating stats.  So it is
>> >>     * possible that a stat update from within interrupt routine, could
>> >>     * deadlock.  Use trylock_page_cgroup() to avoid such deadlock.  This
>> >>     * makes the memcg counters fuzzy.  More complicated, or lower
>> >>     * performing locking solutions avoid this fuzziness, but are not
>> >>     * currently needed.
>> >>     */
>> >>    if (irqs_disabled()) {
>> >             ^^^^^^^^^
>> > Or may be in_interrupt()?
>>
>> Good catch.  I will replace irqs_disabled() with in_interrupt().
>>
> I think you should check both. __remove_from_page_cache(), which will update
> DIRTY, is called with irq disabled(iow, under mapping->tree_lock) but not in
> interrupt context.

The only reason to use trylock in this case is to prevent deadlock
when running in a context that may have preempted or interrupted a
routine that already holds the bit locked.  In the
__remove_from_page_cache() irqs are disabled, but that does not imply
that a routine holding the spinlock has been preempted.  When the bit
is locked, preemption is disabled.  The only way to interrupt a holder
of the bit for an interrupt to occur (I/O, timer, etc).  So I think
that in_interrupt() is sufficient.  Am I missing something?

> Anyway, I tend to agree with KAMEZAWA-san: use trylock always(except for FILE_MAPPED),
> or add some new interfaces(e.g. mem_cgroup_update_stat_locked/safe...).

Thank you for the input.  I'm thinking more on this.

--
Greg
