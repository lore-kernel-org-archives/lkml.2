Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423Ab1LPSkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:40:32 -0500
Received: from mga12.intel.com ([143.182.124.36]:56601 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172Ab1LPSkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:40:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111215135550.748e9aee.akpm@linux-foundation.org>
References: <09b6266e3209433bac9b57baf39e073945533d5a.1323880769.git.dmitry.kasatkin@intel.com>
	<20111215135550.748e9aee.akpm@linux-foundation.org>
Date: Fri, 16 Dec 2011 20:40:20 +0200
Message-ID: <CALLzPKa3d+4R3H7KgB1GPmb4hkAavqEXMh-B3kSnG1fnKFkK3Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] do_truncate needs to increment iversion
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:55 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 Dec 2011 18:44:57 +0200
> Dmitry Kasatkin <dmitry.kasatkin@intel.com> wrote:
>
>> IMA/EVM uses iversion to identify if file content has been changed.
>> It has been found that when file is opened, truncated with ftruncate()
>> and then closed, iversion is not updated.
>>
>> This patch adds iversion incrementation to do_truncate().
>
> I confess that I've never really fully understood what i_version is
> supposed to do, so I'm not in any position to comment on where, when
> and why the thing should be updated.
>
> At present it gets updated in file_update_time() so I suppose that
> we're not calling file_update_time() in the ftruncate case, which
> sounds wrong?

What I see from notify_change(), it updates the time...
So what is really missing is incrimination of i_version...

>
> It's notable that file_update_time() will not update i_version if the
> inode has NOCMTIME.  This might be wrong, but one would need to know
> the intent of i_version to be able to say.  Do your files have
> S_NOCMTIME set?

Yes. I saw it and even made a test to verify if is the reason for
i_version not to be updated...
But it was not set.
I have the same feeling that i_version should be updated despite NOCMTIME,
because i_version supposed to work if mounted with "iversion" option....
I think it should not have dependency to other mount options...

>
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -56,6 +56,8 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
>>               newattrs.ia_valid |= ret | ATTR_FORCE;
>>
>>       mutex_lock(&dentry->d_inode->i_mutex);
>> +     if (IS_I_VERSION(dentry->d_inode))
>> +             inode_inc_iversion(dentry->d_inode);
>>       ret = notify_change(dentry, &newattrs);
>>       mutex_unlock(&dentry->d_inode->i_mutex);
>>       return ret;
>
> With four evaluations, it is time to cache dentry->d_inode in a local.

True...

Thanks..
