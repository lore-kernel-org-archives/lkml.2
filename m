Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab0LBRnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:43:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38892 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab0LBRni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YoY7njYUQ4JXjBfljmmmC2VaGmI04iN078m7wPmstX6CKV3XUAH1ldjE14KGudoiDP
         iG4V0IlxepG4aJNZypaXNtPCAOhXc3ub/zTjalYudRx+db3u6b7y5NXcIZnm2xOLtFrw
         PGqE8tKMmM/0Fwn9YRbE/n22XP2DRklNi87pE=
Date: Thu, 2 Dec 2010 18:43:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in  2.6.36
Message-ID: <20101202174328.GA1750@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
 <20101118163048.GE5374@nowhere>
 <201011261757.08303.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011261757.08303.roucaries.bastien@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 05:57:05PM +0100, Bastien ROUCARIES wrote:
> Dear frederic,
> > Hi Bastien,
> > 
> > This really looks like a hung task detector report.
> > Several tasks are stuck in queue_log_writer(), waiting
> > to be woken up on the "journal->j_join_wait" event and
> > that never happens because the waker is also stuck.
> > The problem is your report doesn't show where the waker
> > is stuck, but the hung task detector reports it, it just
> > did before or after the chunk you've posted.
> > 
> > If you could provide me the entire report, I could fix this
> > easily.
> 
> I have manged to reproduce it after six hour of stress. Unfornatly locked was 
> disabled due to a known non bug, in the init sequence. I have used sysrq -t in 
> order to get more information to you.
> 
> Do I need to try to reproduce it, with a newer kernel ? Or it is sufficient ?

> Nov 26 16:27:56 portablebastien kernel: [27960.775903] kded4         D 00000001006907a6     0  2852      1 0x00000000
> Nov 26 16:27:56 portablebastien kernel: [27960.777842]  ffff8800d8a97b28 0000000000000046 ffff880000000000 ffff880100000000
> Nov 26 16:27:56 portablebastien kernel: [27960.779768]  ffff8800d8a96010 ffff8800d8a97fd8 ffff8800379f4f60 ffff8800379f5230
> Nov 26 16:27:56 portablebastien kernel: [27960.781694]  ffff8800379f5228 0000000000014d80 0000000000014d80 ffff8800d8a97fd8
> Nov 26 16:27:56 portablebastien kernel: [27960.783594] Call Trace:
> Nov 26 16:27:56 portablebastien kernel: [27960.785483]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
> Nov 26 16:27:56 portablebastien kernel: [27960.787344]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
> Nov 26 16:27:56 portablebastien kernel: [27960.789253]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
> Nov 26 16:27:56 portablebastien kernel: [27960.791142]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
> Nov 26 16:27:56 portablebastien kernel: [27960.793070]  [<ffffffffa019ebb6>] reiserfs_create+0x105/0x233 [reiserfs]
> Nov 26 16:27:56 portablebastien kernel: [27960.794960]  [<ffffffff8110b57d>] ? generic_permission+0x17/0x9a
> Nov 26 16:27:56 portablebastien kernel: [27960.796854]  [<ffffffff81171e65>] ? security_inode_permission+0x1c/0x1e
> Nov 26 16:27:56 portablebastien kernel: [27960.798714]  [<ffffffff8110c423>] vfs_create+0x6b/0x8d
> Nov 26 16:27:56 portablebastien kernel: [27960.800570]  [<ffffffff8110cdee>] do_last+0x26c/0x532
> Nov 26 16:27:56 portablebastien kernel: [27960.802377]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
> Nov 26 16:27:56 portablebastien kernel: [27960.804232]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
> Nov 26 16:27:56 portablebastien kernel: [27960.806058]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
> Nov 26 16:27:56 portablebastien kernel: [27960.807911]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
> Nov 26 16:27:56 portablebastien kernel: [27960.809790]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> Nov 26 16:27:56 portablebastien kernel: [27960.811646]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
> Nov 26 16:27:56 portablebastien kernel: [27960.813506]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b

Ok, this time I don't have the feeling that a deadlock between reiserfs lock and
another lock is involved.

We entered queue_log_writer() and then waited for someone to call do_journal_end()
to testify he finished his job with the journal.

But somehow that didn't happen. Or may be we called queue_log_writer() but we shouldn't,
thinking there was a writer already but there wasn't. Or there is a crazy race somewhere.

On which kernel do you see this? Do you know a kernel on which you've never seen it.
Were you running something specific to trigger this deadlock?

Thanks!
