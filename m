Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2GJAbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:31:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52139 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2GJAbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:31:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Greg Thelen <gthelen@google.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1341565747-15374-1-git-send-email-glommer@parallels.com>
	<20120709161336.0ec23592.akpm@linux-foundation.org>
Date: Mon, 09 Jul 2012 17:30:48 -0700
In-Reply-To: <20120709161336.0ec23592.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 9 Jul 2012 16:13:36 -0700")
Message-ID: <87txxgxxs7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19iS2/uFp3DYSOESLB7GECcnEEED4TnGjo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0010]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] fail dentry revalidation after namespace change
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>>  {
>>  	struct sysfs_dirent *sd;
>>  	int is_dir;
>> +	int type;
>>  
>>  	if (nd->flags & LOOKUP_RCU)
>>  		return -ECHILD;
>> @@ -326,6 +327,13 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>>  	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
>>  		goto out_bad;
>>  
>> +	/* The sysfs dirent has been moved to a different namespace */
>> +	type = KOBJ_NS_TYPE_NONE;
>> +	if (sd->s_parent)
>> +		type = sysfs_ns_type(sd->s_parent);
>> +	if (type && (sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns))
>
> eww, the code is assuming that KOBJ_NS_TYPE_NONE has a value of zero. 
> Don't do that; it smells bad.

Gag.  An incomplete change in idiom.

KOBJ_NS_TYPE_NONE is explicitly defined as 0 so that it can be used
this way, and every where else in fs/sysfs/dir.c uses this idiom.

Furthermore your change below takes one line of readable code and turns
it into something inappropriate to talk about in polite company.

If you want the code to be perfect type should be defined as
"enum kobj_ns_type type" instead of "int kobj_ns_type".

Of course the truly perfect solution is to rework the sysfs
code in a manner similar to proc, with magic internal symlinks
and multiple parallel tress for the different namespaces.
For the users of sysfs semantically there would be no changes
but in the implementation there would many fewer special cases
for namespaces.   The only special case would be reduced to
the internal sysfs symlink that lookup would have to know
about.

> @@ -329,10 +329,12 @@ static int sysfs_dentry_revalidate(struc
>  
>  	/* The sysfs dirent has been moved to a different namespace */
>  	type = KOBJ_NS_TYPE_NONE;
> -	if (sd->s_parent)
> +	if (sd->s_parent) {
>  		type = sysfs_ns_type(sd->s_parent);
> -	if (type && (sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns))
> -		goto out_bad;
> +		if (type != KOBJ_NS_TYPE_NONE &&
> +				sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns)
> +			goto out_bad;
> +	}

Pray tell in what parallel universe is that monstrosity above more
readable than the line it replaces?

Eric

