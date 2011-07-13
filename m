Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1GMMp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:45:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1GMMp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:45:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1310513452-13397-2-git-send-email-serge@hallyn.com>
References: <1310513452-13397-2-git-send-email-serge@hallyn.com> <1310513452-13397-1-git-send-email-serge@hallyn.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [RFC PATCH 01/14] add Documentation/namespaces/user_namespace.txt
Date: Wed, 13 Jul 2011 13:45:16 +0100
Message-ID: <31047.1310561116@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge@hallyn.com> wrote:

> +Traditionally, each task is owned by a userid (uid) and belongs to one

"userid" -> "user ID" perhaps.

> +or more groups (gid).  Both are simple numeric ids, though userspace

Expanding the wrap column to 79 chars would reduce the number of lines, though
I grant for this text you will get a more ragged margin.

"ids" -> "IDs"?

> +... The user namespace allows tasks to
> +have different views of the uids and gids associated with tasks and
> +other resources.

How does this relate to UIDs/GIDs stored on disk?

> +The user namespace is a simple heirarchical one.  The system begins

Or even a "hierarchical" one.

I'd recommend "starts" rather than "begins".

> +To do so, the creating task needs the CAP_SETUID, CAP_SETGID, and
> +CAP_CHOWN capabilities, but does not need to be root.

How about "This requires the creating task to have the ... but it does not
need to be running as root."?

> ... The clone(2) call will result in a new task which to the creator
> appears to have the same credentials as itself, but which sees itself as
> being uid and gid 0.

How about "The clone(2) call will result in a new task which to itself appears
to be running as uid and gid 0, but to its creator seems to have the creator's
credentials."

> ... Any task in or resource belonging to the initial user
> namespace will, to this new task, appear to belong to uid and gid
> -1, which is usually known as 'nobody'.

I think ", which is usually" should probably be " - which is usually".

> ... Opening such files will result in obtaining the 'user other'
> permissions.

How about "Permission to open such files will be granted according to the
'user other' permissions."?

Do you mean 'user other' or just 'other'?

> ... UID comparisons will return false, and privilege will be denied.

UID and GID both?

You should probably be consistent about using all 'UID/GID' or all 'uid/gid'.
I prefer the former as it's an acronym, but that's up to you.

> When a task belonging to userid 500 in the initial user namespace

Is 500 special?  Or is this just a worked example?

> creates a new user namespace, even though the new task will see itself
> as belonging to uid 0, any task in the initial user namespace
> will see it as belonging to uid 500.  Therefore, uid 500 in the
> initial user namespace will be able to kill the new task.  Files
> created by the new user will (eventually) be seen by tasks in its
> own user namespace as belonging to uid 0, but to tasks in the initial
> user namespace as belonging to uid 500.

The next bit should probably be a new paragraph (or possibly inline note).

> Note that this userid
> mapping for the VFS is not yet implemented, though the lkml and
> containers mailing list archives will show several previous prototypes.
> In the end, those got hung up waiting on the concept of targeted
> capabilities to be developed, which, thanks to the insight of Eric
> Biederman, they finally did.

Section heading here?

> Other namespaces, such as UTS and network, are owned by a user
> namespace.

I think this is awkward because you're now overloading the term 'namespace' to
mean two different things.  I wonder if you should hyphenate "user namespace".
Let me think about that.

> ...  When such a namespace is created, it is assigned to the user
> namespace by which it was created.  Therefore, attempts to exercise
> privilege to resources in a network namespace can be properly validated
> by checking whether the caller has the needed privilege targeted to the
> user namespace owning the network namespace.

That's a very convoluted sentence.

> ...  This is called checking
> targeted capabilities, and is done using the 'ns_capable' function.
> 
> As an example, if a new task is cloned with a private user namespace but
> no private network namespace, then the task's network namespace is owned
> by the parent user namespace.  The new task has no privilege to the
> parent user namespace, so it will not be able to create or configure
> network devices.  If, instead, the task were cloned with both private
> user and network namespaces, then the private network namespace is owned
> by the private user namespace, and so root in the new user namespace
> will have privilege targeted to the network namespace.  It will be able
> to create and configure network devices.
> 
> Working notes
> =============
> capable checks for actions related to syslog must be against the
> init_user_ns until syslog is containerized.

Do you mean the 'capable' function?  If so, I recommend you suffix it with
'()'.  Or did you mean 'Capability checks'?

> Same is true for reboot and power, control groups, devices, and time.
> 
> Perf actions (kernel/event/core.c for instance) will always be
> constrained to init_user_ns.
> 
> Q:
> Is accounting considered properly containerized wrt pidns?  (it
> appears to be).  If so, then we can change the capable check in

'capability check' or 'capable() call'?  Anyone reading this ought to know what
capable() does.

> kernel/acct.c to 'ns_capable(current_pid_ns()->user_ns, CAP_PACCT)'
> 
> Q:
> For things like nice and schedaffinity, we could allow root in a
> container to control those, and leave only cgroups to constrain
> the container.  I'm not sure whether that is right, or whether it
> violates admin expectations.
> 
> I punted on some of commoncap.c.  I'm punting on xattr stuff as
> they take dentries, not inodes.

Rather than 'punted' you might want to use 'deferred' if that's what you meant.

> For drivers/tty/tty_io.c and drivers/tty/vt/vt.c, we'll want to (for
> some of them) target at the user_ns owning the tty.  That will have
> to wait until we get userns owning files straightened out.

Target what at the user_ns?

> We need to figure out how to label devices.  Should we just toss a user_ns
> right into struct device?

Would that isolate a device and make it exclusively accessible by that user_ns?

> capable(CAP_MAC_ADMIN) checks are always to be against init_user_ns,
> unless some day LSMs were to be containerized, near zero chance.

'Containerized'?  Yuck:-)

> inode_owner_or_capable() should probably take an optional ns and
> cap paramter.  If cap is 0, then CAP_FOWNER is checked.  If ns is

'parameter'.

> NULL, we derive the ns from inode.  But if ns is provided, then
> callers who need to derive inode_userns(inode) anyway can save a
> few cycles.

David
