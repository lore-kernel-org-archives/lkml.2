Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2JJU7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:59:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42987 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2JJU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:59:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        Greg KH <greg@kroah.com>
References: <20121010204256.GD29501@moon>
	<20121010135408.515c2e21.akpm@linux-foundation.org>
Date: Wed, 10 Oct 2012 13:59:43 -0700
In-Reply-To: <20121010135408.515c2e21.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 10 Oct 2012 13:54:08 -0700")
Message-ID: <87vceiqc00.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+HSXwb5yy+8i4MiBIwHWg9e8UJf6Hj1lA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: openvz.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns() v5
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 11 Oct 2012 00:42:56 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
>> The free_pid_ns function done in recursion fashion:
>> 
>> free_pid_ns(parent)
>>   put_pid_ns(parent)
>>     kref_put(&ns->kref, free_pid_ns);
>>       free_pid_ns
>> 
>> thus if there was a huge nesting of namespaces the userspace
>> may trigger avalanche calling of free_pid_ns leading to
>> kernel stack exhausting and a panic eventually.
>> 
>> This patch turns the recursion into iterative loop.
>> 
>> v5 (from oleg@):
>>  - Drop @ret variable
>>  - Make put_pid_ns non-inline since it grows in size,
>>    in turn make free_pid_ns static
>
> OK, let's try that.  I'll sit on this until -rc2 to give it a bit of
> time to cook.
>
> A -stable backport might be needed.  What capabilities does userspace
> need to be able to trigger the kernel stack overflow?

CAP_SYS_ADMIN is required to create a new pid namespace today.

With a little luck the user namespace bits that allow unprivelged
creation of pid namespaces will be ready for 3.8.

Eric

