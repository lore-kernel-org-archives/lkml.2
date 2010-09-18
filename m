Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0IRCdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 22:33:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38320 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0IRCdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 22:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <20100917181556.GA2499@localhost.localdomain>
References: <20100917152639.0e88341a@basil.nowhere.org>
	<1284736618-27153-2-git-send-email-wad@chromium.org>
	<20100917181556.GA2499@localhost.localdomain>
Date: Fri, 17 Sep 2010 21:33:52 -0500
Message-ID: <AANLkTimPC5Ns06L_zqzETtrXrBOohyyLSk7JPhV-Ay8S@mail.gmail.com>
Subject: Re: [PATCH 2/2] exec: move core_pattern pipe helper into the crashing namespace
From: Will Drewry <wad@chromium.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 1:15 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Fri, Sep 17, 2010 at 10:16:58AM -0500, Will Drewry wrote:
>> Presently, a core_pattern pipe endpoint will be run in the init
>> namespace.  It will receive the virtual pid (task_tgid_vnr->%p) of the
>> core dumping process but will have no access to that processes /proc
>> without walking the init namespace /proc looking through all the global
>> pids until it finds the one it thinks matches.
>>
>> One option for implementing this I've already posed:
>>   https://patchwork.kernel.org/patch/185912/
>> However, it's unclear if it is desirable for the core_pattern to run
>> outside the namespace.  In particular, it can easily access the mounts
>> via /proc/[pid_nr]/root, but if there is a net namespace, it will not
>> have access.  (Originally introduced in 2007 in commit
>> b488893a390edfe027bae7a46e9af8083e740668 )
>>
>> Instead, this change implements the more complex option two.  It
>> migrates the ____call_usermodehelper() thread into the same namespaces
>> as the dumping process.  It does not assign a pid in that namespace so
>> the collector will appear to be pid 0.  (Using alloc_pid and change_pid
>> are options though. I avoided it because kernel_thread's returned pid
>> will then mismatch the actual threads pid.)
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  fs/exec.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 files changed, 53 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 828dd24..3b82607 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -51,6 +51,7 @@
>>  #include <linux/audit.h>
>>  #include <linux/tracehook.h>
>>  #include <linux/kmod.h>
>> +#include <linux/nsproxy.h>
>>  #include <linux/fsnotify.h>
>>  #include <linux/fs_struct.h>
>>  #include <linux/pipe_fs_i.h>
>> @@ -65,6 +66,12 @@ char core_pattern[CORENAME_MAX_SIZE] = "core";
>>  unsigned int core_pipe_limit;
>>  int suid_dumpable = 0;
>>
>> +struct coredump_pipe_params {
>> +     struct coredump_params *params;
>> +     struct nsproxy *nsproxy;
>> +     struct fs_struct *fs;
>> +};
>> +
> Generally, I like this approach, but i think perhaps it would be better if you
> made the coredump_pipe_params struct a member of the coredump_params structure
> (perhaps within an anonymous union, so you can handle future core dump types, if
> those ever come along).  That will save you needing the extra pointer to the
> coredump_params structure itself.

I'll rework it as suggested while also taking into account Oleg's
feedback (another mail coming).

Thanks!

>>  /* The maximal length of core_pattern is also specified in sysctl.c */
>>
>>  static LIST_HEAD(formats);
>> @@ -1819,8 +1826,34 @@ static int umh_pipe_setup(struct subprocess_info *info)
>>  {
>>       struct file *rp, *wp;
>>       struct fdtable *fdt;
>> -     struct coredump_params *cp = (struct coredump_params *)info->data;
>> -     struct files_struct *cf = current->files;
>> +     struct coredump_pipe_params *pipe_params =
>> +             (struct coredump_pipe_params *)info->data;
> If you do the above, you can just reference this as cp->pipe_params, or
> what-not.
>
>> +     struct coredump_params *cp = pipe_params->params;
>> +     struct task_struct *tsk = current;
>> +     struct files_struct *cf = tsk->files;
>> +     struct fs_struct *cfs = tsk->fs;
>> +
>> +     /* Migrate this thread into the crashing namespaces, but
>> +      * don't change its pid struct to avoid breaking any other
>> +      * dependencies.  This will mean the process is pid=0 if it
>> +      * was migrated into a pid namespace.
>> +      */
>> +     if (pipe_params->nsproxy && pipe_params->fs) {
>> +             int kill;
>> +             switch_task_namespaces(tsk, pipe_params->nsproxy);
>> +             pipe_params->nsproxy = NULL;
>> +
>> +             task_lock(tsk);
>> +             tsk->fs = pipe_params->fs;
>> +             task_unlock(tsk);
>> +             pipe_params->fs = NULL;
>> +             /* Clean up the previous fs struct */
>> +             write_lock(&cfs->lock);
>> +             kill = !--cfs->users;
>> +             write_unlock(&cfs->lock);
>> +             if (kill)
>> +                     free_fs_struct(cfs);
>> +     }
>>
>>       wp = create_write_pipe(0);
>>       if (IS_ERR(wp))
>> @@ -1911,6 +1944,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>>       if (ispipe) {
>>               int dump_count;
>>               char **helper_argv;
>> +             struct coredump_pipe_params pipe_params = { .params = &cprm };
>>
> And you won't have to allocate this, it will just be part of the
> coredump_params.
>
>>               if (cprm.limit == 1) {
>>                       /*
>> @@ -1950,10 +1984,26 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>>                       goto fail_dropcount;
>>               }
>>
>> +             /* Run the core_collector in the crashing namespaces */
>> +             if (copy_namespaces_unattached(0, current,
>> +                     &pipe_params.nsproxy, &pipe_params.fs)) {
>> +                     printk(KERN_WARNING "%s failed to copy namespaces\n",
>> +                            __func__);
>> +                     argv_free(helper_argv);
>> +                     goto fail_dropcount;
>> +             }
>> +
>>               retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
>>                                       NULL, UMH_WAIT_EXEC, umh_pipe_setup,
>> -                                     NULL, &cprm);
>> +                                     NULL, &pipe_params);
> And you can pass a pointer to coredump_params here, instead of a pointer to a
> pipe_specific coredumps, to a function that isn't specific to pipes
>
>>               argv_free(helper_argv);
>> +             /* nsproxy and fs will survive if call_usermodehelper_fns hits
>> +              * ENOMEM prior to creating a new thread.
>> +              */
>> +             if (pipe_params.nsproxy)
>> +                     put_nsproxy(pipe_params.nsproxy);
>> +             if (pipe_params.fs)  /* not in use by anything else */
>> +                     free_fs_struct(pipe_params.fs);
>>               if (retval) {
>>                       printk(KERN_INFO "Core dump to %s pipe failed\n",
>>                              corename);
>> --
>> 1.7.0.4
>>
>>
>
>
> Regards
> Neil
>
>
