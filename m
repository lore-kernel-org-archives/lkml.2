Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2JOUDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:03:32 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:18277 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754484Ab2JOUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:03:30 -0400
Message-ID: <1350331403.2819.25.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v6 08/10] IPC: message queue receive cleanup
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: <akpm@linux-foundation.org>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <dhowells@redhat.com>,
        <manfred@colorfullife.com>, <hughd@google.com>, <jmorris@namei.org>,
        <mtk.manpages@gmail.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <paulmck@linux.vnet.ibm.com>, <sds@tycho.nsa.gov>, <devel@openvz.org>,
        <a.p.zijlstra@chello.nl>, <cmetcalf@tilera.com>,
        <linux-driver@qlogic.com>, <ron.mercer@qlogic.com>,
        <viro@zeniv.linux.org.uk>, <eparis@parisplace.org>,
        <tglx@linutronix.de>, <jitendra.kalsaria@qlogic.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <ebiederm@xmission.com>,
        <casey@schaufler-ca.com>
Date: Mon, 15 Oct 2012 21:03:23 +0100
In-Reply-To: <20121015160017.28348.44238.stgit@localhost.localdomain>
References: <20121015155800.28348.23561.stgit@localhost.localdomain>
	 <20121015160017.28348.44238.stgit@localhost.localdomain>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 20:00 +0400, Stanislav Kinsbursky wrote:
> This patch moves all message related manipulation into one function msg_fill().
> Actually, two functions because of the compat one.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---
>  include/linux/msg.h |    5 +++--
>  ipc/compat.c        |   36 +++++++++++++++++++-----------------
>  ipc/msg.c           |   44 +++++++++++++++++++++++---------------------
>  3 files changed, 45 insertions(+), 40 deletions(-)
> 
> diff --git a/include/linux/msg.h b/include/linux/msg.h
> index 7a4b9e9..f38edba 100644
> --- a/include/linux/msg.h
> +++ b/include/linux/msg.h
> @@ -34,7 +34,8 @@ struct msg_queue {
>  /* Helper routines for sys_msgsnd and sys_msgrcv */
>  extern long do_msgsnd(int msqid, long mtype, void __user *mtext,
>  			size_t msgsz, int msgflg);
> -extern long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
> -			size_t msgsz, long msgtyp, int msgflg);
> +extern long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
> +		      int msgflg,
> +		      long (*msg_fill)(void __user *, struct msg_msg *, size_t ));
>  
>  #endif /* _LINUX_MSG_H */
> diff --git a/ipc/compat.c b/ipc/compat.c
> index 84d8efd..b879d50 100644
> --- a/ipc/compat.c
> +++ b/ipc/compat.c
[...]
> @@ -394,7 +395,8 @@ long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
>  {
>  	long err, mtype;
>  
> -	err =  do_msgrcv(msqid, &mtype, msgp->mtext, (ssize_t)msgsz, msgtyp, msgflg);
> +	err =  do_msgrcv(msqid, &mtype, msgp->mtext, (ssize_t)msgsz, msgtyp,
> +			 msgflg, compat_do_msg_fill);
>  	if (err < 0)
>  		goto out;
>  
[...]

That isn't even the right number of arguments now...

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

