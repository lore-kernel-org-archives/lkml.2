Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2LNRC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:02:26 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50921 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2LNRCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:02:25 -0500
Message-ID: <50CB5B9D.3040208@acm.org>
Date: Fri, 14 Dec 2012 11:02:21 -0600
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Evans, Robert" <Robert.Evans@stratus.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Tony Camuso <tcamuso@redhat.com>,
        jparadis@redhat.com
Subject: Re: [PATCH] ipmi: add new kernel options to prevent automatic ipmi
 init
References: <50CA31BB.2030507@acm.org> <50CA38CE.2040005@redhat.com> <AC1B83CE65082B4DBDDB681ED2F6B2EF023202A7@EXHQ.corp.stratus.com> <AC1B83CE65082B4DBDDB681ED2F6B2EF023202AB@EXHQ.corp.stratus.com>
In-Reply-To: <AC1B83CE65082B4DBDDB681ED2F6B2EF023202AB@EXHQ.corp.stratus.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 10:25 AM, Evans, Robert wrote:
> Corey,
>
> Thanks for the thoughtful reply.  Below I respond in detail to
> these three points.
>
> 1) Why building a variant kernel with ipmi_si as a module is not
>     feasible.
>
> 2) User mode access to IPMI on Stratus systems (e.g. ipmitool).
>
> 3) ipmi_si hot removal seems to not work as needed.
>
> Stratus might be able to use the hot removal option instead of the
> proposed patch if hot removal can remove all interfaces from usage
> by ipmi_si.  Our testing of this option was not successful as
> shown below.
>
>   - - -
>
> 1) Why building a variant kernel with ipmi_si as a module is not
> feasible:
>
> Stratus sells servers based upon Red Hat Enterprise Linux (RHEL).
> In the next release of RHEL, ipmi_si will be built into the kernel
> so that access to ACPI opregion is available early in kernel
> startup.  Stratus systems run the Red Hat kernel so that the
> system is certified and supported by Red Hat.  For this reason
> using a custom kernel configured to build ipmi_si as a module is
> not an option.

Yes, the RHEL engineer explained this to me, and it makes sense now. Thanks.

>
>
> 2) User mode access to IPMI on Stratus systems:
>
> Although Stratus provides a replacement for ipmi_si, we depend
> on ipmi_msghandler and ipmi_devintf.  The device /dev/ipmi0 is
> present and this device is utilized by the user-mode system
> management software Stratus supplies.
>
> Therefore other programs like ipmitool can send IPMI commands and
> get responses on Stratus systems.

Ah, ok. That's good.

>
>
>
> 3) Hot removal of the KCS interfaces discovered by ipmi_si seems
> to not do enough... One KCS cannot successfully be removed:
>
> Based upon your suggestion, we tried to use hot removal.  With
> RHEL 6.4 Beta (kernel-2.6.32-343.el6), Stratus attempted to hot
> remove the IPMI interfaces.  This was booted with
>   "ipmi_si.trydefaults=0"
> although we expect that kernel option to have no effect since a
> BMC is found before the defaults would be tried.
>
> This is logged when ipmi_si initializes indicating that both BMCs
> were discovered:
>
> ipmi message handler version 39.2
> IPMI System Interface driver.
> ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2,
> slave address 0x0, irq 0
> ipmi: Found new BMC (man_id: 0x000077,  prod_id: 0x05c6, dev_id: 0x41)
> IPMI kcs interface initialized
> ipmi_si: Adding SMBIOS-specified kcs state machine
> ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xda2,
> slave address 0x20, irq 0
> ipmi: interfacing existing BMC (man_id: 0x000077, prod_id: 0x05c6,
> dev_id: 0x41)
> IPMI kcs interface initialized
>
> Although there are two different BMCs, because it says
>   "interfacing existing BMC"
> it appears that ipmi_si assumes they are the same BMC.

That's happening in the message handler and it happens because the
manufacturer, product, and device id all match. From the spec:

    The Device ID is typically used in combination with the Product ID
    field such
    that the Device IDs for different controllers are unique under a
    given Product
    ID. A controller can optionally use the Device ID as an ‘instance’
    identifier if
    more than one controller of that kind is used in the system.
    (Section 20.1)

Different controllers in the same system are supposed to have different 
device
IDs.

>
> Also, I notice the slave address for the first KCS (port CA2) seems
> wrong.  Maybe these findings are relevant to what happens next.

Probably not relevant. It's not correct because, for some bizarre
reason, the slave address is not present in the ACPI information.
The slave address is only used by the message handler for the
IPMB return address on messages routed over IPMB.

It is odd that one interface is specified in ACPI and the other in DMI.
You can specify all of them in both tables.

>
> After ipmi_si has been initialized, a script runs to load ftmod, the
> module that contains the Stratus IPMI driver.  This code was added to
> hot remove the interfaces discovered by ipmi_si before loading ftmod:
>
> for i in $(cd /proc/ipmi; ls)
> do
>      dev="IPMI${i}"
>      params="$(cat /proc/ipmi/${i}/params)"
>      msg="Considering removal of dev: ${dev} ${params}"
>      logger -p kern.info -t `basename ${0}` "${msg}"
>      echo "${msg}" > /dev/console
>      [ -n "${params}" ] &&
> 	echo "remove,`cat /proc/ipmi/${i}/params`" \
> 		> /sys/module/ipmi_si/parameters/hotmod
> done
>
> In the console log we can see this script run prior to loading the
> Stratus ftmod.ko and we also see that ftmod exposes a BMC:
>
> Considering removal of dev: IPMI0
> kcs,i/o,0xca2,rsp=1,rsi=1,rsh=0,irq=0,ipmb=0
> Considering removal of dev: IPMI1
> kcs,i/o,0xda2,rsp=1,rsi=1,rsh=0,irq=0,ipmb=32
> ftmod: module license 'LGPL' taints kernel.
> Disabling lock debugging due to kernel taint
> FTMOD version lsb-ft-ftmod-9.0.4-209
> ftmod: GLOBAL_SIZE=4194304
> ftmod: global_cc_memory 0xffff880037400000
> ipmi: Found new BMC (man_id: 0x000000,  prod_id: 0x0000, dev_id: 0x00)
> ipmi device interface
>
> The KCS at port DA2 is removed from use by ipmi_si.  However, the
> other KCS is still in use by ipmi_si.  Like ipmi_si, the Stratus IPMI
> driver uses ipmi_msghandler.  With two interfaces sending commands to
> the same BMC, responses seem to be misdirected.  The Stratus management
> software cannot successfully commnicate with that BMC and many errors
> like this are logged by ipmi_msghandler:
>
> IPMI message handler: BMC returned incorrect response, expected netfn 3d
> cmd 75, got netfn 3d cmd 71
> IPMI message handler: BMC returned incorrect response, expected netfn 3d
> cmd 71, got netfn 19 cmd 20
> IPMI message handler: BMC returned incorrect response, expected netfn b
> cmd 40, got netfn 3d cmd 71
> IPMI message handler: BMC returned incorrect response, expected netfn 3d
> cmd 71, got netfn d cmd 2
>
> I tried a few variations on the remove string, but never got ipmi_si
> to stop using the KCS at port CA2.

When you remove it, does it disappear from /proc/ipmi? That directory
should be empty after running your script.

The other strange thing is that, if the other driver is running, the
request_region() call in your driver should fail.

Perhaps the first driver is leaving the device in a strange state that is
confusing your driver? That doesn't seem possible. Or maybe there
is something in the message handler that is getting messed up? There
was a bug in the driver at one point that caused errors like that
intermittently, but not all the time.

After sleeping on it a bit, though, I think the patch is a good idea, and
I'll also add something for openfirmware and PCI. I was hoping to get
you a quicker solution, though, than having to deal with a patch.

-corey
