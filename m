Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2GJBvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:51:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33084 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJBvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:51:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Greg Thelen <gthelen@google.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1341565747-15374-1-git-send-email-glommer@parallels.com>
	<20120709161336.0ec23592.akpm@linux-foundation.org>
	<87txxgxxs7.fsf@xmission.com>
	<20120709174705.0e2078c8.akpm@linux-foundation.org>
Date: Mon, 09 Jul 2012 18:51:37 -0700
In-Reply-To: <20120709174705.0e2078c8.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 9 Jul 2012 17:47:05 -0700")
Message-ID: <87629wxu1i.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18n9y6dqKXa5kEMPKSaW+SIlZz5m2+Ynd8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0359]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] fail dentry revalidation after namespace change
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 09 Jul 2012 17:30:48 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> >>  {
>> >>  	struct sysfs_dirent *sd;
>> >>  	int is_dir;
>> >> +	int type;
>> >>  
>> >>  	if (nd->flags & LOOKUP_RCU)
>> >>  		return -ECHILD;
>> >> @@ -326,6 +327,13 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>> >>  	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
>> >>  		goto out_bad;
>> >>  
>> >> +	/* The sysfs dirent has been moved to a different namespace */
>> >> +	type = KOBJ_NS_TYPE_NONE;
>> >> +	if (sd->s_parent)
>> >> +		type = sysfs_ns_type(sd->s_parent);
>> >> +	if (type && (sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns))
>> >
>> > eww, the code is assuming that KOBJ_NS_TYPE_NONE has a value of zero. 
>> > Don't do that; it smells bad.
>> 
>> Gag.  An incomplete change in idiom.
>> 
>> KOBJ_NS_TYPE_NONE is explicitly defined as 0 so that it can be used
>> this way, and every where else in fs/sysfs/dir.c uses this idiom.
>
> One man's idiom is another man's idiocy.

And code that uses inconsistent idioms is even harder to read.

A half assed cleanup is worse than no cleanup.

> Seriously.  What sort of idea is that?  Create an enumerated type and
> then just ignore it?

It isn't ignored.  It just has a well defined NULL value. That is hardly
controversial.

>> Pray tell in what parallel universe is that monstrosity above more
>> readable than the line it replaces?
>
> Don't be silly, it is not a "monstrosity".  The code it is modifying
> contains an unneeded test-and-branch.  It's a test and branch which the
> compiler might be able to avoid.  If we can demonstrate that the
> compiler does indeed optimise it, or if we can find a less monstrous
> way of implementing it then fine.  Otherwise, efficiency wins.

Efficiency wins?  In a rarely used function?  Which kernel are you
working on?

Readable maintainable code wins.  Unreadable code causes regressions.

Your addition while it may not be monstrous is most definitely less
readable.

Eric
