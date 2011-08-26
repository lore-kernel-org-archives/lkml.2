Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab1HZH1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:27:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52014 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1HZH1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:27:37 -0400
Message-ID: <4E574B09.6050108@cn.fujitsu.com>
Date: Fri, 26 Aug 2011 15:28:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>,
        Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem?
 (was Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <20110801161900.1fe24b76.akpm@linux-foundation.org> <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com> <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com> <20110818143319.GC10441@somewhere> <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com> <20110824175431.GA26417@somewhere.redhat.com>
In-Reply-To: <20110824175431.GA26417@somewhere.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-26 15:26:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-26 15:26:35,
	Serialize complete at 2011-08-26 15:26:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Aug 23, 2011 at 09:07:59AM -0700, Paul Menage wrote:
>> On Thu, Aug 18, 2011 at 7:33 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>
>>> So the problem with the task counter as a subsystem is that you could
>>> mount it in your systemd cgroups hierarchy but then it's not anymore
>>> available for those who want to use containers.
>>
>> Another possible option is something that I prototyped a couple of
>> years ago, but dropped due to lack of compelling need and demand - the
>> ability to have subsystems that can be bound on multiple subsystems at
>> once. See
>>
>> http://lkml.indiana.edu/hypermail/linux/kernel/0907.0/00574.html
>> http://lkml.indiana.edu/hypermail/linux/kernel/0907.0/00576.html
>> http://lkml.indiana.edu/hypermail/linux/kernel/0907.0/00577.html
>>
>> It's applicable to subsystems whose state isn't tied to any specific
>> single resource in the kernel outside of cgroups (so e.g. the CPU
>> scheduler couldn't be usefully multi-bindable, since the CPU cgroup
>> state is tied to the machine's single CPU scheduler).
>>
>> In the end I didn't work further on it, since it seemed that most
>> things that needed to be available to multiple hierarchies could more
>> simply be added to the core cgroups subsystem and automatically be
>> available on all hierarchies. But the point about tracking overhead
>> for fork/exit is certainly something that could make this worthwhile.
> 
> That sounds like a perfect fit. I like that much better because there
> should be no noticeable overhead when the task counter subsys is
> nowhere mounted, compared to a pure core feature.
> 

I had a patchset that can make things even better. The patchset is
to bind/unbind a subsystem to/from an existing cgroup hierarchy.

So if you found you need to use task couter but it's not avaiable
in the hierarchy you've set up, you can do this:

	# mount -o remount,task_num xxx /cgroup

Currently the above operation is supported only if there's no child
cgroups in /cgroup.

> So I'm going to continue to work on that task counter subsystem and
> I will unearth your old patch afterward to make that work on several
> mountpoints once we are sure this is needed for systemd.
> 
> It seems your patch doesn't handle the ->fork() and ->exit() calls.
> We probably need a quick access to states of multi-subsystems from
> the task, some lists available from task->cgroups, I don't know yet.
> 
