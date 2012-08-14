Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2HNMzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:55:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53218 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2HNMzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:55:41 -0400
Date: Tue, 14 Aug 2012 08:55:23 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v2 2/2] net: netprio: fd passed in SCM_RIGHTS
 datagram not set correctly
Message-ID: <20120814125523.GA18731@hmsreliant.think-freely.org>
References: <20120814024320.6983.92222.stgit@jf-dev1-dcblab>
 <20120814024326.6983.97403.stgit@jf-dev1-dcblab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814024326.6983.97403.stgit@jf-dev1-dcblab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 07:43:27PM -0700, John Fastabend wrote:
> A socket fd passed in a SCM_RIGHTS datagram was not getting
> updated with the new tasks cgrp prioidx. This leaves IO on
> the socket tagged with the old tasks priority.
> 
> To fix this add a check in the scm recvmsg path to update the
> sock cgrp prioidx with the new tasks value.
> 
> Thanks to Al Viro for catching this.
> 
> CC: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
> ---
> 
>  net/core/scm.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 8f6ccfd..a14d9e2 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -249,6 +249,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	struct file **fp = scm->fp->fp;
>  	int __user *cmfptr;
>  	int err = 0, i;
> +	__u32 prioidx = task_netprioidx(current);
>  
>  	if (MSG_CMSG_COMPAT & msg->msg_flags) {
>  		scm_detach_fds_compat(msg, scm);
> @@ -265,6 +266,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
>  	     i++, cmfptr++)
>  	{
> +		struct socket *sock;
>  		int new_fd;
>  		err = security_file_receive(fp[i]);
>  		if (err)
> @@ -281,6 +283,9 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  		}
>  		/* Bump the usage count and install the file. */
>  		get_file(fp[i]);
> +		sock = sock_from_file(fp[i], &err);
> +		if (sock)
> +			sock->sk->sk_cgrp_prioidx = prioidx;
nit: You can replace the prioidx variable above and this set with a call to
sock_update_netprioidx

Neil

