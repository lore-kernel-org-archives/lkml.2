Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1FIR4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:56:06 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1FIR4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gxtnAfG6ycvQTQuPo9FJiXhHsh8J8D8sxb2aXNn/ITUlo19Gf7uoUHmc9x04eR7Ji5
         yoF1xPc8f8vfMXi+hBBQ==
MIME-Version: 1.0
In-Reply-To: <20110608203945.GF1150@redhat.com>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
 <1307117538-14317-12-git-send-email-gthelen@google.com> <20110607193835.GD26965@redhat.com>
 <xr93lixdv0df.fsf@gthelen.mtv.corp.google.com> <20110607210540.GB30919@redhat.com>
 <20110608091815.fdef924d.kamezawa.hiroyu@jp.fujitsu.com> <BANLkTim-sYkuekCcOA+HXhCtED4xKfT=0Q@mail.gmail.com>
 <20110608203945.GF1150@redhat.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 9 Jun 2011 10:55:40 -0700
Message-ID: <BANLkTikg=Gnh7UnLQUTfO7yA3kD3f7MK9YK4EUrbaPBsQBxKuQ@mail.gmail.com>
Subject: Re: [PATCH v8 11/12] writeback: make background writeback cgroup aware
To: Vivek Goyal <vgoyal@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Wed, Jun 8, 2011 at 1:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jun 07, 2011 at 09:02:21PM -0700, Greg Thelen wrote:
>
> [..]
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
>
> Ok, we seem to be mixing multiple things.
>
> - First of all, i thought running apps in root group is very valid
>  use case. Generally by default we run everything in root group and
>  once somebody notices that an application or group of application
>  is memory hog, that can be moved out in a cgroup of its own with
>  upper limits.
>
> - Secondly, root starvation issue is not present as long as we fall
>  back to normal way of writting inodes once we have crossed dirty
>  limit. But you had suggested that we move cgroup based writeout
>  above so that we always use same scheme for writeout and that
>  potentially will have root starvation issue.

To reduce the risk of breaking system writeback (by potentially
starting root inodes), my preference is to to retain this patch's
original ordering (first check and write towards system limits, only
if under system limits write per-cgroup).

> - If we don't move it up, then atleast it will not work for CFQ IO
>  controller.

As originally proposed, over_bground_thresh() would check system
background limit, and if over limit then write b_dirty, until under
system limit.  Then over_bground_thresh() checks cgroup background
limits, and if over limit(s) write over-limit-cgroup inodes until
cgroups are under their background limits.

How does the order of the checks in over_bground_thresh() affect CFQ
IO?  Are you referring to recently proposed block throttle patches,
which (AFAIK) throttle the rate at which a cgroup can produce dirty
pages as a way to approximate the rate that async dirty pages will be
written to disk?
