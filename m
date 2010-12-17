Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab0LQBMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:12:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18423 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0LQBMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bvaQHENMh/nQ7jOddYmHoN4nugWrjTS2EHRtDeUkZJwXtDoQDAz20FgkvGivqDXTN1
         B9h4sEQrV9vBwkTo2XGA==
MIME-Version: 1.0
In-Reply-To: <AANLkTinZarXbEyb1xfJWjG4gN2qhTVTXTdso4Cym5M9T@mail.gmail.com>
References: <AANLkTi=6nwDCdzDz7E2EaAw2pf3KUVjmKMRqGfz5zVhP@mail.gmail.com>
	<1290577024-12347-1-git-send-email-ccross@android.com>
	<AANLkTimFqJ+qPidS_81DKd7ExSxDG7GNi0gjcUEEq_7j@mail.gmail.com>
	<AANLkTimwvP2Ey1gJ6AbbFNtDKjGZt4cwqL=08nGBa_PT@mail.gmail.com>
	<AANLkTimJA52-GTM=AzS+tkOugrsi6Keh0_j87vK1BkGv@mail.gmail.com>
	<AANLkTim67fLN+PYz-P0TM0QRmvQKP80tyXSNKNSZhFZ2@mail.gmail.com>
	<AANLkTinZarXbEyb1xfJWjG4gN2qhTVTXTdso4Cym5M9T@mail.gmail.com>
Date: Thu, 16 Dec 2010 17:12:42 -0800
X-Google-Sender-Auth: dsKDJJGtmri7rNltwmrcvDG9cKw
Message-ID: <AANLkTinf5dqjE+Q1Qr3RZRa2a9CygA9vc+xgpjVSzPdw@mail.gmail.com>
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

On Thu, Dec 16, 2010 at 4:54 PM, Paul Menage <menage@google.com> wrote:
> On Thu, Dec 2, 2010 at 7:07 PM, Colin Cross <ccross@android.com> wrote:
>>> Not in one case - if we create a new cgroup and try to move a thread
>>> into it, but the thread is exiting as we move it, we'll call
>>> put_css_set() on the new css_set, which will drop the refcount on the
>>> target cgroup back to 0. We wouldn't want the auto-release
>>> notification to kick in in that situation, I think.
>>
>> Clearing the CGRP_RELEASABLE bit any time after the tests in
>> check_for_release introduces a race if __css_get is called between the
>> check and clearing the bit - the cgroup will have an entry, but the
>> bit will not be set.  Without additional locking in __css_get, I don't
>> see any way to safely clear CGRP_RELEASABLE.
>
> I don't quite follow your argument here. Are you saying that the
> problem is that you could end up spawning a release agent for a cgroup
> that was no longer releasable since it now had a process in it again?
> If so, then I don't think that's a problem - spurious release agent
> invocations for non-empty cgroups will always happen occasionally due
> to races between the kernel and userspace. But a failed move of a task
> into a previously-empty cgroup shouldn't trigger the agent.

No, if you add a new process to the group while check_for_release, the
bit could get set by the add for the new process, then cleared by the
concurrently running check_for_release.  The release agent would be
spawned with a process in the group, which is fine, but when
RELEASABLE bit would be clear.  When the new process was removed,
check_for_release would not call the release agent at all.
