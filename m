Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab1CZAZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:25:12 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:26110 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932293Ab1CZAZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:25:09 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: HVj_wWsVM1nbbhTBS_oM4LCD2Jl9NaC_6DlUpvDBzYo1dUh
 Rd77jpcDI_tnDhf3AJpZVDG6REPddBXqda1drjyaRb1iiJGHAbKsOW2NEcS2
 yp6YCP2b.5CrkehYPga.pzSo_KNccDssbzyBnSoBS6.U0eVb8hDAImzxt5Om
 gUnxujJPXd5TVEy5vTbiz0o98oPWl2V7EN6fR_lXZUH96Qf8D_AN7HokwhVC
 ypfte5XTchV3Puh4ctoAf3pByVF6ZJRQz7hkGkwaE6e6feRegDR99Lrnl13E
 cnyF3R2Z5.PMOuSOt1RDTrWjy4OvZcGdclKAr6GJ3om.qblivxfBy9TWd8Mg
 PtlciAP7rfUNbg_Uzc2nKu07u8aZmdwc9TNHaWyhw7FI-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D8D3258.5090804@schaufler-ca.com>
Date: Fri, 25 Mar 2011 17:24:56 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josef Bacik <josef@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [34/35] fs: call security_d_instantiate in d_obtain_alias V2
References: <20110326000459.388812559@clark.kroah.org>
In-Reply-To: <20110326000459.388812559@clark.kroah.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2011 5:04 PM, Greg KH wrote:
> 2.6.33-longterm review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Josef Bacik <josef@redhat.com>
>
> commit 24ff6663ccfdaf088dfa7acae489cb11ed4f43c4 upstream.
>
> While trying to track down some NFS problems with BTRFS, I kept noticing I was
> getting -EACCESS for no apparent reason.  Eric Paris and printk() helped me
> figure out that it was SELinux that was giving me grief, with the following
> denial
>
> type=AVC msg=audit(1290013638.413:95): avc:  denied  { 0x800000 } for  pid=1772
> comm="nfsd" name="" dev=sda1 ino=256 scontext=system_u:system_r:kernel_t:s0
> tcontext=system_u:object_r:unlabeled_t:s0 tclass=file
>
> Turns out this is because in d_obtain_alias if we can't find an alias we create
> one and do all the normal instantiation stuff, but we don't do the
> security_d_instantiate.
>
> Usually we are protected from getting a hashed dentry that hasn't yet run
> security_d_instantiate() by the parent's i_mutex, but obviously this isn't an
> option there, so in order to deal with the case that a second thread comes in
> and finds our new dentry before we get to run security_d_instantiate(), we go
> ahead and call it if we find a dentry already.  Eric assures me that this is ok
> as the code checks to see if the dentry has been initialized already so calling
> security_d_instantiate() against the same dentry multiple times is ok.  With
> this patch I'm no longer getting errant -EACCESS values.

Not to be a bother, but did you try this with Smack as well as SELinux?
Smack should be fine with the change, but if you're not going to try
Smack I need to know.

> Signed-off-by: Josef Bacik <josef@redhat.com>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Chuck Ebbert <cebbert@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  fs/dcache.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1176,9 +1176,12 @@ struct dentry *d_obtain_alias(struct ino
>  	spin_unlock(&tmp->d_lock);
>  
>  	spin_unlock(&dcache_lock);
> +	security_d_instantiate(tmp, inode);
>  	return tmp;
>  
>   out_iput:
> +	if (res && !IS_ERR(res))
> +		security_d_instantiate(res, inode);
>  	iput(inode);
>  	return res;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

