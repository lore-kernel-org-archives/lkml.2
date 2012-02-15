Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2BOQ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:57:40 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58824 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2BOQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:57:39 -0500
Message-ID: <4F3BE3F9.2010002@gmail.com>
Date: Wed, 15 Feb 2012 09:57:29 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Luigi Semenzato <semenzato@chromium.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] Perf: bug fix: distinguish between rename and exec
References: <1329195360-10699-1-git-send-email-semenzato@chromium.org> <1329310113.2293.72.camel@twins>
In-Reply-To: <1329310113.2293.72.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/12 5:48 AM, Peter Zijlstra wrote:
> On Mon, 2012-02-13 at 20:56 -0800, Luigi Semenzato wrote:
>> This makes it possible for "perf report" to distinguish between an exec and
>> a rename (for instance from prctl(PR_SET_NAME)).  Currently a similar COMM
>> record is produced for the two events.  Perf report assumes all COMM records
>> are execs and discards the old mappings.  Without mappings, perf report
>> can no longer correlate sampled IPs to the functions containing them,
>> and collapses all samples into a single bucket.
>>
>> This change maintains backward compatibility in both directions, i.e. old
>> version of perf will continue to work on new perf.data files in the same
>> way, and new versions of perf on old data files.
>>
>> Another solution would be to not send COMM records for renames.  Although
>> it seems reasonable, it might break existing setups.
>
> Uhm, didn't you argue its already broken?
>
>> +++ b/fs/exec.c
>> @@ -1052,7 +1052,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
>>   }
>>   EXPORT_SYMBOL_GPL(get_task_comm);
>>
>> -void set_task_comm(struct task_struct *tsk, char *buf)
>> +void set_task_comm(struct task_struct *tsk, char *buf, bool is_rename)
>>   {
>>   	task_lock(tsk);
>>
>> @@ -1068,7 +1068,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
>>   	wmb();
>>   	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
>>   	task_unlock(tsk);
>> -	perf_event_comm(tsk);
>> +	perf_event_comm(tsk, is_rename);
>>   }
>
> I really dislike changing generic code purely for the purpose of
> instrumentation like this. Better to pull perf_event_comm() out of here
> if you want to change semantics.
>
> Personally I couldn't care less about renames, I think they're a waste
> of time, so I'm ok with the simple patch moving the perf_event_comm()
> into setup_new_exec() and possibly renaming it to perf_event_exec().
>
> Acme, do you care about renames?
>

I'm not Acme, but I do care. We use a lot of processes with named 
threads that give users an idea about the function of a particular thread.

I do not understand the use case targeted by the patch -- what kind of 
processes run for some amount of time and then decide to change task names?

David
