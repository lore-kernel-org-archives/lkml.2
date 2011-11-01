Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1KAXu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:50:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39948 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab1KAXuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:50:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <mzxreary@0pointer.de>, greg@kroah.com,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        david@fubar.dk, Linux Containers <lxc-devel@lists.sourceforge.net>,
        Linux Containers <containers@lists.osdl.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, harald@redhat.com
References: <1317943022.1095.25.camel@mop>
	<20111007074904.GC16723@count0.beaverton.ibm.com>
	<20111007160113.GB14201@tango.0pointer.de>
	<m17h4g2jqy.fsf@fess.ebiederm.org>
	<20111010163140.GA22191@tango.0pointer.de>
	<m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
	<20111010214148.GB26510@tango.0pointer.de>
	<CAPXgP13npxh6UoEtXNiZ+Lhe_QxpO8-7r==WuUXDnNr+sHGXMw@mail.gmail.com>
	<4EB06D27.4020507@msgid.tls.msk.ru>
Date: Tue, 01 Nov 2011 16:51:22 -0700
In-Reply-To: <4EB06D27.4020507@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Wed, 02 Nov 2011 02:05:27 +0400")
Message-ID: <m17h3js8p1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ahx/oPLSvtwCD+qZBBhHeYILVqLxNYHY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michael Tokarev <mjt@tls.msk.ru>
X-Spam-Relay-Country: **
Subject: Re: [lxc-devel] Detecting if you are running in a container
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> [Replying to an oldish email...]
>
> On 12.10.2011 20:59, Kay Sievers wrote:
>> On Mon, Oct 10, 2011 at 23:41, Lennart Poettering <mzxreary@0pointer.de> wrote:
>>> On Mon, 10.10.11 13:59, Eric W. Biederman (ebiederm@xmission.com) wrote:
>> 
>>>> - udev.  All of the kernel interfaces for udev should be supported in
>>>>   current kernels.  However I believe udev is useless because container
>>>>   start drops CAP_MKNOD so we can't do evil things.  So I would
>>>>   recommend basing the startup of udev on presence of CAP_MKNOD.
>>>
>>> Using CAP_MKNOD as test here is indeed a good idea. I'll make sure udev
>>> in a systemd world makes use of that.
>> 
>> Done.
>> 
>> http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=9371e6f3e04b03692c23e392fdf005a08ccf1edb
>
> Maybe CAP_MKNOD isn't actually a good idea, having in mind devtmpfs?
>
> Without CAP_MKNOD, is devtmpfs still being populated internally by
> the kernel, so that udev only needs to change ownership/permissions
> and maintain symlinks in response to device changes, and perform
> other duties (reacting to other types of events) normally?
>
> In other words, provided devtmpfs works even without CAP_MKNOD,
> I can easily imagine a whole system running without this capability
> from the very early boot, with all functionality in place, including
> udev and what not...

Agreed devtmpfs does pretty much make dropping CAP_MKNOD useless.  I
expect we should verify that whoever mounts devtmpfs has CAP_MKNOD.

> And having CAP_MKNOD in container may not be that bad either, while
> cgroup device.permission is set correctly - some nodes may need to
> be created still, even in an unprivileged containers.  Who filters
> out CAP_MKNOD during container startup (I don't see it in the code,
> which only removes CAP_SYS_BOOT, and even that due to current
> limitation), and which evil things can be done if it is not filtered?

If you don't filter which device nodes you a process can read/write then
that process can access any device on the system.  Steal the keyboard,
the X display, access any filesystem, directly access memory.  Basically
the process can escalate that permission to full control of the system
without needing any kernel bugs to help it.

Eric
