Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1DAAWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 20:22:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48204 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1DAAWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 20:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110330170458.GB7219@peq.hallyn.com>
References: <20110329211251.28682.63651.stgit@paris.rdu.redhat.com>
	<20110330170458.GB7219@peq.hallyn.com>
Date: Thu, 31 Mar 2011 17:22:08 -0700
X-Google-Sender-Auth: kZsHONPiW0K-Y4_DMqmuvIUoBHo
Message-ID: <AANLkTinVRNDZpAoHuM8EsH0J3Srdbub5MrYH9x5617F9@mail.gmail.com>
Subject: Re: [PATCH] capabilites: allow the application of capability limits
 to usermode helpers
From: "Andrew G. Morgan" <morgan@kernel.org>
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, greg@kroah.com,
        dhowells@redhat.com, jmorris@namei.org, serge.hallyn@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

On Wed, Mar 30, 2011 at 10:04 AM, Serge E. Hallyn
<serge.hallyn@ubuntu.com> wrote:
> Quoting Eric Paris (eparis@redhat.com):
>> There is no way to limit the capabilities of usermodehelpers. This problem
>> reared its head recently when someone complained that any user with
>> cap_net_admin was able to load arbitrary kernel modules, even though the user
>> didn't have cap_sys_module.  The reason is because the actual load is done by
>> a usermode helper and those always have the full cap set.  This patch addes new
>> sysctls which allow us to bound the permissions of usermode helpers.
>>
>> /proc/sys/kernel/usermodehelper/bset
>> /proc/sys/kernel/usermodehelper/inheritable
>>
>> You must have CAP_SYS_MODULE  and CAP_SETPCAP to change these (changes are
>> &= ONLY).  When the kernel launches a usermodehelper it will do so with these
>> as the bset and pI.
>>
>> -v2:  make globals static
>>       create spinlock to protect globals
>>
>> -v3:  require both CAP_SETPCAP and CAP_SYS_MODULE
>> -v4:  fix the typo s/CAP_SET_PCAP/CAP_SETPCAP/ because I didn't commit
>> Signed-off-by: Eric Paris <eparis@redhat.com>
>> No-objection-from: Serge E. Hallyn <serge.hallyn@canonical.com>
>
> Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
>
> thanks,
> -serge
>
>> Acked-by: David Howells <dhowells@redhat.com>
>> ---
>>
>>  include/linux/kmod.h |    3 ++
>>  kernel/kmod.c        |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/sysctl.c      |    6 +++
>>  3 files changed, 109 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
>> index 6efd7a7..79bb98d 100644
>> --- a/include/linux/kmod.h
>> +++ b/include/linux/kmod.h
>> @@ -24,6 +24,7 @@
>>  #include <linux/errno.h>
>>  #include <linux/compiler.h>
>>  #include <linux/workqueue.h>
>> +#include <linux/sysctl.h>
>>
>>  #define KMOD_PATH_LEN 256
>>
>> @@ -109,6 +110,8 @@ call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
>>                                      NULL, NULL, NULL);
>>  }
>>
>> +extern struct ctl_table usermodehelper_table[];
>> +
>>  extern void usermodehelper_init(void);
>>
>>  extern int usermodehelper_disable(void);
>> diff --git a/kernel/kmod.c b/kernel/kmod.c
>> index 9cd0591..06fdea2 100644
>> --- a/kernel/kmod.c
>> +++ b/kernel/kmod.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/kmod.h>
>>  #include <linux/slab.h>
>>  #include <linux/completion.h>
>> +#include <linux/cred.h>
>>  #include <linux/file.h>
>>  #include <linux/fdtable.h>
>>  #include <linux/workqueue.h>
>> @@ -43,6 +44,13 @@ extern int max_threads;
>>
>>  static struct workqueue_struct *khelper_wq;
>>
>> +#define CAP_BSET     (void *)1
>> +#define CAP_PI               (void *)2
>> +
>> +static kernel_cap_t usermodehelper_bset = CAP_FULL_SET;
>> +static kernel_cap_t usermodehelper_inheritable = CAP_FULL_SET;
>> +static DEFINE_SPINLOCK(umh_sysctl_lock);
>> +
>>  #ifdef CONFIG_MODULES
>>
>>  /*
>> @@ -132,6 +140,7 @@ EXPORT_SYMBOL(__request_module);
>>  static int ____call_usermodehelper(void *data)
>>  {
>>       struct subprocess_info *sub_info = data;
>> +     struct cred *new;
>>       int retval;
>>
>>       spin_lock_irq(&current->sighand->siglock);
>> @@ -153,6 +162,19 @@ static int ____call_usermodehelper(void *data)
>>                       goto fail;
>>       }
>>
>> +     retval = -ENOMEM;
>> +     new = prepare_kernel_cred(current);
>> +     if (!new)
>> +             goto fail;
>> +
>> +     spin_lock(&umh_sysctl_lock);
>> +     new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
>> +     new->cap_inheritable = cap_intersect(usermodehelper_inheritable,
>> +                                          new->cap_inheritable);
>> +     spin_unlock(&umh_sysctl_lock);
>> +
>> +     commit_creds(new);
>> +
>>       retval = kernel_execve(sub_info->path,
>>                              (const char *const *)sub_info->argv,
>>                              (const char *const *)sub_info->envp);
>> @@ -418,6 +440,84 @@ unlock:
>>  }
>>  EXPORT_SYMBOL(call_usermodehelper_exec);
>>
>> +static int proc_cap_handler(struct ctl_table *table, int write,
>> +                      void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +     struct ctl_table t;
>> +     unsigned long cap_array[_KERNEL_CAPABILITY_U32S];
>> +     kernel_cap_t new_cap;
>> +     int err, i;
>> +
>> +     if (write && (!capable(CAP_SETPCAP) ||
>> +                   !capable(CAP_SYS_MODULE)))
>> +             return -EPERM;
>> +
>> +     /*
>> +      * convert from the global kernel_cap_t to the ulong array to print to
>> +      * userspace if this is a read.
>> +      */
>> +     spin_lock(&umh_sysctl_lock);
>> +     for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)  {
>> +             if (table->data == CAP_BSET)
>> +                     cap_array[i] = usermodehelper_bset.cap[i];
>> +             else if (table->data == CAP_PI)
>> +                     cap_array[i] = usermodehelper_inheritable.cap[i];
>> +             else
>> +                     BUG();
>> +     }
>> +     spin_unlock(&umh_sysctl_lock);
>> +
>> +     t = *table;
>> +     t.data = &cap_array;
>> +
>> +     /*
>> +      * actually read or write and array of ulongs from userspace.  Remember
>> +      * these are least significant 32 bits first
>> +      */
>> +     err = proc_doulongvec_minmax(&t, write, buffer, lenp, ppos);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     /*
>> +      * convert from the sysctl array of ulongs to the kernel_cap_t
>> +      * internal representation
>> +      */
>> +     for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)
>> +             new_cap.cap[i] = cap_array[i];
>> +
>> +     /*
>> +      * Drop everything not in the new_cap (but don't add things)
>> +      */
>> +     spin_lock(&umh_sysctl_lock);
>> +     if (write) {
>> +             if (table->data == CAP_BSET)
>> +                     usermodehelper_bset = cap_intersect(usermodehelper_bset, new_cap);
>> +             if (table->data == CAP_PI)
>> +                     usermodehelper_inheritable = cap_intersect(usermodehelper_inheritable, new_cap);
>> +     }
>> +     spin_unlock(&umh_sysctl_lock);
>> +
>> +     return 0;
>> +}
>> +
>> +struct ctl_table usermodehelper_table[] = {
>> +     {
>> +             .procname       = "bset",
>> +             .data           = CAP_BSET,
>> +             .maxlen         = _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
>> +             .mode           = 0600,
>> +             .proc_handler   = proc_cap_handler,
>> +     },
>> +     {
>> +             .procname       = "inheritable",
>> +             .data           = CAP_PI,
>> +             .maxlen         = _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
>> +             .mode           = 0600,
>> +             .proc_handler   = proc_cap_handler,
>> +     },
>> +     { }
>> +};
>> +
>>  void __init usermodehelper_init(void)
>>  {
>>       khelper_wq = create_singlethread_workqueue("khelper");
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index c0bb324..965134b 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -56,6 +56,7 @@
>>  #include <linux/kprobes.h>
>>  #include <linux/pipe_fs_i.h>
>>  #include <linux/oom.h>
>> +#include <linux/kmod.h>
>>
>>  #include <asm/uaccess.h>
>>  #include <asm/processor.h>
>> @@ -616,6 +617,11 @@ static struct ctl_table kern_table[] = {
>>               .child          = random_table,
>>       },
>>       {
>> +             .procname       = "usermodehelper",
>> +             .mode           = 0555,
>> +             .child          = usermodehelper_table,
>> +     },
>> +     {
>>               .procname       = "overflowuid",
>>               .data           = &overflowuid,
>>               .maxlen         = sizeof(int),
>>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iQEcBAEBAgAGBQJNk2K6AAoJEHmllQITXQdF8AgH/RDWKdOXjySrBXaCc7LQR29M
> tPxdgl+/w7aKxsWF9iXxoIsMSKQXGhY1+J9QyoWpP9LWJ3njXcofZjg3x7uX94Ex
> JNnCrhjMFHhI6evPz00l0jqXA5lrg/LVqaDmpoTwJs+oKNj+3kHMQtdLpMrCKqjO
> RX6fNIthfYgBEdHPVN1h4nHdNurRRfsxXsrHso1Ljkc4DhaUsEKZaDRbf+mIM6zP
> Z+e6a/IwsYrfJ5tbA37tppActh3tcVcIEYj31g/peeZV1L5MHlkn0jemPIWyQJ8I
> zauWoBsWj5/uuIcGJ7tU6ae7iFLo1kWI1x03TwWSf6k2xeRfx3uwdf04mgrS1pY=
> =40oa
> -----END PGP SIGNATURE-----
>
>
