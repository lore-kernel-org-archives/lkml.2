Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1G2VXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:23:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1G2VXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:23:24 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=CRjEFeY9x6sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FS67umOuR6wxwi0VtsMA:9 a=aYvY24ifucpxYkg9gVcA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/5] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1311721194-12164-5-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
	 <1311721194-12164-5-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 17:23:22 -0400
Message-ID: <1311974602.21143.92.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:

> +		ret = NULL;
> +		if (((unsigned long)to_remove & RB_FLAG_MASK) == RB_PAGE_HEAD) {
> +			/*
> +			 * this is a head page, we have to set RB_PAGE_HEAD
> +			 * flag while updating the next pointer
> +			 */
> +			unsigned long tmp = (unsigned long)next_page |
> +							RB_PAGE_HEAD;
> +			ret = cmpxchg(&tail_page->next, to_remove,
> +					(struct list_head *) tmp);

This is fine, it will work.

> +
> +		} else if (((unsigned long)to_remove & ~RB_PAGE_HEAD) ==
> +					(unsigned long)to_remove) {
> +
> +			/* not a head page, just update the next pointer */
> +			ret = cmpxchg(&tail_page->next, to_remove, next_page);

This is not, it wont work.

You can *only* remove the HEAD from the ring buffer without causing
issues.

As you probably know, the trick is done with the list pointers. We or
the pointer with 1 for head, and the writer will or it with 2 when it
updates the page.

This only works if we have a 1 or 2 here. Now if we try to do what you
suggest, by starting with a 0, and ending with 0, we may fail. Between
the  to_remove = tail_page->next and the cmpxchg(), the writer could
easily move to the tail page, and you would never know it.

Now we just removed the tail page with no idea that the write is on it.
The writer could have also moved on to the next page, and we just
removed the most recently recorded data.

The only way to really make this work is to always get it from the HEAD
page. If there's data there, we could just store it separately, so that
the read_page can read from it first. We will still need to be careful
with the writer on the page. But I think this is doable.

That is, read the pages from head, if there's no data on it, simply
remove the pages. If there is data, we store it off later. If the writer
happens to be on the page, we will can check that. We could even
continue to get pages, because we will be moving the header page with
the cmpxchg, and the writer does that too. It will take some serious
thought, but it is possible to do this.

-- Steve



> +
> +		} else {
> +			/*
> +			 * this means that this page is being operated on
> +			 * try the next page in the list
> +			 */
> +		}
> +
> +		if (ret != to_remove) {
> +			/*
> +			 * Well, try again with the next page.
> +			 * If we cannot move the page in 3 retries, there are
> +			 * lot of interrupts on this cpu and probably causing
> +			 * some weird behavior. Warn in this case and stop
> +			 * tracing
> +			 */
> +			if (RB_WARN_ON(cpu_buffer, !retries--))
> +				break;
> +			else
> +				continue;


