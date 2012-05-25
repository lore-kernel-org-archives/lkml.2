Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2EYVoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:44:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41521 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2EYVoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:44:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com>
	<20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com>
	<20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com>
	<20120522122315.c3f2118c.akpm@linux-foundation.org>
	<20120523145239.GA20378@redhat.com>
	<20120525151526.GA13111@redhat.com>
	<20120525155941.GA16885@redhat.com>
	<20120525160008.GB16885@redhat.com>
Date: Fri, 25 May 2012 15:43:48 -0600
In-Reply-To: <20120525160008.GB16885@redhat.com> (Oleg Nesterov's message of
	"Fri, 25 May 2012 18:00:08 +0200")
Message-ID: <87pq9sdjhn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/PQmbKGn9CSa/hfSQfoVJIz3xWD+QO2ao=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0458]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH -mm 1/1] pidns: find_new_reaper() can no longer switch to init_pid_ns.child_reaper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> find_new_reaper() changes pid_ns->child_reaper, see add0d4df
> "pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing".
>
> The original reason has gone away after the previous patch,
> ->children list must be empty after zap_pid_ns_processes().
> However, "can't clear ->child_reaper or leave it alone" is
> still true, and now we can not use init_pid_ns.child_reaper.
>
> __unhash_process() relies on the "->child_reaper == parent"
> check, but this check does not work if the last exiting task
> is also the child reaper.
>
> Change find_new_reaper() to use pid_ns->parent->child_reaper.

Oleg this is a good catch for a real problem.  However I disagree about
the fix.

We should make unhash_process say:
	if ((task_active_pid_ns(parent)->child_reaper == parent) &&
	    list_empty(&parent->children) &&
	    (parent->flags & PF_EXITING))
		wake_up_process(parent);

It is always the child_reaper of our parent's pid namespace that we are
reparented to if our parent exits.  So we were looking at the wrong
processes pid_namespace.  Just using parent removes any need for magic
after zap_pid_ns_processes(), and the test always becomes valid.

And we should just set delete the code after zap_pid_ns_processes that
changes the child_reaper since nothing we will use the child_reaper
after that.  We could set pid_ns.child_reaper to NULL after that
but why bother.

Eric
