Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1CPVSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:18:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58090 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab1CPVRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:17:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        serge@hallyn.com, eparis@redhat.com, jmorris@namei.org,
        eugeneteo@kernel.org, drosenberg@vsecurity.com
References: <1300303907-22627-1-git-send-email-richard@nod.at>
	<201103162108.17127.richard@nod.at> <201103162145.45772.arnd@arndb.de>
	<201103162152.49615.richard@nod.at>
Date: Wed, 16 Mar 2011 14:17:39 -0700
In-Reply-To: <201103162152.49615.richard@nod.at> (Richard Weinberger's message
	of "Wed, 16 Mar 2011 21:52:49 +0100")
Message-ID: <m1lj0eepe4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+r9y8n9JWzeoqlnfx1qlNdMxt9FEtaXTk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

2> Am Mittwoch 16 März 2011, 21:45:45 schrieb Arnd Bergmann:
>> On Wednesday 16 March 2011 21:08:16 Richard Weinberger wrote:
>> > Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
>> > > On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
>> > > > When containers like LXC are used a unprivileged and jailed
>> > > > root user can still write to critical files in /proc/.
>> > > > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
>> > > > 
>> > > > This new restricted attribute makes it possible to protect such
>> > > > files. When restricted is set to true root needs CAP_SYS_ADMIN
>> > > > to into the file.
>> > > 
>> > > I was thinking about this too. I'd prefer more fine-grained control
>> > > in this area, since some sysctl entries aren't strictly controlled by
>> > > CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).
>> > > 
>> > > How about this instead?
>> > 
>> > Good Idea.
>> > May we should also consider a per-directory restriction.
>> > Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
>> > It would be much easier to set the protection on the parent directory
>> > instead of protecting file by file...
>> 
>> How does this interact with the per-namespace sysctls that Eric
>> Biederman added a few years ago?
>
> Do you mean CONFIG_{UTS, UPC, USER, NET,}_NS?
>
>> I had expected that any dangerous sysctl would not be visible in
>> an unpriviledge container anyway.
>
> No way.
> That's why it's currently a very good idea to mount /proc/ read-only
> into a container.

However it is in the architecture.  The problem is that the user
namespace is not finished.  Once finished even root with all caps in a
container will have no more permissions than the unprivileged user that
created the user namespace.

Essentially the change is to make permissions checks become a comparison
of the tuple (user_ns, uid) instead of just comparisons by uid.  If we
want to fix permission problems with proc and containers please let's
focus on the completing the user namespace.

Eric
