Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0ERKfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:35:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48615 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab0ERKfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:35:17 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
	<m1wrv13dam.fsf@fess.ebiederm.org>
	<20100518175451.a01e314b.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 18 May 2010 03:35:10 -0700
In-Reply-To: <20100518175451.a01e314b.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Tue\, 18 May 2010 17\:54\:51 +1000")
Message-ID: <m1iq6lh50h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: sfr@canb.auug.org.au, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: build failure after merge of the driver-core tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> On Tue, 18 May 2010 00:00:01 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
>>
>> Stephen what is the easiest way to get a copy of Al's tree so I can take
>> a look to see what needs to happen?
>
> It is here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git#for-next
>
> [The latest list of trees included in linux-next can always be found here:
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/Trees]

Thanks.

I will cook up a proper incremental patch after I get some sleep.  Stephen
it appears those two lines you have commented out are actually unnecessary.

We have
deactivate_super
  kill_sb aka sysfs_kill_sb
    kill_anon_super
      generic_shutdown_super
         sb_lock
         list_del(sb->s_instances)
         sb_unlock
  kfree(info)

Nothing generic stomps on s_fs_info.

Which means that if I find a superblock on sb->s_instances sb->s_fs_info
still points to a valid sysfs_super_info.





As as for the race Al mentions between sysfs_exit_ns and
sysfs_readdir, I looked and a small race has crept in.  The primary
prevention of problems is that all matching sysfs_dirents for that
namespace are required to be removed before sysfs_exit_ns is called.

What remains is the tiniest of races where a namespace structure is
freed and a new namespace structure of the same type is allocated at
the same address and sysfs_dirents for it are created, all during the
a single kernel readdir operation.  Possible with slabs, and
copy_to_user triggering a page fault.  Still the worst case is that we
tell userspace some name that it wasn't supposed to see on that mount
point.  From a userspace point of view this seems to fall under a
readdir implementations license to return some odd things if the
directory is changing during the readdir call.  Overall we do preserve
the property of returning everything that is in the directory between
opendir and the time readdir his the end of file.

Eric
