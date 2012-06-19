Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2FSDXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 23:23:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52359 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab2FSDXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:23:24 -0400
X-IronPort-AV: E=Sophos;i="4.77,434,1336320000"; 
   d="scan'208";a="5220232"
Message-ID: <4FDFF036.2000106@cn.fujitsu.com>
Date: Tue, 19 Jun 2012 11:21:26 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, a.p.zijlstra@chello.nl, jkosina@suse.cz,
        ebiederm@xmission.com, dhowells@redhat.com, keescook@chromium.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] futex: Do not leak robust list to unprivileged
 process
References: <20120319231253.GA20893@www.outflux.net> <tip-bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8@git.kernel.org> <4FDFD8AF.6030209@cn.fujitsu.com> <20120619022456.GA2949@sergelap> <4FDFE4B1.80500@cn.fujitsu.com> <20120619031306.GA3985@sergelap>
In-Reply-To: <20120619031306.GA3985@sergelap>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/19 11:23:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/19 11:23:48,
	Serialize complete at 2012/06/19 11:23:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 11:13 AM, Serge Hallyn wrote:
> Quoting Wanlong Gao (gaowanlong@cn.fujitsu.com):
>> On 06/19/2012 10:24 AM, Serge Hallyn wrote:
>>> Quoting Wanlong Gao (gaowanlong@cn.fujitsu.com):
>>>> On 03/29/2012 05:55 PM, tip-bot for Kees Cook wrote:
>>>>> Commit-ID:  bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
>>>>> Gitweb:     http://git.kernel.org/tip/bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
>>>>> Author:     Kees Cook <keescook@chromium.org>
>>>>> AuthorDate: Mon, 19 Mar 2012 16:12:53 -0700
>>>>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>>>>> CommitDate: Thu, 29 Mar 2012 11:37:17 +0200
>>>>>
>>>>> futex: Do not leak robust list to unprivileged process
>>>>>
>>>>> It was possible to extract the robust list head address from a setuid
>>>>> process if it had used set_robust_list(), allowing an ASLR info leak. This
>>>>> changes the permission checks to be the same as those used for similar
>>>>> info that comes out of /proc.
>>>>>
>>>>> Running a setuid program that uses robust futexes would have had:
>>>>>   cred->euid != pcred->euid
>>>>>   cred->euid == pcred->uid
>>>>> so the old permissions check would allow it. I'm not aware of any setuid
>>>>> programs that use robust futexes, so this is just a preventative measure.
>>>>>
>>>>
>>>> I'm not sure this change prevents the unprivileged process.
>>>> Please refer to LTP test, recently I saw that this change broke
>>>> the following test.
>>>>
>>>> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/get_robust_list/get_robust_list01.c#L155
>>>> 		if (seteuid(1) == -1)
>>>> 			tst_brkm(TBROK|TERRNO, cleanup, "seteuid(1) failed");
>>>>
>>>> 		TEST(retval = syscall(__NR_get_robust_list, 1,
>>>> 				      (struct robust_list_head *)&head,
>>>> 				      &len_ptr));
>>>>
>>>> We set the euid to an unprivileged user, and expect to FAIL with EPERM,
>>>> without this patch, it FAIL as we expected, but with it, this call succeed.
>>>
>>> This relates to a question I asked - I believe in this thread, maybe in
>>> another thread - about ptrace_may_access.  That code goes back further than
>>> our git history, and for so long has used current->uid and ->gid, not
>>> euid and gid, for permission checks.  I asked if that's what we really
>>> want, but at the same am not sure we want to change something that's
>>> been like that for so long.
>>>
>>> But that's why it succeeded - you changed your euid, not your uid.
>>
>> Yeah, I known what I'm doing.
> 
> Didn't mean to offend :)

Sorry for my poor words, I didn't mean that, either. ;)

> 
>> I just wonder which is the right thing.
>> Should we check euid or uid ? You mean that checking uid instead of
>> checking euid for a long time, right?
> 
> Yup, and I agree it seems wrong.

Are there any other places where also switch checking uid instead of euid ?
In this place, anyway, this syscall is already marked as deprecated.

Thanks,
Wanlong Gao

> 
> -serge
> 


