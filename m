Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0ITSeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:34:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48782 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0ITSeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:34:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Will Drewry <wad@chromium.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org
References: <20100918012939.GA25046@redhat.com>
	<1284779629-15273-1-git-send-email-wad@chromium.org>
Date: Mon, 20 Sep 2010 11:34:00 -0700
In-Reply-To: <1284779629-15273-1-git-send-email-wad@chromium.org> (Will
	Drewry's message of "Fri, 17 Sep 2010 22:13:49 -0500")
Message-ID: <m1eico1cyv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Will Drewry <wad@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH][RFC] v2 exec: move core_pattern pipe helper into the crashing namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Drewry <wad@chromium.org> writes:

> Presently, a core_pattern pipe endpoint will be run in the init
> namespace.  It will receive the virtual pid (task_tgid_vnr->%p) of the
> core dumping process but will have no access to that processes /proc
> without walking the init namespace /proc looking through all the global
> pids until it finds the one it thinks matches.
>
> One option for fixing this is to change the reported pid:
>   https://patchwork.kernel.org/patch/185912/
> However, it's unclear if it is desirable for the core_pattern to run
> outside the namespace.  In particular, it can easily access the mounts
> via /proc/[pid_nr]/root, but if there is a net namespace, it will not
> have access.  (Originally introduced in 2007 in commit
> b488893a390edfe027bae7a46e9af8083e740668 )
>
> Instead, this change implements the more complex option two.  It
> migrates the ____call_usermodehelper() thread into the same namespaces
> as the dumping process.  It does not assign a pid in that namespace so
> the collector will appear to be pid 0 in the namespace.

I like the direction this is going but as structured this looks like a
security exploit waiting to happen.

The pipe process needs to run in the namespaces of the process who set
the core pattern, not in the namespaces of the dumping process.
Otherwise it is possible to trigger a privileged process to run in a
context where it's reality that it expected, causing it to misuse
it's privileges.  Even if we don't have a privilege problem I think
we will have a case of mismatched functionality where the core pattern
will not work as expected.

I believe the solution here is to move the core pattern into the pid
namespace and to capture the namespaces when set, but if the core
pattern hasn't been set to use the core pattern of the parent pid
namespace.

Eric
