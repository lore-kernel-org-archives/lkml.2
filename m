Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0KZBsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 20:48:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61267 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0KZBsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 20:48:51 -0500
Message-ID: <4CEF1260.4000009@cn.fujitsu.com>
Date: Fri, 26 Nov 2010 09:50:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup monitoring
 (v5)
References: <4ce510d4.0fedd80a.742c.10b9@mx.google.com> <1290684523.2145.31.camel@laptop>
In-Reply-To: <1290684523.2145.31.camel@laptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-26 09:49:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-26 09:49:03,
	Serialize complete at 2010-11-26 09:49:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19:28, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 12:40 +0200, Stephane Eranian wrote:
>> This kernel patch adds the ability to filter monitoring based on
>> container groups (cgroups). This is for use in per-cpu mode only.
>>     
>> The cgroup to monitor is passed as a file descriptor in the pid
>> argument to the syscall. The file descriptor must be opened to 
>> the cgroup name in the cgroup filesystem. For instance, if the
>> cgroup name is foo and cgroupfs is mounted in /cgroup, then the
>> file descriptor is opened to /cgroup/foo. Cgroup mode is
>> activated by passing PERF_FLAG_PID_CGROUP in the flags argument
>> to the syscall.
>>
>> For instance to measure in cgroup foo on CPU1 assuming
>> cgroupfs is mounted under /cgroup:
>>
>> struct perf_event_attr attr;
>> int cgroup_fd, fd;
>>
>> cgroup_fd = open("/cgroup/foo", O_RDONLY);
>> fd = perf_event_open(&attr, cgroup_fd, 1, -1, PERF_FLAG_PID_CGROUP);
>> close(cgroup_fd);
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com> 
> 
> Could you please split this patch:
>   - pure code movement
>   - time accounting changes
>   - event_filter_match() stuff
>   - cgroup thing
> 
> From a quick reading it doesn't look bad, but I want an ACK from the
> cgroup people -- specifically if they're OK with the filedesc juggling
> thing, because I know the sysfs people objected to such tricks.
> 

Long long ago, a feature that used this trick was accepted, and that's
cgroup taskstat.

You get an fd of a cgroup directory and send it to the kernel via netlink,
and then you'll receive some statistics, such as how many tasks are
running/interrupted in that cgroup.

> Also, it might make sense to add a CONFIG_PERF_CGROUP, even if you want
> it automagically set if CONFIG_PERF && CONFIG_CGROUP, its easier to find
> all related code if its under a single CONFIG_var.
> 
