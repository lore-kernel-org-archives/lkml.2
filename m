Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966741Ab0GSUo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966583Ab0GSUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:44:56 -0400
Date: Mon, 19 Jul 2010 16:44:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, guijianfeng@cn.fujitsu.com,
        czoccolo@gmail.com
Subject: Re: [PATCH 1/3] cfq-iosched: Improve time slice charging logic
Message-ID: <20100719204446.GF32503@redhat.com>
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
 <1279560008-2905-2-git-send-email-vgoyal@redhat.com>
 <x49mxtntikn.fsf@segfault.boston.devel.redhat.com>
 <20100719185828.GB32503@redhat.com>
 <AANLkTikqd3VzLSkJfGoN0s29NzhkqJSYSPEEOS2s0TOn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikqd3VzLSkJfGoN0s29NzhkqJSYSPEEOS2s0TOn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 01:32:24PM -0700, Divyesh Shah wrote:
> On Mon, Jul 19, 2010 at 11:58 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Yes it is mixed now for default CFQ case. Whereever we don't have the
> > capability to determine the slice_used, we charge IOPS.
> >
> > For slice_idle=0 case, we should charge IOPS almost all the time. Though
> > if there is a workload where single cfqq can keep the request queue
> > saturated, then current code will charge in terms of time.
> >
> > I agree that this is little confusing. May be in case of slice_idle=0
> > we can always charge in terms of IOPS.
> 
> I agree with Jeff that this is very confusing. Also there are
> absolutely no bets that one job may end up getting charged in IOPs for
> this behavior while other jobs continue getting charged in timefor
> their IOs. Depending on the speed of the disk, this could be a huge
> advantage or disadvantage for the cgroup being charged in IOPs.
> 
> It should be black or white, time or IOPs and also very clearly called
> out not just in code comments but in the Documentation too.

Ok, how about always charging in IOPS when slice_idle=0?

So on fast devices, admin/user space tool, can set slice_idle=0, and CFQ
starts doing accounting in IOPS instead of time. On slow devices we
continue to run with slice_idle=8 and nothing changes.

Personally I feel that it is hard to sustain time based logic on high end
devices and still get good throughput. We could make CFQ a dual mode kind
of scheduler which is capable of doing accouting both in terms of time as
well as IOPS. When slice_idle !=0, we do accounting in terms of time and
it will be same CFQ as of today. When slice_idle=0, CFQ starts accounting
in terms of IOPS.

I think this change should bring us one step closer to our goal of one
IO sheduler for all devices.

Jens, what do you think?

Thanks
Vivek 
