Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1JRVyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:54:49 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40244 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752354Ab1JRVyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:54:47 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com
Subject: user namespaces: fix some uid/privilege leaks
Date: Tue, 18 Oct 2011 21:54:49 +0000
Message-Id: <1318974898-21431-1-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set of patches which I'm currently aiming to get upstream is queued at:
http://kernel.ubuntu.com/git?p=serge/linux-2.6.git;a=shortlog;h=refs/heads/userns

In the below descriptions, it helps to remember that a task can have more
privilege to his own, child, user namespace, than he does in his parent or
the initial user namespace.  In fact a task created in a new user namespace
receives all capabilities (within bounding set) in the new user namespace.
So checks for privilege in a task's own user ns can not be safely used in place
of checks against another user ns.

The set includes:

0001-pid_ns-ensure-pid-is-not-freed-during-kill_pid_info_.patch
	Fix a case where a pid could be referenced after being freed.
	(This is in Greg's usb tree, but not yet in Linus' tree; it's
	here just to show full context)

0002-user-namespace-usb-make-usb-urbs-user-namespace-awar.patch
	Take the user namespace into account when comparing uids when
	signals are sent by usb urbs.
	(This is in Greg's usb tree, but not yet in Linus' tree; it's
	here just to show full context)

0003-user-namespace-make-signal.c-respect-user-namespaces.patch
	This convers the uid for the task sending a signal to the
	user namespace of the receiver.  It is somewhat analogous
	to what is done with the sender's pid.
	Waiting on feedback from Oleg, but I believe this patch is
	ready.

0004-User-namespace-don-t-allow-sysctl-in-non-init-user-n.patch
	This prevents root in a child user namespace from man-handling
	sysctls.  With this patch, a task in a child user namespace
	will only get the world access rights to sysctls.

0005-user-namespace-clamp-down-users-of-cap_raised.patch
	This clamps down on cases where privilege to your own user
	namespace were checked for access to the initial user namespace.

0006-Add-Documentation-namespaces-user_namespace.txt-v3.patch
	Documentation.

0007-user-namespace-make-each-net-net_ns-belong-to-a-user.patch
	This adds a struct user_namespace pointer to the net_ns for use
	by later patches.

0008-protect-cap_netlink_recv-from-user-namespaces.patch
	Now that net_ns is owned by a user_ns, cap_netlink_recv() can
	target privilege checks to the user_ns owning the resource.  The
	current check against current_cap() is unsafe.

0009-make-net-core-scm.c-uid-comparisons-user-namespace-a.patch
	In scm_send, uids of sender/receiver are being compared without
	accounting for different user namespaces.  Fix that.

