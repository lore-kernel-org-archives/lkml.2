Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1BJDl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:41:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53676 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1BJDly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:41:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org
References: <20110207231416.GD1457@outflux.net>
	<alpine.LRH.2.00.1102081127330.3342@tundra.namei.org>
	<20110208011445.GF1457@outflux.net>
	<alpine.LRH.2.00.1102081437430.3879@tundra.namei.org>
	<20110208042708.GG1457@outflux.net> <m1ipwu5lj2.fsf@fess.ebiederm.org>
	<alpine.LRH.2.00.1102101337100.19432@tundra.namei.org>
Date: Wed, 09 Feb 2011 19:41:41 -0800
In-Reply-To: <alpine.LRH.2.00.1102101337100.19432@tundra.namei.org> (James
	Morris's message of "Thu, 10 Feb 2011 13:44:58 +1100 (EST)")
Message-ID: <m1r5bglfnu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/eV/NdW929kZfDIqQQ0mJkd2FtYIn54ME=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Morris <jmorris@namei.org>
X-Spam-Relay-Country: 
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> writes:

> On Tue, 8 Feb 2011, Eric W. Biederman wrote:
>
>> Kees Cook <kees.cook@canonical.com> writes:
>> 
>> > On Tue, Feb 08, 2011 at 02:43:15PM +1100, James Morris wrote:
>
>> >> > I don't think /proc/$pid/* needs to stay open across execs, does it? Or at
>> >> > least the non-0444 files should be handled separately.
>> >> 
>> >> Actually, this seems like a more general kind of bug in proc rather than a 
>> >> leaked fd.  Each child task should only see its own /proc/[pid] data.
>> >
>> > Right, that's precisely the problem. The unprivileged process can read
>> > the setuid process's /proc files.
>> 
>> If these are things that we actually care about we should sprinkle in a
>> few more ptrace_may_access calls into implementations of the relevant
>> proc files.
>
> This seems to be papering over a bug.
>
> It is plainly broken to return an access error to a task which is 
> legitimately accessing a file.  The task should not receive the wrong 
> information from /proc/[pid]/* .

Per task files are special because of exec.  The permission needed
change dynamically.  The common solution to this problem (see ttys) is
to revoke anyone who has file descriptors open.  Proc does something a
little different and simply gives you a permission error when you read
or write if it would be a problem.

We happen to call the test to see if you should have permission
security_may_ptrace because ptrace lets you get the information anyway
so we might as well allow the information from /proc.

Given that security_may_ptrace is the existing model, and that we don't
return wrong data, but a clear an unambiguous error I don't see problems
with the approach.

The practical question is, is the data sensitive enough that we want
this protection.

Eric
