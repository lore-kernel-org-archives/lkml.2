Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0CYOFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:05:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64274 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0CYOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b6rUxa8vTUYkG+pkILErnP2ZcrRfoZAOGgjn/rhkLqnakr5wJtvyQlyhIex5pB0UMz
         r38ePelwgTZbOnUPn6S7ONwPseS+7LjfUL15u57QHixLplq30qSnG97ucFhmGRM4Pe6N
         US6kYbdvv9lVNavYA+F38emO9zcSlD0aX/aq8=
Message-ID: <4BAB6D98.1090900@panasas.com>
Date: Thu, 25 Mar 2010 16:05:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       linux-kernel@vger.kernel.org, Sachin Prabhu <sprabhu@redhat.com>
Subject: Re: [PATCH] ocfs2: Skip check for mandatory locks when unlocking
References: <19368.33225.516492.542519@notabene.brown>
In-Reply-To: <19368.33225.516492.542519@notabene.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 10:54 AM, Neil Brown wrote:
> 
> The nfs bug fixed by 0800c5f7a499a8961c3868e95cc4cf1715166457
> and the 9p bug fixed by f78233dd44a110c574fe760ad6f9c1e8741a0d00
> and the gfs2 bug fixed by 720e7749279bde0d08684b1bb4e7a2eedeec6394
> 
> also needs to be fixed for ocfs2.  This patch does that.
> 
> Hopefully this is the last filesystem with this bug :-)
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> Cc: stable@kernel.org
> 
> diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
> index 544ac62..923d3d8 100644
> --- a/fs/ocfs2/locks.c
> +++ b/fs/ocfs2/locks.c
> @@ -113,7 +113,8 @@ int ocfs2_flock(struct file *file, int cmd, struct file_lock *fl)
>  
>  	if (!(fl->fl_flags & FL_FLOCK))
>  		return -ENOLCK;
> -	if (__mandatory_lock(inode))
> +	if (__mandatory_lock(inode) &&
> +	    fl->fl_type != F_UNLCK)

If you reverse the order of these then you'd optimize away
the call to __mandatory_lock(inode). As it is now, it will
call it but then ignore the return if  == F_UNLCK.

>  		return -ENOLCK;
>  
>  	if ((osb->s_mount_opt & OCFS2_MOUNT_LOCALFLOCKS) ||
> --

Boaz
