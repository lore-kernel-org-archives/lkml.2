Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0IPUMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:12:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55083 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0IPUMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:12:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org
References: <1284663599-3549-1-git-send-email-wad@chromium.org>
	<20100916193543.GA11016@redhat.com>
Date: Thu, 16 Sep 2010 13:12:31 -0700
In-Reply-To: <20100916193543.GA11016@redhat.com> (Oleg Nesterov's message of
	"Thu, 16 Sep 2010 21:35:43 +0200")
Message-ID: <m1zkvh4fdc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH][RFC] fs/exec.c: provide the correct process pid to the pipe helper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 09/16, Will Drewry wrote:
>>
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1467,6 +1467,13 @@ static int format_corename(char *corename, long signr)
>>  	char *const out_end = corename + CORENAME_MAX_SIZE;
>>  	int rc;
>>  	int pid_in_pattern = 0;
>> +	pid_t pid = task_tgid_vnr(current);
>> +
>> +	/* The pipe helper runs in the init namespace and should
>> +	 * receive the matching pid until that changes.
>> +	 */
>> +	if (ispipe)
>> +		pid = task_tgid_nr(current);
>
> Agreed, it doesn't make sense to pass the "local" pid to the init ns.

Yes, passing the local pid to the init pid namespace doesn't make a lot
of sense.  I have recently fixed unix domain sockets to avoid doing that
kind of silliness.

That said I don't think this is a complete fix.  We also potentially
have the same issue with the uts namespace and the user namespace.

I believe the core file holds all of this information relative to the
process that is dying, one elf note or other so we don't need to worry
about information loss.

As for how to implement this for the pid case can we simply grab the
namespace at the ispipe stage and use task_tgid_nr_ns.  Something like:
pid_ns = current->nsproxy->pid_ns;
if (is_pipe)
	pid_ns = &init_pid_ns;

....
	/* pid */
	case 'p':
		pid_in_pattern = 1;
		rc = snprintf(out_ptr, out_end - out_ptr,
			      "%d", task_tgid_pid_nr_ns(pid_ns, current));
		if (rc > out_end - out_ptr)
			goto out;
		out_ptr += rc;
		break;

Will you were saying something about complex namespacing (in particular
the network namespace giving you problems).  The network namespace has
no influence over pipes so how does that come into play?

I can imagine that it would be nice to have different core patterns
depending on where you are in the process tree, so a container can
do something different than the system outside of the container.  Are
you thinking along those lines, or are you imagining something else?

Eric
