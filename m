Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1HYRH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:07:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29157 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1HYRH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:07:26 -0400
Message-ID: <4E5680D2.1030608@parallels.com>
Date: Thu, 25 Aug 2011 21:05:22 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        Zan Lynx <zlynx@acm.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v2
References: <20110824085329.GL29452@sun> <20110824111806.GA7191@albatros> <20110825082944.GH10030@sun> <20110825170147.GM2803@mtj.dyndns.org>
In-Reply-To: <20110825170147.GM2803@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 09:01 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 25, 2011 at 12:29:44PM +0400, Cyrill Gorcunov wrote:
>>  | lr-x------ 1 cyrill cyrill 64 Aug  9 15:25 0x3d73a00000 -> /lib64/ld-2.5.so
>>  | lr-x------ 1 cyrill cyrill 64 Aug  9 15:25 0x3d73c1b000 -> /lib64/ld-2.5.so
>>  | lr-x------ 1 cyrill cyrill 64 Aug  9 15:25 0x3d73c1c000 -> /lib64/ld-2.5.so
>>  | lr-x------ 1 cyrill cyrill 64 Aug  9 15:25 0x3d73e00000 -> /lib64/libc-2.5.so
>>  | lr-x------ 1 cyrill cyrill 64 Aug  9 15:25 0x3d73f4e000 -> /lib64/libc-2.5.so
> 
> I would prefer if the filename included both start and end addresses
> so that it matches the first column of /proc/PID/maps and ls'ing the
> directory is more useful.  What do other people think?

Without 0x at the beginning this is not very convenient, but once we add them it no
longer matches the contents of the /proc/pid/maps.

Just an opinion, do not mind adding <end> to the name.

>> +static int map_files_d_revalidate(struct dentry *dentry, struct nameidata *nd)
>> +{
>> +	struct task_struct *task;
>> +	struct vm_area_struct *vma;
>> +	struct mm_struct *mm;
>> +	struct inode *inode;
>> +
>> +	if (nd && nd->flags & LOOKUP_RCU)
>> +		return -ECHILD;
>> +
>> +	inode = dentry->d_inode;
>> +	task = get_proc_task(inode);
>> +	if (!task)
>> +		goto out;
>> +
>> +	mm = get_task_mm(task);
>> +	put_task_struct(task);
>> +	if (!mm)
>> +		goto out;
>> +
>> +	down_read(&mm->mmap_sem);
>> +	vma = find_exact_vma(mm, PROC_I(inode)->vm_start);
>> +	up_read(&mm->mmap_sem);
>> +	mmput(mm);
>> +
>> +	if (vma)
>> +		return 1;
> 
> Hmm... don't we need the same credential update as
> tid_fd_revalidate()?  If the task seteuid's, we want the permissions
> to change accordingly, right?
> 
> Thanks.
> 

