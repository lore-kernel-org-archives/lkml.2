Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0CWVDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:03:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51195 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0CWVDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:03:03 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Christoph Hellwig <hch@lst.de>,
       Janak Desai <janak@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] sys_unshare: simplify the not-really-implemented CLONE_THREAD/SIGHAND/VM code
References: <20100323170816.GA20809@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 23 Mar 2010 14:02:55 -0700
In-Reply-To: <20100323170816.GA20809@redhat.com> (Oleg Nesterov's message of "Tue\, 23 Mar 2010 18\:08\:16 +0100")
Message-ID: <m1hbo6u4xs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, sukadev@us.ibm.com, sgruszka@redhat.com, roland@redhat.com, janak@us.ibm.com, hch@lst.de, pbadari@us.ibm.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> (on top of check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch)
>
> Cleanup.
>
> sys_unshare(CLONE_THREAD/SIGHAND/VM) is not really implemented, and I doubt
> very much it will ever work. At least, nobody even tried since the original
> "unshare system call -v5: system call handler function" commit
> 99d1419d96d7df9cfa56bc977810be831bd5ef64 was applied more than 4 years ago.
>
> And the code is not consistent. unshare_thread() always fails unconditionally,
> while unshare_sighand() and unshare_vm() pretend to work if there is nothing
> to unshare.

This is setting off alarm bells in my head.

I haven't traced this all through but I like your logic a lot less, and
I think it is buggy.  Why don't we need to look at sigh->count ?

The current logic is very fine grained but it does a lot of simple logical
checks and it ties those checks together if a very maintainable way.

You require that we know upfront all of the dependencies, which is things
change subtlety can be a maintenance challenge.



> Remove unshare_thread(), unshare_sighand(), unshare_vm() helpers and related
> variables and add a simple CLONE_THREAD | CLONE_SIGHAND| CLONE_VM check into
> check_unshare_flags().
>
> Also, move the "CLONE_NEWNS needs CLONE_FS" check from check_unshare_flags()
> to sys_unshare(). This looks more consistent and matches the similar
> do_sysvsem check in sys_unshare().
>
> Note: with or without this patch "atomic_read(mm->mm_users) > 1" can give
> a false positive due to get_task_mm().

I think the number of times get_task_mm is called on not current this isn't
an interesting race.

Eric
