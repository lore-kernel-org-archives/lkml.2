Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0JETuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:50:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0JETuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v9lha8IYXdoYmD1yESTEs0mtNhsDmMgGY+EJF2I+xOJUB3cy02GJ6AA6hwRDCXc/A7
         lSOd2FAoH2F/nQxezqag==
MIME-Version: 1.0
In-Reply-To: <20101005124802.989f6214.akpm@linux-foundation.org>
References: <cover.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
	<2acb25707f916de866aa520b1a9f04f0f48c949c.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
	<20101005124802.989f6214.akpm@linux-foundation.org>
Date: Tue, 5 Oct 2010 12:50:41 -0700
Message-ID: <AANLkTi=W7-aA1kG7-BQf7j0Yoykb2fY0gnLyQXsz1JMK@mail.gmail.com>
Subject: Re: [PATCH 1/1] cgroups: strcpy destination string overflow
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, bblum@andrew.cmu.edu,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 12:48 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue,  5 Oct 2010 12:38:05 +0400
> Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com> wrote:
>
>> From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
>>
>> Function "strcpy" is used without check for maximum allowed source
>> string length and could cause destination string overflow.
>> Check for string length is added before using "strcpy".
>> Function now is return error if source string length is more than
>> a maximum.
>>
>> Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
>> ---
>>  kernel/cgroup.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index c9483d8..82bbede 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1883,6 +1883,8 @@ static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
>>                                     const char *buffer)
>>  {
>>       BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
>> +     if (strlen(buffer) >= PATH_MAX)
>> +             return -EINVAL;
>>       if (!cgroup_lock_live_group(cgrp))
>>               return -ENODEV;
>>       strcpy(cgrp->root->release_agent_path, buffer);
>
> I don't think this can happen, because cftype.max_write_len is
> PATH_MAX.

Yes, it shouldn't be possible.

>
> But it's pretty unobvious if this is actually true, and the code is
> fragile against future changes.

Fair enough - adding the check doesn't hurt anything.

Acked-by: Paul Menage <menage@google.com>
