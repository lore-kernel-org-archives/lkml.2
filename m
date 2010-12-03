Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0LCDHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 22:07:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab0LCDHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 22:07:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=swAFwby7Qm/uQZ4vUwNB0wd8xSxQ6xIg2ahOVcN7AqOoOw7wh533CYUos37nJJq8ML
         RcT9Y/0uRXzvggzKw1AA==
MIME-Version: 1.0
In-Reply-To: <AANLkTimJA52-GTM=AzS+tkOugrsi6Keh0_j87vK1BkGv@mail.gmail.com>
References: <AANLkTi=6nwDCdzDz7E2EaAw2pf3KUVjmKMRqGfz5zVhP@mail.gmail.com>
	<1290577024-12347-1-git-send-email-ccross@android.com>
	<AANLkTimFqJ+qPidS_81DKd7ExSxDG7GNi0gjcUEEq_7j@mail.gmail.com>
	<AANLkTimwvP2Ey1gJ6AbbFNtDKjGZt4cwqL=08nGBa_PT@mail.gmail.com>
	<AANLkTimJA52-GTM=AzS+tkOugrsi6Keh0_j87vK1BkGv@mail.gmail.com>
Date: Thu, 2 Dec 2010 19:07:12 -0800
X-Google-Sender-Auth: W_2Ldcyv9zx3Gv1CJTj-7NL0K8k
Message-ID: <AANLkTim67fLN+PYz-P0TM0QRmvQKP80tyXSNKNSZhFZ2@mail.gmail.com>
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

On Wed, Nov 24, 2010 at 4:21 PM, Paul Menage <menage@google.com> wrote:
> On Wed, Nov 24, 2010 at 4:11 PM, Colin Cross <ccross@android.com> wrote:
>>>
>>> We seem to have lost some notify_on_release() checks - maybe move that
>>> to check_for_release()?
>> check_for_release immediately calls cgroup_is_releasable, which checks
>> for the same bit as notify_on_release.  There's no need for
>> CGRP_RELEASABLE to depend on notify_on_release, or to check
>> notify_on_release before calling check_for_release.
>
> OK.
>
>> I matched the existing behavior, __css_put sets CGRP_RELEASABLE when
>> refcnt goes to 0.
>>
>
> Ah, we do appear to have had that behaviour for a while. I don't
> remember the justification for it at this point :-)
>
>> check_for_release is only called from __css_put, cgroup_rmdir, and
>> __put_css_set (or free_css_set_work after my second patch).  Those all
>> imply that __css_get, get_css_set, or cgroup_create have been
>> previously called, which are the functions that set CGRP_RELEASABLE.
>
> Not in one case - if we create a new cgroup and try to move a thread
> into it, but the thread is exiting as we move it, we'll call
> put_css_set() on the new css_set, which will drop the refcount on the
> target cgroup back to 0. We wouldn't want the auto-release
> notification to kick in in that situation, I think.

Clearing the CGRP_RELEASABLE bit any time after the tests in
check_for_release introduces a race if __css_get is called between the
check and clearing the bit - the cgroup will have an entry, but the
bit will not be set.  Without additional locking in __css_get, I don't
see any way to safely clear CGRP_RELEASABLE.
