Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2LQVOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:14:33 -0500
Received: from mailhub.stratus.com ([134.111.1.17]:42091 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2LQVOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:14:32 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ipmi: add new kernel options to prevent automatic ipmi init
Date: Mon, 17 Dec 2012 16:14:11 -0500
Message-ID: <AC1B83CE65082B4DBDDB681ED2F6B2EF023202B4@EXHQ.corp.stratus.com>
In-Reply-To: <50CB5B9D.3040208@acm.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ipmi: add new kernel options to prevent automatic ipmi init
thread-index: Ac3aHMwBamch7aH2RiqBzCWkwVVFNgCfVAKg
References: <50CA31BB.2030507@acm.org> <50CA38CE.2040005@redhat.com> <AC1B83CE65082B4DBDDB681ED2F6B2EF023202A7@EXHQ.corp.stratus.com> <AC1B83CE65082B4DBDDB681ED2F6B2EF023202AB@EXHQ.corp.stratus.com> <50CB5B9D.3040208@acm.org>
From: "Evans, Robert" <Robert.Evans@stratus.com>
To: <minyard@acm.org>
Cc: "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        <openipmi-developer@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        "Tony Camuso" <tcamuso@redhat.com>, <jparadis@redhat.com>,
        "Evans, Robert" <Robert.Evans@stratus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 12:02 PM, Corey Minyard wrote:
>On 12/14/2012 10:25 AM, Evans, Robert wrote:
>> Corey,
>>
>> Thanks for the thoughtful reply.  Below I respond in detail to
>> these three points.
>>
>> 1) Why building a variant kernel with ipmi_si as a module is not
>>     feasible.
>>
>> 2) User mode access to IPMI on Stratus systems (e.g. ipmitool).
>>
>> 3) ipmi_si hot removal seems to not work as needed.
>>
>> Stratus might be able to use the hot removal option instead of the
>> proposed patch if hot removal can remove all interfaces from usage
>> by ipmi_si.  Our testing of this option was not successful as
>> shown below.
>>
>>   - - -
>>
>> 1) Why building a variant kernel with ipmi_si as a module is not
>> feasible:
>>
>> Stratus sells servers based upon Red Hat Enterprise Linux (RHEL).
>> In the next release of RHEL, ipmi_si will be built into the kernel
>> so that access to ACPI opregion is available early in kernel
>> startup.  Stratus systems run the Red Hat kernel so that the
>> system is certified and supported by Red Hat.  For this reason
>> using a custom kernel configured to build ipmi_si as a module is
>> not an option.
>
>Yes, the RHEL engineer explained this to me, and it makes sense now.
Thanks.
>
>>
>>
>> 2) User mode access to IPMI on Stratus systems:
>>
>> Although Stratus provides a replacement for ipmi_si, we depend
>> on ipmi_msghandler and ipmi_devintf.  The device /dev/ipmi0 is
>> present and this device is utilized by the user-mode system
>> management software Stratus supplies.
>>
>> Therefore other programs like ipmitool can send IPMI commands and
>> get responses on Stratus systems.
>
>Ah, ok. That's good.
>
>>
>>
>>
>> 3) Hot removal of the KCS interfaces discovered by ipmi_si seems
>> to not do enough... One KCS cannot successfully be removed:
>>
>> Based upon your suggestion, we tried to use hot removal.  With
>> RHEL 6.4 Beta (kernel-2.6.32-343.el6), Stratus attempted to hot
>> remove the IPMI interfaces.  This was booted with
>>   "ipmi_si.trydefaults=0"
>> although we expect that kernel option to have no effect since a
>> BMC is found before the defaults would be tried.
>>
>> This is logged when ipmi_si initializes indicating that both BMCs
>> were discovered:
>>
>> ipmi message handler version 39.2
>> IPMI System Interface driver.
>> ipmi_si: Trying ACPI-specified kcs state machine at i/o address
0xca2,
>> slave address 0x0, irq 0
>> ipmi: Found new BMC (man_id: 0x000077,  prod_id: 0x05c6, dev_id:
0x41)
>> IPMI kcs interface initialized
>> ipmi_si: Adding SMBIOS-specified kcs state machine
>> ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address
0xda2,
>> slave address 0x20, irq 0
>> ipmi: interfacing existing BMC (man_id: 0x000077, prod_id: 0x05c6,
>> dev_id: 0x41)
>> IPMI kcs interface initialized
>>
>> Although there are two different BMCs, because it says
>>   "interfacing existing BMC"
>> it appears that ipmi_si assumes they are the same BMC.
>
>That's happening in the message handler and it happens because the
>manufacturer, product, and device id all match. From the spec:
>
>    The Device ID is typically used in combination with the Product ID
>    field such
>    that the Device IDs for different controllers are unique under a
>    given Product
>    ID. A controller can optionally use the Device ID as an 'instance'
>    identifier if
>    more than one controller of that kind is used in the system.
>    (Section 20.1)
>
>Different controllers in the same system are supposed to have different

>device
>IDs.

I have a made an inquiry to Stratus Hardware Engineering asking why our
product is not compliant with the specification.  I will pursue a change
to future products to comply.  However, Stratus has several generations
of systems in the field for which this change will be very difficult.


>
>> Also, I notice the slave address for the first KCS (port CA2) seems
>> wrong.  Maybe these findings are relevant to what happens next.
>
>Probably not relevant. It's not correct because, for some bizarre
>reason, the slave address is not present in the ACPI information.
>The slave address is only used by the message handler for the
>IPMB return address on messages routed over IPMB.
>
>It is odd that one interface is specified in ACPI and the other in DMI.
>You can specify all of them in both tables.

The Stratus server is actually two complete servers that operate in
lockstep to provide reliable operation regardless of any single failed
component.  One of the two I/O subsystems is active during BIOS POST.
Only information about the active subsystem is placed in the SMBIOS
data structure.  Thus dmidecode shows this info for either port CA2
or DA2 depending upon which I/O CRU was active:

  Handle 0x0048, DMI type 38, 18 bytes
  IPMI Device Information
	Interface Type: KCS (Keyboard Control Style)
	Specification Version: 2.0
	I2C Slave Address: 0x10
	NV Storage Device: Not Present
	Base Address: 0x0000000000000DA2 (I/O)
	Register Spacing: Successive Byte Boundaries
	Interrupt Polarity: Active High
	Interrupt Trigger Mode: Edge

I believe the ACPI data provides information to locate both KCS
interfaces.
Therefore only one interface is found at first when ipmi_si calls
dmi_find_bmc().  And the other interface is discovered by
acpi_find_bmc()
or by ipmi_pnp_probe().

>>
>> After ipmi_si has been initialized, a script runs to load ftmod, the
>> module that contains the Stratus IPMI driver.  This code was added to
>> hot remove the interfaces discovered by ipmi_si before loading ftmod:
>>
>> for i in $(cd /proc/ipmi; ls)
>> do
>>      dev="IPMI${i}"
>>      params="$(cat /proc/ipmi/${i}/params)"
>>      msg="Considering removal of dev: ${dev} ${params}"
>>      logger -p kern.info -t `basename ${0}` "${msg}"
>>      echo "${msg}" > /dev/console
>>      [ -n "${params}" ] &&
>> 	echo "remove,`cat /proc/ipmi/${i}/params`" \
>> 		> /sys/module/ipmi_si/parameters/hotmod
>> done
>>
>> In the console log we can see this script run prior to loading the
>> Stratus ftmod.ko and we also see that ftmod exposes a BMC:
>>
>> Considering removal of dev: IPMI0
>> kcs,i/o,0xca2,rsp=1,rsi=1,rsh=0,irq=0,ipmb=0
>> Considering removal of dev: IPMI1
>> kcs,i/o,0xda2,rsp=1,rsi=1,rsh=0,irq=0,ipmb=32
>> ftmod: module license 'LGPL' taints kernel.
>> Disabling lock debugging due to kernel taint
>> FTMOD version lsb-ft-ftmod-9.0.4-209
>> ftmod: GLOBAL_SIZE=4194304
>> ftmod: global_cc_memory 0xffff880037400000
>> ipmi: Found new BMC (man_id: 0x000000,  prod_id: 0x0000, dev_id:
0x00)
>> ipmi device interface
>>
>> The KCS at port DA2 is removed from use by ipmi_si.  However, the
>> other KCS is still in use by ipmi_si.  Like ipmi_si, the Stratus IPMI
>> driver uses ipmi_msghandler.  With two interfaces sending commands to
>> the same BMC, responses seem to be misdirected.  The Stratus
management
>> software cannot successfully commnicate with that BMC and many errors
>> like this are logged by ipmi_msghandler:
>>
>> IPMI message handler: BMC returned incorrect response, expected netfn
3d
>> cmd 75, got netfn 3d cmd 71
>> IPMI message handler: BMC returned incorrect response, expected netfn
3d
>> cmd 71, got netfn 19 cmd 20
>> IPMI message handler: BMC returned incorrect response, expected netfn
b
>> cmd 40, got netfn 3d cmd 71
>> IPMI message handler: BMC returned incorrect response, expected netfn
3d
>> cmd 71, got netfn d cmd 2
>>
>> I tried a few variations on the remove string, but never got ipmi_si
>> to stop using the KCS at port CA2.
>
>When you remove it, does it disappear from /proc/ipmi? That directory
>should be empty after running your script.

After my script runs, the kernel still has one device (0) with with
the proc files from ipmi_si and from ipmi_msghandler.  I see those files
exist after my script runs, but before the Stratus driver gets loaded.

After it is loaded, the Stratus driver is using device (1).  For that
device, I only see the proc files exposed by ipmi_msghandler:

  # ls /proc/ipmi/?
  /proc/ipmi/0:
  ipmb  params  si_stats  stats  type  version

  /proc/ipmi/1:
  ipmb  stats  version

I still am experimenting with this as I am curious about why the hot-
remove is not working.


>
>The other strange thing is that, if the other driver is running, the
>request_region() call in your driver should fail.

The Stratus common low-level machine control code is shared by a
few different operating systems.  I do not have a list of all the
I/O ports the common code accesses.  So there is no request for a
I/O port region when the Stratus common code starts.  The linux-
specific wrapper around common code simply does in or out
instructions to access the requested ports.


>
>Perhaps the first driver is leaving the device in a strange state that
is
>confusing your driver? That doesn't seem possible. Or maybe there
>is something in the message handler that is getting messed up? There
>was a bug in the driver at one point that caused errors like that
>intermittently, but not all the time.

I think this is unlikely as the Stratus driver does retries and even
can use a GPIO to reboot the BMC when communications fail.


>
>After sleeping on it a bit, though, I think the patch is a good idea,
and
>I'll also add something for openfirmware and PCI. I was hoping to get
>you a quicker solution, though, than having to deal with a patch.
>
>-corey

I appreciate your help and would like the patch as it seems the best
solution for existing systems.  Thanks again for your assistance.


- Robert N. Evans


