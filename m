Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab1FWST4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:19:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39061 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab1FWSTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DrL0k43XL9bFZJzT5hoPIj0XbLNK3OWX+ENrZukaiptZSWwKNvrSYs9zY17K050iwX
         Fs5iuicN8FnVYFhOFH4VmavteZjtdtt3u7xPwSFSxzC5PvwCslI2kHGuHG/82tr08dbQ
         WWCYJbMcAU8vu9P9tdeny7nmp2Re7g4rOVK8c=
MIME-Version: 1.0
In-Reply-To: <1308851366.5295.1.camel@dan>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
	<1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
	<1308850515-15242-179-git-send-email-paul.gortmaker@windriver.com>
	<1308851366.5295.1.camel@dan>
Date: Thu, 23 Jun 2011 14:19:50 -0400
X-Google-Sender-Auth: TyVj4muAtyQ-wC714TiIjLXk9-4
Message-ID: <BANLkTimWz4q-N1cs74c+HeBEPXKEjxD1Zg@mail.gmail.com>
Subject: Re: [34-longterm 238/247] xfs: prevent leaking uninitialized stack
 memory in FSGEOMETRY_V1
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Alex Elder <aelder@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 1:49 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> On Thu, 2011-06-23 at 13:35 -0400, Paul Gortmaker wrote:
>> From: Dan Rosenberg <drosenberg@vsecurity.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit 3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba upstream.
>>
>> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
>> xfs_fs_geometry() with a version number of 3.  This code path does not
>> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
>> the leaking of four bytes of uninitialized stack data to potentially
>> unprivileged callers.
>>
>> v2 switches to memset() to avoid future issues if structure members
>> change, on suggestion of Dave Chinner.
>>
>> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
>> Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
>> Signed-off-by: Alex Elder <aelder@sgi.com>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>  fs/xfs/xfs_fsops.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
>> index 37a6f62..4e7f02b 100644
>> --- a/fs/xfs/xfs_fsops.c
>> +++ b/fs/xfs/xfs_fsops.c
>> @@ -57,6 +57,9 @@ xfs_fs_geometry(
>>       xfs_fsop_geom_t         *geo,
>>       int                     new_version)
>>  {
>> +
>> +     memset(geo, 0, sizeof(*geo));
>> +
>>       geo->blocksize = mp->m_sb.sb_blocksize;
>>       geo->rtextsize = mp->m_sb.sb_rextsize;
>>       geo->agblocks = mp->m_sb.sb_agblocks;
>> --
>> 1.7.4.4
>
> This introduced a regression which was fixed by commit
> af24ee9ea8d532e16883251a6684dfa1be8eec29.

Thanks Dan,

Fix queued and will appear shortly here.

http://git.kernel.org/?p=linux/kernel/git/longterm/longterm-queue-2.6.34.git;a=summary

Paul.

>
> -Dan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
