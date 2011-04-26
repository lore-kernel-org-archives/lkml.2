Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab1DZD4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:56:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab1DZD4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OLEXC3yYy+WP4iyFybNqU8zn1rJuZEcnK9V8qJhnVNbpUfkMnGA1KLwh1rW16xxG7U
         D6/2lnhultdKNuTfrReQ==
Date: Mon, 25 Apr 2011 20:56:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: bookjovi@gmail.com
cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: put check_mem_permission before __get_free_page
 in mem_read
In-Reply-To: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
Message-ID: <alpine.LSU.2.00.1104252048190.6978@sister.anvils>
References: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011, bookjovi@gmail.com wrote:
> From: Jovi Zhang <bookjovi@gmail.com>
> 
> It should be better if put check_mem_permission before __get_free_page
> in mem_read, to be same as function mem_write.
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

Sorry to be contrary, but I disagree with this.  I'm all for consistency,
but is there a particular reason why you think the mem_write ordering is
right and mem_read wrong?

My reason for preferring the current mem_read ordering is this:

check_mem_permission gets a reference to the mm.  If we __get_free_page
after check_mem_permission, imagine what happens if the system is out
of memory, and the mm we're looking at is selected for killing by the
OOM killer: while we wait in __get_free_page for more memory, no memory
is freed from the selected mm because it cannot reach exit_mmap while
we hold that reference.

(I may be overstating the case: a little memory may be freed from the
exiting task's stack, and kswapd should still be able to pick some pages
off the mm.  But nonetheless, we would do better to let this mm go.)

No doubt there are plenty of other places in /proc which try to
allocate memory after taking a reference on an mm; but I think
we should be working to eliminate those rather than add to them.

Hugh
