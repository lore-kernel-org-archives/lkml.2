Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab2GFAm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:42:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53840 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2GFAmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:42:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Dilip Daya <dilip.daya@hp.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, <netdev@vger.kernel.org>
References: <1340900320.3441.88.camel@pro6455b.example.com>
	<20120705220749.GA11255@mail.hallyn.com>
Date: Thu, 05 Jul 2012 17:41:54 -0700
In-Reply-To: <20120705220749.GA11255@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 5 Jul 2012 22:07:49 +0000")
Message-ID: <87ehopu3e5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX190npRSwRHzwIjH/v5rerhRS2YSAtG9mmQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: Network namespace and bonding WARNING at fs/proc/generic.c remove_proc_entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Dilip Daya (dilip.daya@hp.com):
>> Hi,
>> 
>> I'd discussed the following with Serge Hallyn.
>> 
>> => Environment based on 3.2.18 / x86_64 kernel.
>> => WARNING: at fs/proc/generic.c:808 remove_proc_entry+0xdb/0x21f()
>> => WARNING: at fs/proc/generic.c:849 remove_proc_entry+0x208/0x21f()
>
> Hi,
>
> thanks much for sending this.  I'm still getting this error on
> 3.5.0-2-generic (today's ubuntu quantal kernel)
>
>> network namespace and bonding
>> -----------------------------
>> 
>> * Migrate two phy nics from host to netns (netns0).
>>   - ip link set ethX netns netns0
>> 
>> * In host environment:
>>   - load bonding module, /sbin/modprobe -v bonding mode=1 miimon=100
>>   - /sys/class/net/bond0 exists.
>>   - /proc/net/bonding/bond0 exists.
>>   - /sys/class/net/bonding_masters has bond0.
>> 
>> * Migrate bond0 to netns (netns0):
>>   - ip link set bond0 netns netns0.
>> 
>> * Within netns (netns0):
>>   - /sys/class/net/bonding_masters is empty.
>>   - /sys/class/net/bond0 exist.
>>   - configure bond0 and ifenslave with two phy nics.
>>   - /proc/net/bonding/bond0 does not exist within netns0, but does
>>     exist in the host environment.
>>   - /sys/class/net/bonding_masters is empty.
>
> mine is not empty, fwiw.  However
>
>>   - ping to remote end of bond0 works.
>> 
>> * Within netns (netns0), flushing ethX and bondY:
>>   - down bond0 and its phy nic interfaces:
>>   - ip link set ... down
>>   - ip addr flush dev [bond0 | eth#]
>>   - deleting bond0, /sbin/ip link del dev bond0
>
> Yup I still get a remove_proc_entry WARNING at fs/proc/generic.c:808,
> which is the warning when (!de)

It looks like Dilip is running an old kernel.  There should have been
some version of /sys/class/net/bonding_masters in every network
namespace since sometime in 2009.

>From the warning it looks like the proc files are being added/removed
to the wrong network namespace.  So in one namespace we get an error
when we delete the moved device and in the other network namespace
we get an error when we remove the /proc/directory.

An old kernel without proper network namespace support is the only
reason I can imagine someone would be moving an existing bond device
between network namespaces.

If there are other reasons for wanting to move a bonding device between
network namespaces it is possible to catch the NETDEV_UNREGISTER and
NETDEV_REGISTER events to remove/add the per device proc files at the
appropriate time.

However since moving bonding devices appears to be an unneded operation
let's just do things simply and forbid moving bonding devices between
network namespaces.  Serge, Dilip can you two test the patch below
and see if it fixes the warnings.

Eric


diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2ee8cf9..818ed64 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4345,6 +4345,9 @@ static void bond_setup(struct net_device *bond_dev)
        bond_dev->priv_flags |= IFF_BONDING;
        bond_dev->priv_flags &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
 
+       /* Don't allow bond devices to change network namespaces. */
+       bond_dev->features |= NETIF_F_LOCAL;
+
        /* At first, we block adding VLANs. That's the only way to
         * prevent problems that occur when adding VLANs over an
         * empty bond. The block will be removed once non-challenged
