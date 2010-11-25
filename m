Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0KYALj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:11:39 -0500
Received: from smtp-out.google.com ([74.125.121.35]:32702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0KYALi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dfPdX4sJG97kemsWYh/d7xcEzvpDblMQjGvHjXPonoQAQDpvVODKMAWmnebqo2SJER
         Bmkzze7mhCDN1VMuW7Qw==
MIME-Version: 1.0
In-Reply-To: <AANLkTimFqJ+qPidS_81DKd7ExSxDG7GNi0gjcUEEq_7j@mail.gmail.com>
References: <AANLkTi=6nwDCdzDz7E2EaAw2pf3KUVjmKMRqGfz5zVhP@mail.gmail.com>
	<1290577024-12347-1-git-send-email-ccross@android.com>
	<AANLkTimFqJ+qPidS_81DKd7ExSxDG7GNi0gjcUEEq_7j@mail.gmail.com>
Date: Wed, 24 Nov 2010 16:11:34 -0800
X-Google-Sender-Auth: uSI5zJtMgNZmMdHsbv0Ug75d3k8
Message-ID: <AANLkTimwvP2Ey1gJ6AbbFNtDKjGZt4cwqL=08nGBa_PT@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
From: Colin Cross <ccross@android.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 3:54 PM, Paul Menage <menage@google.com> wrote:
> On Tue, Nov 23, 2010 at 9:37 PM, Colin Cross <ccross@android.com> wrote:
>> @@ -364,12 +372,8 @@ static void __put_css_set(struct css_set *cg, int taskexit)
>>                struct cgroup *cgrp = link->cgrp;
>>                list_del(&link->cg_link_list);
>>                list_del(&link->cgrp_link_list);
>> -               if (atomic_dec_and_test(&cgrp->count) &&
>> -                   notify_on_release(cgrp)) {
>> -                       if (taskexit)
>> -                               set_bit(CGRP_RELEASABLE, &cgrp->flags);
>> +               if (atomic_dec_and_test(&cgrp->count))
>>                        check_for_release(cgrp);
>> -               }
>
> We seem to have lost some notify_on_release() checks - maybe move that
> to check_for_release()?
check_for_release immediately calls cgroup_is_releasable, which checks
for the same bit as notify_on_release.  There's no need for
CGRP_RELEASABLE to depend on notify_on_release, or to check
notify_on_release before calling check_for_release.

>>  /* Caller must verify that the css is not for root cgroup */
>> +void __css_get(struct cgroup_subsys_state *css, int count)
>> +{
>> +       atomic_add(count, &css->refcnt);
>> +       set_bit(CGRP_RELEASABLE, &css->cgroup->flags);
>> +}
>
> Is css_get() the right place to be putting this? It's not clear to me
> why a subsystem taking a refcount on a cgroup's state should render it
> releasable when it drops that refcount.
I matched the existing behavior, __css_put sets CGRP_RELEASABLE when
refcnt goes to 0.

> Should we maybe clear the CGRP_RELEASABLE flag right before doing the
> userspace callback?
Actually, I think CGRP_RELEASABLE can be dropped entirely.
check_for_release is only called from __css_put, cgroup_rmdir, and
__put_css_set (or free_css_set_work after my second patch).  Those all
imply that __css_get, get_css_set, or cgroup_create have been
previously called, which are the functions that set CGRP_RELEASABLE.
