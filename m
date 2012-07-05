Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab2GEXcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:32:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35003 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2GEXcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:32:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1341496805-26394-1-git-send-email-glommer@parallels.com>
Date: Thu, 05 Jul 2012 16:31:57 -0700
In-Reply-To: <1341496805-26394-1-git-send-email-glommer@parallels.com>
	(Glauber Costa's message of "Thu, 5 Jul 2012 18:00:05 +0400")
Message-ID: <8762a1vl76.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18GPsj0gsLgfLBYqB5KbclCOXZLUUTtEe4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Glauber Costa <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] force dentry revalidation after namespace change
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <glommer@parallels.com> writes:

> When we change the namespace tag of a sysfs entry, the associated dentry
> is still kept around. readdir() will work correctly and not display the
> old entries, but open() will still succeed, so will reads and writes.
>
> This will no longer happen if sysfs is remounted, hinting that this is a
> cache-related problem.

Equalivalently to remounting you can do
echo 3 > /proc/sys/vm/drop_caches.

> I am using the following sequence to demonstrate that:
>
> shell1:
> ip link add type veth
> unshare -nm
>
> shell2:
> ip link set veth1 <pid_of_shell_1>
> cat /sys/devices/virtual/net/veth1/ifindex
>
> Before that patch, this will succeed (fail to fail). After it, it will
> correctly return an error. Differently from a normal rename, which we
> handle fine, changing the object namespace will keep it's path intact.
> So this check seems necessary as well.

Overall good bug spotting, and good spotting of where the fix should
live.

Your summary should have said:
[PATCH] fail dentry revalidation after namespace change

And you have the test slightly wrong below.

> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/sysfs/dir.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index e6bb9b2..c24bdd9 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -307,6 +307,7 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>  {
>  	struct sysfs_dirent *sd;
>  	int is_dir;
> +	int type;
>  
>  	if (nd->flags & LOOKUP_RCU)
>  		return -ECHILD;
> @@ -314,6 +315,10 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>  	sd = dentry->d_fsdata;
>  	mutex_lock(&sysfs_mutex);
>  
> +	type = sysfs_ns_type(sd);
> +	if (sd->s_ns && (sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns))
> +		goto out_bad;
> +

First this check should be down below with after the other rename
checks.

Second the test should be:
	type = KOBJ_NS_TYPE_NONE;
	if (sd->s_parent)
		type = sysfs_ns_type(sd->s_parent);
	if (type && (sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns))
        	goto out_bad;

The important difference there it is the directory that the dirent is
in that the type comes from.  Not the dirent itself.

>  	/* The sysfs dirent has been deleted */
>  	if (sd->s_flags & SYSFS_FLAG_REMOVED)
>  		goto out_bad;

Glauber.  Do you think you can fix your patch and resubmit.

Eric
