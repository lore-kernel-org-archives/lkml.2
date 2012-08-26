Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2HZA2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 20:28:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35600 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2HZA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 20:28:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
References: <87lih2h6i4.fsf@xmission.com> <87wr0mecxz.fsf@xmission.com>
	<1345940316.19381.1.camel@pippen.local.home>
Date: Sat, 25 Aug 2012 17:28:02 -0700
In-Reply-To: <1345940316.19381.1.camel@pippen.local.home> (Steven Rostedt's
	message of "Sat, 25 Aug 2012 20:18:36 -0400")
Message-ID: <87mx1icx9p.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX191UjRnEDUn3aWPTY4TDkTv3b2uZra9QJY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 11/15] userns: Teach trace to use from_kuid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Sat, 2012-08-25 at 17:04 -0700, Eric W. Biederman wrote:
>> - When tracing capture the kuid.
>> - When displaying the data to user space convert the kuid into the
>>   user namespace of the process that opened the report file.
>> 
>
>> index 5c38c81..c9ace83 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -2060,7 +2060,8 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
>>  	seq_puts(m, "#    -----------------\n");
>>  	seq_printf(m, "#    | task: %.16s-%d "
>>  		   "(uid:%d nice:%ld policy:%ld rt_prio:%ld)\n",
>> -		   data->comm, data->pid, data->uid, data->nice,
>> +		   data->comm, data->pid,
>> +		   from_kuid_munged(seq_user_ns(m), data->uid), data->nice,
>
> This is a global id. That is, it stored whatever process triggered the
> report, not the one reading it. Thus, two different readers could get a
> different uid for the same task that triggered the latency?

Yes the stored value is a kuid_t the global kernel internal form.

We report the value as a uid_t in the user namespace of the reader.  So
if two different processes in different user namespaces read the file
they can see different values.

Now I don't expect in practice we will allow anyone who isn't
the global root user to even think of looking at debugfs, but in
case we do we might as well handle this as best as we can.

Eric
