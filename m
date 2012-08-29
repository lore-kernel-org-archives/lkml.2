Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2H2GkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:40:07 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:45918 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2H2GkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:40:04 -0400
Message-ID: <503DB925.4040809@in.ibm.com>
Date: Wed, 29 Aug 2012 12:09:33 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, ananth@in.ibm.com,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] [perf] Remove the node from rblist in strlist__remove
References: <20120829055840.7802.1459.stgit@suzukikp.in.ibm.com> <503DB6CD.4070502@gmail.com>
In-Reply-To: <503DB6CD.4070502@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082906-2000-0000-0000-000008E1B51C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 11:59 AM, David Ahern wrote:
> On 8/29/12 12:00 AM, Suzuki K. Poulose wrote:
>> The following commit:
>>
>> author    David Ahern <dsahern@gmail.com>
>>     Tue, 31 Jul 2012 04:31:33 +0000 (22:31 -0600)
>> committer    Arnaldo Carvalho de Melo <acme@redhat.com>
>>     Fri, 3 Aug 2012 13:39:51 +0000 (10:39 -0300)
>> commit    ee8dd3ca43f151d9fbe1edeef68fb8a77eb9f047
>>
>> causes a double free during a probe deletion as the node is
>> never removed from the list via strlist__remove(), even though
>> it gets 'deleted' (read free()'d). This causes a double
>> free when we do strlist__delete() as the node is already deleted
>> but present in the rblist.
>>
>> [suzukikp@suzukikp perf]$ sudo ./perf probe -a do_fork
>> Added new event:
>>    probe:do_fork        (on do_fork)
>>
>> You can now use it in all perf tools, such as:
>>
>>     perf record -e probe:do_fork -aR sleep 1
>>
>> [suzukikp@suzukikp perf]$ sudo ./perf probe -d do_fork
>> Removed event: probe:do_fork
>> *** glibc detected *** ./perf: double free or corruption (fasttop):
>> 0x000000000133d600 ***
>> ======= Backtrace: =========
>> /lib64/libc.so.6[0x38eec7dda6]
>> ./perf(rblist__delete+0x5c)[0x47d3dc]
>> ./perf(del_perf_probe_events+0xb6)[0x47b826]
>> ./perf(cmd_probe+0x471)[0x42c8d1]
>> ./perf[0x4150b3]
>> ./perf(main+0x501)[0x4148e1]
>> /lib64/libc.so.6(__libc_start_main+0xed)[0x38eec2169d]
>> ./perf[0x414a61]
>>
>>
>> Make sure we remove the node from the rblist before we delete the
>> node. The rblist__remove_node() will invoke rblist->node_delete,
>> which  will take care of deleting the node with the suitable function
>> provided by the user.
>>
>> Reported-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
>> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
>
> Acked-by: David Ahern <dsahern@gmail.com>
>
> Same type of change is needed for util/intlist.c if you want to submit
> one, otherwise I will take care of it.

I can send it.

Thanks
Suzuki

