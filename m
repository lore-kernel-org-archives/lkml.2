Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2DCHIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:08:22 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:60010 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295Ab2DCHIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:08:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	<20120402165036.2bc987ad@pluto.restena.lu>
	<m17gxyklfm.fsf@fess.ebiederm.org> <20120402213440.49e9de74@neptune>
	<1333401898.2960.78.camel@laptop> <1333403193.2960.80.camel@laptop>
	<20120403060252.GA27084@gmail.com>
	<20120403081735.78ca3bb3@pluto.restena.lu>
Date: Tue, 03 Apr 2012 00:11:57 -0700
In-Reply-To: <20120403081735.78ca3bb3@pluto.restena.lu> ("Bruno
 =?utf-8?Q?Pr=C3=A9mont=22's?=
	message of "Tue, 3 Apr 2012 08:17:35 +0200")
Message-ID: <m1d37pgugy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wX1kw2t8lOSGklZ28UilrONFo1c5mR0c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Bruno Pr=c3=a9mont <bonbons@linux-vserver.org>?=
X-Spam-Relay-Country: **
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Bruno Prémont <bonbons@linux-vserver.org> writes:

> Prevent kernel from crashing when a device is being registered with sysfs
> but has no (aka NULL) group attributes, but warn about it so calling path
> can get fixed.

The idea is reasonable but the implementation is horrible.

>> Will do - but the underlying generic bug should be fixed as 
>> well: we must not crash just because some attributes are missing 
>> in a rarely used sub-driver ...
>> 
>> We should WARN_ON(), etc. - but not crash.

FIX perf to include sanity checks.

Anything we do in sysfs is just pointless because perf was clever and
the offender did not show up in the backtrace.

Right now perf is so bad we just waste everyone's time.

> Greg, is this ok for you or should the check be moved out to calling
> internal_create_group()?

Please put changes in internal_create_group where all of the rest of the
checks are.

We should do something like:
if (!grp->attrs) {
	WARN(1, "sysfs: idiot subsystem did not include attrs for group: %s/%s\n"
        	kobj->name, grp->name?"":grp->name);
	return -EINVAL;
}

As it stands your patch is horrible it leaves sysfs in an inconsistent
state.  Creating the directory and leaving it there.  Not returning an
error code.  It looks like there are all kinds of weird problems that
removing the group or updating the group could get into if we go with
your patch.

Eric
> ---
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index dd1701c..0040ff2 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -32,7 +32,8 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  	struct attribute *const* attr;
>  	int error = 0, i;
>  
> -	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> +	WARN_ON(!grp->attrs);
> +	for (i = 0, attr = grp->attrs; attr && *attr && !error; i++, attr++) {
>  		umode_t mode = 0;
>  
>  		/* in update mode, we're changing the permissions or
