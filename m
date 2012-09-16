Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2IPRtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 13:49:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51114 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2IPRtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 13:49:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Serge Hallyn <serge@hallyn.com>, Aristeu Rozanski <aris@ruivo.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20120913205827.GO7677@google.com>
	<20120914183641.GA2191@cathedrallabs.org>
	<20120915022037.GA6438@mail.hallyn.com>
	<87wqzv7i08.fsf_-_@xmission.com>
	<20120915220520.GA11364@mail.hallyn.com> <87y5kazuez.fsf@xmission.com>
	<20120916122112.3f16178d@pyramind.ukuu.org.uk>
	<87sjaiuqp5.fsf@xmission.com> <87d31mupp3.fsf@xmission.com>
	<5055D4D1.3070407@hallyn.com> <87k3vuqc5l.fsf@xmission.com>
	<20120916171316.517ad0fd@pyramind.ukuu.org.uk>
Date: Sun, 16 Sep 2012 10:49:07 -0700
In-Reply-To: <20120916171316.517ad0fd@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Sun, 16 Sep 2012 17:13:16 +0100")
Message-ID: <87zk4pluy4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/L9rEmqsvUe0JV/SAZdpH5uNLc5g/A+EE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0098]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
Subject: Re: Controlling devices and device namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> At least with a recent modern distro I can't imagine this to be an
>> issue.  I expect we could have a kernel build option that removed the
>> mknod system call and a modern distro wouldn't notice.
>
> A few things beyond named pipes will break. PCMCIA I believe still
> depends on ugly mknod hackery of its own. You also need it for some
> classes of non detectable device.
>
> Basically though you could.

Ah yes fifos.  I had forgotten mknod created them.  I am half surprised
there isn't a mkfifo system call.

>> For migration with direct access to real hardware devices we must treat
>> it as hardware hotunplug.  There is nothing else we can do.
>
> That is demonstrably false for a shared bus or a network linked device.
> Consider a firewire camera wired to two systems at once. Consider SAN
> storage.

Sort of.

If you are talking to the device directly there is usually enough state
with the path changing that modelling it as a hotunplug/hotplug is about
all that is practical.  There is all of that intermediate state for in
progress DMAs in the end system controllers etc.

Now if you have a logical abstraction like a block device in between the
program and the SAN storage, then figuring out how to preserve device
names and numbers becomes interesting.  At least far enough to keep
device and inode numbers for stat intact.

A fully general solution for preserving device names, and numbers
requires rewriting sysfs.  I expect a lot of the infrastructure someone
needs is there already from my network namespace work but after having
done the network namespace I am sick and tired of manhandling that
unreasonably conjoined glob of device stuff.

Eric
