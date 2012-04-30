Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2D3N5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:57:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39896 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755054Ab2D3N5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:57:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19lHBZ9v81lzJ3QRlVXEhfg/zLDIJhqdq/kxOV98I
	G0k2DyAvKnHRgz
Message-ID: <1335794269.15288.17.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Date: Mon, 30 Apr 2012 15:57:49 +0200
In-Reply-To: <1335604790.5995.22.camel@marge.simpson.net>
References: <1335604790.5995.22.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 11:19 +0200, Mike Galbraith wrote:

> There's still at least one pid
> namespace leak left, that being the final put_pid() in softirq context
> goes missing.

Ah..

vsftpd-14507 [003] ....  1467.046189: proc_set_super: get_pid_ns: 0xffff8801dc560998 count:1->2
vsftpd-14507 [003] ....  1467.046201: create_pid_namespace: create_pid_namespace: 0xffff8801dc560998
vsftpd-14507 [003] ....  1467.046206: alloc_pid: get_pid_ns: 0xffff8801dc560998 count:2->3
vsftpd-14521 [003] ....  1467.052481: switch_task_namespaces: exiting: 0xffff8801dc560998 count:3
vsftpd-14521 [003] ....  1467.073823: free_nsproxy: put_pid_ns: 0xffff8801dc560998 count:3->2
vsftpd-14507 [003] ....  1467.173657: put_pid: namespace: 0xffff8801dc560998 pid count:2->1 pid_ns count:2
vsftpd-14507 [003] ....  1467.173677: proc_kill_sb: put_pid_ns: 0xffff8801dc560998 count:2->1
<idle>-0     [003] ..s.  1467.213562: put_pid: namespace: 0xffff8801dc560998 pid count:6->5 pid_ns count:1

..somebody grabs pid references while we wait for rcu destruction.

-Mike

