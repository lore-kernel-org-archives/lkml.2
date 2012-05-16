Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2EPRBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:01:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2EPRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:01:30 -0400
Date: Wed, 16 May 2012 10:01:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120516170124.GA21275@google.com>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:36:51AM +0200, Jiri Kosina wrote:
> +static struct workqueue_struct *floppy_wq;
> +
>  static struct floppy_struct *_floppy = floppy_type;
>  static unsigned char current_drive;
>  static long current_count_sectors;
> @@ -629,16 +631,15 @@ static inline void set_debugt(void) { }
>  static inline void debugt(const char *func, const char *msg) { }
>  #endif /* DEBUGT */
>  
> -typedef void (*timeout_fn)(unsigned long);
> -static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
>  
> +static DECLARE_DELAYED_WORK(fd_timeout, floppy_shutdown);
>  static const char *timeout_message;

There's no need to create a separate workqueue for this.  There's just
single work item which shouldn't be executed concurrently on different
CPUs, right?  Just queueing the work item onto system_nrt_wq should be
enough.

Thanks.

-- 
tejun
