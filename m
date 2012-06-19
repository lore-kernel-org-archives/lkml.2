Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2FSDNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 23:13:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50498 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2FSDNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:13:20 -0400
Date: Mon, 18 Jun 2012 22:13:06 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, a.p.zijlstra@chello.nl, jkosina@suse.cz,
        ebiederm@xmission.com, dhowells@redhat.com, keescook@chromium.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] futex: Do not leak robust list to
 unprivileged process
Message-ID: <20120619031306.GA3985@sergelap>
References: <20120319231253.GA20893@www.outflux.net>
 <tip-bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8@git.kernel.org>
 <4FDFD8AF.6030209@cn.fujitsu.com>
 <20120619022456.GA2949@sergelap>
 <4FDFE4B1.80500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDFE4B1.80500@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Wanlong Gao (gaowanlong@cn.fujitsu.com):
> On 06/19/2012 10:24 AM, Serge Hallyn wrote:
> > Quoting Wanlong Gao (gaowanlong@cn.fujitsu.com):
> >> On 03/29/2012 05:55 PM, tip-bot for Kees Cook wrote:
> >>> Commit-ID:  bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
> >>> Gitweb:     http://git.kernel.org/tip/bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
> >>> Author:     Kees Cook <keescook@chromium.org>
> >>> AuthorDate: Mon, 19 Mar 2012 16:12:53 -0700
> >>> Committer:  Thomas Gleixner <tglx@linutronix.de>
> >>> CommitDate: Thu, 29 Mar 2012 11:37:17 +0200
> >>>
> >>> futex: Do not leak robust list to unprivileged process
> >>>
> >>> It was possible to extract the robust list head address from a setuid
> >>> process if it had used set_robust_list(), allowing an ASLR info leak. This
> >>> changes the permission checks to be the same as those used for similar
> >>> info that comes out of /proc.
> >>>
> >>> Running a setuid program that uses robust futexes would have had:
> >>>   cred->euid != pcred->euid
> >>>   cred->euid == pcred->uid
> >>> so the old permissions check would allow it. I'm not aware of any setuid
> >>> programs that use robust futexes, so this is just a preventative measure.
> >>>
> >>
> >> I'm not sure this change prevents the unprivileged process.
> >> Please refer to LTP test, recently I saw that this change broke
> >> the following test.
> >>
> >> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/get_robust_list/get_robust_list01.c#L155
> >> 		if (seteuid(1) == -1)
> >> 			tst_brkm(TBROK|TERRNO, cleanup, "seteuid(1) failed");
> >>
> >> 		TEST(retval = syscall(__NR_get_robust_list, 1,
> >> 				      (struct robust_list_head *)&head,
> >> 				      &len_ptr));
> >>
> >> We set the euid to an unprivileged user, and expect to FAIL with EPERM,
> >> without this patch, it FAIL as we expected, but with it, this call succeed.
> > 
> > This relates to a question I asked - I believe in this thread, maybe in
> > another thread - about ptrace_may_access.  That code goes back further than
> > our git history, and for so long has used current->uid and ->gid, not
> > euid and gid, for permission checks.  I asked if that's what we really
> > want, but at the same am not sure we want to change something that's
> > been like that for so long.
> > 
> > But that's why it succeeded - you changed your euid, not your uid.
> 
> Yeah, I known what I'm doing.

Didn't mean to offend :)

> I just wonder which is the right thing.
> Should we check euid or uid ? You mean that checking uid instead of
> checking euid for a long time, right?

Yup, and I agree it seems wrong.

-serge
