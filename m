Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2B1HRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:17:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40027 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2B1HRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:17:23 -0500
Message-ID: <4F4C7F7C.6020009@canonical.com>
Date: Mon, 27 Feb 2012 23:17:16 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120224 Thunderbird/11.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] AppArmor: Add the ability to mediate mount
References: <1330381397-5352-1-git-send-email-john.johansen@canonical.com> <1330381397-5352-8-git-send-email-john.johansen@canonical.com> <201202280229.q1S2TBVA080761@www262.sakura.ne.jp>
In-Reply-To: <201202280229.q1S2TBVA080761@www262.sakura.ne.jp>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 06:29 PM, Tetsuo Handa wrote:
> Only checking "[PATCH 7/7] AppArmor: Add the ability to mediate mount".
> 
> 
> 
> John Johansen wrote:
>> --- a/security/apparmor/include/apparmor.h
>> +++ b/security/apparmor/include/apparmor.h
>> @@ -29,8 +29,9 @@
>>  #define AA_CLASS_NET           4
>>  #define AA_CLASS_RLIMITS       5
>>  #define AA_CLASS_DOMAIN                6
>> +#define AA_CLASS_MOUNT         7
>>
>> -#define AA_CLASS_LAST          AA_CLASS_DOMAIN
>> +#define AA_CLASS_LAST          AA_CLASS_MOUNT
> 
> Maybe use of enum is easier to maintain?
> 
meh, I'm indifferent either works I don't really see enums as easier, but certainly
no worse

> 
> 
>> --- /dev/null
>> +++ b/security/apparmor/mount.c
>> +static void audit_mnt_flags(struct audit_buffer *ab, unsigned long flags)
>> +{
> (...snipped...)
>> +       if (flags & MS_UNBINDABLE)
>> +               audit_log_format(ab, flags & MS_REC ? ", runbindable" :
>> +                                ", unbindable");
>> +       if (flags & MS_PRIVATE)
>> +               audit_log_format(ab, flags & MS_REC ? ", rprivate" :
>> +                                ", private");
>> +       if (flags & MS_UNBINDABLE)
>> +               audit_log_format(ab, flags & MS_REC ? ", rslave" :
>> +                                ", slave");
> 
> MS_UNBINDABLE -> MS_SLAVE
> 
>> +       if (flags & MS_UNBINDABLE)
>> +               audit_log_format(ab, flags & MS_REC ? ", rshared" :
>> +                                ", shared");
> 
> MS_UNBINDABLE -> MS_SHARED
> 
> (...snipped...)

gah, color me embarrassed and a little puzzled I know I fixed that error once
already.  Not sure if it did get saved, was not git added or maybe something
else ...

>> +}
> 
> 
> 
>> +/**
>> + * mount_audit_cb - call back for mount specific audit fields
>> + * @ab: audit_buffer  (NOT NULL)
>> + * @va: audit struct to audit values of  (NOT NULL)
>> + */
>> +static void mount_audit_cb(struct audit_buffer *ab, void *va)
>> +{
>> +       struct common_audit_data *sa = va;
> (...snipped...)
>> +       if (sa->aad.mnt.data) {
>> +               audit_log_format(ab, " options=");
>> +               audit_log_untrustedstring(ab, sa->aad.mnt.data);
>> +       }
> 
> data might be binary. Also, there is no guarantee that
> memchr(data, '\0', PAGE_SIZE) != NULL even if data is not binary.
> I think auditing this argument should be avoided.
> 
Hrmm we should only be setting it/checking it if its not binary data.
But of course while I got the checking bit in there, I missed the
conditional on setting.

You are right about the no null termination not being guarenteed
though we should be using audit_log_n_untrustedstring, and capping
at the first of null byte or data page.

Its size can be an issue and that is why its deliberately the last element
that gets added.  I think that we do want to audit it though because it
can be quite useful.

>> +}
> 
> 
> 
>> +/**
>> + * aa_audit_file - handle the auditing of file operations
>> + * @profile: the profile being enforced  (NOT NULL)
>> + * @gfp: allocation flags
>> + * @op: operation being mediated
>> + * @name: name of object being mediated (MAYBE NULL)
>> + * @src_name: src_name of object being mediated (MAYBE_NULL)
>> + * @type: type of filesystem
> 
> aa_remount() passes @type == NULL.
right, I did grab the type in remount from the fs, though perhaps I should have,
NULL should be valid here as it just assigns it to mnt.type which is conditionally
logged in mount_audit_cb, so the comment needs to updated

Really the whole audit setup for these routines needs to be reworked, to clean
them up. I have been toying with a couple of ways to make this cleaner and
avoid calling function with a huge list of parameters like, is being done here.

> Maybe use of gcc's __attribute__((nonnull(...))) helps catching this kind of
> error.
> 
yeah, actually that isn't a bad idea

>> + * @trans: name of trans (MAYBE NULL)
>> + * @flags: filesystem idependent mount flags
>> + * @data: filesystem mount flags
>> + * @request: permissions requested
>> + * @perms: the permissions computed for the request (NOT NULL)
>> + * @info: extra information message (MAYBE NULL)
>> + * @error: 0 if operation allowed else failure error code
>> + *
>> + * Returns: %0 or error on failure
>> + */
> 
> 
> 
>> +int aa_remount(struct aa_profile *profile, struct path *path,
>> +              unsigned long flags, void *data)
>> +{
>> +       struct file_perms perms;
> 
> Please explicitly initialize perms, or
> 
yikes! yes.  I missed this one when reworking how the permissions where handled

>> +       const char *name, *info = NULL;
>> +       char *buffer = NULL;
>> +       int binarydata, error;
>> +
>> +       binarydata = path->dentry->d_sb->s_type->fs_flags & FS_BINARY_MOUNTDATA;
>> +
>> +       error = aa_path_name(path, path_flags(profile, path), &buffer, &name,
>> +                            &info);
>> +       if (error)
>> +               goto audit;
>> +
> 
> this error path will call aa_audit_mount() with perms uninitialized.
> 
> 
> 
>> +int aa_mount_change_type(struct aa_profile *profile, struct path *path,
>> +                        unsigned long flags)
>> +{
>> +       struct file_perms perms = { };
>> +       char *buffer = NULL;
>> +       const char *name, *info = NULL;
>> +       int error;
>> +
>> +       flags &= (MS_REC | MS_SILENT | MS_SHARED | MS_PRIVATE | MS_SLAVE |
>> +                 MS_UNBINDABLE);
> 
> Do you really want to drop these flags from audit_mnt_flags()?
> 
hrmm, it was intentional, though something I was on the fence about.  Basically
this is currently the set of valid flags for do_change_type() and the question was
whether to have apparmor rejecting on invalid flags or do_change_type()

Of course this also means that apparmor needs to be kept in sync with what is
valid flags in do_change_type().  So perhaps it is better to just have apparmor issue
rejects here even if do_change_type would fail it later.

> 
> 
>> +int aa_move_mount(struct aa_profile *profile, struct path *path,
>> +                 const char *orig_name)
>> +{
>> +       struct file_perms perms = { };
>> +       char *buffer = NULL, *old_buffer = NULL;
>> +       const char *name, *old_name, *info = NULL;
> 
> Please explicitly initialize old_name with NULL, or
> 
yep, thanks

>> +       struct path old_path;
>> +       int error;
>> +
>> +       if (!orig_name || !*orig_name)
>> +               return -EINVAL;
>> +
>> +       error = aa_path_name(path, path_flags(profile, path), &buffer, &name,
>> +                            &info);
>> +       if (error)
>> +               goto audit;
> 
> this error path will call aa_audit_mount() with old_name uninitialized.
> 
> 
> 
>> +int aa_new_mount(struct aa_profile *profile, const char *orig_dev_name,
>> +                struct path *path, const char *type, unsigned long flags,
>> +                void *data)
>> +{
>> +       struct file_system_type *fstype = NULL;
>> +       struct file_perms perms = { };
>> +       char *buffer = NULL, *dev_buffer = NULL;
>> +       const char *name, *dev_name, *info = NULL;
> 
> Please explicitly initialize dev_name with NULL, or
> 
sigh, yep.

>> +       struct path dev_path;
>> +       int binary_data, error;
>> +
>> +       fstype = get_fs_type(type);
> 
> get_fs_type() does not accept type == NULL but type != NULL is not checked.
> 
indeed, thanks
>> +       if (!fstype) {
>> +               error = -ENODEV;
>> +               goto out;
>> +       }
>> +       binary_data = fstype->fs_flags & FS_BINARY_MOUNTDATA;
>> +
>> +       if (fstype->fs_flags & FS_REQUIRES_DEV) {
>> +               if (!dev_name) {
> 
> dev_name -> orig_dev_name
> 
> kern_path() does not accept orig_dev_name == NULL.
> 
right

>> +                       error = -ENOENT;
>> +                       goto out;
>> +               }
>> +
>> +               error = kern_path(orig_dev_name, LOOKUP_FOLLOW, &dev_path);
>> +               if (error)
>> +                       goto audit;
>> +
> 
> this error path will call aa_audit_mount() with dev_name uninitialized.
> 
yep

>> +               error = aa_path_name(&dev_path, path_flags(profile, &dev_path),
>> +                                    &dev_buffer, &dev_name, &info);
>> +               path_put(&dev_path);
>> +               if (error)
>> +                       goto audit;
>> +       } else
>> +               dev_name = orig_dev_name;
>> +
> (...snipped...)
>> +}
> 
> 
> 
>> +int aa_pivotroot(struct aa_profile *profile, struct path *old_path,
>> +                 struct path *new_path)
>> +{
>> +       struct file_perms perms = { };
>> +       struct aa_profile *target = NULL;
>> +       char *old_buffer = NULL, *new_buffer = NULL;
>> +       const char *old_name, *new_name, *info = NULL;
> 
> Please explicitly initialize new_name with NULL, or
> 
yep

>> +       int error;
>> +
>> +       error = aa_path_name(old_path, path_flags(profile, old_path),
>> +                            &old_buffer, &old_name, &info);
>> +       if (error)
>> +               goto audit;
> 
> this error path will call aa_audit_mount() with new_name uninitialized.
> 
> (...snipped...)
>> +}

thanks for the review Tetsuo
