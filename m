Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0IWOKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:10:46 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:53061 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0IWOKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:10:45 -0400
Date: Thu, 23 Sep 2010 19:40:37 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Robin Holt <holt@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Denis V. Lunev" <den@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <mszeredi@suse.cz>,
        Mingming Cao <cmm@us.ibm.com>, Nick Piggin <npiggin@kernel.dk>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: When booting a 16TB system, unix_create1 fails due to integer
 overflow.
Message-ID: <20100923141037.GA3811@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20100923121704.GR14064@sgi.com>
 <1285246384.362.3.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1285246384.362.3.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 02:53:04PM +0200, Eric Dumazet wrote:
> Le jeudi 23 septembre 2010 à 07:17 -0500, Robin Holt a écrit : 
> > I do not know which direction to take, but here is the summary of the
> > problem.
> > 
> > We recently started trying to boot a customer's two new machines which
> > are configured with 384GB short of 16TB of memory.
> > 
> > We were seeing a failure which prevented boot.  The kernel was incapable
> > of creating either a named pipe or unix domain socket.  This comes down
> > to a common kernel function called unix_create1() which does:
> > 
> > 	atomic_inc(&unix_nr_socks);
> > 	if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
> > 		goto out;
> > 
> 
> Hi Robin
> 
> I would say : We can use atomic_long_t instead of atomic_t
> 
> And make get_max_files(void) return a long ?
> 
> Something like :
> 
> 
>  fs/file_table.c    |   10 +++++-----
>  include/linux/fs.h |    2 +-
>  net/unix/af_unix.c |   14 +++++++-------
>  3 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> 
>  	n = (mempages * (PAGE_SIZE / 1024)) / 10;
> -	files_stat.max_files = n; 
> +	files_stat.max_files = min(n, 0x7FFFFFFFUL);

It may be cleaner to just convert both the file counters and
the file limits to usnsigned long.

Other than that, this seems like a reasonable thing to do.

Thanks
Dipankar
