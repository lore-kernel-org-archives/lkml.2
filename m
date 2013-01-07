Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3AGPN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:13:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab3AGPNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:13:25 -0500
Date: Mon, 7 Jan 2013 10:13:16 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.com>
Cc: jongman.heo@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [3.8-rc2] stuck at reading CIFS mounted directory
Message-ID: <20130107101316.10f5e2ea@tlielax.poochiereds.net>
In-Reply-To: <50EA97F5.5050801@suse.com>
References: <1839076.322591357261060518.JavaMail.weblogic@epml11>
	<50EA97F5.5050801@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jan 2013 15:10:05 +0530
Suresh Jayaraman <sjayaraman@suse.com> wrote:

> (Cc linux-cifs@vger.kernel.org)
> 
> On 01/04/2013 06:27 AM, Jongman Heo wrote:
> > Hi, all,
> > 
> > In 3.8-rc2, access to CIFS-mounted directory (df, ls, or similar) got stuck with following message.
> > 
> > It's mounted with...
> >   mount -t cifs //<win_host_ip_address>/Share  /mnt/window -o user=jongman.heo,password=xxxx,sec=ntlm
> > 
> > 
> > [16655.288591] INFO: task bash:4042 blocked for more than 120 seconds.
> > [16655.318117] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [16655.318123] bash            D dada9c5c     0  4042      1 0x00000004
> > [16655.318132]  dada9cd0 00000082 00000282 dada9c5c c09022c6 dada9c7c c044d316 c0c7c300
> > [16655.318139]  d6db3a7b 00000f09 c0c7c300 00000000 00000f09 f3b7b240 c04401ba 00000000
> > [16655.318145]  c0b9e0d8 f598e960 00000000 00000303 dada9c98 dada9c98 f598e960 00000006
> > [16655.318150] Call Trace:
> > [16655.342785]  [<c09022c6>] ? _raw_spin_unlock_irqrestore+0xf/0x11
> > [16655.351554]  [<c044d316>] ? __wake_up+0x3b/0x42
> > [16655.358802]  [<c04401ba>] ? call_usermodehelper_fns+0x148/0x152
> > [16655.358840]  [<c0440468>] ? __request_module+0x15e/0x1a1
> > [16655.358842]  [<c043fe3d>] ? call_usermodehelper_freeinfo+0x19/0x19
> > [16655.358845]  [<c0901a9a>] schedule+0x51/0x53
> > [16655.358847]  [<c0901bed>] schedule_preempt_disabled+0x8/0xa
> > [16655.384345]  [<c0900de6>] __mutex_lock_common+0xd6/0x123
> > [16655.384430]  [<c0900f39>] __mutex_lock_slowpath+0x20/0x22
> > [16655.384436]  [<c0900edf>] ? mutex_lock+0x18/0x25
> > [16655.384441]  [<c0900edf>] mutex_lock+0x18/0x25
> > [16655.384892]  [<c05e1650>] cifs_reconnect_tcon+0x170/0x252
> > [16655.384953]  [<c044c652>] ? should_resched+0x8/0x22
> > [16655.384963]  [<c09018dc>] ? _cond_resched+0x8/0x1c
> > [16655.384969]  [<c05e174f>] smb_init+0x1d/0x6d
> > [16655.385023]  [<c05e4f7f>] CIFSSMBQPathInfo+0x4e/0x1e4
> > [16655.385071]  [<c05fe062>] cifs_query_path_info+0x38/0x73
> > [16655.385080]  [<c05f460a>] cifs_get_inode_info+0x122/0x3ac
> > [16655.385548]  [<c04e1f2f>] ? walk_component+0x14a/0x17a
> > [16655.385570]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
> > [16655.385585]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
> > [16655.385596]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
> > [16655.385601]  [<c04e225c>] ? getname_flags+0x59/0xeb
> > [16655.385606]  [<c090227a>] ? _raw_spin_lock+0x8/0xa
> > [16655.385613]  [<c05f5c84>] cifs_revalidate_dentry_attr+0x120/0x168
> > [16655.385618]  [<c05f5d6d>] cifs_getattr+0x5e/0xe3
> > [16655.385625]  [<c04dde86>] vfs_getattr+0x37/0x4e
> > [16655.385631]  [<c05f5d0f>] ? cifs_revalidate_dentry+0x20/0x20
> > [16655.385639]  [<c04ddef6>] vfs_fstatat+0x59/0x8a
> > [16655.385645]  [<c04ddf5b>] vfs_stat+0x19/0x1b
> > [16655.385652]  [<c04de160>] sys_stat64+0x11/0x22
> > [16655.385659]  [<c044c652>] ? should_resched+0x8/0x22
> > [16655.385668]  [<c09018dc>] ? _cond_resched+0x8/0x1c
> > [16655.385674]  [<c0443b74>] ? task_work_run+0x6d/0x79
> > [16655.385825]  [<c0904f3d>] ? __do_page_fault+0x33b/0x33b
> > [16655.385834]  [<c0904f45>] ? do_page_fault+0x8/0xa
> > [16655.385840]  [<c0907911>] sysenter_do_call+0x12/0x2c
> > 
> > N�����r��y���b�X��ǧv�^�)޺{.n�+����{����zX����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢf��^jǫy�m��@A�a���0��h��i
> > 
> 
> 

Looks like it's waiting on the session_mutex to become free. The
question is what's holding it and why. Some questions:

1) is this a regression? If so, what version were you using previously?

2) any other processes stuck on on this mutex? What about the cifsd
thread for this mount? Is it stuck holding it? You may want to
"cat /proc/<pid>/stack" on any other threads that might be related here
and see if you can figure out what they're doing.

-- 
Jeff Layton <jlayton@redhat.com>
