Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab2B1C3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:29:20 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57516 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2B1C3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:29:18 -0500
X-Nat-Received: from [202.181.97.72]:56254 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1330396152.7899
Message-Id: <201202280229.q1S2TBVA080761@www262.sakura.ne.jp>
Subject: Re: [PATCH 7/7] AppArmor: Add the ability to mediate mount
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.johansen@canonical.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Feb 2012 11:29:11 +0900
References: <1330381397-5352-1-git-send-email-john.johansen@canonical.com> <1330381397-5352-8-git-send-email-john.johansen@canonical.com>
In-Reply-To: <1330381397-5352-8-git-send-email-john.johansen@canonical.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 28022012 #7118673, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only checking "[PATCH 7/7] AppArmor: Add the ability to mediate mount".



John Johansen wrote:
> --- a/security/apparmor/include/apparmor.h
> +++ b/security/apparmor/include/apparmor.h
> @@ -29,8 +29,9 @@
>  #define AA_CLASS_NET           4
>  #define AA_CLASS_RLIMITS       5
>  #define AA_CLASS_DOMAIN                6
> +#define AA_CLASS_MOUNT         7
> 
> -#define AA_CLASS_LAST          AA_CLASS_DOMAIN
> +#define AA_CLASS_LAST          AA_CLASS_MOUNT

Maybe use of enum is easier to maintain?



> --- /dev/null
> +++ b/security/apparmor/mount.c
> +static void audit_mnt_flags(struct audit_buffer *ab, unsigned long flags)
> +{
(...snipped...)
> +       if (flags & MS_UNBINDABLE)
> +               audit_log_format(ab, flags & MS_REC ? ", runbindable" :
> +                                ", unbindable");
> +       if (flags & MS_PRIVATE)
> +               audit_log_format(ab, flags & MS_REC ? ", rprivate" :
> +                                ", private");
> +       if (flags & MS_UNBINDABLE)
> +               audit_log_format(ab, flags & MS_REC ? ", rslave" :
> +                                ", slave");

MS_UNBINDABLE -> MS_SLAVE

> +       if (flags & MS_UNBINDABLE)
> +               audit_log_format(ab, flags & MS_REC ? ", rshared" :
> +                                ", shared");

MS_UNBINDABLE -> MS_SHARED

(...snipped...)
> +}



> +/**
> + * mount_audit_cb - call back for mount specific audit fields
> + * @ab: audit_buffer  (NOT NULL)
> + * @va: audit struct to audit values of  (NOT NULL)
> + */
> +static void mount_audit_cb(struct audit_buffer *ab, void *va)
> +{
> +       struct common_audit_data *sa = va;
(...snipped...)
> +       if (sa->aad.mnt.data) {
> +               audit_log_format(ab, " options=");
> +               audit_log_untrustedstring(ab, sa->aad.mnt.data);
> +       }

data might be binary. Also, there is no guarantee that
memchr(data, '\0', PAGE_SIZE) != NULL even if data is not binary.
I think auditing this argument should be avoided.

> +}



> +/**
> + * aa_audit_file - handle the auditing of file operations
> + * @profile: the profile being enforced  (NOT NULL)
> + * @gfp: allocation flags
> + * @op: operation being mediated
> + * @name: name of object being mediated (MAYBE NULL)
> + * @src_name: src_name of object being mediated (MAYBE_NULL)
> + * @type: type of filesystem

aa_remount() passes @type == NULL.
Maybe use of gcc's __attribute__((nonnull(...))) helps catching this kind of
error.

> + * @trans: name of trans (MAYBE NULL)
> + * @flags: filesystem idependent mount flags
> + * @data: filesystem mount flags
> + * @request: permissions requested
> + * @perms: the permissions computed for the request (NOT NULL)
> + * @info: extra information message (MAYBE NULL)
> + * @error: 0 if operation allowed else failure error code
> + *
> + * Returns: %0 or error on failure
> + */



> +int aa_remount(struct aa_profile *profile, struct path *path,
> +              unsigned long flags, void *data)
> +{
> +       struct file_perms perms;

Please explicitly initialize perms, or

> +       const char *name, *info = NULL;
> +       char *buffer = NULL;
> +       int binarydata, error;
> +
> +       binarydata = path->dentry->d_sb->s_type->fs_flags & FS_BINARY_MOUNTDATA;
> +
> +       error = aa_path_name(path, path_flags(profile, path), &buffer, &name,
> +                            &info);
> +       if (error)
> +               goto audit;
> +

this error path will call aa_audit_mount() with perms uninitialized.



> +int aa_mount_change_type(struct aa_profile *profile, struct path *path,
> +                        unsigned long flags)
> +{
> +       struct file_perms perms = { };
> +       char *buffer = NULL;
> +       const char *name, *info = NULL;
> +       int error;
> +
> +       flags &= (MS_REC | MS_SILENT | MS_SHARED | MS_PRIVATE | MS_SLAVE |
> +                 MS_UNBINDABLE);

Do you really want to drop these flags from audit_mnt_flags()?



> +int aa_move_mount(struct aa_profile *profile, struct path *path,
> +                 const char *orig_name)
> +{
> +       struct file_perms perms = { };
> +       char *buffer = NULL, *old_buffer = NULL;
> +       const char *name, *old_name, *info = NULL;

Please explicitly initialize old_name with NULL, or

> +       struct path old_path;
> +       int error;
> +
> +       if (!orig_name || !*orig_name)
> +               return -EINVAL;
> +
> +       error = aa_path_name(path, path_flags(profile, path), &buffer, &name,
> +                            &info);
> +       if (error)
> +               goto audit;

this error path will call aa_audit_mount() with old_name uninitialized.



> +int aa_new_mount(struct aa_profile *profile, const char *orig_dev_name,
> +                struct path *path, const char *type, unsigned long flags,
> +                void *data)
> +{
> +       struct file_system_type *fstype = NULL;
> +       struct file_perms perms = { };
> +       char *buffer = NULL, *dev_buffer = NULL;
> +       const char *name, *dev_name, *info = NULL;

Please explicitly initialize dev_name with NULL, or

> +       struct path dev_path;
> +       int binary_data, error;
> +
> +       fstype = get_fs_type(type);

get_fs_type() does not accept type == NULL but type != NULL is not checked.

> +       if (!fstype) {
> +               error = -ENODEV;
> +               goto out;
> +       }
> +       binary_data = fstype->fs_flags & FS_BINARY_MOUNTDATA;
> +
> +       if (fstype->fs_flags & FS_REQUIRES_DEV) {
> +               if (!dev_name) {

dev_name -> orig_dev_name

kern_path() does not accept orig_dev_name == NULL.

> +                       error = -ENOENT;
> +                       goto out;
> +               }
> +
> +               error = kern_path(orig_dev_name, LOOKUP_FOLLOW, &dev_path);
> +               if (error)
> +                       goto audit;
> +

this error path will call aa_audit_mount() with dev_name uninitialized.

> +               error = aa_path_name(&dev_path, path_flags(profile, &dev_path),
> +                                    &dev_buffer, &dev_name, &info);
> +               path_put(&dev_path);
> +               if (error)
> +                       goto audit;
> +       } else
> +               dev_name = orig_dev_name;
> +
(...snipped...)
> +}



> +int aa_pivotroot(struct aa_profile *profile, struct path *old_path,
> +                 struct path *new_path)
> +{
> +       struct file_perms perms = { };
> +       struct aa_profile *target = NULL;
> +       char *old_buffer = NULL, *new_buffer = NULL;
> +       const char *old_name, *new_name, *info = NULL;

Please explicitly initialize new_name with NULL, or

> +       int error;
> +
> +       error = aa_path_name(old_path, path_flags(profile, old_path),
> +                            &old_buffer, &old_name, &info);
> +       if (error)
> +               goto audit;

this error path will call aa_audit_mount() with new_name uninitialized.

(...snipped...)
> +}
