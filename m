Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab2AMKOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 05:14:04 -0500
Received: from mga12.intel.com ([143.182.124.36]:46896 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658Ab2AMKOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 05:14:00 -0500
MIME-Version: 1.0
In-Reply-To: <20120105143015.540ba7d7.akpm@linux-foundation.org>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
	<1324560391.1964.8.camel@falcor>
	<20120104152801.d8f555ca.akpm@linux-foundation.org>
	<1325723630.13419.2.camel@falcor>
	<20120104164638.cc21fc2e.akpm@linux-foundation.org>
	<20120105020639.GA1161@kroah.com>
	<1325737033.13419.43.camel@falcor>
	<20120105165412.GE26153@kroah.com>
	<1325783951.23566.52.camel@falcor>
	<1325788781.2775.12.camel@dabdike.Larkspurhotels.com>
	<20120105143015.540ba7d7.akpm@linux-foundation.org>
Date: Fri, 13 Jan 2012 12:13:59 +0200
Message-ID: <CALLzPKYngbfS+ccEfhMFy1u1UZuPCdA++bVAuDg5+_mgxh47JA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 12:30 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 05 Jan 2012 10:39:41 -0800
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>
>> > > Please, go read Documentation/stable_kernel_rules.txt for how to
>> > > properly submit patches to the stable kernel tree.  The information here
>> > > needs to be in the patch changelog itself, not in some random email
>> > > thread that will get lost instantly into my email-archive-from-hell
>> > > after I am done reading this.
>> > >
>> > > greg k-h
>> >
>> > Yes, I've read Documentation/stable_kernel_rules.txt and think this
>> > patch meets the criteria for being backported.
>> >
>> > As far as I'm aware, this patch hasn't been upstreamed yet and is
>> > waiting for someone, besides myself, to Ack it.  Once Acked, either
>> > Dmitry or I can send a pull request with an updated patch description.
>> > Should this patch go in via the security tree?
>>
>> If it hasn't been upstreamed yet, just make sure you put
>>
>> cc: stable@kernel.org
>>
>> In the signoffs of the patch you're sending upstream and the backport
>> will occur automatically when the patch is finally upstreamed.
>
> Mimi didn't write or send the patch.
>
> This happily git-free maintainer simply goes in and edits the
> changelog.  I do this very very frequently.
>
>
> Here's what I currently have.  I plan to send this to Rip Van Viro.
>
>

Hello,

Should I do anything about re-submitting this patch now?
Or it went forward already?

Thanks,
Dmitry

>
>
> From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Subject: vfs: increment iversion when a file is truncated
>
> When a file is truncated with truncate()/ftruncate() and then closed,
> iversion is not updated.  This patch uses ATTR_SIZE flag as an indication
> to increment iversion.
>
> Mimi said:
>
> On fput(), i_version is used to detect and flag files that have changed
> and need to be re-measured in the IMA measurement policy.  When a file
> is truncated with truncate()/ftruncate() and then closed, i_version is
> not updated.  As a result, although the file has changed, it will not be
> re-measured and added to the IMA measurement list on subsequent access.
>
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/attr.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff -puN fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated fs/attr.c
> --- a/fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated
> +++ a/fs/attr.c
> @@ -176,6 +176,11 @@ int notify_change(struct dentry * dentry
>                        return -EPERM;
>        }
>
> +       if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
> +               if (attr->ia_size != inode->i_size)
> +                       inode_inc_iversion(inode);
> +       }
> +
>        if ((ia_valid & ATTR_MODE)) {
>                umode_t amode = attr->ia_mode;
>                /* Flag setting protected by i_mutex */
> _
