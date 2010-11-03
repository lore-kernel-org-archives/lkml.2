Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0KCVvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:51:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:56511 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0KCVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:51:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=x-relay-ip:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=qFme3hI0sVy/PU3gh8THcTW/j73GSaxAsDKEgq/hzTXpxrNOh/3kSCDDnP5NfBvb/
	/4sbmwVZPoR3jrruKkCow==
X-Relay-IP: 172.22.64.119
Message-ID: <4CD1D919.5000209@google.com>
Date: Wed, 03 Nov 2010 14:50:17 -0700
From: Aaron Durbin <adurbin@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "Satoru Moriya"@google.com
Subject: Re: [RFC][Patch] Adding kmsg_dump() to reboot/halt/poweroff/emergency_restart
 path
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com> <20101018153350.18b68c50.akpm@linux-foundation.org> <5C4C569E8A4B9B42A84A977CF070A35B2C1276CEC7@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C1276CEC7@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/10 12:44, Seiji Aguchi wrote:
> Hi,
>
>> What actual problem are we solving here?  Why is the current code
>> inadequate?  It would help to demonstrate some use-case and to explain
>> how the situation improved with this patch.
>
> [Purpose]
>   My purpose is developing highly reliable logging facility for
enterprise use.
>
>   I'm planning to add the following triggers of kmsg_dumper().
>      - reboot/poweroff/halt/emergency_restart (this patch)
>      - Machine check
>
>   I'm also planning to add an feature outputting kernel messages to
NVRAM,
>   because NVRAM is equipped with enterprise servers.
>   We can realize highly reliable logging facility by outputting
kernel messages to NVRAM.
>   (NVRAM is commonly used on Mainframe and Commercial Unix as well.)
>
> [Use case of reboot/poweroff/halt/emergency_restart]
>
>   My company has often experienced the followings in our support service.
>   - Customer's system suddenly reboots.
>   - Customers ask us to investigate the reason of the reboot.
>
>   We recognize the fact itself because boot messages remain in
/var/log/messages.
>   However, we can't investigate the reason why the system rebooted,
>   because the last messages don't remain.
>   And off course we can't explain the reason.
>
>
>   We can solve above problem with this patch as follows.
>   Case1: reboot with command
>     - We can see "Restarting system with command:" or ""Restarting
system.".
>
>   Case2: halt with command
>     - We can see "System halted.".
>
>   Case3: poweroff with command
>     - We can see " Power down.".
>
>   Case4: emergency_restart with sysrq.
>     - We can see "Sysrq:" outputted in __handle_sysrq().
>
>   Case5: emergency_restart with softdog.
>     - We can see "Initiating system reboot" in watchdog_fire().
>
>   So, we can distinguish the reason of reboot, poweroff, halt and
emergency_restart.
>
>   If customer executed reboot command, you may think the customer
should know the fact.
>   However, they often claim they don't execute the command when they
rebooted system by mistake.
>
>   No evidential message remain on current Linux kernel, so we can't
show the proof to the customer.
>   This patch improves this situation.
>
> Seiji

We carry patches in our kernels that do very similar things. The reason 
is essentially the same as what you have cited. On our platforms we have 
two different ways of storing events to an event log. One communicates 
with the BIOS itself; the other writes bit flags to a known area of 
non-volatile storage. That way when the machine comes back up we have a 
clear eventlog (with times) as to what happened when. Piecing these 
events together has proven to be invaluable for finding issues.

For both of the drivers that log these events they use a shared 
interface that collect various events in the kernel and present them 
through a single notifier chain for the drivers' consumption.

The things we currently track and log are the following:
- clean reboot/shutdown
- panic
- oops
- die
- NMI watchdog

An example eventlog produced by our systems looks like the following 
(63-67 are the boot numbers of the system in question):

2010-10-14 10:26:06 | System Reset | 63
2010-10-14 10:26:19 | System boot | 63
2010-10-14 11:36:43 | Kernel Shutdown | 63 | Unknown Shutdown Reason
2010-10-14 11:36:43 | System Reset | 64
2010-10-14 11:36:56 | System boot | 64
2010-10-18 14:51:54 | Kernel Shutdown | 64 | Clean
2010-10-18 14:52:38 | System Reset | 65
2010-10-18 14:52:51 | System boot | 65
2010-10-26 02:44:48 | Kernel Shutdown | 65 | Oops
2010-10-26 02:44:48 | Kernel Shutdown | 65 | Die
2010-10-26 02:44:49 | Kernel Shutdown | 65 | Panic
2010-10-26 02:45:43 | System Reset | 66
2010-10-26 02:45:56 | System boot | 66
2010-10-26 02:49:22 | Kernel Shutdown | 66 | Clean
2010-10-26 02:50:05 | System Reset | 67
2010-10-26 02:50:18 | System boot | 67
2010-10-26 11:39:20 | Kernel Shutdown | 67 | Clean

Hope that helps others know that we think such a mechansim is vital. I 
can post the patches for the common infrastructure if people are interested.

-Aaron
