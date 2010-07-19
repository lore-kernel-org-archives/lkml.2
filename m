Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966827Ab0GSVTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:19:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60082 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966812Ab0GSVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IoogMpGbRQD5zQeIw8mIcVbryycYvKyOQj5SCRFpYQ5Dd+H0fXYNs4k9cZBnAA/NCP
         OQdYy2LupUb++9IJ8MdBSXQIAu51vM1b1BDmx0QwPtNWKOtKLulCet25QHuZA9D7eAv/
         Tvd3ErqsV8KFXhLwrE23WOpc4FH08BxXooaxY=
MIME-Version: 1.0
In-Reply-To: <20100719204446.GF32503@redhat.com>
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
	<1279560008-2905-2-git-send-email-vgoyal@redhat.com>
	<x49mxtntikn.fsf@segfault.boston.devel.redhat.com>
	<20100719185828.GB32503@redhat.com>
	<AANLkTikqd3VzLSkJfGoN0s29NzhkqJSYSPEEOS2s0TOn@mail.gmail.com>
	<20100719204446.GF32503@redhat.com>
Date: Mon, 19 Jul 2010 23:19:21 +0200
Message-ID: <AANLkTinIj5v7kYdZWFEpNP6RnF45BpT1N4U1smA0W5r2@mail.gmail.com>
Subject: Re: [PATCH 1/3] cfq-iosched: Improve time slice charging logic
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Divyesh Shah <dpshah@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        guijianfeng@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Jul 19, 2010 at 01:32:24PM -0700, Divyesh Shah wrote:
>> On Mon, Jul 19, 2010 at 11:58 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Yes it is mixed now for default CFQ case. Whereever we don't have the
>> > capability to determine the slice_used, we charge IOPS.
>> >
>> > For slice_idle=0 case, we should charge IOPS almost all the time. Though
>> > if there is a workload where single cfqq can keep the request queue
>> > saturated, then current code will charge in terms of time.
>> >
>> > I agree that this is little confusing. May be in case of slice_idle=0
>> > we can always charge in terms of IOPS.
>>
>> I agree with Jeff that this is very confusing. Also there are
>> absolutely no bets that one job may end up getting charged in IOPs for
>> this behavior while other jobs continue getting charged in timefor
>> their IOs. Depending on the speed of the disk, this could be a huge
>> advantage or disadvantage for the cgroup being charged in IOPs.
>>
>> It should be black or white, time or IOPs and also very clearly called
>> out not just in code comments but in the Documentation too.
>
> Ok, how about always charging in IOPS when slice_idle=0?
>
> So on fast devices, admin/user space tool, can set slice_idle=0, and CFQ
> starts doing accounting in IOPS instead of time. On slow devices we
> continue to run with slice_idle=8 and nothing changes.
>
> Personally I feel that it is hard to sustain time based logic on high end
> devices and still get good throughput. We could make CFQ a dual mode kind
> of scheduler which is capable of doing accouting both in terms of time as
> well as IOPS. When slice_idle !=0, we do accounting in terms of time and
> it will be same CFQ as of today. When slice_idle=0, CFQ starts accounting
> in terms of IOPS.
There is an other mode in which cfq can operate: for ncq ssds, it
basically ignores slice_idle, and operates as if it was 0.
This mode should also be handled as an IOPS counting mode.
SSD mode, though, differs from rotational mode for the definition of
"seekyness", and we should think if this mode is appropriate also for
the other hardware where slice_idle=0 is beneficial.
>
> I think this change should bring us one step closer to our goal of one
> IO sheduler for all devices.

I think this is an interesting instance of a more general problem: cfq
needs a cost function applicable to all requests on any hardware. The
current function is a concrete one (measured time), but unfortunately
it is not always applicable, because:
- for fast hardware the resolution is too coarse (this can be fixed
using higher resolution timers)
- for hardware that allows parallel dispatching, we can't measure the
cost of a single request (can we try something like average cost of
the requests executed in parallel?).
IOPS, instead, is a synthetic cost measure. It is a simplified model,
that will approximate some devices (SSDs) better than others
(multi-spindle rotational disks). But if we want to go for the
synthetic path, we can have more complex measures, that also take into
account other parameters, as sequentiality of the requests, their size
and so on, all parameters that may have still some impact on high-end
devices.

Thanks,
Corrado
>
> Jens, what do you think?
>
> Thanks
> Vivek
