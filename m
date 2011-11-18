Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1KRDXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:23:40 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53312 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab1KRDXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:23:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>, richard@nod.at,
        containers@lists.linux-foundation.org, eparis@redhat.com,
        oleg@redhat.com, dhowells@redhat.com
References: <20111117045230.GA26345@hallyn.com>
Date: Thu, 17 Nov 2011 19:24:34 -0800
In-Reply-To: <20111117045230.GA26345@hallyn.com> (Serge E. Hallyn's message of
	"Thu, 17 Nov 2011 04:52:30 +0000")
Message-ID: <m1aa7u2jv1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18AKBggsCfHyhsQTvduOlCSDRoMrNmpMyw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: user namespace: make signal.c respect user namespaces (v5)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> ipc/mqueue.c: for __SI_MESQ, convert the uid being sent to recipient's
> user namespace. (new, thanks Oleg)
>
> __send_signal: convert current's uid to the recipient's user namespace
> for any siginfo which is not SI_FROMKERNEL (patch from Oleg, thanks
> again :)
>
> do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
> user namespace
>
> ptrace_signal maps parent's uid into current's user namespace before
> including in signal to current.  IIUC Oleg has argued that this shouldn't
> matter as the debugger will play with it, but it seems like not converting
> the value currently being set is misleading.
>
> Changelog:
> Sep 20: Inspired by Oleg's suggestion, define map_cred_ns() helper to
> 	simplify callers and help make clear what we are translating
>         (which uid into which namespace).  Passing the target task would
> 	make callers even easier to read, but we pass in user_ns because
> 	current_user_ns() != task_cred_xxx(current, user_ns).
> Sep 20: As recommended by Oleg, also put task_pid_vnr() under rcu_read_lock
> 	in ptrace_signal().
> Sep 23: In send_signal(), detect when (user) signal is coming from an
> 	ancestor or unrelated user namespace.  Pass that on to __send_signal,
> 	which sets si_uid to 0 or overflowuid if needed.
> Oct 12: Base on Oleg's fixup_uid() patch.  On top of that, handle all
> 	SI_FROMKERNEL cases at callers, because we can't assume sender is
> 	current in those cases.
> Nov 10: (mhelsley) rename fixup_uid to more meaningful usern_fixup_signal_uid
> Nov 10: (akpm) make the !CONFIG_USER_NS case clearer
>

> @@ -1088,6 +1117,9 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  				q->info.si_pid = 0;
>  			break;
>  		}
> +
> +		userns_fixup_signal_uid(info, t);

There is a small bug here.  You want to fixup q->info, not info.
Otherwise you might try dereferencing one of the special signals and get
a NULL pointer dereference.

Eric

> +
>  	} else if (!is_si_special(info)) {
>  		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
>  			/*
