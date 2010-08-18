Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0HRK5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:57:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37653 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0HRK5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:57:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Zhang\, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, alex.shi@intel.com,
        Pavel Emelyanov <xemul@openvz.org>,
        "David S. Miller" <davem@davemloft.net>
References: <1282112318.21202.8.camel@ymzhang.sh.intel.com>
Date: Wed, 18 Aug 2010 03:56:58 -0700
In-Reply-To: <1282112318.21202.8.camel@ymzhang.sh.intel.com> (Yanmin Zhang's
	message of "Wed, 18 Aug 2010 14:18:37 +0800")
Message-ID: <m1lj842nph.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
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
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:

> Comparing with 2.6.35's result, hackbench (thread mode) has about
> 80% regression on dual-socket Nehalem machine and about 90% regression
> on 4-socket Tigerton machines.

That seems unfortunate.  Do you only show a regression in the pthread
hackbench test?  Do you show a regression when you use pipes?

Does the size of the regression very based on the number of loop
iterations?  I ask because it appears that on the last message the
sender will exit necessitating that the receiver put the senders pid.
Which should be atypical.

> Command to start hackbench:
> #./hackbench 100 thread 2000
>
> process mode has no such regression.
>
> Profiling shows:
> #perf top
>              samples  pcnt function                 DSO
>              _______ _____ ________________________ ________________________
>
>             74415.00 29.9% put_pid                  [kernel.kallsyms]       
>             38395.00 15.4% unix_stream_recvmsg      [kernel.kallsyms]       
>             34877.00 14.0% unix_stream_sendmsg      [kernel.kallsyms]       
>             25204.00 10.1% pid_vnr                  [kernel.kallsyms]       
>             21864.00  8.8% unix_scm_to_skb          [kernel.kallsyms]       
>             13637.00  5.5% cred_to_ucred            [kernel.kallsyms]       
>              6520.00  2.6% unix_destruct_scm        [kernel.kallsyms]       
>              4731.00  1.9% sock_alloc_send_pskb     [kernel.kallsyms]       
>
>
> With 2.6.35, perf doesn't show put_pid/pid_NR.

Yes.  2.6.35 is imperfect and can report the wrong pid in some
circumstances.  I am surprised nothing related to the reference count on
struct cred does not show up in your profiling traces.

You are performing statistical sampling so I don't believe the
percentage of hits per function is the same as the percentage of
time per function.

Given that we are talking about a scheduler benchmark that is
doing something rather artificial (inter thread communication via
sockets), I don't know that this case is worth worrying about.

> Alex Shi and I did a quick bisect and located below 2 patches.

That is a plausible result.  The atomic reference counts may
be causing you to ping pong cache lines between cpus.

Eric


> 1) commit 7361c36c5224519b258219fe3d0e8abc865d8134
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sun Jun 13 03:34:33 2010 +0000
>
>     af_unix: Allow credentials to work across user and pid namespaces.
>
>     In unix_skb_parms store pointers to struct pid and struct cred instead
>     of raw uid, gid, and pid values, then translate the credentials on
>     reception into values that are meaningful in the receiving processes
>     namespaces.
>
>
> 2) commit 257b5358b32f17e0603b6ff57b13610b0e02348f
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sun Jun 13 03:32:34 2010 +0000
>
>     scm: Capture the full credentials of the scm sender.
>
>     Start capturing not only the userspace pid, uid and gid values of the
>     sending process but also the struct pid and struct cred of the sending
>     process as well.
