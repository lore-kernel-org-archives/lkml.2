Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2JRCQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:16:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56198 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2JRCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120929071318.GA7444@gmail.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAM_iQpVVCjJ0Bde9RS9Rm-0RJ=CtTyX3eUH45+oaaepvdAvAmQ@mail.gmail.com>
	<20120923202727.GA28937@mwanda>
	<CAE9FiQX-R1L-0LDZNTbk-a6SUog+=tTrdwcfr0QUczH_PLMMpw@mail.gmail.com>
	<20120929071318.GA7444@gmail.com>
Date: Thu, 18 Oct 2012 10:16:42 +0800
Message-ID: <CABqxG0czidut37LkwqH2_D44ng-HWHudjgZr9w8csqnGVUT0rA@mail.gmail.com>
Subject: Re: kexec/kdump kernel fails to start
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, ianfang.cn@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 3:13 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Sun, Sep 23, 2012 at 1:27 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Wed, Sep 05, 2012 at 11:34:25PM +0800, Cong Wang wrote:
>> >> On Wed, Sep 5, 2012 at 1:32 AM, Flavio Leitner <fbl@redhat.com> wrote:
>> >> > Hi folks,
>> >> >
>> >> > I have system that no longer boots kdump kernel. Basically,
>> >> >
>> >> > # echo c > /proc/sysrq-trigger
>> >> >
>> >> > to dump a vmcore doesn't work. It just hangs after showing the usual
>> >> > panic messages. I've bisected the problem and the commit introducing
>> >> > the issue is the one below.
>> >> >
>> >> > Any idea?
>> >> >
>> >> > commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8
>> >> > Author: WANG Cong <xiyou.wangcong@gmail.com>  2012-03-05 20:05:13
>> >> > Committer: Ingo Molnar <mingo@elte.hu>  2012-03-06 05:38:26
>> >> > Parent: 550cf00dbc8ee402bef71628cb71246493dd4500 (Merge tag 'mmc-fixes-for-3.3' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
>> >> > Child:  a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f (x86, tlb: Switch cr3 in leave_mm() only when needed)
>> >> > Branches: master, remotes/origin/master
>> >> > Follows: v3.3-rc6
>> >> > Precedes: v3.5-rc1
>> >> >
>> >> >     x86/mm: Fix the size calculation of mapping tables
>> >>
>> >> There was some attempt to fix this:
>> >> https://patchwork.kernel.org/patch/1195751/
>> >>
>> >> but for some reason it is not accepted.
>> >
>> > I filed a bug for this:
>> > https://bugzilla.kernel.org/show_bug.cgi?id=47881
>> >
>> > Is it fixed now?
>>
>> that offending patch should be reverted...
>>
>> 722bc6b16771ed80871e1fd81c86d3627dda2ac8
>
> It does not revert cleanly - could someone send a (kexec
> tested!) patch with a proper description?

Hi, ingo

Besides of commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8,
below commit also need revert.

commit bd2753b2dda7bb43c7468826de75f49c6a7e8965
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed Jun 6 10:55:40 2012 -0700

    x86/mm: Only add extra pages count for the first memory range
during pre-allocation early page table space

    Robin found this regression:

    | I just tried to boot an 8TB system.  It fails very early in boot with:
    | Kernel panic - not syncing: Cannot find space for the kernel page tables

    git bisect commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.

    A git revert of that commit does boot past that point on the 8TB
    configuration.

    That commit will add up extra pages for all memory range even
    above 4g.

    Try to limit that extra page count adding to first entry only.

    Bisected-by: Robin Holt <holt@sgi.com>
    Tested-by: Robin Holt <holt@sgi.com>
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Cc: WANG Cong <xiyou.wangcong@gmail.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t%3DMOzJ%3D9BZMYA@mail.gmail.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>



OTOH,  Jacob and Yinghai has better init_memory_mapping
cleanup patches which are in tip:x86/mm2 already.  Their patches fixes
this issue
as well.

Since kdump does not work for long time since
722bc6b16771ed80871e1fd81c86d3627dda2ac8
Can you or someone else help to get the init_memory_mapping patches merged?

Or do you still prefer to revert 722bc6b and bd2753b2d?  I think
stable kernel also need a fix.

-- 
Regards
Dave
