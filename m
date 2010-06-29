Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0F2Mg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:36:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0F2Mg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YKhLZVoGR+fFh5lVzDVCYIjnc8WboLXi5z3No+p99jluw/jA8ao+vYL8ItVwexeJJY
         diYbfyuqiOq49tdeNwBsZBq9tbDc6oyIGrwunDhufTypMRTSH6youOx13+g59LuQyVmU
         oDuDaNxHiDf5AUtUfUVQF+ou7ZugMJ3IB/gTc=
Date: Tue, 29 Jun 2010 14:36:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
Message-ID: <20100629123632.GB5318@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29A33D.2060407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C29A33D.2060407@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 09:39:41AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/29/2010 12:47 AM, Frederic Weisbecker wrote:
> >>  void __init init_workqueues(void)
> >>  {
> >> +	/*
> >> +	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
> >> +	 * Make sure that the alignment isn't lower than that of
> >> +	 * unsigned long long.
> >> +	 */
> >> +	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
> >> +		     __alignof__(unsigned long long));
> >> +
> > 
> > But they are not allocated contiguously as we use the per cpu offsets.
> > So why does the struct itself need to be aligned? Only the base pointer
> > of its dynamic allocation needs to be aligned. Or am I missing something?
> 
> work->data doesn't store the percpu pointer but the address of cwq of
> that specific cpu as returned by per_cpu_ptr(), so each element needs
> to be aligned.  Besides, if the percpu ptr is aligned the elements are
> aligned so they aren't different things.



But then, if each cpu pointers are aligned, the struct itself doesn't need
to be aligned in its size right? It would need to if multiple elements
were allocated per cpu but for this struct we only have one per cpu. So
what seems to matter wrt alignment is only the base pointer of these structs,
not the size.

