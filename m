Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0H0BUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:20:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48443 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0H0BUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=v00Tgv6XK8knZ00x7vZnZC+mtchw/aEm1spViljnHaFxMcdq875lAIK+8KxyMnx1lM
         mMdIN+e8lTYRp9V309qlIgEgQXr4sUBT5jdCB7yjUNokUk1Tq4J2rvnFWPg2y1MGpDLz
         XPxeEoUeeOQEpTbgZfgm5vietHfH+NyaiBu94=
MIME-Version: 1.0
In-Reply-To: <20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
	<20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
Date: Fri, 27 Aug 2010 06:50:44 +0530
X-Google-Sender-Auth: 98zM79fGVVqq_QUqaznb0p0k3_c
Message-ID: <AANLkTi=YaUTVWQ23SVE250hd+qMgdTGvk0fZ4J5zPmkh@mail.gmail.com>
Subject: Re: cgroup: rmdir() does not complete
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Mark Hills <mark@pogo.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 6:26 AM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> Hi.
>
> On Thu, 26 Aug 2010 16:51:55 +0100 (BST)
> Mark Hills <mark@pogo.org.uk> wrote:
>
>> I am experiencing hung tasks when trying to rmdir() on a cgroup. One task
>> spins, others queue up behind it with the following:
>>
>>   INFO: task soaked-cgroup:27257 blocked for more than 120 seconds.
>>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>   soaked-cgrou D ffff8800058157c0     0 27257  29411 0x00000000
>>   ffff88004ffffdd8 0000000000000086 ffff88004ffffda8 ffff88004ffffeb8
>>   0000000000000010 ffff880119813780 ffff88004ffffd48 ffff88004fffffd8
>>   ffff88004fffffd8 000000000000f9b0 00000000000157c0 ffff880137693268
>>   Call Trace:
>>   [<ffffffff81115edb>] ? mntput_no_expire+0x24/0xe7
>>   [<ffffffff81427acd>] __mutex_lock_common+0x14d/0x1b4
>>   [<ffffffff81108a7c>] ? path_put+0x1d/0x22
>>   [<ffffffff81427b48>] __mutex_lock_slowpath+0x14/0x16
>>   [<ffffffff81427c4f>] mutex_lock+0x31/0x4b
>>   [<ffffffff8110bdf8>] do_rmdir+0x74/0x102
>>   [<ffffffff8110bebd>] sys_rmdir+0x11/0x13
>>   [<ffffffff81009b02>] system_call_fastpath+0x16/0x1b
>>
>> Kernel is from Fedora, 2.6.33.6. In all cases the cgroup contains no
>> tasks.
>>
>> Commit ec64f5 ("fix frequent -EBUSY at rmdir") adds a busy wait loop to
>> the rmdir. It looks like what I am seeing here and indicates that some
>> cgroup subsystem is busy, indefinitely.
>>
> The commit had caused a bug about rmdir, but it was fixed by the commit 88703267.
> The fix was merged in 2.6.31, so it seems that you hit a new one...
>
>> I have not worked out how to reproduce it quickly. My only way is to
>> complete a 'dd' command in the cgroup, but then the problem is so rare it
>> is slow progress.
>>
>> Documentation/cgroup.memory.txt describes how force_empty can be required
>> in some cases. Does this mean that with the patch above, these cases will
>> now spin on rmdir(), instead of returning -EBUSY? How can produce a
>> reliable test case requiring memory.force_empty to be used, to test this?
>>
> You don't need to touch "force_empty". rmdir() does what "force_empty" does.
>
>> Or is it likely to be some other cause, and how best to find it?
>>
> What cgroup subsystem did you mount where the directory existed you tried
> to rmdir() first ?
> If you mounted several subsystems on the same hierarchy, can you mount them
> separately to narrow down the cause ?
>

It would also be nice to see what your mounted cgroup (filesystem
perspective) looks like and what /proc/cgroups looks like when the
problem occurs.

Balbir
