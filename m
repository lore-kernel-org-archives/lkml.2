Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab0F2O4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:56:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab0F2O40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:56:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       "ocfs2-devel\@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com> <4C22F316.3080009@oracle.com>
	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
	<4C284419.3000905@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 29 Jun 2010 10:56:15 -0400
In-Reply-To: <4C284419.3000905@oracle.com> (Tao Ma's message of "Mon, 28 Jun
	2010 14:41:29 +0800")
Message-ID: <x49wrthlwfk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tao.ma@oracle.com> writes:

> Hi Jeff,
>
> On 06/27/2010 09:48 PM, Jeff Moyer wrote:
>> Tao Ma<tao.ma@oracle.com>  writes:
>>> I am sorry to say that the patch make jbd2 locked up when I tested
>>> fs_mark using ocfs2.
>>> I have attached the log from my netconsole server. After I reverted
>>> the patch [3/3], the box works again.
>>
>> I can't reproduce this, unfortunately.  Also, when building with the
>> .config you sent me, the disassembly doesn't line up with the stack
>> trace you posted.
>>
>> I'm not sure why yielding the queue would cause a deadlock.  The only
>> explanation I can come up with is that I/O is not being issued.  I'm
>> assuming that no other I/O will be completed to the file system in
>> question.  Is that right?  Could you send along the output from sysrq-t?
> yes, I just mounted it and begin the test, so there should be no
> outstanding I/O. So do you need me to setup another disk for test?
> I have attached the sysrq output in sysrq.log. please check.

Well, if it doesn't take long to reproduce, then it might be helpful to
see a blktrace of the run.  However, it might also just be worth waiting
for the next version of the patch to see if that fixes your issue.

> btw, I also met with a NULL pointer deference in cfq_yield. I have
> attached the null.log also. This seems to be related to the previous
> deadlock and happens when I try to remount the same volume after
> reboot and ocfs2 try to do some recovery.

 Pid: 4130, comm: ocfs2_wq Not tainted 2.6.35-rc3+ #5 0MM599/OptiPlex 745                  
 RIP: 0010:[<ffffffff82161537>] 
  [<ffffffff82161537>] cfq_yield+0x5f/0x135 
 RSP: 0018:ffff880123061c60  EFLAGS: 00010246 
 RAX: 0000000000000000 RBX: ffff88012c2b5ea8 RCX: ffff88012c3a30d0 

ffffffff82161528:	e8 69 eb ff ff       	callq  ffffffff82160096 <cfq_cic_lookup>
ffffffff8216152d:	49 89 c6             	mov    %rax,%r14
ffffffff82161530:	48 8b 85 00 06 00 00 	mov    0x600(%rbp),%rax
ffffffff82161537:	f0 48 ff 00          	lock incq (%rax)

I'm pretty sure that's a NULL pointer deref of the tsk->iocontext that
was passed into the yield function.  I've since fixed that, so your
recovery code should be safe in the newest version (which I've not yet
posted).

Cheers,
Jeff
