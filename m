Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0KXCLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:11:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab0KXCLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:11:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R45Y6cm7pww9Er4q9EPG1GW1IAnBE7B89gg00XyyMYDtYcRLUYVSu+0zWe4ev8qRhq
         qGSxRujU9MhFNANZYA0w==
MIME-Version: 1.0
In-Reply-To: <4CEC7329.7070909@cn.fujitsu.com>
References: <AANLkTikx6d0_VFtZ4zWQucRCf=vFt7N2M6=0jpnKasEE@mail.gmail.com>
	<1290398767-15230-1-git-send-email-ccross@android.com>
	<AANLkTi=4-OgPUugnUBaqSU3oC=3wxTjAsOB_Ais3Or+i@mail.gmail.com>
	<4CEC7329.7070909@cn.fujitsu.com>
Date: Tue, 23 Nov 2010 18:10:58 -0800
X-Google-Sender-Auth: 2U8kdo5MeKSk3izwfmvc77TdhlM
Message-ID: <AANLkTi=6nwDCdzDz7E2EaAw2pf3KUVjmKMRqGfz5zVhP@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Convert synchronize_rcu to call_rcu in cgroup_attach_task
From: Colin Cross <ccross@android.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 6:06 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Paul Menage wrote:
>> On Sun, Nov 21, 2010 at 8:06 PM, Colin Cross <ccross@android.com> wrote:
>>> The synchronize_rcu call in cgroup_attach_task can be very
>>> expensive.  All fastpath accesses to task->cgroups that expect
>>> task->cgroups not to change already use task_lock() or
>>> cgroup_lock() to protect against updates, and, in cgroup.c,
>>> only the CGROUP_DEBUG files have RCU read-side critical
>>> sections.
>>
>> I definitely agree with the goal of using lighter-weight
>> synchronization than the current synchronize_rcu() call. However,
>> there are definitely some subtleties to worry about in this code.
>>
>> One of the reasons originally for the current synchronization was to
>> avoid the case of calling subsystem destroy() callbacks while there
>> could still be threads with RCU references to the subsystem state. The
>> fact that synchronize_rcu() was called within a cgroup_mutex critical
>> section meant that an rmdir (or any other significant cgrooup
>> management action) couldn't possibly start until any RCU read sections
>> were done.
>>
>> I suspect that when we moved a lot of the cgroup teardown code from
>> cgroup_rmdir() to cgroup_diput() (which also has a synchronize_rcu()
>> call in it) this restriction could have been eased, but I think I left
>> it as it was mostly out of paranoia that I was missing/forgetting some
>> crucial reason for keeping it in place.
>>
>> I'd suggest trying the following approach, which I suspect is similar
>> to what you were suggesting in your last email
>>
>> 1) make find_existing_css_set ignore css_set objects with a zero refcount
>> 2) change __put_css_set to be simply
>>
>> if (atomic_dec_and_test(&cg->refcount)) {
>>   call_rcu(&cg->rcu_head, free_css_set_rcu);
>> }
>
> If we do this, it's not anymore safe to use get_css_set(), which just
> increments the refcount without checking if it's zero.

I used an alternate approach, removing the css_set from the hash table
in put_css_set, but delaying the deletion to free_css_set_rcu.  That
way, nothing can get another reference to the css_set to call
get_css_set on.
