Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0JPIg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:36:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47579 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0JPIgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WvF/3aimDMFR3HdSCOtVvR7UEFecavgEdU+SfOiuoJsWSKYCmWjKhmr4focdGSfcoJ
         i+UrdXNW8xXWKnPXk+fmP3p0S1VyN1V00uCP1Fa7sFUkdRGUF/TFvGEmHr+vmx0adZpx
         9bEy+skAw+1dcMI+FtH4Oku5ldT1tCcHMLhwc=
Subject: Re: [PATCH 03/19] fs: Convert nr_inodes and nr_unused to per-cpu
 counters
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1287216853-17634-4-git-send-email-david@fromorbit.com>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
	 <1287216853-17634-4-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 10:29:36 +0200
Message-ID: <1287217776.2799.69.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 16 octobre 2010 à 19:13 +1100, Dave Chinner a écrit :
> From: Dave Chinner <dchinner@redhat.com>
> 
> The number of inodes allocated does not need to be tied to the
> addition or removal of an inode to/from a list. If we are not tied
> to a list lock, we could update the counters when inodes are
> initialised or destroyed, but to do that we need to convert the
> counters to be per-cpu (i.e. independent of a lock). This means that
> we have the freedom to change the list/locking implementation
> without needing to care about the counters.
> 
> Based on a patch originally from Eric Dumazet.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

NACK

Some people believe percpu_counter object is the right answer to such
distributed counters, because the loop is done on 'online' cpus instead
of 'possible' cpus. "It must be better if number of possible cpus is
4096 and only one or two cpus are online"...

But if we do this loop only on rare events, like
"cat /proc/sys/fs/inode-nr", then the percpu_counter() is more
expensive, because percpu_add() _is_ more expensive :

- Its a function call and lot of instructions/cycles per call, while
this_cpu_inc(nr_inodes) is a single instruction, using no register on
x86.

- Its possibly accessing a shared spinlock and counter when the percpu
counter reaches the batch limit.


To recap : nr_inodes is not a counter that needs to be estimated in real
time, since we have not limit on number of inodes in the machine (limit
is the memory allocator).

Unless someone can prove "cat /proc/sys/fs/inode-nr" must be performed
thousand of times per second on their setup, the choice I made to scale
nr_inodes is better over the 'obvious percpu_counter choice'

This choice was made to scale some counters in network stack some years
ago.

Thanks


