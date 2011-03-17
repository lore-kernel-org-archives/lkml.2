Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1CQQvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:51:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59076 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1CQQvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:51:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        serge@hallyn.com, eparis@redhat.com, jmorris@namei.org,
        eugeneteo@kernel.org, drosenberg@vsecurity.com
References: <1300303907-22627-1-git-send-email-richard@nod.at>
	<20110316195549.GZ5466@outflux.net>
	<201103162108.17127.richard@nod.at>
	<20110316211911.GA13715@p183.telecom.by>
Date: Thu, 17 Mar 2011 09:51:41 -0700
In-Reply-To: <20110316211911.GA13715@p183.telecom.by> (Alexey Dobriyan's
	message of "Wed, 16 Mar 2011 23:19:11 +0200")
Message-ID: <m1mxktbsgy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18rN4fLKZC/ALoOnggZBzdxhC/rarpgrzk=
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
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Wed, Mar 16, 2011 at 09:08:16PM +0100, Richard Weinberger wrote:
>> Kees,
>> 
>> Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
>> > Hi Richard,
>> > 
>> > On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
>> > > When containers like LXC are used a unprivileged and jailed
>> > > root user can still write to critical files in /proc/.
>> > > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
>> > > 
>> > > This new restricted attribute makes it possible to protect such
>> > > files. When restricted is set to true root needs CAP_SYS_ADMIN
>> > > to into the file.
>> > 
>> > I was thinking about this too. I'd prefer more fine-grained control
>> > in this area, since some sysctl entries aren't strictly controlled by
>> > CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).
>> > 
>> > How about this instead?
>> 
>> Good Idea.
>> May we should also consider a per-directory restriction.
>> Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
>> It would be much easier to set the protection on the parent directory
>> instead of protecting file by file...
>
> Of course, not.
>
> You should _enable_ them one by one, not the other way around.
>
> 	"default deny"

Right.

Since the primary problem here is containers we can use the
user_namespace to add the default deny policy.

Something like the trivial patch below should make /proc/sys safe,
and the technique applies in general.

Richard is that a good enough example to get you started?

Eric

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f1bd83..a172a9d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1674,10 +1674,12 @@ void register_sysctl_root(struct ctl_table_root *root)
 
 static int test_perm(int mode, int op)
 {
-	if (!current_euid())
-		mode >>= 6;
-	else if (in_egroup_p(0))
-		mode >>= 3;
+	if (current_user_ns() == &init_user_ns) {
+		if (!current_euid())
+			mode >>= 6;
+		else if (in_egroup_p(0))
+			mode >>= 3;
+	}
 	if ((op & ~mode & (MAY_READ|MAY_WRITE|MAY_EXEC)) == 0)
 		return 0;
 	return -EACCES;


