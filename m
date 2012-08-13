Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2HMFze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 01:55:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:32906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab2HMFzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 01:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,757,1336374000"; 
   d="scan'208";a="179833772"
Message-ID: <502896C5.7080303@intel.com>
Date: Sun, 12 Aug 2012 22:55:17 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [flame^Wreview] net: netprio_cgroup: rework update socket logic
References: <20120813015348.GZ23464@ZenIV.linux.org.uk>
In-Reply-To: <20120813015348.GZ23464@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2012 6:53 PM, Al Viro wrote:
> 	Ladies and gentlemen, who the devil had reviewed that little gem?
>
> commit 406a3c638ce8b17d9704052c07955490f732c2b8
> Author: John Fastabend <john.r.fastabend@intel.com>
> Date:   Fri Jul 20 10:39:25 2012 +0000
>
> is a bleeding bogosity that doesn't pass even the most cursory
> inspection.  It iterates through descriptor tables of a bunch
> of processes, doing this:
>                          file = fcheck_files(files, fd);
>                          if (!file)
>                                  continue;
>
>                          path = d_path(&file->f_path, tmp, PAGE_SIZE);
>                          rv = sscanf(path, "socket:[%lu]", &s);
>                          if (rv <= 0)
>                                  continue;
>
>                          sock = sock_from_file(file, &err);
>                          if (!err)
>                                  sock_update_netprioidx(sock->sk, p);
> Note the charming use of sscanf() for pattern-matching.  's' (inode
> number of socket) is completely unused afterwards; what happens here
> is a very badly written attempt to skip non-sockets.  Why, will
> sock_from_file() blow up on non-sockets?  And isn't there some less
> obnoxious way to check that the file is a sockfs one?  Let's see:
> struct socket *sock_from_file(struct file *file, int *err)
> {
>          if (file->f_op == &socket_file_ops)
>                  return file->private_data;      /* set in sock_map_fd */
>
>          *err = -ENOTSOCK;
>          return NULL;
> }
> ... and the first line is exactly that - a check that we are on sockfs.
> _Far_ less expensive one, at that, so it's not even that we are avoiding
> a costly test.  In other words, all masturbation with d_path() is absolutely
> pointless.
>
> Furthermore, it's racy; had been even more so before the delayed fput series
> went in, but even now it's not safe.  fcheck_files() does *NOT* guarantee
> that file is not getting closed right now.  rcu_read_lock() prevents only
> freeing and potential reuse of struct file we'd got; it might go all the
> way through final fput() just as we look at it.  So file->f_path is not
> protected by anything.  Worse yet, neither is struct socket itself - we
> might be going through sock_release() at the same time, so sock->sk might
> very well be NULL, leaving us a oops even after we dump d_path() idiocy.
>
> To make it even funnier, there's such thing as SCM_RIGHTS datagrams and
> descriptor passing.  In other words, it's *not* going to catch all sockets
> that would be caught by the earlier variant.
>

OK clearly I screwed it up thanks for reviewing Al. How about this.

                 fdt = files_fdtable(files);
                 for (fd = 0; fd < fdt->max_fds; fd++) {
                         struct socket *sock;
                         int err = 0;

                         sock = sockfd_lookup(fd, &err);
                         if (!sock) {
                                 lock_sock(sock->sk);
                                 sock_update_netprioidx(sock->sk, p);
                                 release_sock(sock->sk);
                                 sockfd_put(sock);
                         }
                 }

sockfd_lookup will call fget() and also test file->f_op. testing this
now.
