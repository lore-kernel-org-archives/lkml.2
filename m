Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2ECO5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:57:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48076 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756215Ab2ECO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:57:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ZZfUHn/vZ6XCEyDtZhfUF10Yf2r6jYsWPR8tfVh
	l/Wt4hmMTLPT4Q
Message-ID: <1336057018.8119.46.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Thu, 03 May 2012 16:56:58 +0200
In-Reply-To: <1336014721.7370.32.camel@marge.simpson.net>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 05:12 +0200, Mike Galbraith wrote: 
> On Tue, 2012-05-01 at 13:42 -0700, Andrew Morton wrote:
> > On Tue, 01 May 2012 13:35:03 -0700
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> > 
> > > 
> > > Andrew can you please pick up this patch?
> > 
> > Sure.  I assume it's fixing a post-3.4 regression?  No -stable backport
> > needed?
> 
> Dunno what all should go to stable, but anyone using vsftpd will
> appreciate something going.  Large leakage was initially reported
> against 3.1.  That was bisected to..
> 423e0ab0 VFS : mount lock scalability for internal mounts 
> 
> Subsequent fixes which did not go to stable were applied..
> 	905ad269 procfs: fix a vfsmount longterm reference leak
> 	6f686574 ... and the same kind of leak for mqueue
> ..but leakage persists even with fork failure hole plugged.

> Whatever goes to stable, what fixes this little bugger should go too.

Finally have a decent trace, patch to fix the problem below.

marge:~ # grep 0xffff8801fad5dff0 /trace3
          vsftpd-18277 [003] ....  1779.012239: proc_set_super: get_pid_ns: 0xffff8801fad5dff0 count:1->2
          vsftpd-18277 [003] ....  1779.012253: create_pid_namespace: create_pid_namespace: 0xffff8801fad5dff0
          vsftpd-18277 [003] ....  1779.012258: alloc_pid: get_pid_ns: 0xffff8801fad5dff0 count:2->3
          vsftpd-18277 [003] ....  1779.012278: proc_kill_sb: put_pid_ns: 0xffff8801fad5dff0 count:3->2
     ksoftirqd/3-16    [003] ..s.  1779.012731: delayed_put_pid: put_pid_ns: 0xffff8801fad5dff0 count:2->1
          vsftpd-18277 [003] ....  1779.015614: destroy_pid_namespace: destroy_pid_namespace: 0xffff8801fad5dff0
          vsftpd-18277 [003] ....  1779.015614: free_nsproxy: put_pid_ns: 0xffff8801fad5dff0 count:1->0
          vsftpd-18277 [003] ....  1779.249871: proc_set_super: get_pid_ns: 0xffff8801fad5dff0 count:1->2
          vsftpd-18277 [003] ....  1779.249884: create_pid_namespace: create_pid_namespace: 0xffff8801fad5dff0
          vsftpd-18277 [003] ....  1779.249888: alloc_pid: get_pid_ns: 0xffff8801fad5dff0 count:2->3
          vsftpd-18351 [003] ....  1779.256337: switch_task_namespaces: exiting: 0xffff8801fad5dff0 count:3
          vsftpd-18351 [003] ....  1779.266243: free_nsproxy: put_pid_ns: 0xffff8801fad5dff0 count:3->2
<insert>
              ps-18381 [000] ....  1779.298798: proc_fill_cache <-proc_pid_readdir
              ps-18381 [000] ....  1779.298802: proc_pid_instantiate <-proc_fill_cache
              ps-18381 [000] ....  1779.298802: proc_pid_make_inode <-proc_pid_instantiate
              ps-18381 [000] ....  1779.298802: proc_alloc_inode <-alloc_inode
              ps-18381 [000] ....  1779.298807: get_task_pid <-proc_pid_make_inode
              ps-18381 [000] ....  1779.298807: get_pid <-get_task_pid
</insert> ditto for other pid references added post task exit
              ps-18381 [000] ....  1779.298807: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:1->2 pid_ns count:2
              ps-18381 [001] ....  1779.327593: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:2->3 pid_ns count:2
              ps-18381 [001] ....  1779.327653: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:3->4 pid_ns count:2
              ps-18381 [001] ....  1779.327716: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:4->5 pid_ns count:2
              ps-18381 [001] ....  1779.327804: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:5->6 pid_ns count:2
              ps-18381 [001] ....  1779.327817: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:6->7 pid_ns count:2
              ps-18381 [001] ....  1779.327818: put_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:7->6 pid_ns count:2
          vsftpd-18277 [003] ....  1779.358887: put_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:6->5 pid_ns count:2
          vsftpd-18277 [003] ....  1779.358889: put_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:5->4 pid_ns count:2
          vsftpd-18277 [003] ....  1779.358891: put_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:4->3 pid_ns count:2
          vsftpd-18277 [003] ....  1779.358894: put_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:3->2 pid_ns count:2
          vsftpd-18277 [003] ....  1779.358897: put_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:2->1 pid_ns count:2
          vsftpd-18277 [003] ....  1779.358918: proc_kill_sb: put_pid_ns: 0xffff8801fad5dff0 count:2->1
              ps-18386 [001] ....  1779.370210: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:1->2 pid_ns count:1
              ps-18386 [001] ....  1779.370240: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:2->3 pid_ns count:1
              ps-18386 [001] ....  1779.370300: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:3->4 pid_ns count:1
              ps-18386 [001] ....  1779.370361: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:4->5 pid_ns count:1
              ps-18386 [001] ....  1779.370454: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:5->6 pid_ns count:1
              ps-18386 [001] ....  1779.370467: get_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:6->7 pid_ns count:1
              ps-18386 [001] ....  1779.370468: put_pid: pid: 0xffff8802031a2fc0 namespace: 0xffff8801fad5dff0 pid count:7->6 pid_ns count:1
     ksoftirqd/3-16    [003] ..s.  1779.390717: delayed_put_pid: pid: 0xffff8802031a2fc0 LEAKED namespace: 0xffff8801fad5dff0

Ok, that seems reasonable.

Create > 27k "leaked" namespaces, watch many thousands go away over
time.. but many hundred persist and persist and persist.

Hm.  echo 3 > /proc/sys/vm/drop_caches.. *poof gone*

Grr.  I wonder who is doing the pinning when I don't monitor, but..

<patch>
kick kick kick... it's dead Jim.
</patch>

-Mike

