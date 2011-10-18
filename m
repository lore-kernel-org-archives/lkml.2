Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab1JRDQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 23:16:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1JRDQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 23:16:22 -0400
Message-ID: <4E9CEFCE.1030003@cn.fujitsu.com>
Date: Tue, 18 Oct 2011 11:17:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ben Blum <bblum@andrew.cmu.edu>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: don't cache common ancestor in task counter
 subsys
References: <4E9BDA43.6060406@cn.fujitsu.com> <20111017172537.GH2829@somewhere>
In-Reply-To: <20111017172537.GH2829@somewhere>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-18 11:14:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-18 11:14:34,
	Serialize complete at 2011-10-18 11:14:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -2151,7 +2151,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>>  			}
>>  		} else if (retval == -ESRCH) {
>>  			if (ss->cancel_attach_task)
>> -				ss->cancel_attach_task(cgrp, tsk);
>> +				ss->cancel_attach_task(cgrp, oldcgrp, tsk);
>>  		} else {
>>  			BUG_ON(1);
>>  		}
>> @@ -2191,7 +2191,8 @@ out_cancel_attach:
>>  					tsk = flex_array_get_ptr(group, i);
>>  					if (tsk == failed_task)
>>  						break;
>> -					ss->cancel_attach_task(cgrp, tsk);
>> +					ss->cancel_attach_task(cgrp, oldcgrp,
>> +							       tsk);
> 
> When we rollback there, we are dealing with oldcgrp of the last thread
> we have treated. All threads in the rollback list don't necessary belonged
> to that old_cgroup.
> 

Good point. I didn't look carefully at this case.

> And we can't try to retrieve these old_cgroup through task_cgroup_from_root() because
> the threads might have exited and thus could be assigned to the init cgroup.
> 
> I believe we need to cache these old cgroups in the flex array.
> 
