Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1KDWYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:24:14 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:45253 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab1KDWYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:24:09 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: oleg@redhat.com, richard@nod.at, akpm@linux-foundation.org,
        ebiederm@xmission.com, serge@hallyn.com, dhowells@redhat.com,
        eparis@redhat.com
Subject: user namespaces: fix some uid/privilege leaks
Date: Fri,  4 Nov 2011 22:24:36 +0000
Message-Id: <1320445482-8459-1-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous submission of these patches, and review comments, can be
seen in the thread starting here: https://lkml.org/lkml/2011/10/18/463 .
Since then, patches 
0001-pid_ns-ensure-pid-is-not-freed-during-kill_pid_info_.patch
and
0002-user-namespace-usb-make-usb-urbs-user-namespace-awar.patch
have gone upstream, and I've reverted
0009-make-net-core-scm.c-uid-comparisons-user-namespace-a.patch
because it relaxes checks, and right now we want to focus on
fixing leaks.

The set includes:

0001-user-namespace-make-signal.c-respect-user-namespaces.patch
	This convers the uid for the task sending a signal to the
	user namespace of the receiver.  It is somewhat analogous
	to what is done with the sender's pid.
	Waiting on feedback from Oleg, but I believe this patch is
	ready.

0002-User-namespace-don-t-allow-sysctl-in-non-init-user-n.patch
	This prevents root in a child user namespace from man-handling
	sysctls.  With this patch, a task in a child user namespace
	will only get the world access rights to sysctls.

0003-user-namespace-clamp-down-users-of-cap_raised.patch
	This clamps down on cases where privilege to your own user
	namespace were checked for access to the initial user namespace.

0004-Add-Documentation-namespaces-user_namespace.txt-v3.patch
	Documentation.

0005-user-namespace-make-each-net-net_ns-belong-to-a-user.patch
	This adds a struct user_namespace pointer to the net_ns for use
	by later patches.

0006-protect-cap_netlink_recv-from-user-namespaces.patch
	Now that net_ns is owned by a user_ns, cap_netlink_recv() can
	target privilege checks to the user_ns owning the resource.  The
	current check against current_cap() is unsafe.

