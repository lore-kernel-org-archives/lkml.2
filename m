Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2ADGIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 01:08:00 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:42000 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2ADGH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 01:07:58 -0500
Message-ID: <4F03ECAF.4080207@linux.vnet.ibm.com>
Date: Wed, 04 Jan 2012 11:37:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode should perform update after suspend to disk
References: <jdq23r$vni$1@dough.gmane.org>
In-Reply-To: <jdq23r$vni$1@dough.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
x-cbid: 12010406-8256-0000-0000-000000B96DF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2012 10:07 PM, Sven Köhler wrote:

> Hi,
> 
> at startup I load the microcode module and it correctly loads the
> microcode from /lib/firmware/intel-ucode/. In dmesg, I can see that the
> microcode has been updated from 0xc to 0xd.
> After suspend to ram, dmesg shows new messages from the microcode
> module, telling me that the microcode is still at revision 0xd. Hence,
> no update is performed.
> However, after suspend to disk, dmesg shows no new messages from the
> microcode module. After rmmod microcode; modprobe microcode dmesg tells
> me that the microcode had to be updated from 0xc to 0xd.
> 
> Somethings wrong here. My interpretation of the messages in dmesg is,
> that microcode is trying to update the microcode after suspend to ram
> but not after suspend to disk. It should try in both cases. Note that I
> don't unload the microcode module.
> 
> 


Which kernel version are you using?

As far as this part of the code is concerned, the path taken for both
suspend-to-ram and suspend-to-disk are more or less the same.
On the resume path, both call enable_nonboot_cpus() which brings the nonboot
cpus online, and due to the cpuhotplug notifications for these, we have a
flow something like:

[The following functions are all in arch/x86/kernel/microcode_core.c]

  mc_cpu_callback() //with action=CPU_ONLINE_FROZEN
  -> microcode_update_cpu()
     -> microcode_resume_cpu() //since uci->valid is true
        -> apply_microcode_on_target()


I tried doing suspend-to-ram and suspend-to-disk on latest kernel (3.2-rc7+)
and I saw exactly the same messages getting emitted from the microcode
module in both cases. Not sure what is going wrong in your case...
Are you really sure that your hibernation script (pm-hibernate) does not
unload the microcode module? You could look up the hooks installed in
/usr/lib/pm-utils/sleep.d/ and also /var/log/pm-suspend.log

If you want to try out by-passing all those hooks and attempting a
suspend-to-disk directly, do:

echo platform > /sys/power/disk  //or shutdown, if platform doesn't exist
echo none > /sys/power/pm_test
echo disk > /sys/power/state

Regards,
Srivatsa S. Bhat

