Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1IIXlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:41:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab1IIXlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:41:52 -0400
Date: Fri, 9 Sep 2011 16:41:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sched: share task comm length value to userspace
Message-Id: <20110909164130.3bc63ff7.akpm@linux-foundation.org>
In-Reply-To: <20110905133903.76cd3a61@infradead.org>
References: <1315247881-31597-1-git-send-email-vz@mleia.com>
	<20110905124726.28b24db4@infradead.org>
	<4E652E41.1030308@mleia.com>
	<20110905133903.76cd3a61@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 13:39:03 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 05 Sep 2011 23:17:05 +0300
> Vladimir Zapolskiy <vz@mleia.com> wrote:
> 
> > but eventually having that value in
> > userspace is really desirable. However in assumption that this value
> > is preserved fixed and won't be changed in reasonable perspective,
> > the presented approach becomes the most evident and simple.
> 
> yeah if it would never change, your change would be the most simple.
> but I really don't want to pin that thing down....
> 
> > 
> > >
> > > If we need to export this, we should export it in /proc or /sys
> > > somewhere as a dynamic value.....
> > >
> > Let's do it in a proper way. What's the common practice to export
> > such limit values? I suppose via /proc/sys/kernel, please correct me,
> > if I'm wrong.
> 
> that or /sys/kernel
> 
> personally I like /proc/sys/kernel for this kind of thing more, but...
> ... others might disagree.
> 

Run this:

#include <sys/prctl.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

main()
{
	char comm[512];
	int len;

	memset(comm, 0, sizeof(comm));
	for (len = 1; len < sizeof(comm) - 1; len++) {
		char comm2[512];
	
		comm[len - 1] = 'a';
		if (prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0) < 0) {
			fprintf(stderr, "PR_SET_NAME failed with: %s\n",
					strerror(errno));
			exit(1);
		}
		if (prctl(PR_GET_NAME, (unsigned long)comm2, 0, 0, 0) < 0) {
			fprintf(stderr, "PR_SET_NAME failed with: %s\n",
					strerror(errno));
			exit(1);
		}
		if (strlen(comm2) != len) {
			printf("%d\n", len);
			break;
		}
	}
	exit(0);
}
			

once per boot, echoing the result into /etc/sizeof-comm.  Sell resulting
package to all vendors ;)


