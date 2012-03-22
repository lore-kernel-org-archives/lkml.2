Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab2CVOXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:23:38 -0400
Received: from mga07.intel.com ([143.182.124.22]:45244 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932075Ab2CVOXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <1332356057-3356-3-git-send-email-zohar@linux.vnet.ibm.com>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1332356057-3356-3-git-send-email-zohar@linux.vnet.ibm.com>
Date: Thu, 22 Mar 2012 16:23:33 +0200
Message-ID: <CALLzPKabJQOjYmG8-MWqoQdTc1mKjOCaxy+K6T_ZyvURKLnj6g@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] vfs: move ima_file_free before releasing the file
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 8:54 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> ima_file_free(), called on __fput(), currently flags files that have
> changed, so that the file is re-measured.  For appraising a files's
> integrity, the file's hash must be re-calculated and stored in the
> 'security.ima' xattr to reflect any changes.
>
> This patch moves the ima_file_free() call to before releasing the file
> in preparation of ima-appraisal measuring the file and updating the
> 'security.ima' xattr.
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

> ---
>  fs/file_table.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 20002e3..554161a 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -243,10 +243,10 @@ static void __fput(struct file *file)
>                if (file->f_op && file->f_op->fasync)
>                        file->f_op->fasync(-1, file, 0);
>        }
> +       ima_file_free(file);
>        if (file->f_op && file->f_op->release)
>                file->f_op->release(inode, file);
>        security_file_free(file);
> -       ima_file_free(file);
>        if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
>                     !(file->f_mode & FMODE_PATH))) {
>                cdev_put(inode->i_cdev);
> --
> 1.7.6.5
>
