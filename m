Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab0JVAqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:46:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379Ab0JVAp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:45:56 -0400
Date: Thu, 21 Oct 2010 17:45:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
Message-Id: <20101021174536.26213ab7.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1010211807280.3431@router.home>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-17-git-send-email-david@fromorbit.com>
	<20100929215322.ff635d3e.akpm@linux-foundation.org>
	<20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
	<20101016020744.366bd9c6.akpm@linux-foundation.org>
	<1287221475.2799.123.camel@edumazet-laptop>
	<1287238754.2799.376.camel@edumazet-laptop>
	<20101021153719.c8bde251.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1010211807280.3431@router.home>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 18:10:13 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:

> On Thu, 21 Oct 2010, Andrew Morton wrote:
> 
> > That isn't actually what I was suggesting.  I was suggesting the use of
> > an inlined, this_cpu_add()-using percpu_counter_add() variant which
> > still does the batched spilling into ->count.  IOW, just speed up the
> > current implementation along the lines of
> >
> > {
> > 	val = this_cpu_add_return(*fbc->counters, amount);
> 
> this_cpu_add_return() is not in the kernel but could be realized using a
> variant offshoot of cmpxchg_local. I had something like that initially but
> omitted it since there was no use case.

this_cpu_add_return() isn't really needed in this application.

{
	this_cpu_add(*fbc->counters, amount);
	if (unlikely(abs(this_cpu_read(*fbc->counters)) > fbc->batch))
		out_of_line_stuff();
}	

will work just fine.				
