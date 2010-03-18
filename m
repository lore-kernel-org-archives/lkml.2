Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0CRDMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 23:12:32 -0400
Received: from smtpout2.superonline.com ([212.252.122.228]:49863 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0CRDMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 23:12:30 -0400
Message-ID: <4BA19A0F.4030507@superonline.com>
Date: Wed, 17 Mar 2010 23:12:15 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bisected Regression in 2.6.32.8] i915 with KMS enabled causesmemory corruption when resuming from suspend-to-disk
References: <4B9B1E8F.5090806@superonline.com> <201003132105.27127.rjw@sisk.pl>
In-Reply-To: <201003132105.27127.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 165 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -6.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/10 03:05 PM, Rafael J. Wysocki wrote:
> On Saturday 13 March 2010, M. Vefa Bicakci wrote:
>> Hello,
>>
>> As you can guess from the subject, I have noticed that enabling the
>> KMS feature of the i915 module with any kernel version after 2.6.32.7
>> causes memory corruption after one resumes from suspend-to-disk.
>>
>> My hardware is a Toshiba Satellite A100, with an Intel graphics card.
>> I am using an up-to-date version of Debian Sid. Here are the lspci 
>> entries for my graphics card:
>>
>> === 8< ===
>> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03) (prog-if 00 [VGA controller])
>> 00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
>> === >8 ===
>>
>> I have noticed that after upgrading from 2.6.32.7 to 2.6.32.9, I started
>> to get a lot of segfaults from different programs when I resume from
>> suspend-to-disk. After searching the Internet for this problem, I have
>> seen that some other people also had it, and that it wasn't a new problem
>> either: 
>>
>> http://bbs.archlinux.org/viewtopic.php?id=91375
>> https://bugzilla.redhat.com/show_bug.cgi?id=537494
>> http://bugzilla.kernel.org/show_bug.cgi?id=13811
>>
>> Even though some people say that they have had this problem for a long time,
>> I have only noticed it after upgrading to 2.6.32.9.
>>
>> After booting with "nomodeset" and confirming that the problem doesn't
>> happen with that kernel option, I have determined that the problem was
>> with i915.
>>
>> Then I used the following command to bisect the changes that i915 has
>> seen between 2.6.32.7 and 2.6.32.9:
>>
>> git bisect start v2.6.32.9 v2.6.32.7 -- ./drivers/gpu/drm/
>>
>> With each iteration in the bisection, I have tried at least 3 cycles
>> of suspend-to-disk and resume operations. I saw that all of the tried
>> versions had memory corruption issues after resume from suspend-to-disk.
>>
>> Then, git told me that the culprit is the first change to i915 after the
>> release 2.6.32.7. So 2.6.32.8 introduced the regression I am experiencing.
>> Here's the "git bisect log" output:
>>
>> === 8< ===
>> # bad: [7f5e918e62cbc9ac27c2f47d3c3dd4b86f67ff0e] Linux 2.6.32.9
>> # good: [b4bdd73ce865213a5653dc424873e8da37e858cc] Linux 2.6.32.7
>> git bisect start 'v2.6.32.9' 'v2.6.32.7' '--' './drivers/gpu/drm/'
>> # bad: [192ff23a2206eb5136c779bfed73171a4d214ad6] drm/i915: Add HP nx9020/SamsungSX20S to ACPI LID quirk list
>> git bisect bad 192ff23a2206eb5136c779bfed73171a4d214ad6
>> # bad: [6240058ce3725f5e708e1c17c3a676217e44ba9b] drm/i915: disable hotplug detect before Ironlake CRT detect
>> git bisect bad 6240058ce3725f5e708e1c17c3a676217e44ba9b
>> # bad: [61d4374b51386dd40c03fd15df5a7f97347de688] drm/i915: Reload hangcheck timer too for Ironlake
>> git bisect bad 61d4374b51386dd40c03fd15df5a7f97347de688
>> # bad: [d8e0902806c0bd2ccc4f6a267ff52565a3ec933b] drm/i915: Selectively enable self-reclaim
>> git bisect bad d8e0902806c0bd2ccc4f6a267ff52565a3ec933b
>>
>> d8e0902806c0bd2ccc4f6a267ff52565a3ec933b is the first bad commit
>> commit d8e0902806c0bd2ccc4f6a267ff52565a3ec933b
>> Author: Chris Wilson <chris@chris-wilson.co.uk>
>> Date:   Wed Jan 27 13:36:32 2010 +0000
>>
>>     drm/i915: Selectively enable self-reclaim
>>
>>     commit 4bdadb9785696439c6e2b3efe34aa76df1149c83 upstream.
>>
>>     Having missed the ENOMEM return via i915_gem_fault(), there are probably
>>     other paths that I also missed. By not enabling NORETRY by default these
>>     paths can run the shrinker and take memory from the system (but not from
>>     our own inactive lists because our shrinker can not run whilst we hold
>>     the struct mutex) and this may allow the system to survive a little longer
>>     whilst our drivers consume all available memory.
>>
>>     References:
>>       OOM killer unexpectedly called with kernel 2.6.32
>>       http://bugzilla.kernel.org/show_bug.cgi?id=14933
>>
>>     v2: Pass gfp into page mapping.
>>     v3: Use new read_cache_page_gfp() instead of open-coding.
>>
>>     ...
>> === >8 ===
>>
>> For the record, just to confirm that this commit is actually the culprit,
>> I took a vanilla 2.6.32.9 source tree and reverted only this commit. I am
>> happy to let you know that with this commit reverted, I can no longer
>> reproduce the memory corruption issue.
>>
>> However, as I noted above, some people have had this problem for a longer
>> time. So I am not sure if the commit above causes the bug or if it makes
>> the bug easier to trigger.
>>
>> Finally, I would like to note that this regression is going to be important,
>> because, as you know, Intel's X11 drivers are not going to support mode-setting
>> in user mode starting with version 2.10.0.
>>
>> If there is any help I can provide in fixing this regression, please let me
>> know. I am willing to try patches.
> 
> If I remember correctly, this has been fixed in the mainline, but I don't
> remember the exact commit right now.
> 
> Chris, Jesse, can you please help?
> 
> Rafael

Dear Rafael Wysocki,

I am sorry for the late reply. When you said that this problem had
been fixed in mainline, I thought that you meant the 2.6.34-rcX
series, because I had already tested 2.6.33 before sending my
original e-mail and confirmed that it had this problem as well.

So, with the hope of seeing this problem fixed, I tried git commit

a3d3203e4bb40f253b1541e310dc0f9305be7c84

(which happens to be the most recent version in the git repository
as of a few hours ago) but I am sorry to let you know that the
problem persists. After I resume from suspend to disk with this
version, I still get a lot of segfaults from newly started programs.

As I have mentioned in my original e-mail (which I left intact
above), I have already done a bisection and identified the git
commit which introduced this problem.

I believe that this is an important regression, and I know of
at least three more people who are affected by this problem.
If I remember correctly, you made a list of known regressions.
Would it be possible to create an entry in the list for this
bug, so that this regression will hopefully get more attention?

I would appreciate any help.

Regards,

M. Vefa Bicakci
