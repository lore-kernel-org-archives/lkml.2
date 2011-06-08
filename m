Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1FHFUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:20:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1FHFUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BKRk22IiI9USvkxV2bYY1VfL4DyZ2u6cp1HQcCFuWBVijswtZaLz011VymRwErXLGl
         vX1vV37YHFL0IYGOdIeA==
MIME-Version: 1.0
In-Reply-To: <20110608130315.0a365dbb.kamezawa.hiroyu@jp.fujitsu.com>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
 <1307117538-14317-12-git-send-email-gthelen@google.com> <20110607193835.GD26965@redhat.com>
 <xr93lixdv0df.fsf@gthelen.mtv.corp.google.com> <20110607210540.GB30919@redhat.com>
 <20110608091815.fdef924d.kamezawa.hiroyu@jp.fujitsu.com> <BANLkTim-sYkuekCcOA+HXhCtED4xKfT=0Q@mail.gmail.com>
 <20110608130315.0a365dbb.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Tue, 7 Jun 2011 22:20:26 -0700
Message-ID: <BANLkTinifX7cYX+yaBP+Pp5=oU9EdSHLtg@mail.gmail.com>
Subject: Re: [PATCH v8 11/12] writeback: make background writeback cgroup aware
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 9:03 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 7 Jun 2011 21:02:21 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> On Tue, Jun 7, 2011 at 5:18 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Tue, 7 Jun 2011 17:05:40 -0400
>> > Vivek Goyal <vgoyal@redhat.com> wrote:
>> >
>> >> On Tue, Jun 07, 2011 at 01:43:08PM -0700, Greg Thelen wrote:
>> >> > Vivek Goyal <vgoyal@redhat.com> writes:
>> >> >
>> >> > > On Fri, Jun 03, 2011 at 09:12:17AM -0700, Greg Thelen wrote:
>> >> > >> When the system is under background dirty memory threshold but a cgroup
>> >> > >> is over its background dirty memory threshold, then only writeback
>> >> > >> inodes associated with the over-limit cgroup(s).
>> >> > >>
>> >> > >
>> >> > > [..]
>> >> > >> -static inline bool over_bground_thresh(void)
>> >> > >> +static inline bool over_bground_thresh(struct bdi_writeback *wb,
>> >> > >> +                                       struct writeback_control *wbc)
>> >> > >>  {
>> >> > >>          unsigned long background_thresh, dirty_thresh;
>> >> > >>
>> >> > >>          global_dirty_limits(&background_thresh, &dirty_thresh);
>> >> > >>
>> >> > >> -        return (global_page_state(NR_FILE_DIRTY) +
>> >> > >> -                global_page_state(NR_UNSTABLE_NFS) > background_thresh);
>> >> > >> +        if (global_page_state(NR_FILE_DIRTY) +
>> >> > >> +            global_page_state(NR_UNSTABLE_NFS) > background_thresh) {
>> >> > >> +                wbc->for_cgroup = 0;
>> >> > >> +                return true;
>> >> > >> +        }
>> >> > >> +
>> >> > >> +        wbc->for_cgroup = 1;
>> >> > >> +        wbc->shared_inodes = 1;
>> >> > >> +        return mem_cgroups_over_bground_dirty_thresh();
>> >> > >>  }
>> >> > >
>> >> > > Hi Greg,
>> >> > >
>> >> > > So all the logic of writeout from mem cgroup works only if system is
>> >> > > below background limit. The moment we cross background limit, looks
>> >> > > like we will fall back to existing way of writting inodes?
>> >> >
>> >> > Correct.  If the system is over its background limit then the previous
>> >> > cgroup-unaware background writeback occurs.  I think of the system
>> >> > limits as those of the root cgroup.  If the system is over the global
>> >> > limit than all cgroups are eligible for writeback.  In this situation
>> >> > the current code does not distinguish between cgroups over or under
>> >> > their dirty background limit.
>> >> >
>> >> > Vivek Goyal <vgoyal@redhat.com> writes:
>> >> > > If yes, then from design point of view it is little odd that as long
>> >> > > as we are below background limit, we share the bdi between different
>> >> > > cgroups. The moment we are above background limit, we fall back to
>> >> > > algorithm of sharing the disk among individual inodes and forget
>> >> > > about memory cgroups. Kind of awkward.
>> >> > >
>> >> > > This kind of cgroup writeback I think will atleast not solve the problem
>> >> > > for CFQ IO controller, as we fall back to old ways of writting back inodes
>> >> > > the moment we cross dirty ratio.
>> >> >
>> >> > It might make more sense to reverse the order of the checks in the
>> >> > proposed over_bground_thresh(): the new version would first check if any
>> >> > memcg are over limit; assuming none are over limit, then check global
>> >> > limits.  Assuming that the system is over its background limit and some
>> >> > cgroups are also over their limits, then the over limit cgroups would
>> >> > first be written possibly getting the system below its limit.  Does this
>> >> > address your concern?
>> >>
>> >> Do you treat root group also as any other cgroup? If no, then above logic
>> >> can lead to issue of starvation of root group inode. Or unfair writeback.
>> >> So I guess it will be important to treat root group same as other groups.
>> >>
>> >
>> > As far as I can say, you should not place programs onto ROOT cgroups if you need
>> > performance isolation.
>>
>> Agreed.
>>
>> > From the code, I think if the system hits dirty_ratio, "1" bit of bitmap should be
>> > set and background writeback can work for ROOT cgroup seamlessly.
>> >
>> > Thanks,
>> > -Kame
>>
>> Not quite.  The proposed patches do not set the "1" bit (css_id of
>> root is 1).  mem_cgroup_balance_dirty_pages() (from patch 10/12)
>> introduces the following balancing loop:
>> +       /* balance entire ancestry of current's mem. */
>> +       for (; mem_cgroup_has_dirty_limit(mem); mem =
>> parent_mem_cgroup(mem)) {
>>
>> The loop terminates when mem_cgroup_has_dirty_limit() is called for
>> the root cgroup.  The bitmap is set in the body of the loop.  So the
>> root cgroup's bit (bit 1) will never be set in the bitmap.  However, I
>> think the effect is the same.  The proposed changes in this patch
>> (11/12) have background writeback first checking if the system is over
>> limit and if yes, then b_dirty inodes from any cgroup written.  This
>> means that a small system background limit with an over-{fg or
>> bg}-limit cgroup could cause other cgroups that are not over their
>> limit to have their inodes written back.  In an system-over-limit
>> situation normal system-wide bdi writeback is used (writing inodes in
>> b_dirty order).  For those who want isolation, a simple rule to avoid
>> this is to ensure that that sum of all cgroup background_limits is
>> less than the system background limit.
>>
>
> Hmm, should we add the rule ?
> How about disallowing to set dirty_ratio bigger than system's one ?

The rule needs to consider all cgroups when adjusting any cgroup (or
the system) effective background limit:

check_rule()
{
  cgroup_bg_bytes = 0
  for_each_mem_cgroup_tree(root, mem)
    cgroup_bg_bytes += mem->dirty_param.dirty_background_bytes;

  assert cgroup_bg_bytes < effective_background_limit
}

There may be more aggressive (lower values of cgroup_bg_bytes) if
hierarchy is enabled.  If hierarchy is enabled the cgroup limits may
be more restrictive than just the sum of all.  But the sum of all is
simpler.  Enforcing this rule would disallow background over commit.

If a global dirty ratio (rather than byte count) is set, then the
effective_background_limit is a function of
global_reclaimable_pages(), which can fluctuate as the number lru
pages changes (e.g. mlock may lower effective_background_limit).  So
the rule could be true when the limits are set, but when an mlock
occurs the rule would need to be reevaluated.  This feels way too
complex.  So my thinking is not to enforce this rule in code.  I will
plan to add this guidance to the memcg Documentation.
