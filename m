Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2DEWgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:36:14 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:44196 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab2DEWgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:36:12 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 18:36:12 EDT
X-AuditID: 12074425-b7f4a6d0000008e0-46-4f7e1d2f5ec3
Message-ID: <4F7E1D23.1080507@mit.edu>
Date: Thu, 05 Apr 2012 15:30:59 -0700
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.file-systems,gmane.linux.kernel
To: Hagen Paul Pfeifer <hagen@jauu.net>
CC: Jason Baron <jbaron@redhat.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
References: <1332943060-18374-1-git-send-email-hagen@jauu.net> <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com> <20120328162108.GB2381@redhat.com> <20120328195848.GA5331@hell> <20120329141653.GA2424@redhat.com> <20120329150541.GB3173@hell>
In-Reply-To: <20120329150541.GB3173@hell>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsUixG6nrqsvW+dv0NMsbDFn/Ro2i33vz7JZ
	bHi5ldXi1uml7BZ79p5ksbi8aw6bxdvLshYfJm5gs3jU95bd4vzf46wOXB47Z91l93h5ez+r
	x4kZv1k8bvV9ZfF4v+8qm8fnTXIem568ZQpgj+KySUnNySxLLdK3S+DKmHh7N3vBAfaK7iuv
	mBsY/7B2MXJySAiYSLxevIwFwhaTuHBvPVsXIxeHkMA+RonP3z6xQjjrGSWeH2xjhnCeM0m8
	X/GRCaSFV0BNYunu3WCjWARUJVY1rgQbxSagItGx9AFQDQeHqECYxO9jDhDlghInZz4BK+ET
	MJf4OqOXGcQWEVCXOPvpFxPIfGaBbmaJL7vaGUESwgK2ErdfgcwEWdzMJNG8eR/YUE4BTYl5
	X2NAapgFdCTe9T1ghrDlJba/ncM8gVFoFpJ9s5CUzUJStoCReRWjbEpulW5uYmZOcWqybnFy
	Yl5eapGuhV5uZoleakrpJkZwZLmo7mCccEjpEKMAB6MSD2/x5lp/IdbEsuLK3EOMkhxMSqK8
	d6Tr/IX4kvJTKjMSizPii0pzUosPMUpwMCuJ8D7lB8rxpiRWVqUW5cOkpDlYlMR5NbXe+QkJ
	pCeWpGanphakFsFkZTg4lCR4pWSAGgWLUtNTK9Iyc0oQ0kwcnCDDeYCGC4PU8BYXJOYWZ6ZD
	5E8xKkqJ83KBJARAEhmleXC9sMT3ilEc6BVh3t8gd/MAkyZc9yugwUxAg09+rQYZXJKIkJJq
	YFSNkTuYaxAUru5rXLB1ykzBLVNPW149YG/wUnjqWblve+J/m4jMc51f5TzHPEcjoJaj/9cc
	fe/7eozKi/bvmMw05/r1Q2drZ29gL/uykEM+9GTyseqbly63LU08GyO5z3ee2lO1nqBei+9+
	7Yy51xy4d5jVTtrL+FjC32t+Z/Zh4cNP4q5ZyCixFGckGmoxFxUnAgDfpiHoVwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 08:05 AM, Hagen Paul Pfeifer wrote:
> * Jason Baron | 2012-03-29 10:16:53 [-0400]:
> 
>> Right, for level triggered events, they all wait up. However, if you use
>> edge triggered, ie add 'EPOLLET', then the event gets 'consumed' by the
>> first thread that wakes up, and the subseqent waiters wouldn't get woken
>> up. IE you'll get one wakeup.
> 
> I addressed level triggered, right - it match the model. But I don't wanted to
> wake up every every thread anyway. I don't want to abandon level triggered
> functioning.

I think that what you want is a mode in which, once epoll_wait returns,
the bits it returns get cleared from the event mask.  Am I right?

(To get this right, you'd need another flag that disables the automatic
addition of POLLERR and POLLHUP.)

If you do that and add an extra syscall that simultaneously does a bunch
of epoll_ctls, a timerfd_settime, and an epoll_wait, I'll be extra happy.

--Andy
