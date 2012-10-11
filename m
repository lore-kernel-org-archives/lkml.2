Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab2JKDcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:32:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50151 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2JKDcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:32:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
References: <506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
	<CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
	<CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
	<87zk42tab4.fsf@xmission.com> <20121004174254.GA14301@kroah.com>
Date: Wed, 10 Oct 2012 20:32:00 -0700
In-Reply-To: <20121004174254.GA14301@kroah.com> (Greg KH's message of "Thu, 4
	Oct 2012 10:42:54 -0700")
Message-ID: <87626hr8en.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Msk7EuXujwaRhu66uIhVHxP9K+fVJXAo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: udev breakages -
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, Oct 04, 2012 at 10:29:51AM -0700, Eric W. Biederman wrote:
>> There are still quite a few interesting cases that devtmpfs does not
>> even think about supporting.  Cases that were reported when devtmpfs was
>> being reviewed. 
>
> Care to refresh my memory?

Anyone who wants something besides the default policy.   Containers
chroots anyone who doesn't want /dev/console to be c 5 1.

>> Additionally the devtmpfs maintainership has not dealt with legitimate
>> concerns any better than this firmware issue has been dealt with.  I
>> still haven't even hear a productive suggestion back on the hole
>> /dev/ptmx mess.
>
> I don't know how to handle the /dev/ptmx issue properly from within
> devtmpfs, does anyone?  Proposals are always welcome, the last time this
> came up a week or so ago, I don't recall seeing any proposals, just a
> general complaint.

The proposal at that time was to work around the silliness with a little
kernel magic.

To recap for those who haven't watched closely.  devpts now has a ptmx
device node and it would be very nice if we were to use that device
node instead of /dev/ptmx.

Baically it would be nice to tell udev to not create /dev/ptmx, and
instead to make /dev/ptmx a symlink to /dev/pts/ptmx.

I got to looking at the problem and if I don't worry about systemd and
just look at older versions of udev that are out there in the wild it
turns out the following udev configuratoin line does exactly what is
needed.  It creats a symlink from /dev/ptmx to /dev/pts/ptmx.  And if
on the odd chance devpts is not mounted it creates /dev/pts/ptmx as
well.

KERNEL=="ptmx" NAME:="pts/ptmx" SYMLINK="ptmx"

Does assigning to NAME to specify the device naming policy work in
systemd-udev or has that capability been ripped out?

Thinking about it.  Since systemd-udev no longer supports changing the
device name.  And likely it no longer even supports assigning to NAME
even for purposes of changing the target of the symlink.  Then I expect
what we want to do is:

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 147d1a4..7dc5bed 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -377,6 +377,7 @@ static int devtmpfsd(void *p)
                goto out;
        sys_chdir("/.."); /* will traverse into overmounted root */
        sys_chroot(".");
+       sys_symlink("pts/ptmx", "ptmx");
        complete(&setup_done);
        while (1) {
                spin_lock(&req_lock);



Eric
