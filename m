Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2ADGA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 01:00:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43211 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2ADGA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 01:00:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 2/4] proc: Show namespaces IDs in /proc/pid/ns/* files
References: <20111223124741.711871189@openvz.org>
	<20111223124920.725686255@openvz.org>
Date: Tue, 03 Jan 2012 22:02:32 -0800
In-Reply-To: <20111223124920.725686255@openvz.org> (Cyrill Gorcunov's message
	of "Fri, 23 Dec 2011 16:47:43 +0400")
Message-ID: <m1d3b0gg3r.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19bADOvGzQIjVRmVjL7/yvBF4QOaaJpHhA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@openvz.org> writes:

> This patch adds proc_ns_read method which provides
> IDs for /proc/pid/ns/* files.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This is a poorly thought out user interface.  If we are going to return
this kind of information and I believe we should we should, we should
return the id in the inode field with stat.

Comparing device+inode for equality is the traditional way to see if
two objects are the same in unix and there is no reason to make up
a new interface to get this functionality.

Furthermore we should always return the information, as it is valuable
even outside of the checkpoint/restart context.

I am also concerned that you appear to be building an interface
for use by checkpoint/restart that makes it impossible
checkpoint/restart the programs using that interface.  The reason
is that you appear to be  putting this nebulous id into a global 
namespace and as such even if we wanted to I don't see how we could
build a version where we could restore the id during a restart.  And
the thing is if you start building interfaces with identifiers you can
not possibly restore I expect you will find you have painted yourself
into a corner.

Using inode from stat avoids painting yourself into a corner because
you have the possibility of different mounts with different device
numbers having different inode numbers.

For the short term I don't see value in being able to restore the
object identifiers, but I do see a lot of value in allowing for a future
where nested checkpoint/restart is an option.

Eric


> Based-on-patch-from: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Glauber Costa <glommer@parallels.com>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Tejun Heo <tj@kernel.org>
> CC: Matt Helsley <matthltc@us.ibm.com>
> CC: Pekka Enberg <penberg@kernel.org>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Vasiliy Kulikov <segoon@openwall.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  Documentation/filesystems/proc.txt |   24 ++++++++++++++++++++++++
>  fs/proc/namespaces.c               |   22 ++++++++++++++++++++++
>  include/linux/gen_obj_id.h         |    1 +
>  3 files changed, 47 insertions(+)
>
> Index: linux-2.6.git/Documentation/filesystems/proc.txt
> ===================================================================
> --- linux-2.6.git.orig/Documentation/filesystems/proc.txt
> +++ linux-2.6.git/Documentation/filesystems/proc.txt
> @@ -40,6 +40,7 @@ Table of Contents
>    3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
>    3.5	/proc/<pid>/mountinfo - Information about mounts
>    3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
> +  3.7	/proc/<pid>/ns - Information about namespaces
>  
>  
>  ------------------------------------------------------------------------------
> @@ -1545,3 +1546,26 @@ a task to set its own or one of its thre
>  is limited in size compared to the cmdline value, so writing anything longer
>  then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
>  comm value.
> +
> +3.7	/proc/<pid>/ns - Information about namespaces
> +-----------------------------------------------------
> +
> +This directory consists of the following files "net", "uts", "ipc",
> +and depend if appropriate CONFIG_ entry is set, i.e. it's possible
> +to have only one, two or all three files here.
> +
> +Currently file contents provides that named "object id" number, which
> +is a number useful for the one purpose only -- to test if two differen
> +<pid> share the namespace.
> +
> +A typical format is
> +
> +id:	445332486300860161
> +
> +i.e. "id" followed by a number. One should never assume the number
> +means something, it is only useful for "sameness" test with another number
> +obtained from another <pid>.
> +
> +Moreover, a safe approach is to remember it as a string, since format may
> +change in future and id would be not a long integer value, but something
> +else, say SHA1/2 or even uuid encoded stream.
> Index: linux-2.6.git/fs/proc/namespaces.c
> ===================================================================
> --- linux-2.6.git.orig/fs/proc/namespaces.c
> +++ linux-2.6.git/fs/proc/namespaces.c
> @@ -12,6 +12,7 @@
>  #include <linux/mnt_namespace.h>
>  #include <linux/ipc_namespace.h>
>  #include <linux/pid_namespace.h>
> +#include <linux/gen_obj_id.h>
>  #include "internal.h"
>  
>  
> @@ -27,10 +28,31 @@ static const struct proc_ns_operations *
>  #endif
>  };
>  
> +#ifdef CONFIG_GENERIC_OBJECT_ID
> +static ssize_t proc_ns_read(struct file *file, char __user *buf,
> +				      size_t len, loff_t *ppos)
> +{
> +	struct proc_inode *ei = PROC_I(file->f_dentry->d_inode);
> +	char tmp[32];
> +
> +	snprintf(tmp, sizeof(tmp), "id:\t%lu\n",
> +		gen_obj_id(ei->ns, GEN_OBJ_ID_NS));
> +	return simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
> +}
> +
> +static const struct file_operations ns_file_operations = {
> +	.llseek		= no_llseek,
> +	.read		= proc_ns_read,
> +};
> +
> +#else
> +
>  static const struct file_operations ns_file_operations = {
>  	.llseek		= no_llseek,
>  };
>  
> +#endif /* CONFIG_GENERIC_OBJECT_ID */
> +
>  static struct dentry *proc_ns_instantiate(struct inode *dir,
>  	struct dentry *dentry, struct task_struct *task, const void *ptr)
>  {
> Index: linux-2.6.git/include/linux/gen_obj_id.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/gen_obj_id.h
> +++ linux-2.6.git/include/linux/gen_obj_id.h
> @@ -4,6 +4,7 @@
>  #ifdef __KERNEL__
>  
>  enum {
> +	GEN_OBJ_ID_NS,
>  	GEN_OBJ_ID_TYPES,
>  };
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
