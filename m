Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0LAVsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 16:48:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43622 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab0LAVsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 16:48:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
References: <4CF60095.1020900@kernel.org> <1291202867.4023.3.camel@twins>
	<20101201160640.GA2511@redhat.com>
	<1291219906.32004.1671.camel@laptop>
	<20101201162335.GB2511@redhat.com>
	<1291232292.32004.1969.camel@laptop>
	<20101201194644.GD2511@redhat.com>
	<1291232989.32004.1987.camel@laptop>
	<20101201195835.GE2511@redhat.com>
	<1291234036.32004.2008.camel@laptop>
Date: Wed, 01 Dec 2010 13:48:07 -0800
In-Reply-To: <1291234036.32004.2008.camel@laptop> (Peter Zijlstra's message of
	"Wed, 01 Dec 2010 21:07:16 +0100")
Message-ID: <m162vdp3l4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Q5OH3SEIe+LECm4rt8pV9J2VijIYp/Cc=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: infradead.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Peter Zijlstra <peterz@infradead.org>
X-Spam-Relay-Country: 
Subject: Re: perf hw  in kexeced kernel broken in tip
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, 2010-12-01 at 14:58 -0500, Vivek Goyal wrote:
>> On Wed, Dec 01, 2010 at 08:49:49PM +0100, Peter Zijlstra wrote:
>> > On Wed, 2010-12-01 at 14:46 -0500, Vivek Goyal wrote:
>> > > On Wed, Dec 01, 2010 at 08:38:12PM +0100, Peter Zijlstra wrote:
>> > > > On Wed, 2010-12-01 at 11:23 -0500, Vivek Goyal wrote:
>> > > > > > What does kexec normally do to ensure hardware is left in a sane state?
>> > > > > 
>> > > > > Typically calls device_shutdown() and sysdev_shutdown() from
>> > > > > kernel_restart_prepare() to shutdown the devices.
>> > > > > 
>> > > > > Also calls machine_shutdown() which depending on architecture can take
>> > > > > care of various things like stopping other cpus, shutting down LAPIC, 
>> > > > > disabling IOAPIC, disabling hpet, shutting down IOMMU etc
>> > > > > (native_machine_shutdown()). 
>> > > > 
>> > > > So basically there's no sane generic reset callout?
>> > > 
>> > > I think ->shutdown() calls are sane generic callouts. Isn't it?
>> > 
>> > ->shutdown looks like it's about to reset/halt the hardware, no point in
>> > slowing down the regular shutdown/reboot path for something like this,
>> > we know the hardware will get reset to a sane state.
>> 
>> I think we already call ->shutdown() in regular reboot path.
>> 
>> kernel_restart()
>>   kernel_restart_prepare()
>>     device_shutdown();
>>     sysdev_shutdown();
>> 
>> So it should not make lot of difference if perf subsystem/counters are
>> also shutdown using ->shutdown().
>
> Oh, but I'm not a device or sysdev thing, I'll never get something like
> that.

There is also the reboot notifier, if the NMI needs to be controlled
outside of device model.  Sigh. The NMI handling is such a special case.

>> > > There seem to be few exceptions for LAPIC, IOMMU and HPET and I am not
>> > > sure why they are not covered by shutdown calls. CCing Eric, he might
>> > > have more insight into it.
>> > 
>> > That's all arch specific, but even there I don't think the reset code
>> > should live outside of kexec.
>> 
>> I would not know the history but I have heard stories that if you don't
>> shutdown the hardware over restart, BIOS might not be expecting it and
>> might get trumped.
>
> Never yet had a problem with that.

I haven't personally but I have certainly heard stories and seen
debugging sessions where some devices work or don't depending on the
order of running linux and windows on a machine, with soft reboots in
between.

Eric

