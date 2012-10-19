Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2JSG5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:57:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48030 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2JSG5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:57:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121019124454.316ecfac@notabene.brown>
References: <CADpTngUPcX71qjE2QKhYqgDg7tZoz+pu8A6nE9DT-zbFKWGx1g@mail.gmail.com>
	<20121018212357.GA17646@quack.suse.cz>
	<1350596425.1366.15.camel@x61.thuisdomein>
	<20121018220809.GD17646@quack.suse.cz>
	<20121019124454.316ecfac@notabene.brown>
Date: Fri, 19 Oct 2012 08:57:42 +0200
Message-ID: <CADpTngX=6vWV1fv8x-g8ufKTb3gW2=phPZBHZJHATEcqqjwtYg@mail.gmail.com>
Subject: Re: ext3 issue on 3.6.1
From: Fabio Coatti <fabio.coatti@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/19 NeilBrown <neilb@suse.de>:
> On Fri, 19 Oct 2012 00:08:09 +0200 Jan Kara <jack@suse.cz> wrote:
>
>> On Thu 18-10-12 23:40:25, Paul Bolle wrote:
>> > On Thu, 2012-10-18 at 23:23 +0200, Jan Kara wrote:
>> > > On Fri 12-10-12 14:57:55, Fabio Coatti wrote:
>> > > > [13031.051521] ------------[ cut here ]------------
>> > > > [13031.051576] WARNING: at fs/inode.c:280 drop_nlink+0x1b/0x35()
>> > > > [13031.051624] Hardware name: ProLiant BL465c G7
>> > > > [13031.051668] Pid: 3344, comm: php Tainted: G        W
>> > > > 3.6.1-1000hz-preempt #2
>> > > > [13031.051746] Call Trace:
>> > > > [13031.051787]  [<ffffffff810578c4>] ? warn_slowpath_common+0x73/0x87
>> > > > [13031.051837]  [<ffffffff810ec628>] ? drop_nlink+0x1b/0x35
>> > > > [13031.051885]  [<ffffffff8118ad51>] ? nfs_dentry_iput+0x33/0x49
>> > > > [13031.051934]  [<ffffffff810ea920>] ? d_kill+0xe8/0x108
>> > > > [13031.051980]  [<ffffffff810eb001>] ? dput+0x147/0x154
>> > > > [13031.052027]  [<ffffffff810d9e46>] ? __fput+0x19a/0x1b2
>> > > > [13031.052073]  [<ffffffff8106bdf0>] ? task_work_run+0x4c/0x60
>> > > > [13031.052123]  [<ffffffff815ff5e8>] ? int_signal+0x12/0x17
>> > > > [13031.052169] ---[ end trace e60232a455c8e2dd ]---
>> > >   And this seems unrelated - likely an NFS problem... Let's sort this out
>> > > if you still see it after ext3 issue is solved.
>> >
>> > Looks rather similar too https://lkml.org/lkml/2012/8/29/165 , doesn't
>> > it?
>>   Yup. I wonder why that patch didn't get merged. Neil?
>>
>>                                                               Honza
>
> Don't know.  Maybe I slipped under Trond's radar some how.
>
> Trond:  can you comment on and hopefully apply this patch?
>
> Subject of original email was "WARNING: at fs/inode.c:280 drop_nlink+0x31/0x33()

I'll apply this patch and see what happens, I guess it applies also to
3.6.2 where I still see the warning. Could this be a culprit for
several server lockups that we are seeing in 3.6.X machines and not in
2.6.39.X? I'm running some tests with 3.6.X with same setup of other
machines wth 2.6.39.X and where the new kernel is installed at least
once a day the machines lockups (not a reassuring thing :) . To answer
to previous questions, yes, the server has a ext3 read only mount and
no, the logs shows no other weird things besides the one I posted
before (see below for a fresh one on 3.6.2). The server has several
nfs mounts, all R/W.

[  207.558585] ------------[ cut here ]------------
[  207.558692] WARNING: at fs/ext3/inode.c:1754
ext3_journalled_writepage+0x55/0x1a7()
[  207.558816] Hardware name: ProLiant BL465c G7
[  207.558905] Pid: 2741, comm: flush-8:0 Not tainted 3.6.2-hll-2scsi #1
[  207.559000] Call Trace:
[  207.559087]  [<ffffffff81057884>] ? warn_slowpath_common+0x73/0x87
[  207.559183]  [<ffffffff8115ccc2>] ? ext3_journalled_writepage+0x55/0x1a7
[  207.559282]  [<ffffffff810a2833>] ? __writepage+0xa/0x21
[  207.559375]  [<ffffffff810a31db>] ? write_cache_pages+0x206/0x2f8
[  207.559470]  [<ffffffff810a2829>] ? set_page_dirty+0x5e/0x5e
[  207.559565]  [<ffffffff8107a81b>] ? load_balance+0xd7/0x5cc
[  207.559658]  [<ffffffff810a330b>] ? generic_writepages+0x3e/0x55
[  207.559755]  [<ffffffff810f4eb0>] ? __writeback_single_inode+0x39/0xd1
[  207.559851]  [<ffffffff810f5c69>] ? writeback_sb_inodes+0x206/0x392
[  207.559946]  [<ffffffff810f5e5c>] ? __writeback_inodes_wb+0x67/0xa2
[  207.560040]  [<ffffffff810f5ffa>] ? wb_writeback+0xfd/0x18b
[  207.560134]  [<ffffffff810a36d1>] ? bdi_dirty_limit+0x27/0x81
[  207.560227]  [<ffffffff810f61c5>] ? wb_do_writeback+0x13d/0x1a2
[  207.560322]  [<ffffffff81061e9b>] ? add_timer_on+0x61/0x61
[  207.560414]  [<ffffffff810f62a9>] ? bdi_writeback_thread+0x7f/0x13e
[  207.560509]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
[  207.560603]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
[  207.560698]  [<ffffffff8106e134>] ? kthread+0x81/0x89
[  207.560791]  [<ffffffff81607b74>] ? kernel_thread_helper+0x4/0x10
[  207.560886]  [<ffffffff8106e0b3>] ? kthread_worker_fn+0xe0/0xe0
[  207.560979]  [<ffffffff81607b70>] ? gs_change+0xb/0xb
[  207.561069] ---[ end trace 5de5f6a314770eda ]---


Thanks for all the answers!


-- 
Fabio
