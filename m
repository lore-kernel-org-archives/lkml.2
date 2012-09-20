Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2ITU5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:57:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62872 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2ITU51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:57:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120920132903.437434aa.akpm@linux-foundation.org>
References: <1347043094-11120-1-git-send-email-keescook@chromium.org>
	<1347043094-11120-2-git-send-email-keescook@chromium.org>
	<20120920132903.437434aa.akpm@linux-foundation.org>
Date: Thu, 20 Sep 2012 13:57:26 -0700
X-Google-Sender-Auth: y1euzt9jVmLPdyy4kiUXQevSeB8
Message-ID: <CAGXu5jKRK0KmiGAUY6ufg8rZqR5eJOocdTpmqYfL4OZct0OrCw@mail.gmail.com>
Subject: Re: [PATCH 2/2] security: introduce kernel_module_from_file hook
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 1:29 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  7 Sep 2012 11:38:13 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> Instead of (or in addition to) kernel module signing, being able to reason
>> about the origin of a kernel module would be valuable in situations
>> where an OS already trusts a specific file system, file, etc, due to
>> things like security labels or an existing root of trust to a partition
>> through things like dm-verity.
>
> <scratches head>
>
> This is a really sketchy rationale and I would like to see a *lot* more
> about the reasoning behind this.  Who will use the feature?  How will
> they use it?  What value will they obtain from using it?  This
> description should be pitched at kernel literate non-security people
> who lack mind-reading powers, please.

I'm happy to expand this further. I tried to give some examples, but
I'll expand on those. The bottom line is that Chrome OS wants to load
modules only from its crypto-verified read-only root filesystem. Doing
external per-module signatures makes no sense for us, and we want to
be able to reason about the origin of a module, which is what this
syscall gets us.

> We'll need a manpage for this, and I'd suggest that preparing it sooner
> rather than later will help with the review of your proposal.

Sounds good. The manpage is see for the old init_module looks to be
wildly out of data anyway, so perhaps I can fix that too. I'll check
the manpage tree.

>> This introduces a new syscall (currently only on x86), similar to
>> init_module, that has only two arguments. The first argument is used as
>> a file descriptor to the module and the second argument is a pointer to
>> the NULL terminated string of module arguments.
>>
>>
>> ...
>>
>> -static int copy_and_check(struct load_info *info,
>> -                       const void __user *umod, unsigned long len,
>> -                       const char __user *uargs)
>> +int copy_module_from_user(const void __user *umod, unsigned long len,
>> +                       struct load_info *info)
>
> can be made static, methinks.

Ah, yes, thanks. I'll fix the missing statics.

> `len' should have type size_t?

Yes, this was a left-over from the prior revision of this. I'll get
that fixed too.

>> +{
>> +     struct file *file;
>> +     int err;
>> +     struct kstat stat;
>> +     unsigned long size;
>> +     off_t pos;
>> +     ssize_t bytes = 0;
>> +
>> +     file = fget(fd);
>> +     if (!file)
>> +             return -ENOEXEC;
>> +
>> +     err = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
>> +     if (err)
>> +             goto out;
>> +
>> +     size = stat.size;
>
> kstat.size had type loff_t.  Here it gets trucated to 32 bits on 32-bit
> machines.  Harmless I guess, but sloppy.

It's actually intentional, since I want to load the entire file into a
kmalloc-able region. I'll return EFBIG if we would truncate instead.

>> +     info->hdr = vmalloc(size);
>> +     if (!info->hdr) {
>> +             err = -ENOMEM;
>> +             goto out;
>>       }
>>
>> -     if (hdr->e_shoff >= len ||
>> -         hdr->e_shnum * sizeof(Elf_Shdr) > len - hdr->e_shoff) {
>> -             err = -ENOEXEC;
>> -             goto free_hdr;
>> +     pos = 0;
>> +     while (pos < size) {
>
> `pos' should be loff_t as well.
>
>> +             bytes = kernel_read(file, pos, (char *)(info->hdr) + pos,
>> +                                 size - pos);
>> +             if (bytes < 0) {
>> +                     vfree(info->hdr);
>> +                     err = bytes;
>> +                     goto out;
>> +             }
>> +             if (bytes == 0)
>> +                     break;
>> +             pos += bytes;
>>       }
>> +     info->len = pos;
>> -     info->hdr = hdr;
>> -     info->len = len;
>> -     return 0;
>> +     err = check_info(info);
>> +     if (err)
>> +             vfree(info->hdr);
>>
>> -free_hdr:
>> -     vfree(hdr);
>> +out:
>> +     fput(file);
>>       return err;
>>  }
>>
>> @@ -2861,26 +2916,17 @@ static int post_relocation(struct module *mod, const struct load_info *info)
>>       return module_finalize(info->hdr, info->sechdrs, mod);
>>  }
>>
>> +static int do_init_module(struct module *mod);
>
> I wonder if do_init_module() could have been moved to avoid the forward
> declaration.

I was hoping to make the patch more readable, but I can move things
around to avoid the pre-declaration.

>
>>  /* Allocate and load the module: note that size of section 0 is always
>>     zero, and we rely on this for optional sections. */
>> -static struct module *load_module(void __user *umod,
>> -                               unsigned long len,
>> -                               const char __user *uargs)
>> +static int load_module(struct load_info *info, const char __user *uargs)
>>  {
>> -     struct load_info info = { NULL, };
>>       struct module *mod;
>>       long err;
>>
>>
>> ...
>>
>> @@ -3091,6 +3127,56 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>>       return 0;
>>  }
>>
>> +static int init_module_permission(void)
>
> "init_module_permission" -> initialises a module's permission.
>
> IOW, the name is poor.
>
>> +{
>> +     /* Must have permission */
>
> The world wouldn't end if this comment was omitted ;)

Sure, I'll fix this and the name.

>
>> +     if (!capable(CAP_SYS_MODULE) || modules_disabled)
>> +             return -EPERM;
>> +
>> +     return 0;
>> +}
>> +
>> +SYSCALL_DEFINE2(init_module_fd, int, fd, const char __user *, uargs)
>> +{
>> +     int err;
>> +     struct load_info info = { };
>> +
>> +     err = init_module_permission();
>> +     if (err)
>> +             return err;
>> +
>> +     pr_debug("init_module_fd: fd=%d, uargs=%p\n", fd, uargs);
>> +
>> +     if (fd < 0)
>> +             return -ENOEXEC;
>
> hm, why?  Surely copy_module_from_fd()'s fget() will fail on a -ve fd?

Good point, I'll let it fall through.

>
>> +     err = copy_module_from_fd(fd, &info);
>> +     if (err)
>> +             return err;
>> +
>> +     return load_module(&info, uargs);
>> +}
>> +
>>
>> ...
>>
>

Thanks for the review! I'll get another version up shortly.

-Kees

-- 
Kees Cook
Chrome OS Security
