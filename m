Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1AVCEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:04:13 -0500
Received: from smtp-out.google.com ([74.125.121.67]:37204 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1AVCEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:04:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o88TVk+elM3ydBpPL6rPGlZ/V7ntdMD/35R85tFuK2UkuEKqbEdj0BdefDsBLGhB05
         bSAcf1GM8axSpoFyU1dQ==
MIME-Version: 1.0
In-Reply-To: <4D3A3024.9040402@codeaurora.org>
References: <AANLkTi=4-OgPUugnUBaqSU3oC=3wxTjAsOB_Ais3Or+i@mail.gmail.com>
	<1290563018-2804-1-git-send-email-ccross@android.com>
	<4D3A3024.9040402@codeaurora.org>
Date: Fri, 21 Jan 2011 18:04:06 -0800
X-Google-Sender-Auth: fWzHe2shHz5kOFVZW5sdLaNKwt0
Message-ID: <AANLkTimEA2pjbWgB51GsqofreJtqT7QSr8cQ2xSMCa50@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
From: Colin Cross <ccross@android.com>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mbohan@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 5:17 PM, Bryan Huntsman <bryanh@codeaurora.org> wrote:
> On 11/23/2010 05:43 PM, Colin Cross wrote:
>> synchronize_rcu can be very expensive, averaging 100 ms in
>> some cases.  In cgroup_attach_task, it is used to prevent
>> a task->cgroups pointer dereferenced in an RCU read side
>> critical section from being invalidated by delaying the call
>> to put_css_set until after an RCU grace period.
>>
>> To avoid the call to synchronize_rcu, make the put_css_set
>> call rcu-safe by moving the deletion of the css_set links
>> into rcu-protected free_css_set_rcu.
>>
>> The calls to check_for_release in free_css_set_rcu now occur
>> in softirq context, so convert all uses of the
>> release_list_lock spinlock to irq safe versions.
>>
>> The decrement of the cgroup refcount is no longer
>> synchronous with the call to put_css_set, which can result
>> in the cgroup refcount staying positive after the last call
>> to cgroup_attach_task returns.  To allow the cgroup to be
>> deleted with cgroup_rmdir synchronously after
>> cgroup_attach_task, introduce a second refcount,
>> rmdir_count, that is decremented synchronously in
>> put_css_set.  If cgroup_rmdir is called on a cgroup for
>> hich rmdir_count is zero but count is nonzero, reuse the
>> rmdir waitqueue to block the rmdir until the rcu callback
>> is called.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>
>> This patch is similar to what you described.  The main differences are
>> that I used a new atomic to handle the rmdir case, and I converted
>> check_for_release to be callable in softirq context rather than schedule
>> work in free_css_set_rcu.  Your css_set scanning in rmdir sounds better,
>> I'll take another look at that.  Is there any problem with disabling irqs
>> with spin_lock_irqsave in check_for_release?
>>
>>  include/linux/cgroup.h |    6 ++
>>  kernel/cgroup.c        |  124 ++++++++++++++++++++++++++++--------------------
>>  2 files changed, 78 insertions(+), 52 deletions(-)
>>
>
> Colin, what became of this patch?  I see this in your Tegra tree for
> Android.
>
> http://android.git.kernel.org/?p=kernel/tegra.git;a=commit;h=05946a1e0fdb011ac0e6638ee60b181c584f127b
>
> I looked in linux-next but didn't see it there.  This resolves a
> performance issue on MSM SMP so I'm curious if this is going upstream.
>  Thanks.
>

It's been posted, there are no outstanding comments I am working on,
but they haven't been picked up.
