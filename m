Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab2IFUtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:49:08 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:2072
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759654Ab2IFUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:49:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2dI98dI9371I168aJ148cI1432I14ffIzz1202hzz8275eh8275bha1495iz2dh668h839h93fhd25he5bhf0ah107ah1155h)
X-WSS-ID: 0M9Y4HJ-01-2CB-02
X-M-MSG: 
Message-ID: <50490C9D.1070509@amd.com>
Date: Thu, 6 Sep 2012 22:50:37 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: <sedat.dilek@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: linux-next: Tree for Sept 6 (does not boot on AMD64)
References: <CA+icZUWgPV=RnXGT4hDsk3xDm8iBu8ShvFFrs=t3+3D3=-bP2Q@mail.gmail.com>	<CA+icZUUQiPv=iwwC43f6kuU_ikDDKeRC5=QYN4R9OzccmpAEeA@mail.gmail.com>	<201209062208.34545.rjw@sisk.pl> <CA+icZUV_XPGae8t+e6SCi_8TRYyEKmmEeQ6=RbnsBpdYTFditg@mail.gmail.com>
In-Reply-To: <CA+icZUV_XPGae8t+e6SCi_8TRYyEKmmEeQ6=RbnsBpdYTFditg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 10:30 PM, Sedat Dilek wrote:
> On Thu, Sep 6, 2012 at 10:08 PM, Rafael J. Wysocki<rjw@sisk.pl>  wrote:
>> On Thursday, September 06, 2012, Sedat Dilek wrote:
>>> On Thu, Sep 6, 2012 at 1:48 PM, Sedat Dilek<sedat.dilek@gmail.com>  wrote:
>>>> On Thu, Sep 6, 2012 at 9:23 AM, Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>>>>> Hi all,
>>>> Hi,
>>>>
>>>> Unfortunately, today's linux-next does not boot here on Ubuntu/precise AMD64.
>>>> My yesterday's next-20120905 is fine.
>>>>
>>>> I throw out all my additional patches an rebuild again as "-2", but
>>>> this linux-image does not boot.
>>>> It's in very early stage.
>>>> I removed "quiet" etc. from kernel-command-line, but this reveals not much more.
>>>>
>>>>  From the attached kernel-config.diff:
>>>> Dunno why the 2nd is disabled now and try to turn off the 1st one in a
>>>> "-3" build.
>>>>
>>>> +CONFIG_X86_ACPI_CPUFREQ_CPB=y
>>>> -CONFIG_USB_LIBUSUAL=y
>>>>
>>>
>>> [ CC Rafael (cpufreq sub-maintainer) ]
>>
>> Well, this is related to the AMD cpufreq patchset I've just added to
>> linux-next.  I'll drop it for now until the issue is resolved.
>>
>
> Hi Rafael,
>
> The problem was caused by the slab/next merge (see [1]).
>
> [1] http://marc.info/?t=134695686500008&r=1&w=2
>
>>> I hacked to turn off CONFIG_X86_ACPI_CPUFREQ_CPB, but this is not the
>>> root cause.
>>> Not sure why this setting is default YES, Rafael?
>>>
>>> To switch from upstart to systemd does not help.
>>
>> Andre, care to have a look at this?
>>
>
> I am not sure if the depends-on/default-n/default-y lines are correct.
> Here, I am on a Intel sandy-bridge CPU, so why do I need to activate
> any AMD CPU workaround?

It is not a workaround, it is about keeping a feature that was in 
powernow-k8 for 2.5 years. AMD CPUs have this sysfs knob for turning on 
and off the boost feature, we want to keep this around for some time for 
compatibility reasons.
Newer AMD CPUs (Phenoms/Barcelona and up) are now only supported by 
acpi-cpufreq, not by powernow-k8 anymore.

And: it will only be activated on AMD:
+#ifdef CONFIG_X86_ACPI_CPUFREQ_CPB
....
+        * Lets enable it only on AMD CPUs for compatibility reasons and
+        * only if configured. This is considered legacy code, which
+        * will probably be removed at some point in the future.
+        */
+       if (check_amd_hwpstate_cpu(0)) {
...

>
> [ Linux-Next (next-20120906) ]
>
> 19 config X86_ACPI_CPUFREQ
> 20         tristate "ACPI Processor P-States driver"
> 21         select CPU_FREQ_TABLE
> 22         depends on ACPI_PROCESSOR
> 23         help
> 24           This driver adds a CPUFreq driver which utilizes the ACPI
> 25           Processor Performance States.
> 26           This driver also supports Intel Enhanced Speedstep and newer
> 27           AMD CPUs.
> 28
> 29           To compile this driver as a module, choose M here: the
> 30           module will be called acpi-cpufreq.
> 31
> 32           For details, take a look at<file:Documentation/cpu-freq/>.
> 33
> 34           If in doubt, say N.
> 35
> 36 config X86_ACPI_CPUFREQ_CPB
> 37         default y
> 38         bool "Legacy cpb sysfs knob support for AMD CPUs"
> 39         depends on X86_ACPI_CPUFREQ&&  CPU_SUP_AMD
> 40         help
> 41           The powernow-k8 driver used to provide a sysfs knob called "cpb"
> 42           to disable the Core Performance Boosting feature of AMD CPUs. This
> 43           file has now been superseeded by the more generic "boost" entry.
> 44
> 45           By enabling this option the acpi_cpufreq driver provides the old
> 46           entry in addition to the new boost ones, for compatibility reasons.
>
> Why is there no depends-on "X86_POWERNOW_K8" (see above help-text)?

Because this driver lost the support for newer CPUs and thus also this 
feature. We migrate this feature over to acpi-cpufreq.

> I have set CONFIG_CPU_SUP_AMD=y which leads always to
> CONFIG_X86_ACPI_CPUFREQ_CPB=y.
> As said Intel SNB CPU!

As said it does not hurt if you boot it on an Intel CPU, the code will 
not be run.

>
> What about this (untested)?
>
> ----- SNIP -----
> config X86_ACPI_CPUFREQ_CPB
>          bool "Legacy cpb sysfs knob support for AMD CPUs"
>          depends on X86_ACPI_CPUFREQ
>          default y if X86_POWERNOW_K8&&  CPU_SUP_AMD

Powernow-K8 does not support CPB anymore, this code is now in 
acpi-cpufreq. So a dependency on the old driver does not help.

Are there still any problems with this patchset? Or are you only 
wondering about the new config switch?

Thanks for testing!
Andre.


-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

