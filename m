Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2IPL43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 07:56:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48039 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2IPL40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 07:56:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Aristeu Rozanski <aris@ruivo.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
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
Date: Sun, 16 Sep 2012 04:56:06 -0700
In-Reply-To: <20120916122112.3f16178d@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Sun, 16 Sep 2012 12:21:12 +0100")
Message-ID: <87sjaiuqp5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/EEgN87U6fDI3x22hM4IJk9XV1HN3P2Ds=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2600]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
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

>> One piece of the puzzle is that we should be able to allow unprivileged
>> device node creation and access for any device on any filesystem
>> for which it unprivileged access is safe.
>
> Which devices are "safe" is policy for all interesting and useful cases,
> as are file permissions, security tags, chroot considerations and the
> like.
>
> It's a complete non starter.

There are a handful of device nodes that the kernel creates with mode
0666.  Esentially it is just /dev/tty /dev/null /dev/zero and a few
others.  Enourmous numbers of programs won't work without them.  Making
them both interesting and useful.

In very peculiar cases I can see not wanting to have access to generally
safe devices, like in other peculiar cases we don't have want access to
the network stack.


As for the general case device nodes for real hardware in a container
which I think is the "interesting" case you were referring to.  I
personally find that case icky and boring.

The sanest way I can think of handling real hardware device nodes is a
tmpfs (acting like devtmpfs) mounted on /dev in the containers mount
namespace, but also visible outside to the global root mounted somewhere
interesting.  We have a fuse filesystem pretending to be sysfs and
relaying file accesses from the real sysfs for just the devices that we
want to allow to that container.

Then to add a device in a container the managing daemon makes the
devices available in the pretend sysfs, calls mknod on the tmpfs
and fakes the uevents.


The only case I don't see that truly covering is keeping the stat data
the same for files of migrated applications.  Shrug perhaps that will
just have to be handled with another synthesized uevent.  Hey userspace I
just hot-unplugged and hot-plugged your kernel please cope.

Eric

