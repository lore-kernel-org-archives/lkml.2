Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2JPWdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:33:07 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61906 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2JPWdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <20121016071101.GA5172@kroah.com>
References: <EE928378561BF1449699C96571234A740FE67913@SHSMSX102.ccr.corp.intel.com>
	<EE928378561BF1449699C96571234A740FE67A7D@SHSMSX102.ccr.corp.intel.com>
	<20121015225252.GA14167@kroah.com>
	<CAMP5Xgfo3u5QoKmkOpCyxHaEkCScWwKFDLnfQMH3mevcrF7aJQ@mail.gmail.com>
	<20121015235836.GA3214@kroah.com>
	<CAMP5Xgdh2=k+3qVEEHO81uxqHZSevJfG0jVyv936-zpB+P+0vg@mail.gmail.com>
	<20121016071101.GA5172@kroah.com>
Date: Tue, 16 Oct 2012 15:33:03 -0700
Message-ID: <CAMP5XgeEKbAEj4RB4BRgPravPzPt4K=9kvNTsjR8Ets2dQjDrQ@mail.gmail.com>
Subject: Re: Fix memory leak in binder--version2
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "ccross@android.com" <ccross@android.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zhang, Di" <di.zhang@intel.com>, "Ma, Xindong" <xindong.ma@intel.com>,
        "Zuo, Alex" <alex.zuo@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:11 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 15, 2012 at 05:39:22PM -0700, Arve Hjønnevåg wrote:
>> On Mon, Oct 15, 2012 at 4:58 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Oct 15, 2012 at 04:55:21PM -0700, Arve Hjønnevåg wrote:
>> >> On Mon, Oct 15, 2012 at 3:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> > On Mon, Oct 15, 2012 at 07:20:01AM +0000, Tu, Xiaobing wrote:
>> >> >> After enabling kmemleak and run monkey, following memleak is reported:
>> >> >> unreferenced object 0xeed27f80 (size 64):
>> >> >>   comm "Binder_8", pid 641, jiffies 4294946341 (age 2275.810s)
>> >> >>   hex dump (first 32 bytes):
>> >> >>     4f dd 00 00 84 7f d2 ee 84 7f d2 ee 01 00 00 00  O...............
>> >> >>     00 00 00 00 00 00 00 00 00 aa 4c d7 00 00 00 00  ..........L.....
>> >> >>   backtrace:
>> >> >>     [<c184fabc>] kmemleak_alloc+0x3c/0xa0
>> >> >>     [<c12f391e>] kmem_cache_alloc_trace+0x9e/0x180
>> >> >>     [<c1668bb5>] binder_thread_write+0xcf5/0x23a0
>> >> >>     [<c166b091>] binder_ioctl+0x1f1/0x530
>> >> >>     [<c130dcf6>] do_vfs_ioctl+0x86/0x5e0
>> >> >>     [<c130e282>] sys_ioctl+0x32/0x60
>> >> >>     [<c1872e01>] syscall_call+0x7/0xb
>> >> >>     [<ffffffff>] 0xffffffff
>> >> >>
>> >> >> The work item in async_todo list is not freed when binder released.
>> >> >> Also the async transaction should also be freed in binder_release_work.
>> >> >>
>> >> >> Signed-off-by: Leon Ma <xindong.ma@intel.com>
>> >> >> Signed-off-by: Di Zhang <di.zhang@intel.com>
>> >> >> ---
>> >> >>  drivers/staging/android/binder.c |    6 ++++++
>> >> >>  1 files changed, 6 insertions(+), 0 deletions(-)
>> >> >
>> >> > Nice fix, but next time can you at least use scripts/get_maintainer.pl
>> >> > to figure out who to send this to?  I'll queue it up soon, but it took
>> >> > akpm to point me at this for me to notice it.
>> >>
>> >> This patch was just pointer out to me as well. I have a similar fix
>> >> queued up at https://android-review.googlesource.com/#/c/43801/ that
>> >> is still being tested. It fixes this leak and a theoretical leak of
>> >> death notification objects.
>> >
>> > Ok, should I hold off applying this patch and wait for your patch
>> > instead?
>> >
>>
>> I just sent two patches, but they are not fully tested yet.
>
> Ok, care to test them and after that, resend them with the changes I
> noted in the changelog section of the patch?
>

All the new cleanup code has been tested now. I also included two
older patches that are not in mainline.

-- 
Arve Hjønnevåg
