Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab0HSUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:25:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38730 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0HSUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:25:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Zhang\, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, alex.shi@intel.com,
        Pavel Emelyanov <xemul@openvz.org>,
        "David S. Miller" <davem@davemloft.net>
References: <1282112318.21202.8.camel@ymzhang.sh.intel.com>
	<m1lj842nph.fsf@fess.ebiederm.org>
	<1282208060.2182.34.camel@ymzhang.sh.intel.com>
Date: Thu, 19 Aug 2010 13:25:16 -0700
In-Reply-To: <1282208060.2182.34.camel@ymzhang.sh.intel.com> (Yanmin Zhang's
	message of "Thu, 19 Aug 2010 16:54:20 +0800")
Message-ID: <m1bp8ypcyb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Zhang\, Yanmin" <yanmin_zhang@linux.intel.com>
X-Spam-Relay-Country: 
Subject: Re: hackbench regression with 2.6.36-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:

> On Wed, 2010-08-18 at 03:56 -0700, Eric W. Biederman wrote:
>> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
>> 
>> > Comparing with 2.6.35's result, hackbench (thread mode) has about
>> > 80% regression on dual-socket Nehalem machine and about 90% regression
>> > on 4-socket Tigerton machines.
>> 
>> That seems unfortunate.  
>
>> Do you only show a regression in the pthread
>> hackbench test?
> Yes.
>
>>   Do you show a regression when you use pipes?
> No.
>
>> 
>> Does the size of the regression very based on the number of loop
>> iterations?
> No. I tried 1000 and get the similar regression ratio.
> I choose a large 2000 loop number because I want to get a stable
> result.
>
> It's easy to reproduce it. We found it almost on all our machines.
>
>>   I ask because it appears that on the last message the
>> sender will exit necessitating that the receiver put the senders pid.
>> Which should be atypical.
> I don't agree on that. With hackbench, sender would send loops*receiver_num_per_group
> messages before exiting.
> In addition, 'perf top' shows put_pid is the hottest function in the beginning
> after I start hackbench. 

If increasing the number of loops does not improve the performance the
hypothesis that it is only the last message that has the regression
is shot.


>> > Command to start hackbench:
>> > #./hackbench 100 thread 2000
>> >
>> > process mode has no such regression.
>> >
>> > Profiling shows:
>> > #perf top
>> >              samples  pcnt function                 DSO
>> >              _______ _____ ________________________ ________________________
>> >
>> >             74415.00 29.9% put_pid                  [kernel.kallsyms]       
>> >             38395.00 15.4% unix_stream_recvmsg      [kernel.kallsyms]       
>> >             34877.00 14.0% unix_stream_sendmsg      [kernel.kallsyms]       
>> >             25204.00 10.1% pid_vnr                  [kernel.kallsyms]       
>> >             21864.00  8.8% unix_scm_to_skb          [kernel.kallsyms]       
>> >             13637.00  5.5% cred_to_ucred            [kernel.kallsyms]       
>> >              6520.00  2.6% unix_destruct_scm        [kernel.kallsyms]       
>> >              4731.00  1.9% sock_alloc_send_pskb     [kernel.kallsyms]       
>> >
>> >
>> > With 2.6.35, perf doesn't show put_pid/pid_NR.
>> 
>> Yes.  2.6.35 is imperfect and can report the wrong pid in some
>> circumstances.  I am surprised nothing related to the reference count on
>> struct cred does not show up in your profiling traces.
>> 
>
>> You are performing statistical sampling so I don't believe the
>> percentage of hits per function is the same as the percentage of
>> time per function.
> Agree. But from performance tuning point of view, percentage of hit is enough
> for helping developers to investigate.
>
> I provide 'perf top' data is to help you debug, not to prove your patches
> cause the regression. We used bisect to locate them.

Sure I was just trying to figure out how to explain why the creds
don't show a similar hit.  I still don't have a complete explanation
for the profile but the cred put and get are inline functions so they
won't be present as distinct functions in the profile.

>> Given that we are talking about a scheduler benchmark that is
>> doing something rather artificial (inter thread communication via
>> sockets), I don't know that this case is worth worrying about.
> Good question. I don't know how about below scenario:
> Start 2 processes and every process creates many threads. threads of process 1
> communicates with threads of process 2.

Maybe.  A lot depends on the timing, and what it takes to trigger
the cross cpu cache line bounce.

And we still have pipes for ultimate performance.  Grrr.

I will give it some thought to see if I can find a less expensive way
but I don't have any good ideas at the moment.


Eric
