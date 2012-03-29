Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2C2B6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:58:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2C2B6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:58:24 -0400
Date: Wed, 28 Mar 2012 19:02:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-Id: <20120328190211.4ac8a653.akpm@linux-foundation.org>
In-Reply-To: <20120329015059.GA22697@redhat.com>
References: <20120313182220.GA11500@redhat.com>
	<20120327155149.d41a235b.akpm@linux-foundation.org>
	<20120328001550.GA3077@redhat.com>
	<20120328043951.GA32741@dastard>
	<20120328164720.d1aea752.akpm@linux-foundation.org>
	<20120329005442.GB16008@redhat.com>
	<20120328181023.274401d1.akpm@linux-foundation.org>
	<1332984523.30775.12.camel@joe2Laptop>
	<20120328184602.e6b11a37.akpm@linux-foundation.org>
	<20120329015059.GA22697@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 21:50:59 -0400 Dave Jones <davej@redhat.com> wrote:

> On Wed, Mar 28, 2012 at 06:46:02PM -0700, Andrew Morton wrote:
> 
>  > Could.  There was some discussion last year and implementations were
>  > tossed around.
>  > 
>  > I'm a bit apprehensive - kernel code is supposed to be robust, and
>  > large allocations are not robust and vmalloc() is crappy.
> 
> Can you expand on crappy ?

It's expensive on a per-call basis and can end up failing due to
internal fragmentation of vmalloc()'s virtually-addressed arena.  I
don't think I've ever seen a report of anyone getting a vmalloc()
failure due to the fragmentation issue, so it's largely theoretical. 
But of course, the more we use it (especially for long-lived
allocations), the greater the risk becomes.  Mainly to 32-bit machines,
I assume.

> Also, what happens if something allocates
> and sits on a bunch of vmalloc'd memory ? would we start seeing oom kills ?

vmalloc() would fail.

> (thinking of the context of my fuzzing tool where a bunch of instances could
>  feasibly call these syscalls and not sit on huge amounts per thread, but
>  collectively...  I'm wondering if it could be provoked into killing
>  processes I don't own)

umm, if you wanted to deliberately trigger a vmalloc() failure then I
guess a good approach would be to locate a vmalloc() site which can
persist beyond the syscall (modprobe is a good one!) then exercise it
in a way so that there are no N-byte holes left in the arena, then
trigger an N-byte vmalloc().
