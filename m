Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2IIKo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 06:44:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2IIKo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 06:44:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120909025702.GB9525@kroah.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
	<20120909025702.GB9525@kroah.com>
Date: Sun, 9 Sep 2012 18:44:25 +0800
Message-ID: <CACVXFVP-y2vLJ82UW6j6mDPp4S7+F2Z3QONH1Ds6GRpa8RtWwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] driver core: driver probe asynchronously
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 10:57 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Sep 09, 2012 at 07:25:15AM +0800, Ming Lei wrote:
>> Hi,
>>
>> This patchset implements asynchronous driver probe for driver_register,
>> and try to address the below problems about driver init during
>> kernel boot:
>>       - help to solve some dependency problem during kernel boot
>>       (such as, request_firmware is called inside probe when driver
>>       is built in kernel[1])
>>
>> The idea behind the patch is very simple:
>>
>>       - seperate driver probe from driver_register and run this part
>>       in one standalone kernel thread context
>>
>>       - so driver_register will become two parts: register the driver
>>       on the bus, and trigger to schedule a kernel thread to do the
>>       driver probe if autoprobe is set
>
> You do realize we tried this out about 5+ years ago, it caused major
> problems, no real benefit, and so we removed it (or maybe never did the
> final commit with it, it might never have hit Linus's tree due to all of
> the problems we found.)

Thanks for the information you provided.

I guess you mean the commit 21c7f30b1d3f8a3de3128478daca3ce203fc8733

        driver core: per-subsystem multithreaded probing

which was reverted surely.

IMO, this patch is different with the above commit:

      -  the probe order is guaranteed to be that parent first,
children second since
         both parent's lock and child's lock are held inside
driver_attach. In the
         commit of 21c7f30b, only device's lock is held in the
asynchronous kthread.

      - it should be supported already by hotplug buses: suppose all drivers
        in the bus have been loaded already, so the probe order depends on
        the order of device_add, which is an uncertain event and is random,
        so there should be no probe order dependency on hotplug buses.

      - the async probe is just triggered in driver_init(module_init)
path, which
        is very similar with loading driver from module(looks no obvious probe
        order dependency for non-dependent  moduels)

I will study the original commit further and other non-hotplug buses to see
if there are more dependency about probe order. But IMO, this patch does
respect the basic probe order: parent first, children second.

>
>> Fortunately, my OMAP4 based Pandaboard boots fine with the patchset, and
>> looks it may work well.
>>
>> More or less, some problems might be triggered by these patchset, but
>> it should be helpful and not a big deal:
>>       - the dependency problem may be found, and it either exposes
>>       the driver's probelm or help to improve the asynchronous probe
>>       approach
>>
>>       - can use driver_register_sync to work around it
>>
>> In summary, there are at least two advantages about asynchronous driver
>> probe:
>>       - speedup kernel boot when many drivers are built in kernel
>
> I would be really amazed if this is true in any measurable fashion.
> Again, we tried this, and it did seem to be a tiny bit faster, but in
> the end, wasn't worth it.

If we can make sure that the approach is doable, I will provide some
test data.

>
>>       - make driver's probe() not need to consider running something
>>       asynchronously(such as, scsi scan, request_firmware_no_wait, ...),
>>       so easier to write drivers
>
> No, that's a bus issue, not a driver issue.  Busses can do this today,
> if they want to, no problem at all.  So, some busses have (maybe, maybe
> not, I can't remember, but I think ATA did), and that is the level you
> need to do this at, not at the driver core level, sorry.

IMO, most of drivers have no probe order dependency, and that is my
motivation to try it. From current async_schedule users, most
of them are used inside driver probe, see below:

arch/sh/drivers/pci/pcie-sh7786.c:572:		async_schedule(sh7786_pcie_hwops->port_init_hw,
port);
drivers/acpi/battery.c:1109:	async_schedule(acpi_battery_init_async, NULL);
drivers/ata/libata-core.c:6118:		async_schedule(async_port_probe, ap);
drivers/base/power/main.c:694:			async_schedule(async_resume, dev);
drivers/base/power/main.c:1166:		async_schedule(async_suspend, dev);
drivers/block/floppy.c:4353:	async_schedule(floppy_async_init, NULL);
drivers/md/raid5.c:1478:	async_schedule(async_run_ops, sh);
drivers/regulator/core.c:2964:		async_schedule_domain(regulator_bulk_enable_async,
drivers/s390/block/dasd.c:3011:		async_schedule(dasd_generic_auto_online, cdev);
drivers/scsi/libsas/sas_ata.c:857:			async_schedule_domain(async_sas_ata_eh,
dev, &async);
drivers/scsi/scsi_scan.c:1875:	async_schedule(do_scan_async, data);
drivers/scsi/sd.c:2734:	async_schedule_domain(sd_probe_async, sdkp,
&scsi_sd_probe_domain);
sound/soc/soc-dapm.c:1656:		async_schedule_domain(dapm_pre_sequence_async, d,
sound/soc/soc-dapm.c:1670:		async_schedule_domain(dapm_post_sequence_async, d,


>
>> It should a very simple way to help to solve the problem[1], without
>> any changes on current drivers which call request_firmware() in its
>> probe(). BTW, the patchset doesn't solve the problem completely, and
>> still some work is needed.
>
> As you state, this doesn't really solve the problem, and will cause a
> lot more (think about all the busses that aren't expecting to have their
> probe functions called at the same time as other probe functions are
> being called.)

If the solution can be proved doable, we may use request_firmware
safely in driver probe in either built-in and module situations, so we
can easily to apply the asynchronous probe to fix current problem:

           - replace async_synchronize_full in prepare_namespace
             with async_synchronize_full_domain

           - introduce one completion which will be pended on inside
             request_firmware and will be woken up after prepare_namespace
             is completed in built-in situations.

Thanks,
--
Ming Lei
