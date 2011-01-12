Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1ALMdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:33:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab1ALMd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:33:28 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/9] acpi: Use ACPI C-state type instead of enumeration value to export cpuidle state name
Date: Wed, 12 Jan 2011 13:33:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-18-desktop; KDE/4.5.3; x86_64; ; )
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1294396190-23031-1-git-send-email-trenn@suse.de> <201101091330.12027.trenn@suse.de> <alpine.LFD.2.02.1101120130110.19140@x980>
In-Reply-To: <alpine.LFD.2.02.1101120130110.19140@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101121333.24240.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 January 2011 07:36:17 Len Brown wrote:
> > > But some systems may have more than one state of each type...
> 
> > Exported through ACPI tables?
> 
> Yes.
> 
> It is quite common, for example in the Pentium M
> generations, for a BIOS to export C3 and C4 -
> both of which are ACPI  C3-type.
Then you have two C3 types/names, this doesn't hurt.
It's even "more" correct than enumeration (expecting
that C2 is missing which can happen, right?):
C1 -> C1
C2 -> C3
C3 -> C4

As you already said, people have to look closer at
the description file anyway. There is not much we can/should
do about that in the generic acpi_idle driver (beside
a note in Documentation/...).
 
> > > also, the state->name is somewhat arbitrary.
> > > 
> > > You'll notice that intel_idle uses the hardware C-state names
> > > such as NHM-C1, NHM-C3, NHM-C6 - to match the (arbitrary)
> > > names in the hardware documentation.  We could call those
> > > states Moe/Larry/Curley just as well.
> 
> > That works out with HW specific intel_idle.c driver, but not
> > with the generic acpi/processor one.
> 
> Actually, C0..Cn work out fine for the acpi/processor driver.
> the names are unique, and they also correspond to max_cstate
> if somebody wants to use that.
I do not like the fact that the name contains zero info
and still is wrong and will still cause confusion
(enumerating from C0-Cx will also not match
C-states as described in documentations, but at least match
the type as exported by BIOS vendors).

if [ `cat /sys/devices/system/cpu/cpuidle/current_driver` = "acpi_idle" ];then
  for ((x=1; x<10; x++));do
    [ ! -d /sys/devices/system/cpu/cpu0/cpuidle/state${x} ] && break
    if [ `cat /sys/devices/system/cpu/cpu0/cpuidle/state${x}/name` = C${x} ];then
        echo "The same"
    fi
  done
fi
The same
The same
The same
Currently it will always be "The same".

> > I restore the ACPI type info as exported by ACPI tables
> > with this patch, should be the same as done with
> > /proc/acpi/processor/*/power
> > Do I miss something?
> 
> /proc/acpi/processor/*/power had a type field.
> Per the example above, the type field didn't always
> match the C-state number.
But compared to plain enumeration it has at least
some use (see your own comment below).
And if OEMs care (and some probably would) they can
export the type they like to see and it gets passed
from the BIOS tables up to the very high end
userspace/customer tools.

I know Intel uses intel_idle, but there are others
which make use of ACPI C-states.
 
> > Do you want to export additional ACPI table C-state
> > info?
> 
> I have a 1 line patch someplace to print out the type
> for debug info when needed, that should be sufficient
> for debugging, which is the only time we care about type.
To be honest I do not care about this detail that much.
I think it would be nicer to export the C-state type in
the name. Name and description is cpuidle driver (in this case
acpi_idle) specific info, why shouldn't processor_idle
fill it with something which has at least some meaning.

> > Something else, but related:
> > You recently said that it might be a good idea to get
> > C-/P- state ACPI tables which are often in a separate
> > SSDT loaded at runtime via "load" ACPI command, dumped
> > with the acpidump  tool. This would be a cool feature.
> > Does dynamically loaded SSDT dumping
> > via acpidump work already or is/has someone looked at this?
> 
> Yakui fixed this a while back.
> acpidump in the latest pmtools in
> http://userweb.kernel.org/~lenb/acpi/utils/
> picks up the dynamic tables from /sys/firmware/acpi/tables.
Great!
I didn't update acpidump for quite some time as I hoped it
shows up in the acpica project and also did some adjustance
for this already. I'll grab it for 11.4.

     Thomas
