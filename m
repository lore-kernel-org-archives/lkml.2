Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1HKT3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:29:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50324 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1HKT3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com>
Date: Thu, 11 Aug 2011 15:29:34 -0400
Message-ID: <CACLa4ptNaOvwFX-2VPBve=PBvnB7X85tzTnTPSLtprbT8vSGgw@mail.gmail.com>
Subject: Re: [PATCH] CIFS: remove local xattr definitions
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that this patch is wrong, but shouldn't cifs include xattr.h
directly rather than rely on such an obscure indirect callchain as
well?

-Eric

On Thu, Aug 11, 2011 at 3:14 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Local XATTR_TRUSTED_PREFIX_LEN and XATTR_SECURITY_PREFIX_LEN definitions
> redefined ones in 'linux/xattr.h'. This was caused by commit 9d8f13ba3f48
> ("security: new security_inode_init_security API adds function callback")
> including 'linux/xattr.h' in 'linux/security.h'.
>
> In file included from include/linux/security.h:39,
>                 from include/net/sock.h:54,
>                 from fs/cifs/cifspdu.h:25,
>                 from fs/cifs/xattr.c:26:
>
> This patch removes the local definitions.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  fs/cifs/xattr.c |   39 +++++++++++++++++----------------------
>  1 files changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 2a22fb2..7f23f3c 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -31,16 +31,8 @@
>  #define MAX_EA_VALUE_SIZE 65535
>  #define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
>  #define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
> -#define CIFS_XATTR_USER_PREFIX "user."
> -#define CIFS_XATTR_SYSTEM_PREFIX "system."
> -#define CIFS_XATTR_OS2_PREFIX "os2."
> -#define CIFS_XATTR_SECURITY_PREFIX "security."
> -#define CIFS_XATTR_TRUSTED_PREFIX "trusted."
> -#define XATTR_TRUSTED_PREFIX_LEN  8
> -#define XATTR_SECURITY_PREFIX_LEN 9
> -/* BB need to add server (Samba e.g) support for security and trusted prefix */
> -
>
> +/* BB need to add server (Samba e.g) support for security and trusted prefix */
>
>  int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>  {
> @@ -76,8 +68,8 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>        }
>        if (ea_name == NULL) {
>                cFYI(1, "Null xattr names not supported");
> -       } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
> -               && (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4))) {
> +       } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
> +               && (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))) {
>                cFYI(1,
>                     "illegal xattr request %s (only user namespace supported)",
>                     ea_name);
> @@ -88,7 +80,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>                        goto remove_ea_exit;
>
> -               ea_name += 5; /* skip past user. prefix */
> +               ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
>                rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
>                        (__u16)0, cifs_sb->local_nls,
>                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> @@ -149,21 +141,23 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
>
>        if (ea_name == NULL) {
>                cFYI(1, "Null xattr names not supported");
> -       } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
> +       } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
> +                  == 0) {
>                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>                        goto set_ea_exit;
>                if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
>                        cFYI(1, "attempt to set cifs inode metadata");
>
> -               ea_name += 5; /* skip past user. prefix */
> +               ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
>                rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
>                        (__u16)value_size, cifs_sb->local_nls,
>                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> -       } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
> +       } else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)
> +                  == 0) {
>                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>                        goto set_ea_exit;
>
> -               ea_name += 4; /* skip past os2. prefix */
> +               ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
>                rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
>                        (__u16)value_size, cifs_sb->local_nls,
>                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> @@ -269,7 +263,8 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>        /* return alt name if available as pseudo attr */
>        if (ea_name == NULL) {
>                cFYI(1, "Null xattr names not supported");
> -       } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
> +       } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
> +                  == 0) {
>                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>                        goto get_ea_exit;
>
> @@ -277,15 +272,15 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>                        cFYI(1, "attempt to query cifs inode metadata");
>                        /* revalidate/getattr then populate from inode */
>                } /* BB add else when above is implemented */
> -               ea_name += 5; /* skip past user. prefix */
> +               ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
>                rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
>                        buf_size, cifs_sb->local_nls,
>                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> -       } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
> +       } else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
>                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>                        goto get_ea_exit;
>
> -               ea_name += 4; /* skip past os2. prefix */
> +               ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
>                rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
>                        buf_size, cifs_sb->local_nls,
>                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> @@ -339,10 +334,10 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>                cFYI(1, "Query CIFS ACL not supported yet");
>  #endif /* CONFIG_CIFS_ACL */
>        } else if (strncmp(ea_name,
> -                 CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
> +                 XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
>                cFYI(1, "Trusted xattr namespace not supported yet");
>        } else if (strncmp(ea_name,
> -                 CIFS_XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
> +                 XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
>                cFYI(1, "Security xattr namespace not supported yet");
>        } else
>                cFYI(1,
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
