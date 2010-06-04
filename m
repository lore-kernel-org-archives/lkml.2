Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0FDVap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:30:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596Ab0FDVao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:30:44 -0400
Date: Fri, 4 Jun 2010 13:48:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] NOMMU: Add '[stack]' label to /proc/pid/maps output
Message-Id: <20100604134853.b6ca10f9.akpm@linux-foundation.org>
In-Reply-To: <20100601185937.5188.77506.stgit@warthog.procyon.org.uk>
References: <20100601185937.5188.77506.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jun 2010 19:59:37 +0100
David Howells <dhowells@redhat.com> wrote:

> From: Mike Frysinger <vapier@gentoo.org>
> 
> Add support to the NOMMU /proc/pid/maps file to show which mapping is the stack
> of the original thread after execve.  This is largely based on the MMU code.
> Subsidiary thread stacks are not indicated.
> 
> For FDPIC, we now get:
> 
> 	root:/> cat /proc/self/maps
> 	02064000-02067ccc rw-p 0004d000 00:01 22         /bin/busybox
> 	0206e000-0206f35c rw-p 00006000 00:01 295        /lib/ld-uClibc.so.0
> 	025f0000-025f6f0c r-xs 00000000 00:01 295        /lib/ld-uClibc.so.0
> 	02680000-026ba6b0 r-xs 00000000 00:01 297        /lib/libc.so.0
> 	02700000-0274d384 r-xs 00000000 00:01 22         /bin/busybox
> 	02816000-02817000 rw-p 00000000 00:00 0
> 	02848000-0284c0d8 rw-p 00000000 00:00 0
> 	02860000-02880000 rw-p 00000000 00:00 0          [stack]
> 
> The semi-downside here is that for FLAT, we get:
> 
> 	root:/> cat /proc/155/maps
> 	029f0000-029f9000 rwxp 00000000 00:00 0          [stack]
> 
> The reason being that FLAT combines a whole lot of stuff into one map
> (including the stack).  But this isn't any worse than the current output (which
> is nothing), so screw it.
> 

So it's a non-back-compatible change which can a) break nommu-only
userspace and b) unbreak mmu-tested userspace which gets run on nommu.

ho hum, we suck.  They can send us the bill.

> --- a/fs/proc/task_nommu.c
> +++ b/fs/proc/task_nommu.c
> @@ -122,11 +122,20 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
>  	return size;
>  }
>  
> +static void pad_len_spaces(struct seq_file *m, int len)
> +{
> +	len = 25 + sizeof(void*) * 6 - len;
> +	if (len < 1)
> +		len = 1;
> +	seq_printf(m, "%*c", len, ' ');
> +}

hm, copy-n-paste alert.


