Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab0FYTtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:49:35 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:40486 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932324Ab0FYTte convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:49:34 -0400
Date: Fri, 25 Jun 2010 15:49:08 -0400 (EDT)
From: Ulrich Drepper <drepper@redhat.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Oleg Nesterov <oleg@redhat.com>
Message-ID: <2054433814.959851277495348646.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C2506C3.2000301@us.ibm.com>
Subject: Re: Q: sys_futex() && timespec_valid()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Darren Hart" <dvhltc@us.ibm.com> wrote:
> Unless there is some good reason to object to breaking the API that I
> am  missing, I don't mind changing it to -ETIMEDOUT (although -EINVAL
> seems more intuitive to me).

It's only not intuitive because Oleg misrepresented or at least didn't describe the issue.

The kernel already catches invalid timespec values.  Unfortunately the code used comes from the time when all timeouts where specified with relative values.  In such situations negative tv_sec values were in fact invalid and rejected with EINVAL.

But for absolute timeouts tv_sec = -1 means a time before Epoch.  This is not an invalid value, it just is one of many points in time which have passed and therefore the kernel has to respond with ETIMEDOUT.

This is no semantic change or anything like that.  It pure and simply a bug fix.  When Thomas worked on that come we simply missed updating the test for invalid timespec values.

The kernel code should be fixed to always check tv_nsec for < 0 and > 1000000000.  But the tv_sec test for < 0 should be skipped if the timeout value is interpreted as an absolute time value.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
