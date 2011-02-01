Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1BATdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:33:15 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59119 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1BATdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:33:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <1296578246.12605.22.camel@moss-pluto>
	<1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
Date: Tue, 01 Feb 2011 11:33:03 -0800
In-Reply-To: <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
	(Lucian Adrian Grijincu's message of "Tue, 1 Feb 2011 18:42:22 +0200")
Message-ID: <m1sjw7r1n4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+LMOOncQLYN4feUt8IX6hIatUhZiEzNbA=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] security/selinux: fix /proc/sys/ labeling
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e276eb4..5231b95 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -43,7 +43,6 @@
>  #include <linux/fdtable.h>
>  #include <linux/namei.h>
>  #include <linux/mount.h>
> -#include <linux/proc_fs.h>
>  #include <linux/netfilter_ipv4.h>
>  #include <linux/netfilter_ipv6.h>
>  #include <linux/tty.h>
> @@ -70,7 +69,6 @@
>  #include <net/ipv6.h>
>  #include <linux/hugetlb.h>
>  #include <linux/personality.h>
> -#include <linux/sysctl.h>
>  #include <linux/audit.h>
>  #include <linux/string.h>
>  #include <linux/selinux.h>
> @@ -1120,39 +1118,35 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
>  }
>  
>  #ifdef CONFIG_PROC_FS
> -static int selinux_proc_get_sid(struct proc_dir_entry *de,
> +static int selinux_proc_get_sid(struct dentry *dentry,
>  				u16 tclass,
>  				u32 *sid)
>  {
> -	int buflen, rc;
> -	char *buffer, *path, *end;
> +	int rc;
> +	char *buffer, *path;
>  
>  	buffer = (char *)__get_free_page(GFP_KERNEL);
>  	if (!buffer)
>  		return -ENOMEM;
>  
> -	buflen = PAGE_SIZE;
> -	end = buffer+buflen;
> -	*--end = '\0';
> -	buflen--;
> -	path = end-1;
> -	*path = '/';
> -	while (de && de != de->parent) {
> -		buflen -= de->namelen + 1;
> -		if (buflen < 0)
> -			break;
> -		end -= de->namelen;
> -		memcpy(end, de->name, de->namelen);
> -		*--end = '/';
> -		path = end;
> -		de = de->parent;
> +	path = dentry_path_raw(dentry, buffer, PAGE_SIZE);

What kernel has a dentry_path_raw?  Perhaps you mean __dentry_path?

> +	if (IS_ERR(path))
> +		rc = PTR_ERR(path);
> +	else {
> +		/* each process gets a /proc/PID/ entry. Strip off the
> +		 * PID part to get a valid selinux labeling.
> +		 * e.g. /proc/1/net/rpc/nfs -> /net/rpc/nfs */
> +		while (path[1] >= '0' && path[1] <= '9') {
> +			path[1] = '/';
> +			path++;
> +		}
> +		rc = security_genfs_sid("proc", path, tclass, sid);
>  	}
> -	rc = security_genfs_sid("proc", path, tclass, sid);
>  	free_page((unsigned long)buffer);
>  	return rc;
>  }
>  #else

Eric
