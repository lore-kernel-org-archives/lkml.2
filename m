Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab1DLKe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:34:28 -0400
Received: from mx04.teleca.com ([212.92.145.6]:59254 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab1DLKe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:34:27 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Apr 2011 06:34:26 EDT
Message-ID: <4DA4294C.2020609@nokia.com>
Date: Tue, 12 Apr 2011 14:28:28 +0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: Roman Borisov <ext-roman.borisov@nokia.com>, linux-kernel@vger.kernel.org,
        vda.linux@googlemail.com, cebbert@redhat.com, virtuoso@slind.org
Subject: Re: [PATCH] fs: bound mount propagation fix
References: <201103262243.18031.vda.linux@googlemail.com> <7b9aa806294aadd47704d56ae3e7c757bf0ce6db.1301667509.git.ext-roman.borisov@nokia.com>
In-Reply-To: <7b9aa806294aadd47704d56ae3e7c757bf0ce6db.1301667509.git.ext-roman.borisov@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Apr 2011 10:26:06.0423 (UTC) FILETIME=[0842BE70:01CBF8FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 06:48 PM, Roman Borisov wrote:
> I think MS_SILENT shouldn't be cleared anywhere. I suppose the bug is in
> MS_SHARED options checking. Please see the patch below.
>
> Fixed MS_SHARED, MS_SLAVE, MS_UNBINDABLE option handling;
> Existing options check doesn't allow to have any options combinations
> because of integer comparison (not bitwise).
>
> Signed-off-by: Roman Borisov<ext-roman.borisov@nokia.com>
> ---
>   fs/namespace.c |    2 +-
>   fs/pnode.c     |    6 +++---
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 2beb0fb..e0cf263 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1434,7 +1434,7 @@ static int do_change_type(struct path *path, int flag)
>   		return -EINVAL;
>
>   	down_write(&namespace_sem);
> -	if (type == MS_SHARED) {
> +	if (type&  MS_SHARED) {
>   		err = invent_group_ids(mnt, recurse);
>   		if (err)
>   			goto out_unlock;
> diff --git a/fs/pnode.c b/fs/pnode.c
> index 8d5f392..0c9dc54 100644
> --- a/fs/pnode.c
> +++ b/fs/pnode.c
> @@ -128,15 +128,15 @@ static int do_make_slave(struct vfsmount *mnt)
>
>   void change_mnt_propagation(struct vfsmount *mnt, int type)
>   {
> -	if (type == MS_SHARED) {
> +	if (type&  MS_SHARED) {
>   		set_mnt_shared(mnt);
>   		return;
>   	}
>   	do_make_slave(mnt);
> -	if (type != MS_SLAVE) {
> +	if (!(type&  MS_SLAVE)) {
>   		list_del_init(&mnt->mnt_slave);
>   		mnt->mnt_master = NULL;
> -		if (type == MS_UNBINDABLE)
> +		if (type&  MS_UNBINDABLE)
>   			mnt->mnt_flags |= MNT_UNBINDABLE;
>   		else
>   			mnt->mnt_flags&= ~MNT_UNBINDABLE;

Al could you comment please on which of the two approaches you prefer: 
mine or previously Denis's

--
Roman
