Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0IPVCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:02:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43508 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab0IPVCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <m1zkvh4fdc.fsf@fess.ebiederm.org>
References: <1284663599-3549-1-git-send-email-wad@chromium.org>
	<20100916193543.GA11016@redhat.com>
	<m1zkvh4fdc.fsf@fess.ebiederm.org>
Date: Thu, 16 Sep 2010 16:02:36 -0500
Message-ID: <AANLkTikDDUjvd-hnZ32BiQNc609GdTXtCFtPXrje=zGM@mail.gmail.com>
Subject: Re: [PATCH][RFC] fs/exec.c: provide the correct process pid to the
 pipe helper
From: Will Drewry <wad@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 3:12 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
>
>> On 09/16, Will Drewry wrote:
>>>
>>> --- a/fs/exec.c
>>> +++ b/fs/exec.c
>>> @@ -1467,6 +1467,13 @@ static int format_corename(char *corename, long signr)
>>>      char *const out_end = corename + CORENAME_MAX_SIZE;
>>>      int rc;
>>>      int pid_in_pattern = 0;
>>> +    pid_t pid = task_tgid_vnr(current);
>>> +
>>> +    /* The pipe helper runs in the init namespace and should
>>> +     * receive the matching pid until that changes.
>>> +     */
>>> +    if (ispipe)
>>> +            pid = task_tgid_nr(current);
>>
>> Agreed, it doesn't make sense to pass the "local" pid to the init ns.
>
> Yes, passing the local pid to the init pid namespace doesn't make a lot
> of sense.  I have recently fixed unix domain sockets to avoid doing that
> kind of silliness.
>
> That said I don't think this is a complete fix.  We also potentially
> have the same issue with the uts namespace and the user namespace.

Hrm true.  I was looking at getting the proper pid to the core handler
as a means for it to get the rest from
/proc/<pid>/[status|mountinfo|root] and so on.  As is, it seemed
non-trivial to reliably walk the /proc tree to find the dumping
process.

> I believe the core file holds all of this information relative to the
> process that is dying, one elf note or other so we don't need to worry
> about information loss.

Yeah - my main concern was /proc access to get information that might
otherwise be lost.

> As for how to implement this for the pid case can we simply grab the
> namespace at the ispipe stage and use task_tgid_nr_ns.  Something like:
> pid_ns = current->nsproxy->pid_ns;
> if (is_pipe)
>        pid_ns = &init_pid_ns;
>
> ....
>        /* pid */
>        case 'p':
>                pid_in_pattern = 1;
>                rc = snprintf(out_ptr, out_end - out_ptr,
>                              "%d", task_tgid_pid_nr_ns(pid_ns, current));
>                if (rc > out_end - out_ptr)
>                        goto out;
>                out_ptr += rc;
>                break;

Would that yield different results than the task_tgid_nr versus vnr,
or is it just cleaner?

> Will you were saying something about complex namespacing (in particular
> the network namespace giving you problems).  The network namespace has
> no influence over pipes so how does that come into play?

Ah! All I meant is that this patch lets you access anything that is in
/proc/[tgid]/... for the dumping process.  However, it seems that in
the long run, core_pattern should run the pipe handler inside the
namespace(s) of the process do_coredump is running for.  For instance,
if it wanted to make a network connection on coredump, it'd be doing
it from the init namespace.

> I can imagine that it would be nice to have different core patterns
> depending on where you are in the process tree, so a container can
> do something different than the system outside of the container.  Are
> you thinking along those lines, or are you imagining something else?

Yup - in general, I was thinking that even if core_pattern was not
split by namespace, it would be nice to attempt to execute it in the
namespace of the process that needs it.  My understand of namespaces
is that they were a gateway to longer term lightweight containers (as
the patches go into kernel.org) which would mean that a change to
core_pattern shouldn't result in a process running in the init
namespace (at least not by default!).

To that end, I implemented a function similar to your setns() syscall
patch which calls create_new_namespaces (and copy_fs_struct) to create
an unattached fs and nsproxy which I then migrate the
____call_usermodehelper thread over to in umh_setup_pipe.  It leaves
it with a pid of 0, but otherwise functional.  (I also played with
changing its pid or best effort assigning one in the namespace as per
older threads, but it all seemed to fragile.) I can post them on this
thread (or wherever) if you'd like to see them, but they're pretty
trivial, and I'm unsure of their correctness.

cheers!
will
