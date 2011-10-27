Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1J0QzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:55:19 -0400
Received: from flusers.ccur.com ([173.221.59.2]:37530 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753749Ab1J0QzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:55:15 -0400
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Oct 2011 12:55:12 EDT
Date: Thu, 27 Oct 2011 12:44:30 -0400
From: Joe Korty <joe.korty@ccur.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amwang@redhat.com" <amwang@redhat.com>
Subject: Re: [PATCH 7/4] ipc/mqueue: separate mqueue default value from maximum value
Message-ID: <20111027164430.GE21264@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <1317162613-11060-1-git-send-email-dledford@redhat.com> <1317162613-11060-3-git-send-email-dledford@redhat.com> <CAHGf_=obvkUN-JYVfbLueTV3hmobnV3jY86ukHo1E6d-3NDZxg@mail.gmail.com> <4EA828E4.1070409@gmail.com> <4EA8297B.6020403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA8297B.6020403@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 11:38:35AM -0400, KOSAKI Motohiro wrote:
> commit b231cca438 (message queues: increase range limits)
> changed mqueue default value when attr parameter is specified NULL
> from hard coded value to fs.mqueue.{msg,msgsize}_max sysctl value.
> 
> This made large side effect. When user need to use two mqueue
> applications 1) using !NULL attr parameter and it require big
> message size and 2) using NULL attr parameter and only need small
> size message, app (1) require to raise fs.mqueue.msgsize_max and
> app (2) consume large memory size even though it doesn't need.
> 
> Doug Ledford propsed to switch back it to static hard coded value.
> However it also has a compatibility problem. Some applications might
> started depend on the default value is tunable.
> 
> The solution is to separate default value from maximum value.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Amerigo Wang <amwang@redhat.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Joe Korty <joe.korty@ccur.com>
> ---
>  Documentation/sysctl/fs.txt   |    7 +++++++
>  include/linux/ipc_namespace.h |    3 +++
>  ipc/mq_sysctl.c               |   18 ++++++++++++++++++
>  ipc/mqueue.c                  |    9 ++++++---
>  ipc/msgutil.c                 |    2 ++
>  5 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
> index 88fd7f5..13d6166 100644
> --- a/Documentation/sysctl/fs.txt
> +++ b/Documentation/sysctl/fs.txt
> @@ -225,6 +225,13 @@ a queue must be less or equal then msg_max.
>  maximum  message size value (it is every  message queue's attribute set during
>  its creation).
> 
> +/proc/sys/fs/mqueue/msg_default is  a read/write  file for setting/getting the
> +default number of messages in a queue value if attr parameter of mq_open(2) is
> +NULL. If it exceed msg_max, the default value is initialized msg_max.
> +
> +/proc/sys/fs/mqueue/msgsize_default is a read/write file for setting/getting
> +the default message size value if attr parameter of mq_open(2) is NULL. If it
> +exceed msgsize_max, the default value is initialized msgsize_max.
> 
>  4. /proc/sys/fs/epoll - Configuration options for the epoll interface
>  --------------------------------------------------------


Very much needed; maximums applied as defaults was a
bad idea.

Acked-by: Joe Korty <joe.korty@ccur.com>



> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 2d7c5e0..9e25a33 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -63,6 +63,9 @@ struct ipc_namespace {
>  	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
>  	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */
> 
> +	unsigned int    mq_msg_default;
> +	unsigned int    mq_msgsize_default;
> +
>  	/* user_ns which owns the ipc ns */
>  	struct user_namespace *user_ns;
>  };
> diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
> index e22336a..383d638 100644
> --- a/ipc/mq_sysctl.c
> +++ b/ipc/mq_sysctl.c
> @@ -73,6 +73,24 @@ static ctl_table mq_sysctls[] = {
>  		.extra1		= &msg_maxsize_limit_min,
>  		.extra2		= &msg_maxsize_limit_max,
>  	},
> +	{
> +		.procname	= "msg_default",
> +		.data		= &init_ipc_ns.mq_msg_default,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_mq_dointvec_minmax,
> +		.extra1		= &msg_max_limit_min,
> +		.extra2		= &msg_max_limit_max,
> +	},
> +	{
> +		.procname	= "msgsize_default",
> +		.data		= &init_ipc_ns.mq_msgsize_default,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_mq_dointvec_minmax,
> +		.extra1		= &msg_maxsize_limit_min,
> +		.extra2		= &msg_maxsize_limit_max,
> +	},
>  	{}
>  };
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 91ca145..f762fe6 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -143,9 +143,10 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  		info->qsize = 0;
>  		info->user = NULL;	/* set when all is ok */
>  		memset(&info->attr, 0, sizeof(info->attr));
> -		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max, DFLT_MSG);
> -		info->attr.mq_msgsize =
> -			min(ipc_ns->mq_msgsize_max, DFLT_MSGSIZE);
> +		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
> +					   ipc_ns->mq_msg_default);
> +		info->attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
> +					    ipc_ns->mq_msgsize_default);
>  		if (attr) {
>  			info->attr.mq_maxmsg = attr->mq_maxmsg;
>  			info->attr.mq_msgsize = attr->mq_msgsize;
> @@ -1262,6 +1263,8 @@ int mq_init_ns(struct ipc_namespace *ns)
>  	ns->mq_queues_max    = DFLT_QUEUESMAX;
>  	ns->mq_msg_max       = DFLT_MSGMAX;
>  	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
> +	ns->mq_msg_default   = DFLT_MSG;
> +	ns->mq_msgsize_default  = DFLT_MSGSIZE;
> 
>  	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
>  	if (IS_ERR(ns->mq_mnt)) {
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index 8b5ce5d3..a344216 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -31,6 +31,8 @@ struct ipc_namespace init_ipc_ns = {
>  	.mq_queues_max   = DFLT_QUEUESMAX,
>  	.mq_msg_max      = DFLT_MSGMAX,
>  	.mq_msgsize_max  = DFLT_MSGSIZEMAX,
> +	.mq_msg_default	    = DFLT_MSG,
> +	.mq_msgsize_default = DFLT_MSGSIZE,
>  #endif
>  	.user_ns = &init_user_ns,
>  };
> -- 
> 1.7.5.2
