Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab2C2CYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:24:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2C2CYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:24:17 -0400
Date: Wed, 28 Mar 2012 19:28:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-Id: <20120328192804.7326bce9.akpm@linux-foundation.org>
In-Reply-To: <20120329020820.GB22697@redhat.com>
References: <20120327155149.d41a235b.akpm@linux-foundation.org>
	<20120328001550.GA3077@redhat.com>
	<20120328043951.GA32741@dastard>
	<20120328164720.d1aea752.akpm@linux-foundation.org>
	<20120329005442.GB16008@redhat.com>
	<20120328181023.274401d1.akpm@linux-foundation.org>
	<1332984523.30775.12.camel@joe2Laptop>
	<20120328184602.e6b11a37.akpm@linux-foundation.org>
	<20120329015059.GA22697@redhat.com>
	<20120328190211.4ac8a653.akpm@linux-foundation.org>
	<20120329020820.GB22697@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 22:08:20 -0400 Dave Jones <davej@redhat.com> wrote:

> On Wed, Mar 28, 2012 at 07:02:11PM -0700, Andrew Morton wrote:
> 
>  > > Also, what happens if something allocates
>  > > and sits on a bunch of vmalloc'd memory ? would we start seeing oom kills ?
>  > 
>  > vmalloc() would fail.
> 
> Ok, that's a pretty boring failure mode, so not a big deal probably.
> 
>  > > (thinking of the context of my fuzzing tool where a bunch of instances could
>  > >  feasibly call these syscalls and not sit on huge amounts per thread, but
>  > >  collectively...  I'm wondering if it could be provoked into killing
>  > >  processes I don't own)
>  > 
>  > umm, if you wanted to deliberately trigger a vmalloc() failure then I
>  > guess a good approach would be to locate a vmalloc() site which can
>  > persist beyond the syscall (modprobe is a good one!) then exercise it
>  > in a way so that there are no N-byte holes left in the arena, then
>  > trigger an N-byte vmalloc().
> 
> Well modprobe is root-only, so that's not so bad.

Even if it's root-only, we can still end up with a toasted machine. 
Accidentally toasted, not deliberately.

> But it looks like
> key_add (see other thread from this evening) and probably others can be
> called as a user and gobble up vmalloc space. omnomnom.

hm, the keys code appears to prevent the user from reserving more than
20000 bytes of memory total (key_payload_reserve()), so it doesn't look
very useful for screwing up vmalloc().
