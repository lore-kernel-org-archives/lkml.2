Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab3AIVgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:36:31 -0500
Received: from nm16-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.166]:42448
	"EHLO nm16-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933381Ab3AIVg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:36:28 -0500
X-Yahoo-Newman-Id: 700013.17475.bm@smtp108.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OiEbzs4VM1lAQiU_sBdzgQApr2hyZcnfq70Tl.2Aezgh9V.
 FqyZMZwkanf4tCw.Z6KIzIn6zmX6oC2wEKzoD4alhvBeK6rEopXbwFhRQ9FJ
 L_XWq273CuKDX2HedQNOOzWPZIAK2Zs8svy.TyB.2dG0f.so_5.VjCKvkZW8
 q2eFG7b7QxK8sClp7ZuPpHUwkrW_8lYors3UOmnSJ9O0fE7I81cWLcAI723R
 _VvjPhkRVU_EavDZ2KUxI9ziSnDsC9_xo9I.sOBdkZU7i.ewuEImUTw5yxMF
 UgosOoBcPtbiVL3KFBHMxs4pS6ppXtn_MceEkuWrbWwTht5ytvuRYWKylRx2
 PxJp0q3z9wWl1MnWYld9tL2L19YpdzG3bDhaNMfWFWewpN0LG3TxyproM4RK
 MACDvsgCkU0jhKwPx.xa1Uvpqi.bJyUU6hzmWssQ2E7YxbAefy1VfGQIaUQe
 mOXYOEZ1S80dX5440CJSCfM8-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDE2EC.1080104@schaufler-ca.com>
Date: Wed, 09 Jan 2013 13:36:44 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, dwalsh@redhat.com,
        dmalcolm@redhat.com, sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Subject: Re: Friendlier EPERM - Request for input
References: <1357747463.2593.28.camel@localhost>   <1357760637.2593.55.camel@localhost> <50EDCFC0.3010401@schaufler-ca.com>  <1357763560.1342.7.camel@localhost> <50EDD8D4.60003@schaufler-ca.com> <1357765998.1342.25.camel@localhost>
In-Reply-To: <1357765998.1342.25.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2013 1:13 PM, Eric Paris wrote:
> On Wed, 2013-01-09 at 12:53 -0800, Casey Schaufler wrote:
>
>> Let me try again, I think I didn't quite get the idea across.
>>
>> I'm suggesting that the string returned by get_extended_error_info()
>> ought to be the audit record the system call would generate, regardless
>> of whether the audit system would emit it or not.
>> If the audit record doesn't have the information you need we should
>> fix the audit system to provide it. Any bit of the information in
>> the audit record might be relevant, and your admin or developer might
>> need to see it.
>>
>> I'm suggesting using the audit record because there are tools to
>> examine them and it's a pity to use a different format instead of
>> fixing the one that's already there.
> I get the point.  My problem with using audit records is that they have
> to be stored on disk, forever.  We have to store a record on disk for
> EVERY denial because of rwx bits, acls, capabilities, LSM, etc.  We
> don't do that today and I'm scared of disk growth explosion.  Then we
> could have a kernel interface, say get_last_audit_record(), which could
> query the audit system for that record number.
>
> A thought on disk size explosion might be something like generating
> these records in the kernel and just store them in the task struct until
> some later point in time.

Yes! This is exactly what I'm suggesting.

> If userspace calls get_last_audit_record() we
> might be able to dump the record to auditd.

No! Have reading /proc/self/whatwentwrong return the audit record
associated with the errno last set by the kernel.

> If another record comes
> along we have to free the last one and replace it.  Lot more of a perf
> hit than setting a couple of ints and taking the hit at the time when
> userspace actually wants to collect/use this information.
>
> But are we just building up a rube goldburg machine?  I don't see a
> problem storing the last audit record if it exists, but I don't like
> making audit part of the normal workflow.  I'd do it if others like that
> though....
>
>

