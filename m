Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2GFJhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:37:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50340 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2GFJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:37:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1341565747-15374-1-git-send-email-glommer@parallels.com>
Date: Fri, 06 Jul 2012 02:37:00 -0700
In-Reply-To: <1341565747-15374-1-git-send-email-glommer@parallels.com>
	(Glauber Costa's message of "Fri, 6 Jul 2012 13:09:07 +0400")
Message-ID: <87hatli62r.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Dmd6SDR266OoHK8uZVYquWiVbsfRZY+8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Glauber Costa <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] fail dentry revalidation after namespace change
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <glommer@parallels.com> writes:

> When we change the namespace tag of a sysfs entry, the associated dentry
> is still kept around. readdir() will work correctly and not display the
> old entries, but open() will still succeed, so will reads and writes.

Note reads and writes of file handles open before the move should
continue to work.

> This will no longer happen if sysfs is remounted, hinting that this is a
> cache-related problem.
>
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
>
> [ v2: get type from parent, as suggested by Eric Biederman ]

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/sysfs/dir.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index e6bb9b2..c0bf38a 100644
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
> @@ -326,6 +327,13 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>  	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
>  		goto out_bad;
>  
> +	/* The sysfs dirent has been moved to a different namespace */
> +	type = KOBJ_NS_TYPE_NONE;
> +	if (sd->s_parent)
> +		type = sysfs_ns_type(sd->s_parent);
> +	if (type && (sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns))
> +		goto out_bad;
> +
>  	mutex_unlock(&sysfs_mutex);
>  out_valid:
>  	return 1;
