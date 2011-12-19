Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1LSKNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:13:49 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58427 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1LSKNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:13:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Trond.Myklebust\@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs\@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "neilb\@suse.de" <neilb@suse.de>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields\@fieldses.org" <bfields@fieldses.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "devel\@openvz.org" <devel@openvz.org>
References: <20111214103602.3991.20990.stgit@localhost6.localdomain6>
	<20111214104449.3991.61989.stgit@localhost6.localdomain6>
	<m1bor6rg39.fsf@fess.ebiederm.org> <4EEEFC54.10700@parallels.com>
Date: Mon, 19 Dec 2011 02:15:22 -0800
In-Reply-To: <4EEEFC54.10700@parallels.com> (Stanislav Kinsbursky's message of
	"Mon, 19 Dec 2011 12:56:52 +0400")
Message-ID: <m18vm8g951.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18+J0H422bSowKv1RNUS3qMo0ko30mwV6s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 01/11] SYSCTL: export root and set handling routines
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> 18.12.2011 02:25, Eric W. Biederman пишет:
>> Stanislav Kinsbursky<skinsbursky@parallels.com>  writes:
>>
>>> These routines are required for making SUNRPC sysctl's per network namespace
>>> context.
>>
>> Why does sunrpc require it's own sysctl root?  You should be able to use
>> the generic per network namespace root and call it good.
>>
>> What makes register_net_sysctl_table and register_net_sysctl_ro_table
>> unsuitable for sunrpc.  I skimmed through your patches and I haven't
>> seen anything obvious.
>>
>> Eric
>>
>
> Hello, Eric. Sorry for the lack of information.
> I was considering two ways how to make these sysctl per net ns:
>
> 1) Use register_net_sysctl_table and register_net_sysctl_ro_table as you
> mentioned. This was easy and cheap, but also means, than all user-space
> programs, tuning SUNRPC will be broken (since all sysctl currently located
> in"/proc/sys/sunprc/").

Nope.  That is a misunderstanding.  register_net_sysctl_table works for
anything under /proc/sys.

> 2) Export sysctl root creation routines and make per-net SUNRPC sysctl
> root. This approach allows to make any part of sysctl tree per namespace context
> and thus leave user-space stuff unchanged.
>
> BTW, NFS and LockD also have it's sysctls ("/proc/sys/fs/nfs/").
> And also because of them I've decided, that it would be better to export SYSCTL
> root creation routines instead of breaking compatibility for all NFS layers by
> moving all sysctl under /proc/sys/net/ directory.
>
> Do you feel that it was a bad decision?

I think it was a misinformed decision.

I fully support not breaking userspace by moving where the sysctls files
are.  If something sounds like I am suggesting moving sysctl files there
is a miscommunication somewhere.

The concept of a sysctl root as I had envisioned it and essentially as it
is implemented was a per namespace sysctl tree.  Those sysctl trees are
then unioned together when presented to user space.  There should only
be one root per namespace.

In practice what this means is that register_net_sysctl_table should
work for any sysctl file anywhere under /proc/sys.  I think
register_net_sysctl_table is the right solution for your problem.  The
only possible caveat I can think of is you might hit Al's performance
optimizations and need to create a common empty directory first with
register_sysctl_paths.


....
That said since I am in the process of rewriting things some of this
may change a little bit, but hopefully not in ways that immediately
effect the users of register_sysctl_table.

Don't use register_net_sysctl_ro_table.   I think what the implementors
actually wanted was register_net_sysctl_table(&init_net, ...) and didn't
know it.

Don't put subdirectories in your sysctl tables.  Use a ctl_path to
specify the entire directory where the files should show up.  Generally
the code is easier to read in that form, and the code is simpler to deal
with if we don't have to worry about directories.

Don't play with the sysctl roots.  It is my intention to completely kill
them off and replace them by moving the per net sysctl tree under
/proc/<pid>/sys/.   Leaving behind symlinks in /proc/sys/net and I guess
ultimately in /proc/sys/sunrpc/ and /proc/sys/fs/nfs...  Which actually
seems to better describe your mental model.

Thank you for mentioning /proc/sys/fs/nfs.  That is a case I hadn't
thought about.  In thinking about it I see some deficiencies in my
rewrite that I need to correct before I push that code.

Eric
