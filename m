Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1KOLga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:36:30 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36787 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1KOLg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:36:28 -0500
Message-ID: <4EC24E9E.8040502@parallels.com>
Date: Tue, 15 Nov 2011 15:35:58 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: [PATCH 0/4] Checkpoint/Restore: Show in proc IDs of objects that
 can be shared between tasks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing the checkpoint-restore in the userspace one need to determine
whether various kernel objects (like mm_struct-s of file_struct-s) are shared
between tasks and restore this state.

The 2nd step can for now be solved by using respective CLONE_XXX flags and
the unshare syscall, while there's currently no ways for solving the 1st one.

One of the ways for checking whether two tasks share e.g. an mm_struct is to
provide some mm_struct ID of a task to its proc file. The best from the
performance point of view ID is the object address in the kernel, but showing
them to the userspace is not good for performance reasons.

The previous attempt to solve this was to generate an ID for slab/slub and then
mix it up with the object index on the slab page. This attempt wasn't met
warmly by slab maintainers, so here's the 2nd approach.

The object address is XOR-ed with a "random" value of the same size and then
shown in proc. Providing this poison is not leaked into the userspace then
ID seem to be safe.

The other change from the previous set - this now includes patches from /proc
to show the IDs generated. The objects for which the IDs are shown are:

* all namespaces living in /proc/pid/ns/
* open files (shown in /proc/pid/fdinfo/)
* objects, that can be shared with CLONE_XXX flags (except for namespaces)

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

