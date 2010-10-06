Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab0JFO7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:59:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51012 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab0JFO7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xvcN3SoidoEkkGvInRBqh9Ph3NvWUZPhCK3AZLcFhtQKRP71fUWBcP+bLTCNr1MlxJ
         O18hGyZlYuytCv96wc4sP7qNZzPfQuQZ6991M7BUUh5+6oaGvY3ATzWVaOYugpPPj7uE
         kFw6v0zo7CBikUVcKDtOUOnDeUjvGPB6sOv0U=
MIME-Version: 1.0
In-Reply-To: <m3wrpvinvv.fsf@linux.vnet.ibm.com>
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<AANLkTinpie0YLpiuJjv1RzYr4LN1HbdtXh=OoNNJbG6k@mail.gmail.com>
	<m362xfkfo8.fsf@linux.vnet.ibm.com>
	<m3wrpvinvv.fsf@linux.vnet.ibm.com>
Date: Wed, 6 Oct 2010 10:59:41 -0400
Message-ID: <AANLkTi=qbYsXAOB5ArodYSr+DYwk16mV1F-8+=b5rK6P@mail.gmail.com>
Subject: Re: [V9fs-developer] [PATCH 1/3] fs/9p: Update TLCREATE to allow
 create without open
From: Eric Van Hensbergen <ericvh@gmail.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 7:03 AM, Aneesh Kumar K. V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, 06 Oct 2010 11:48:15 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> On Tue, 5 Oct 2010 13:15:42 -0400, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>> > Ouch.  Protocol change.
>> >
>> > Also - not sure I understand what's going on here.  Why does mknod go
>> > through TLCREATE, shouldn't we have our
>> > own protocol messages for mknod?//
>>
>> This is needed for the below mknod usage
>>
>> mknod("k2", S_IFREG) ;
>>
>>
>
> May be a better fix is to make sure we use TLMKNOD instead of TLCREATE
> in case we get a create without LOOKUP_OPEN flags set. So how about
>

Yes, I think that's the better path.  :)

      -eric


> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 2f904a8..e89754f 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -55,6 +55,10 @@ static const struct inode_operations v9fs_file_inode_operations_dotl;
>  static const struct inode_operations v9fs_symlink_inode_operations;
>  static const struct inode_operations v9fs_symlink_inode_operations_dotl;
>
> +static int
> +v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
> +                   dev_t rdev);
> +
>  /**
>  * unixmode2p9mode - convert unix mode bits to plan 9
>  * @v9ses: v9fs session information
> @@ -681,8 +685,14 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>        v9ses = v9fs_inode2v9ses(dir);
>        if (nd && nd->flags & LOOKUP_OPEN)
>                flags = nd->intent.open.flags - 1;
> -       else
> -               flags = O_RDWR;
> +       else {
> +               /*
> +                * create call without LOOKUP_OPEN is due
> +                * to mknod of regular files. So use mknod
> +                * operation.
> +                */
> +               return v9fs_vfs_mknod_dotl(dir, dentry, omode, 0);
> +       }
>
>        name = (char *) dentry->d_name.name;
>        P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
>
> ------------------------------------------------------------------------------
> Beautiful is writing same markup. Internet Explorer 9 supports
> standards for HTML5, CSS3, SVG 1.1,  ECMAScript5, and DOM L2 & L3.
> Spend less time writing and  rewriting code and more time creating great
> experiences on the web. Be a part of the beta today.
> http://p.sf.net/sfu/beautyoftheweb
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
