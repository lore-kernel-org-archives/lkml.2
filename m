Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0GIWMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:12:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0GIWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:12:34 -0400
X-Authority-Analysis: v=1.1 cv=o8sBXTxWt3Y8I13SYZ0pmcTcOViZ+nX/QX6HkgGmvUU= c=1 sm=0 a=-NzPqxz3L0MA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=PtDNVHqPAAAA:8 a=n_Xm5tqecI35fY1bcKUA:9 a=uOktK_y136zU6fYXz6oA:7 a=M9fGNiobVR_1L05M1Vy-ZE8qVSsA:4 a=CjuIK1q_8ugA:10 a=wYE_KDyynt4A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Fri, 9 Jul 2010 17:13:41 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Louis Rilling <Louis.Rilling@kerlabs.com>,
       Linux Containers <containers@lists.osdl.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 01/24] pidns: Remove races by stopping the caching of
 proc_mnt
Message-ID: <20100709221341.GA31259@hallyn.com>
References: <20100625192945.GA25532@redhat.com>
 <20100625212618.GA11917@us.ibm.com>
 <20100625212758.GA30474@redhat.com>
 <20100625220713.GA31123@us.ibm.com>
 <m1r5jd5l0v.fsf_-_@fess.ebiederm.org>
 <m1mxu15kv4.fsf_-_@fess.ebiederm.org>
 <20100709121425.GB18586@hawkmoon.kerlabs.com>
 <m1lj9k4xfx.fsf@fess.ebiederm.org>
 <20100709141324.GC18586@hawkmoon.kerlabs.com>
 <m1aaq04ph2.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aaq04ph2.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
...
> @@ -2742,13 +2743,13 @@ void proc_flush_task(struct task_struct *task)
>  
>  	for (i = 0; i <= pid->level; i++) {
>  		upid = &pid->numbers[i];
> -		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
> -					tgid->numbers[i].nr);
> -	}
> +		mnt = get_proc_mnt(upid->ns);

...

> -int pid_ns_prepare_proc(struct pid_namespace *ns)
> +struct vfsmount *get_proc_mnt(struct pid_namespace *ns)
>  {
> -	struct vfsmount *mnt;
> -
> -	mnt = kern_mount_data(&proc_fs_type, ns);
> -	if (IS_ERR(mnt))
> -		return PTR_ERR(mnt);
> -
> -	return 0;
> +	return kern_mount_data(&proc_fs_type, ns);

Uh, that looks like it's got to be a *huge* hit.  Each kern_mount_data()
will at least alloc space for a vfsmnt and proc_fs_type->name.  Once for
each pid level of each exiting task.

(Or am I misreading?)

-serge
