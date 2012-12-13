Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2LMVSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 16:18:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32845 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2LMVSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 16:18:14 -0500
Date: Thu, 13 Dec 2012 22:18:08 +0100
From: Jens Axboe <jaxboe@fusionio.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
Message-ID: <20121213211808.GJ25017@kernel.dk>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03 2012, Kent Overstreet wrote:
> Last posting: http://thread.gmane.org/gmane.linux.kernel.aio.general/3169
> 
> Changes since the last posting should all be noted in the individual
> patch descriptions.
> 
>  * Zach pointed out the aio_read_evt() patch was calling functions that
>    could sleep in TASK_INTERRUPTIBLE state, that patch is rewritten.
>  * Ben pointed out some synchronize_rcu() usage was problematic,
>    converted it to call_rcu()
>  * The flush_dcache_page() patch is new
>  * Changed the "use cancellation list lazily" patch so as to remove
>    ki_flags from struct kiocb.

Kent, I ran a few tests, and the below patches still don't seem as fast
as the approach I took. To keep it fair, I used your aio branch and
applied by dio speedups too. As a sanity check, I ran with your branch
alone as well. The quick results below - kaio is kent-aio, just your
branch. kaio-dio is with the direct IO speedups too. jaio is my branch,
which already has the dio changes too.

Devices         Branch          IOPS
1               kaio            ~915K
1               kaio-dio        ~930K
1               jaio           ~1220K
6               kaio           ~3050K
6               kaio-dio       ~3080K
6               jaio            3500K

The box runs out of CPU driving power, which is why it doesn't scale
linearly, otherwise I know that jaio at least does. It's basically
completion limited for the 6 device test at the moment.

I'll run some profiling tomorrow morning and get you some better
results. Just thought I'd share these at least.

-- 
Jens Axboe

