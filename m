Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1IZXMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:12:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1IZXMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:12:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=GZ53TFWRI4y3GH1F4tUjeJQ36EwZAH4ZnjsIczLxk4PcV1yueBkFxU55r6Tp+zFe6
	nQtZBkDVtpSPr26lLVKLA==
Date: Mon, 26 Sep 2011 16:11:36 -0700
From: Andrew Morton <akpm@google.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: remove sysctl to manually rescue unevictable pages
Message-Id: <20110926161136.b4508ecb.akpm@google.com>
In-Reply-To: <20110926112944.GC14333@redhat.com>
References: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
	<20110926112944.GC14333@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 13:29:45 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Sun, Sep 25, 2011 at 04:29:40PM +0530, Kautuk Consul wrote:
> > write_scan_unavictable_node checks the value req returned by
> > strict_strtoul and returns 1 if req is 0.
> > 
> > However, when strict_strtoul returns 0, it means successful conversion
> > of buf to unsigned long.
> > 
> > Due to this, the function was not proceeding to scan the zones for
> > unevictable pages even though we write a valid value to the 
> > scan_unevictable_pages sys file.
> 
> Given that there is not a real reason for this knob (anymore) and that
> it apparently never really worked since the day it was introduced, how
> about we just drop all that code instead?
> 

Yes, let's remove it if at all possible.

However, to be nice to people I do think we should emit a once-per-boot
printk when someone tries to use it, then remove it for real at least a
couple of kernel cycles later.  Just in case someone's script or tuning
app is trying to open that procfs file.

> 
> ---
> From: Johannes Weiner <jweiner@redhat.com>
> Subject: mm: remove sysctl to manually rescue unevictable pages
> 
> At one point, anonymous pages were supposed to go on the unevictable
> list when no swap space was configured, and the idea was to manually
> rescue those pages after adding swap and making them evictable again.
> But nowadays, swap-backed pages on the anon LRU list are not scanned
> without available swap space anyway, so there is no point in moving
> them to a separate list anymore.
> 
> The manual rescue could also be used in case pages were stranded on
> the unevictable list due to race conditions.  But the code has been
> around for a while now and newly discovered bugs should be properly
> reported and dealt with instead of relying on such a manual fixup.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

The changelog failed to note that the sysctl doesn't actually *work*. 
This is a pretty strong argument for removing it ;)

Also, a reported-by:Kautuk would have been nice.

